import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";
// import * as crypto from "crypto"; // Week 4 테스트: 캐시 비활성화로 미사용
// sharp는 convertToWebP()에서 lazy require (다른 함수의 cold start 차단 방지)
import {getUserTier} from "./utils/getUserTier";
import {maskUid} from "./utils/maskUid";

// Prompt injection 방지: 허용 목록 (H-3)
const ALLOWED_BREEDS = [
  "Golden Retriever", "Labrador", "Shiba Inu",
  "Pomeranian", "Husky", "Beagle", "Bulldog", "Poodle",
];
const ALLOWED_COLORS = [
  "golden", "brown", "black", "white", "gray", "cream",
  "orange", // 기본값 호환
];
const ALLOWED_ACCESSORIES = [
  "none", "bandana", "glasses", "bowtie", "hat", "collar",
];
const ALLOWED_STYLES = [
  "sticker-flat", "sticker-3d", "realistic",
];
const ALLOWED_BGS = [
  "transparent", "white", "gradient",
];

interface GenStickerRequest {
  petId: string;
  breed?: string;
  color?: string;
  accessory?: string;
  style?: string;
  size?: number;
  bg?: string;
  seed?: number;
  force?: boolean;
}

// Week 4 테스트: 캐시 비활성화로 미사용
/* interface CacheParams {
  petId: string;
  breed?: string;
  color?: string;
  accessory?: string;
  style?: string;
  size?: number;
  seed?: number;
} */

// Week 4 테스트: 캐시 비활성화로 미사용
/* interface CachedImage {
  data: string;
  seed: number;
} */

interface GeminiImageData {
  data: Buffer;
  seed: number;
}

export const genSticker = functions
  .region("us-central1")
  .runWith({secrets: ["GEMINI_API_KEY"]})
  .https.onCall(async (data: GenStickerRequest, context) => {
    console.log("🎨 genSticker called");

    // 1. App Check 검증
    if (!context.app) {
      console.warn(
        "[genSticker] App Check token missing — " +
        "enable enforcement in Firebase Console before production"
      );
    }

    // 2. 인증 확인 (필수)
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required"
      );
    }
    const uid = context.auth.uid;
    console.log(`👤 User: ${maskUid(uid)}`);

    // 3. 프리미엄 구독 검증
    const tier = await getUserTier(uid);
    if (tier !== "premium") {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Premium subscription required"
      );
    }

    // 4. 입력 검증 + allowlist (H-3 prompt injection 방지)
    const {petId, size = 512, seed} = data;
    const breed = ALLOWED_BREEDS.includes(data.breed ?? "") ?
      data.breed! : "Shiba Inu";
    const color = ALLOWED_COLORS.includes(data.color ?? "") ?
      data.color! : "orange";
    const accessory = ALLOWED_ACCESSORIES
      .includes(data.accessory ?? "") ?
      data.accessory! : "none";
    const style = ALLOWED_STYLES.includes(data.style ?? "") ?
      data.style! : "sticker-flat";
    const bg = ALLOWED_BGS.includes(data.bg ?? "") ?
      data.bg! : "transparent";

    console.log(`📝 petId=${petId}`);

    const PET_ID_REGEX = /^[a-zA-Z0-9_-]{1,64}$/;
    if (!petId || !PET_ID_REGEX.test(petId) ||
      size < 256 || size > 1024) {
      console.error("❌ Invalid parameters");
      throw new functions.https.HttpsError(
        "invalid-argument", "Invalid parameters"
      );
    }

    // 5. 레이트 리밋 체크
    const rateLimitOk = await checkAndReserveSlot(uid);
    if (!rateLimitOk) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        "Rate limit exceeded"
      );
    }

    // 5. 캐시 확인 (임시 비활성화)
    /* const cacheKey = generateCacheKey({petId, breed, color, accessory, style, size, seed});
    if (!force) {
      const cachedImage = await getCachedImage(cacheKey);
      if (cachedImage) {
        return {
          success: true,
          data: {
            image_base64: cachedImage.data,
            mime: "image/webp",
            seed: cachedImage.seed,
            cached: true,
            size: {width: size, height: size},
          },
        };
      }
    } */

    // 6. Gemini API 호출
    console.log("🚀 Calling Gemini API...");
    const prompt = generatePrompt(breed, color, accessory, style, bg);
    console.log(`📝 Prompt length: ${prompt.length} chars`);
    const imageData = await callGeminiAPI(prompt, seed);
    console.log(`✅ Gemini API returned image, seed: ${imageData.seed}`);

    // 7. 이미지 처리 (WebP 변환)
    console.log("🔄 Converting to WebP...");
    const webpImage = await convertToWebP(imageData.data, size);
    const base64Image = webpImage.toString("base64");
    console.log(`✅ WebP conversion complete, size: ${base64Image.length} chars`);

    // 8. 캐시 저장 (임시 비활성화 - Storage bucket 설정 필요)
    // await saveToCache(cacheKey, {data: base64Image, seed: imageData.seed});

    // 9. 사용량 기록 — checkAndReserveSlot에서 원자적으로 완료됨

    const response = {
      success: true,
      data: {
        image_base64: base64Image,
        mime: "image/webp",
        seed: imageData.seed,
        cached: false,
        size: {width: size, height: size},
        metadata: {breed, color, accessory, style},
      },
    };

    console.log("🎉 Returning success response");
    return response;
  });

// 캐시 키 생성 (Week 4 테스트: 캐시 비활성화로 미사용)
/* function generateCacheKey(params: CacheParams): string {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("hex");
} */

// 프롬프트 생성
function generatePrompt(breed: string, color: string, accessory: string, style: string, bg: string): string {
  let prompt = `${breed} dog, ${color} coat, cute sticker, front view, simple shading, 2D flat`;

  if (accessory !== "none") {
    const accessoryMap: Record<string, string> = {
      bandana: "red bandana accessory",
      glasses: "sunglasses accessory",
      bowtie: "bow tie accessory",
      hat: "top hat accessory",
      collar: "decorative collar",
    };
    prompt += `, ${accessoryMap[accessory]}`;
  }

  prompt += `, ${bg} background`;

  return prompt;
}

// Gemini 2.5 Flash Image API 호출
async function callGeminiAPI(prompt: string, seed?: number): Promise<GeminiImageData> {
  const apiKey = process.env.GEMINI_API_KEY ?? "";

  console.log("🔑 API key exists:", !!apiKey);

  // Gemini 2.5 Flash Image endpoint
  const endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent";

  try {
    console.log(`📡 Calling Gemini API endpoint: ${endpoint}`);
    const response = await axios.post(
      endpoint,
      {
        contents: [{
          parts: [{text: prompt}],
        }],
        generationConfig: {
          responseModalities: ["IMAGE"],
          imageConfig: {
            aspectRatio: "1:1",
          },
        },
      },
      {
        timeout: 30000,
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey,
        },
      }
    );

    // 이미지 데이터 추출 (Base64)
    // Gemini는 candidates[0].content.parts에서 inline_data를 찾아야 함
    console.log("📦 Processing Gemini API response...");
    const parts = response.data.candidates[0].content.parts;
    const imagePart = parts.find((part: {inlineData?: {data: string}}) => part.inlineData);

    if (!imagePart || !imagePart.inlineData) {
      console.error("❌ No image found in Gemini response");
      throw new Error("No image found in response");
    }

    const imageBase64 = imagePart.inlineData.data;
    console.log(`✅ Image extracted, size: ${imageBase64.length} chars`);
    return {
      data: Buffer.from(imageBase64, "base64"),
      seed: seed || Date.now(),
    };
  } catch (error) {
    const err = error as {response?: {data?: unknown}; message?: string};
    console.error("❌ Gemini API Error:", err.response?.data || err.message);
    throw new functions.https.HttpsError("internal", "Image generation failed");
  }
}

// WebP 변환
async function convertToWebP(imageBuffer: Buffer, size: number): Promise<Buffer> {
  const {default: sharpModule} = await import("sharp");
  return await sharpModule(imageBuffer)
    .resize(size, size)
    .webp({quality: 90})
    .toBuffer();
}

// 캐시 저장 (Firebase Storage) - 임시 비활성화
/* async function saveToCache(key: string, data: CachedImage): Promise<void> {
  const bucket = admin.storage().bucket();
  const file = bucket.file(`cache/images/${key}.json`);
  await file.save(JSON.stringify(data), {
    metadata: {contentType: "application/json"},
  });
} */

// 캐시 조회 - 임시 비활성화
/* async function getCachedImage(key: string): Promise<CachedImage | null> {
  const bucket = admin.storage().bucket();
  const file = bucket.file(`cache/images/${key}.json`);
  const [exists] = await file.exists();

  if (!exists) return null;

  const [data] = await file.download();
  return JSON.parse(data.toString()) as CachedImage;
} */

// 프리미엄 사용자 할당량
const PREMIUM_DAILY_QUOTA = 5;
const PREMIUM_RATE_LIMIT_PER_5MIN = 5;

/**
 * 레이트 리밋 체크 + 슬롯 예약 (원자적)
 *
 * Firestore Transaction으로 check + increment 원자적 수행.
 * TOCTOU race condition 방지 (H-2).
 * Firestore 오류 시 fail-closed (H-1).
 */
async function checkAndReserveSlot(
  uid: string
): Promise<boolean> {
  const db = admin.firestore();
  const now = Date.now();
  const today = new Date().toISOString().split("T")[0];
  const usageRef = db.collection("imageUsage").doc(uid);

  try {
    return await db.runTransaction(async (tx) => {
      const usageDoc = await tx.get(usageRef);

      if (!usageDoc.exists) {
        tx.set(usageRef, {
          date: today,
          count: 1,
          timestamps: [now],
        });
        return true;
      }

      const usage = usageDoc.data()!;

      // 일일 제한 체크
      const dailyCount =
        (usage.date === today) ?
          (usage.count || 0) : 0;
      if (dailyCount >= PREMIUM_DAILY_QUOTA) {
        return false;
      }

      // 5분 제한 체크
      const recent = (usage.timestamps || [])
        .filter((ts: number) => now - ts < 5 * 60 * 1000);
      if (recent.length >= PREMIUM_RATE_LIMIT_PER_5MIN) {
        return false;
      }

      // 원자적으로 카운터 증가
      if (usage.date !== today) {
        tx.set(usageRef, {
          date: today,
          count: 1,
          timestamps: [now],
        });
      } else {
        tx.update(usageRef, {
          count: dailyCount + 1,
          timestamps:
            admin.firestore.FieldValue.arrayUnion(now),
        });
      }

      return true;
    });
  } catch (error) {
    console.error("❌ Rate limit check failed:", error);
    // Firestore 오류 시 차단 (fail-closed)
    return false;
  }
}

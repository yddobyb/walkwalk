import * as functions from "firebase-functions";
// import * as admin from "firebase-admin"; // Week 4 테스트: 캐시 비활성화로 미사용
import axios from "axios";
// import * as crypto from "crypto"; // Week 4 테스트: 캐시 비활성화로 미사용
import sharp from "sharp";

interface GenStickerRequest {
  petId: string;
  breed?: string;
  color?: string;
  accessory?: "none" | "bandana" | "glasses" | "bowtie" | "hat" | "collar";
  style?: "sticker-flat" | "sticker-3d" | "realistic";
  size?: number;
  bg?: "transparent" | "white" | "gradient";
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
  .https.onCall(async (data: GenStickerRequest) => { // Week 4 테스트: context 미사용
    console.log("🎨 genSticker called with data:", JSON.stringify(data));

    // 1. App Check 검증 (Week 4 테스트: 임시 제거)
    // if (!context.app) {
    //   throw new functions.https.HttpsError(
    //     "failed-precondition",
    //     "App Check required"
    //   );
    // }

    // 2. 인증 확인 (Week 4 테스트: 임시 제거)
    // if (!context.auth) {
    //   throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    // }

    // 3. 입력 검증
    const {petId, breed = "Shiba Inu", color = "orange", accessory = "none",
      style = "sticker-flat", size = 512, bg = "transparent", seed} = data; // force 제거 (캐시 비활성화)

    console.log(`📝 Parameters: petId=${petId}, breed=${breed}, color=${color}`);

    if (!petId || size < 256 || size > 1024) {
      console.error("❌ Invalid parameters");
      throw new functions.https.HttpsError("invalid-argument", "Invalid parameters");
    }

    // 4. 레이트 리밋 체크 (Week 4 테스트: Firestore 없이 항상 통과)
    // const uid = context.auth?.uid || "test-user-" + Date.now();
    // const rateLimitOk = await checkRateLimit(uid);
    // if (!rateLimitOk) {
    //   throw new functions.https.HttpsError("resource-exhausted", "Rate limit exceeded");
    // }

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
    console.log(`📝 Prompt: ${prompt}`);
    const imageData = await callGeminiAPI(prompt, seed);
    console.log(`✅ Gemini API returned image, seed: ${imageData.seed}`);

    // 7. 이미지 처리 (WebP 변환)
    console.log("🔄 Converting to WebP...");
    const webpImage = await convertToWebP(imageData.data, size);
    const base64Image = webpImage.toString("base64");
    console.log(`✅ WebP conversion complete, size: ${base64Image.length} chars`);

    // 8. 캐시 저장 (임시 비활성화 - Storage bucket 설정 필요)
    // await saveToCache(cacheKey, {data: base64Image, seed: imageData.seed});

    // 9. 사용량 기록 (Week 4 테스트: Firestore 없이 스킵)
    // await recordUsage(uid);

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
  const config = functions.config();
  const apiKey = config.gemini.api_key;

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
  return await sharp(imageBuffer)
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

// 레이트 리밋 체크 (Week 4 테스트: 전체 주석 처리)
/*
async function checkRateLimit(uid: string): Promise<boolean> {
  const db = admin.firestore();
  const now = Date.now();
  const today = new Date().toISOString().split("T")[0];

  const usageRef = db.collection("imageUsage").doc(uid);
  const usageDoc = await usageRef.get();

  if (!usageDoc.exists) {
    return true;
  }

  const usage = usageDoc.data()!;
  const config = functions.config();

  // 일일 제한 체크
  if (usage.date === today && usage.count >= parseInt(config.limits.daily_quota)) {
    return false;
  }

  // 5분 제한 체크
  const recent = (usage.timestamps || []).filter((ts: number) => now - ts < 5 * 60 * 1000);
  if (recent.length >= parseInt(config.limits.rate_limit_per_5min)) {
    return false;
  }

  return true;
}
*/

// 사용량 기록 (Week 4 테스트: 전체 주석 처리)
/*
async function recordUsage(uid: string): Promise<void> {
  const db = admin.firestore();
  const now = Date.now();
  const today = new Date().toISOString().split("T")[0];

  const usageRef = db.collection("imageUsage").doc(uid);
  const usageDoc = await usageRef.get();

  if (!usageDoc.exists || usageDoc.data()!.date !== today) {
    await usageRef.set({
      date: today,
      count: 1,
      timestamps: [now],
    });
  } else {
    await usageRef.update({
      count: admin.firestore.FieldValue.increment(1),
      timestamps: admin.firestore.FieldValue.arrayUnion(now),
    });
  }
}
*/

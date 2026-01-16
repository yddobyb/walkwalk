import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";
import * as crypto from "crypto";
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

interface CacheParams {
  petId: string;
  breed?: string;
  color?: string;
  accessory?: string;
  style?: string;
  size?: number;
  seed?: number;
}

interface CachedImage {
  data: string;
  seed: number;
}

interface GeminiImageData {
  data: Buffer;
  seed: number;
}

export const genSticker = functions
  .region("us-central1")
  .https.onCall(async (data: GenStickerRequest, context) => {
    // 1. App Check 검증
    if (!context.app) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "App Check required"
      );
    }

    // 2. 인증 확인
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }

    // 3. 입력 검증
    const {petId, breed = "Shiba Inu", color = "orange", accessory = "none",
      style = "sticker-flat", size = 512, bg = "transparent", seed, force = false} = data;

    if (!petId || size < 256 || size > 1024) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid parameters");
    }

    // 4. 레이트 리밋 체크
    const uid = context.auth.uid;
    const rateLimitOk = await checkRateLimit(uid);
    if (!rateLimitOk) {
      throw new functions.https.HttpsError("resource-exhausted", "Rate limit exceeded");
    }

    // 5. 캐시 확인
    const cacheKey = generateCacheKey({petId, breed, color, accessory, style, size, seed});
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
    }

    // 6. Gemini API 호출
    const prompt = generatePrompt(breed, color, accessory, style, bg);
    const imageData = await callGeminiAPI(prompt, seed);

    // 7. 이미지 처리 (WebP 변환)
    const webpImage = await convertToWebP(imageData.data, size);
    const base64Image = webpImage.toString("base64");

    // 8. 캐시 저장
    await saveToCache(cacheKey, {data: base64Image, seed: imageData.seed});

    // 9. 사용량 기록
    await recordUsage(uid);

    return {
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
  });

// 캐시 키 생성
function generateCacheKey(params: CacheParams): string {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("hex");
}

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

// Gemini API 호출
async function callGeminiAPI(prompt: string, seed?: number): Promise<GeminiImageData> {
  const config = functions.config();
  const apiKey = config.gemini.api_key;
  const endpoint = config.gemini.endpoint;

  try {
    const response = await axios.post(
      `${endpoint}?key=${apiKey}`,
      {
        contents: [{
          parts: [{text: prompt}],
        }],
        generationConfig: {
          temperature: 0.4,
          topK: 32,
          topP: 1,
          maxOutputTokens: 4096,
          responseMimeType: "image/png",
        },
      },
      {
        timeout: 20000,
        headers: {
          "Content-Type": "application/json",
        },
      }
    );

    // 이미지 데이터 추출 (Base64)
    const imageBase64 = response.data.candidates[0].content.parts[0].inlineData.data;
    return {
      data: Buffer.from(imageBase64, "base64"),
      seed: seed || Date.now(),
    };
  } catch (error) {
    const err = error as {response?: {data?: unknown}; message?: string};
    console.error("Gemini API Error:", err.response?.data || err.message);
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

// 캐시 저장 (Firebase Storage)
async function saveToCache(key: string, data: CachedImage): Promise<void> {
  const bucket = admin.storage().bucket();
  const file = bucket.file(`cache/images/${key}.json`);
  await file.save(JSON.stringify(data), {
    metadata: {contentType: "application/json"},
  });
}

// 캐시 조회
async function getCachedImage(key: string): Promise<CachedImage | null> {
  const bucket = admin.storage().bucket();
  const file = bucket.file(`cache/images/${key}.json`);
  const [exists] = await file.exists();

  if (!exists) return null;

  const [data] = await file.download();
  return JSON.parse(data.toString()) as CachedImage;
}

// 레이트 리밋 체크
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

// 사용량 기록
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

/**
 * genStickerFree - 무료 사용자용 스티커 생성 함수
 *
 * 2단계 폴백 시스템 사용:
 * 1차: Pixazo ($0, FLUX.1 Schnell 무료)
 * 2차: OpenAI ($0.005/이미지)
 *
 * ⚠️ Pixazo는 월간/요청 한도가 공시되지 않음 — 대시보드에서 주기적 확인 권장
 *
 * 기존 genSticker와 동일한 인터페이스 유지
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// sharp는 convertToWebP()에서 lazy require (다른 함수의 cold start 차단 방지)
import {
  generateImageWithFallback,
  FallbackConfig,
  calculateCost,
  getProviderDisplayName,
} from "./utils/fallbackManager";
import {recordApiCall} from "./utils/monitoring";
import {maskUid} from "./utils/maskUid";

// Prompt injection 방지: 허용 목록 (H-3)
const ALLOWED_BREEDS = [
  "Golden Retriever", "Labrador", "Shiba Inu",
  "Pomeranian", "Husky", "Beagle", "Bulldog", "Poodle",
];
const ALLOWED_COLORS = [
  "golden", "brown", "black", "white", "gray", "cream",
  "orange",
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

// genSticker와 동일한 인터페이스
interface GenStickerFreeRequest {
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

// 무료 사용자 일일 할당량
const FREE_USER_DAILY_QUOTA = 10;

export const genStickerFree = functions
  .region("us-central1")
  .https.onCall(async (data: GenStickerFreeRequest, context) => {
    console.log("🎨 [genStickerFree] Called");

    // =====================
    // 1. App Check 검증
    // =====================
    if (!context.app) {
      console.warn(
        "[genStickerFree] App Check token missing — " +
        "enable enforcement in Firebase Console before production"
      );
    }

    // =====================
    // 2. 인증 확인 (필수)
    // =====================
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required"
      );
    }
    const uid = context.auth.uid;
    console.log(`👤 [genStickerFree] User: ${maskUid(uid)}`);

    // =====================
    // 3. 입력 검증 + allowlist (H-3 prompt injection 방지)
    // =====================
    const {petId, size = 512, seed} = data;
    const breed = ALLOWED_BREEDS
      .includes(data.breed ?? "") ?
      data.breed! : "Shiba Inu";
    const color = ALLOWED_COLORS
      .includes(data.color ?? "") ?
      data.color! : "orange";
    const accessory = ALLOWED_ACCESSORIES
      .includes(data.accessory ?? "") ?
      data.accessory! : "none";
    const style = ALLOWED_STYLES
      .includes(data.style ?? "") ?
      data.style! : "sticker-flat";
    const bg = ALLOWED_BGS
      .includes(data.bg ?? "") ?
      data.bg! : "transparent";

    console.log(`📝 [genStickerFree] petId=${petId}`);

    const PET_ID_REGEX = /^[a-zA-Z0-9_-]{1,64}$/;
    if (!petId || !PET_ID_REGEX.test(petId) ||
      size < 256 || size > 1024) {
      console.error(
        "❌ [genStickerFree] Invalid parameters"
      );
      throw new functions.https.HttpsError(
        "invalid-argument", "Invalid parameters"
      );
    }

    // =====================
    // 4. 레이트 리밋 체크
    // =====================
    const rateLimitOk = await checkAndReserveSlot(uid, FREE_USER_DAILY_QUOTA);
    if (!rateLimitOk) {
      console.error(`❌ [genStickerFree] Rate limit exceeded for user ${uid}`);
      throw new functions.https.HttpsError(
        "resource-exhausted",
        `Daily limit reached (${FREE_USER_DAILY_QUOTA} images/day for free users)`
      );
    }

    // =====================
    // 4. API 키 로드
    // =====================
    const config = functions.config();
    const pixazoApiKey = config.pixazo?.api_key;
    const openaiApiKey = config.openai?.api_key;

    if (!pixazoApiKey) {
      console.error("❌ [genStickerFree] Pixazo API key not configured");
      throw new functions.https.HttpsError("internal", "Pixazo API key not configured");
    }

    if (!openaiApiKey) {
      console.error("❌ [genStickerFree] OpenAI API key not configured");
      throw new functions.https.HttpsError("internal", "OpenAI API key not configured");
    }

    console.log("🔑 [genStickerFree] API keys configured");

    // =====================
    // 5. 프롬프트 생성 (genSticker와 동일한 로직)
    // =====================
    const prompt = generatePrompt(breed, color, accessory, style, bg);
    console.log(`📝 [genStickerFree] Prompt length: ${prompt.length} chars`);

    // =====================
    // 6. 폴백 시스템으로 이미지 생성
    // =====================
    const fallbackConfig: FallbackConfig = {
      pixazoApiKey,
      openaiApiKey,
    };

    const startTime = Date.now();
    const result = await generateImageWithFallback(fallbackConfig, {
      prompt,
      size: 1024, // 항상 1024로 생성 후 리사이즈
      seed,
    });
    const totalDuration = Date.now() - startTime;

    if (!result.success || !result.imageBuffer) {
      console.error(`❌ [genStickerFree] All providers failed after ${totalDuration}ms`);
      console.error(`❌ [genStickerFree] Attempts: ${JSON.stringify(result.attempts)}`);

      // 실패 모니터링 기록
      await recordApiCall({
        provider: result.provider,
        success: false,
        durationMs: totalDuration,
        fallbackUsed: result.attempts.length > 1,
        fallbackReason: result.attempts[0]?.error,
        error: result.error || "All providers failed",
        attempts: result.attempts,
      });

      throw new functions.https.HttpsError("internal", "Image generation failed with all providers");
    }

    // 성공 모니터링 기록
    const fallbackUsed = result.attempts.length > 1 && result.provider !== "pixazo";
    await recordApiCall({
      provider: result.provider,
      success: true,
      durationMs: totalDuration,
      fallbackUsed,
      fallbackReason: fallbackUsed ? result.attempts[0]?.error : undefined,
      attempts: result.attempts,
    });

    console.log(`✅ [genStickerFree] Image generated by ${result.provider} in ${totalDuration}ms`);

    // =====================
    // 7. 이미지 처리 (WebP 변환)
    // =====================
    console.log("🔄 [genStickerFree] Converting to WebP...");
    const webpImage = await convertToWebP(result.imageBuffer, size);
    const base64Image = webpImage.toString("base64");
    console.log(`✅ [genStickerFree] WebP conversion complete, size: ${base64Image.length} chars`);

    // =====================
    // 8. 사용량 기록
    // =====================
    await recordProviderInfo(uid, result.provider);
    console.log(`📊 [genStickerFree] Usage recorded for user ${maskUid(uid)}`);

    // =====================
    // 9. 응답 반환 (genSticker와 동일한 형식 + 추가 정보)
    // =====================
    const response = {
      success: true,
      data: {
        image_base64: base64Image,
        mime: "image/webp",
        seed: seed || Date.now(),
        cached: false,
        size: {width: size, height: size},
        metadata: {breed, color, accessory, style},
        // 무료 사용자용 추가 정보
        provider: result.provider,
        providerName: getProviderDisplayName(result.provider),
        estimatedCost: calculateCost(result.provider),
        attempts: result.attempts,
        totalDurationMs: totalDuration,
      },
    };

    console.log(`🎉 [genStickerFree] Returning success response (provider: ${result.provider})`);
    return response;
  });

// =====================
// 유틸리티 함수들
// =====================

/**
 * 프롬프트 생성 (genSticker와 동일한 로직)
 */
function generatePrompt(
  breed: string,
  color: string,
  accessory: string,
  style: string,
  bg: string
): string {
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

/**
 * WebP 변환
 */
async function convertToWebP(imageBuffer: Buffer, size: number): Promise<Buffer> {
  const {default: sharpModule} = await import("sharp");
  return await sharpModule(imageBuffer)
    .resize(size, size)
    .webp({quality: 90})
    .toBuffer();
}

/**
 * 레이트 리밋 체크 + 슬롯 예약 (원자적)
 *
 * Firestore Transaction으로 check + increment 원자적 수행.
 * TOCTOU race condition 방지 (H-2).
 * Firestore 오류 시 fail-closed (H-1).
 */
async function checkAndReserveSlot(
  uid: string, dailyQuota: number
): Promise<boolean> {
  const db = admin.firestore();
  const today = new Date().toISOString().split("T")[0];
  const usageRef = db.collection("freeImageUsage").doc(uid);

  try {
    return await db.runTransaction(async (tx) => {
      const usageDoc = await tx.get(usageRef);
      const usage = usageDoc.data();
      const currentCount =
        (usage && usage.date === today) ?
          (usage.count || 0) : 0;

      if (currentCount >= dailyQuota) {
        return false;
      }

      // 원자적으로 카운터 증가
      const now = Date.now();
      if (!usageDoc.exists || usage?.date !== today) {
        tx.set(usageRef, {
          date: today,
          count: 1,
          timestamps: [now],
        });
      } else {
        tx.update(usageRef, {
          count: currentCount + 1,
          timestamps:
            admin.firestore.FieldValue.arrayUnion(now),
        });
      }

      return true;
    });
  } catch (error) {
    console.error(
      "❌ [genStickerFree] Rate limit check failed:", error
    );
    // Firestore 오류 시 차단 (fail-closed)
    return false;
  }
}

/**
 * Provider 정보 기록 (모니터링용)
 *
 * 카운터는 checkAndReserveSlot에서 이미 원자적으로 증가됨.
 * 여기서는 provider 메타데이터만 업데이트.
 */
async function recordProviderInfo(
  uid: string, provider: string
): Promise<void> {
  const db = admin.firestore();
  const usageRef = db.collection("freeImageUsage").doc(uid);

  try {
    await usageRef.update({
      providers:
        admin.firestore.FieldValue.arrayUnion(provider),
      lastProvider: provider,
    });
  } catch (error) {
    console.error(
      "❌ [genStickerFree] Error recording provider:", error
    );
  }
}

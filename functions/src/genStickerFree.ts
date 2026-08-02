/**
 * genStickerFree - 무료 사용자용 스티커 생성 함수
 *
 * 2단계 폴백 시스템 사용:
 * 1차: Cloudflare Workers AI (FLUX.1 Schnell, 매일 10,000 neurons 무료 ≈ 170장/일)
 * 2차: OpenAI ($0.005/이미지)
 *
 * ⚠️ Cloudflare 무료 한도 초과 시 Workers Paid($5/월) + 종량제 필요 (매일 00:00 UTC 리셋)
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
import {
  ALLOWED_BREEDS,
  ALLOWED_COLORS,
  ALLOWED_ACCESSORIES,
  ALLOWED_STYLES,
  ALLOWED_BGS,
  pick,
  generatePrompt,
  restrictToFreeTier,
} from "./utils/stickerPrompt";

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

// 무료 사용자 일일 하드캡 = 기본 2 + 리워드 광고 보너스 2.
// quota 함수는 base(2)만 노출하고, 클라이언트가 2 소진 후 광고 시청 시 3·4번째를 허용.
// 서버는 어뷰징 방지를 위해 최대 4로 하드캡(초과 생성 차단).
// 무료 하드캡 = 기본 1 + 리워드 광고 보너스 1 (Phase 28-9)
// ⚠️ 클라이언트 AdConstants.maxImageAdBonus 와 반드시 일치시킬 것
//    (여기 = quota.ts의 free.dailyQuota + maxImageAdBonus)
const FREE_USER_DAILY_QUOTA = 2;

export const genStickerFree = functions
  .region("us-central1")
  .runWith({
    secrets: [
      "CLOUDFLARE_ACCOUNT_ID",
      "CLOUDFLARE_API_TOKEN",
      "OPENAI_API_KEY",
    ],
    // Cloudflare는 $0이지만 실패 시 OpenAI($0.005/장)로 폴백하므로 상한 필요
    maxInstances: 10,
    enforceAppCheck: true,
  })
  .https.onCall(async (data: GenStickerFreeRequest, context) => {
    console.log("🎨 [genStickerFree] Called");

    // =====================
    // 1. App Check 검증
    // =====================
    // runWith의 enforceAppCheck가 플랫폼 단에서 먼저 막지만,
    // 그 설정이 빠지더라도 새지 않도록 코드에서도 닫는다.
    if (!context.app) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "App Check required"
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
    const breed = pick(ALLOWED_BREEDS, data.breed, "Shiba Inu");
    const color = pick(ALLOWED_COLORS, data.color, "orange");

    // 이 함수는 무료 티어 전용이므로 프리미엄 장식은 여기서 강등한다.
    // 클라이언트도 잠그지만 그건 UI일 뿐 — 변조된 클라이언트는 그냥 보낸다.
    // (품종·색상은 무료도 전부 쓸 수 있어 제한 대상이 아니다)
    const restricted = restrictToFreeTier(
      pick(ALLOWED_ACCESSORIES, data.accessory, "none"),
      pick(ALLOWED_STYLES, data.style, "sticker-flat"),
      pick(ALLOWED_BGS, data.bg, "transparent")
    );
    const {accessory, style, bg} = restricted;
    if (restricted.downgraded.length > 0) {
      console.warn(
        "⬇️ [genStickerFree] premium cosmetics downgraded for " +
        `${maskUid(uid)}: ${restricted.downgraded.join(", ")}`
      );
    }

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
    // 4. API 키 로드 (Secret Manager)
    // =====================
    const cloudflareAccountId = process.env.CLOUDFLARE_ACCOUNT_ID;
    const cloudflareApiToken = process.env.CLOUDFLARE_API_TOKEN;
    const openaiApiKey = process.env.OPENAI_API_KEY;

    if (!cloudflareAccountId || !cloudflareApiToken) {
      console.error("❌ [genStickerFree] Cloudflare credentials not configured");
      throw new functions.https.HttpsError(
        "internal", "Cloudflare credentials not configured");
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
      cloudflareAccountId,
      cloudflareApiToken,
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
    const fallbackUsed =
      result.attempts.length > 1 && result.provider !== "cloudflare";
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

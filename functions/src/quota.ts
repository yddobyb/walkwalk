import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {getUserTier, UserTier} from "./utils/getUserTier";
import {maskUid} from "./utils/maskUid";

// 사용자 등급별 설정
const TIER_CONFIG: Record<UserTier, {
  dailyQuota: number;
  collection: string;
  provider: string;
}> = {
  free: {
    dailyQuota: 10,
    collection: "freeImageUsage",
    provider: "cloudflare",
  },
  premium: {
    dailyQuota: 50,
    collection: "imageUsage",
    provider: "gemini",
  },
};

/**
 * 사용자 할당량 조회
 *
 * 사용자 등급에 따라 다른 컬렉션과 한도 적용:
 * - 무료: freeImageUsage, 10회/일
 * - 프리미엄: imageUsage, 50회/일
 */
export const quota = functions
  .region("us-central1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();
    const today = new Date().toISOString().split("T")[0];

    // App Check 검증 (warn-only — Firebase Console에서 enforcement 설정 전까지)
    if (!context.app) {
      console.warn(
        "[quota] App Check token missing — " +
        "enable enforcement in Firebase Console before production"
      );
    }

    // 인증 확인 (필수)
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required"
      );
    }
    const uid = context.auth.uid;
    console.log(`📊 [quota] User: ${maskUid(uid)}`);

    // 사용자 등급 조회
    const tier = await getUserTier(uid);
    const config = TIER_CONFIG[tier];

    console.log(`📊 [quota] Tier: ${tier}, Quota: ${config.dailyQuota}, Collection: ${config.collection}`);

    let used = 0;

    try {
      const usageRef = db.collection(config.collection).doc(uid);
      const usageDoc = await usageRef.get();

      if (usageDoc.exists) {
        const usageData = usageDoc.data();
        if (usageData && usageData.date === today) {
          used = usageData.count || 0;
        }
      }

      console.log(`📊 [quota] User ${maskUid(uid)}: used=${used}/${config.dailyQuota}`);
    } catch (error) {
      console.error("❌ [quota] Error fetching usage:", error);
    }

    return buildQuotaResponse(config.dailyQuota, used, tier);
  });

/**
 * 할당량 응답 생성
 */
function buildQuotaResponse(total: number, used: number, tier: UserTier) {
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  tomorrow.setHours(0, 0, 0, 0);

  return {
    success: true,
    data: {
      remaining: Math.max(0, total - used),
      total: total,
      used: used,
      resetAt: tomorrow.toISOString(),
      nextResetIn: Math.floor((tomorrow.getTime() - Date.now()) / 1000),
      // 프리미엄 통합을 위한 추가 필드
      tier: tier,
      tierDisplayName: tier === "premium" ? "프리미엄" : "무료",
      provider: TIER_CONFIG[tier].provider,
    },
  };
}

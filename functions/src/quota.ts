import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// 사용자 등급별 설정
const TIER_CONFIG = {
  free: {
    dailyQuota: 10,
    collection: "freeImageUsage",
    provider: "pixazo",
  },
  premium: {
    dailyQuota: 50,
    collection: "imageUsage",
    provider: "gemini",
  },
};

type UserTier = "free" | "premium";

/**
 * 사용자 등급 조회
 *
 * Firestore users/{uid}/subscription 문서에서 구독 상태를 확인한다.
 * RevenueCat SDK가 앱에서 구매 성공 시 이 문서를 기록함.
 * 문서가 없거나 만료되었으면 free로 처리.
 */
async function getUserTier(uid: string): Promise<UserTier> {
  const db = admin.firestore();
  try {
    const userDoc = await db.collection("users").doc(uid).get();
    if (userDoc.exists) {
      const sub = userDoc.data()?.subscription;
      if (
        sub?.status === "active" &&
        sub?.expiresAt &&
        new Date(sub.expiresAt) > new Date()
      ) {
        console.log(
          `[getUserTier] User ${uid}: premium ` +
          `(expires ${sub.expiresAt})`
        );
        return "premium";
      }
    }
  } catch (error) {
    console.error(`Error reading user tier: ${error}`);
  }

  console.log(`[getUserTier] User ${uid}: free`);
  return "free";
}

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

    // App Check 검증
    if (!context.app) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "App Check required"
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
    console.log(`📊 [quota] User: ${uid}`);

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

      console.log(`📊 [quota] User ${uid}: used=${used}/${config.dailyQuota}`);
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

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const quota = functions
  .region("us-central1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();
    const today = new Date().toISOString().split("T")[0];

    const dailyQuota = 20; // 일일 할당량
    let used = 0;

    // 인증 확인: auth context가 있으면 사용, 없으면 전달받은 userId 사용
    let uid: string;
    if (context.auth) {
      uid = context.auth.uid;
      console.log(`📊 Quota requested with auth: ${uid}`);
    } else if (data && data.userId) {
      uid = data.userId as string;
      console.log(`📊 Quota requested with passed userId: ${uid}`);
    } else {
      console.log("📊 Quota requested without auth or userId - returning default");
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(0, 0, 0, 0);

      return {
        success: true,
        data: {
          remaining: dailyQuota,
          total: dailyQuota,
          used: 0,
          resetAt: tomorrow.toISOString(),
          nextResetIn: Math.floor((tomorrow.getTime() - Date.now()) / 1000),
        },
      };
    }

    try {
      const usageRef = db.collection("imageUsage").doc(uid);
      const usageDoc = await usageRef.get();

      if (usageDoc.exists) {
        const usageData = usageDoc.data();
        if (usageData && usageData.date === today) {
          used = usageData.count || 0;
        }
      }

      console.log(`📊 Quota for user ${uid}: used=${used}, total=${dailyQuota}`);
    } catch (error) {
      console.error("❌ Error fetching quota:", error);
      // Firestore 오류 시에도 기본값 반환
    }

    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(0, 0, 0, 0);

    return {
      success: true,
      data: {
        remaining: Math.max(0, dailyQuota - used),
        total: dailyQuota,
        used: used,
        resetAt: tomorrow.toISOString(),
        nextResetIn: Math.floor((tomorrow.getTime() - Date.now()) / 1000),
      },
    };
  });

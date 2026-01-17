import * as functions from "firebase-functions";
// import * as admin from "firebase-admin"; // Week 4 테스트: Firestore 사용 안함

export const quota = functions
  .region("us-central1")
  .https.onCall(async () => { // Week 4 테스트: data, context 미사용
    // Week 4 테스트: 인증 체크 임시 제거
    // if (!context.auth) {
    //   throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    // }

    // Week 4 테스트: Firestore 대신 하드코딩된 값 사용
    // const uid = context.auth?.uid || "test-user-" + Date.now();
    // const db = admin.firestore();
    // const today = new Date().toISOString().split("T")[0];
    // const config = functions.config();

    // const usageRef = db.collection("imageUsage").doc(uid);
    // const usageDoc = await usageRef.get();

    const dailyQuota = 20; // 테스트용 고정값
    const used = 0; // 테스트용: 항상 0으로 시작

    // if (usageDoc.exists && usageDoc.data()!.date === today) {
    //   used = usageDoc.data()!.count;
    // }

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

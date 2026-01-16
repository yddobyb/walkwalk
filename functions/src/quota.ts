import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const quota = functions
  .region("us-central1")
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }

    const uid = context.auth.uid;
    const db = admin.firestore();
    const today = new Date().toISOString().split("T")[0];
    const config = functions.config();

    const usageRef = db.collection("imageUsage").doc(uid);
    const usageDoc = await usageRef.get();

    const dailyQuota = parseInt(config.limits.daily_quota);
    let used = 0;

    if (usageDoc.exists && usageDoc.data()!.date === today) {
      used = usageDoc.data()!.count;
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

/**
 * syncSubscription - 구독 상태 Firestore 동기화 Cloud Function
 *
 * 클라이언트(RevenueCat SDK)에서 구독 상태를 전달받아
 * Admin SDK로 Firestore에 기록한다.
 *
 * 보안: 클라이언트가 subscription 필드를 직접 쓰지 못하도록
 * Firestore Rules에서 차단하고, 이 함수를 통해서만 기록.
 *
 * 향후: RevenueCat Webhook → Cloud Functions으로 전환 예정 (방안 B)
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

interface SyncSubscriptionRequest {
  status: "active" | "inactive";
  expiresAt?: string;
  productId?: string;
}

export const syncSubscription = functions
  .region("us-central1")
  .https.onCall(async (data: SyncSubscriptionRequest, context) => {
    // 1. App Check
    if (!context.app) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "App Check required"
      );
    }

    // 2. 인증 확인
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required"
      );
    }

    const uid = context.auth.uid;

    // 3. 입력 검증
    const {status, expiresAt, productId} = data;

    if (!status || !["active", "inactive"].includes(status)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid status: must be 'active' or 'inactive'"
      );
    }

    if (status === "active" && !expiresAt) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "expiresAt is required for active subscriptions"
      );
    }

    // expiresAt 날짜 유효성 검증
    if (expiresAt) {
      const expDate = new Date(expiresAt);
      if (isNaN(expDate.getTime())) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid expiresAt date format"
        );
      }
    }

    // 4. Firestore에 기록 (Admin SDK → rules 우회)
    const db = admin.firestore();
    const userRef = db.collection("users").doc(uid);

    try {
      await userRef.set(
        {
          subscription: {
            status,
            expiresAt: expiresAt || null,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            productId: productId || "",
          },
        },
        {merge: true}
      );

      console.log(
        `[syncSubscription] User ${uid}: ${status}` +
        (expiresAt ? ` (expires ${expiresAt})` : "")
      );

      return {success: true};
    } catch (error) {
      console.error(
        `[syncSubscription] Error for user ${uid}:`, error
      );
      throw new functions.https.HttpsError(
        "internal",
        "Failed to sync subscription"
      );
    }
  });

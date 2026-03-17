import * as admin from "firebase-admin";

export type UserTier = "free" | "premium";

/**
 * 사용자 등급 조회
 *
 * Firestore users/{uid}.subscription 필드에서 구독 상태를 확인한다.
 * syncSubscription Cloud Function이 이 필드를 기록함.
 * 문서가 없거나 만료되었으면 free로 처리.
 */
export async function getUserTier(
  uid: string
): Promise<UserTier> {
  const db = admin.firestore();
  try {
    const userDoc = await db
      .collection("users").doc(uid).get();
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

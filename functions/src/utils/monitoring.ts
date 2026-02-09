/**
 * Monitoring Utility for Image Generation
 *
 * Firestore에 API 호출 통계를 자동 기록
 * - 일일 통계 (호출 수, 성공률, 응답시간, 비용)
 * - 실시간 상태 (마지막 호출, 에러)
 */

import * as admin from "firebase-admin";
import {ImageProvider} from "./fallbackManager";

// 비용 테이블 (USD per image)
const COST_PER_IMAGE: Record<string, number> = {
  pixazo: 0.0012,
  openai: 0.005,
  gemini: 0.039,
};

interface MonitoringEvent {
  provider: ImageProvider;
  success: boolean;
  durationMs: number;
  fallbackUsed: boolean;
  fallbackReason?: string;
  error?: string;
  attempts: {
    provider: ImageProvider;
    success: boolean;
    error?: string;
    durationMs: number;
  }[];
}

/**
 * API 호출 결과를 Firestore에 기록
 */
export async function recordApiCall(event: MonitoringEvent): Promise<void> {
  const db = admin.firestore();
  const today = new Date().toISOString().split("T")[0];

  try {
    const dailyRef = db.collection("monitoring").doc(`daily-${today}`);
    const realtimeRef = db.collection("monitoring").doc("realtime");

    const cost = event.success ? (COST_PER_IMAGE[event.provider] || 0) : 0;

    // 일일 통계 업데이트 (atomic increment)
    await dailyRef.set(
      {
        date: today,
        totalCalls: admin.firestore.FieldValue.increment(1),
        successCount: admin.firestore.FieldValue.increment(event.success ? 1 : 0),
        failCount: admin.firestore.FieldValue.increment(event.success ? 0 : 1),
        pixazoCount: admin.firestore.FieldValue.increment(
          event.provider === "pixazo" && event.success ? 1 : 0
        ),
        openaiCount: admin.firestore.FieldValue.increment(
          event.provider === "openai" && event.success ? 1 : 0
        ),
        fallbackCount: admin.firestore.FieldValue.increment(event.fallbackUsed ? 1 : 0),
        totalDurationMs: admin.firestore.FieldValue.increment(event.durationMs),
        estimatedCost: admin.firestore.FieldValue.increment(cost),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true}
    );

    // 에러 로그 기록 (실패 시)
    if (!event.success && event.error) {
      const errorLogRef = db.collection("monitoring")
        .doc(`daily-${today}`)
        .collection("errors")
        .doc();

      await errorLogRef.set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        provider: event.provider,
        error: event.error,
        attempts: event.attempts,
      });
    }

    // 폴백 로그 기록
    if (event.fallbackUsed) {
      const fallbackLogRef = db.collection("monitoring")
        .doc(`daily-${today}`)
        .collection("fallbacks")
        .doc();

      await fallbackLogRef.set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        reason: event.fallbackReason || "unknown",
        fromProvider: event.attempts[0]?.provider || "unknown",
        toProvider: event.provider,
        attempts: event.attempts,
      });
    }

    // 실시간 상태 업데이트
    const realtimeData: Record<string, unknown> = {
      lastCallAt: admin.firestore.FieldValue.serverTimestamp(),
      lastProvider: event.provider,
      lastSuccess: event.success,
      lastDurationMs: event.durationMs,
    };

    if (!event.success) {
      realtimeData.lastErrorAt = admin.firestore.FieldValue.serverTimestamp();
      realtimeData.lastError = event.error || "Unknown error";
    }

    await realtimeRef.set(realtimeData, {merge: true});

    const status = event.success ? "✅" : "❌";
    console.log(
      `📊 [Monitoring] Recorded: ${status} ` +
      `${event.provider} ${event.durationMs}ms $${cost.toFixed(4)}`
    );
  } catch (error) {
    // 모니터링 실패는 메인 로직에 영향을 주지 않음
    console.error("⚠️ [Monitoring] Failed to record:", error);
  }
}

/**
 * 일일 통계 조회
 */
export async function getDailyStats(date?: string): Promise<Record<string, unknown> | null> {
  const db = admin.firestore();
  const targetDate = date || new Date().toISOString().split("T")[0];

  try {
    const doc = await db.collection("monitoring").doc(`daily-${targetDate}`).get();
    if (!doc.exists) return null;

    const data = doc.data()!;
    const totalCalls = data.totalCalls || 0;
    const successCount = data.successCount || 0;
    const totalDuration = data.totalDurationMs || 0;

    return {
      ...data,
      successRate: totalCalls > 0 ? ((successCount / totalCalls) * 100).toFixed(1) + "%" : "N/A",
      avgResponseTime: totalCalls > 0 ? Math.round(totalDuration / totalCalls) + "ms" : "N/A",
      pixazoRate: totalCalls > 0 ?
        (((data.pixazoCount || 0) / successCount) * 100).toFixed(1) + "%" :
        "N/A",
      fallbackRate: totalCalls > 0 ?
        (((data.fallbackCount || 0) / totalCalls) * 100).toFixed(1) + "%" :
        "N/A",
    };
  } catch (error) {
    console.error("❌ [Monitoring] Failed to get stats:", error);
    return null;
  }
}

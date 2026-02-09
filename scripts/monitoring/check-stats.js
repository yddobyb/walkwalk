/**
 * 모니터링 통계 조회 스크립트
 *
 * 사용법:
 *   node scripts/monitoring/check-stats.js              # 오늘 통계
 *   node scripts/monitoring/check-stats.js 2026-02-07   # 특정 날짜
 *   node scripts/monitoring/check-stats.js --week        # 최근 7일
 *   node scripts/monitoring/check-stats.js --realtime    # 실시간 상태
 */

const admin = require("firebase-admin");
const path = require("path");

// Firebase 초기화
const serviceAccountPath = path.resolve(
  __dirname,
  "../../functions/service-account-key.json"
);

let app;
try {
  const serviceAccount = require(serviceAccountPath);
  app = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
} catch (e) {
  // service account 없으면 기본 credentials 사용
  app = admin.initializeApp({
    projectId: "walkwalkddog",
  });
}

const db = admin.firestore();

async function getDailyStats(date) {
  const docRef = db.collection("monitoring").doc(`daily-${date}`);
  const doc = await docRef.get();

  if (!doc.exists) {
    return null;
  }

  return doc.data();
}

async function getRealtimeStatus() {
  const doc = await db.collection("monitoring").doc("realtime").get();
  if (!doc.exists) return null;
  return doc.data();
}

async function getRecentErrors(date, limit = 5) {
  const snapshot = await db
    .collection("monitoring")
    .doc(`daily-${date}`)
    .collection("errors")
    .orderBy("timestamp", "desc")
    .limit(limit)
    .get();

  return snapshot.docs.map((doc) => doc.data());
}

async function getRecentFallbacks(date, limit = 5) {
  const snapshot = await db
    .collection("monitoring")
    .doc(`daily-${date}`)
    .collection("fallbacks")
    .orderBy("timestamp", "desc")
    .limit(limit)
    .get();

  return snapshot.docs.map((doc) => doc.data());
}

function formatStats(date, data) {
  if (!data) {
    console.log(`\n📅 ${date}: 데이터 없음\n`);
    return;
  }

  const totalCalls = data.totalCalls || 0;
  const successCount = data.successCount || 0;
  const failCount = data.failCount || 0;
  const pixazoCount = data.pixazoCount || 0;
  const openaiCount = data.openaiCount || 0;
  const fallbackCount = data.fallbackCount || 0;
  const totalDuration = data.totalDurationMs || 0;
  const estimatedCost = data.estimatedCost || 0;

  const successRate =
    totalCalls > 0 ? ((successCount / totalCalls) * 100).toFixed(1) : "N/A";
  const avgTime =
    totalCalls > 0 ? Math.round(totalDuration / totalCalls) : "N/A";
  const fallbackRate =
    totalCalls > 0 ? ((fallbackCount / totalCalls) * 100).toFixed(1) : "N/A";

  console.log(`
╔══════════════════════════════════════════════╗
║  📊 모니터링 리포트: ${date}
╠══════════════════════════════════════════════╣
║  총 호출 수:     ${String(totalCalls).padStart(6)}
║  성공:           ${String(successCount).padStart(6)} (${successRate}%)
║  실패:           ${String(failCount).padStart(6)}
╠══════════════════════════════════════════════╣
║  Provider 분포:
║    Pixazo:       ${String(pixazoCount).padStart(6)}
║    OpenAI:       ${String(openaiCount).padStart(6)} (폴백)
║    폴백 발생:    ${String(fallbackCount).padStart(6)} (${fallbackRate}%)
╠══════════════════════════════════════════════╣
║  성능:
║    평균 응답시간: ${String(avgTime).padStart(6)}ms
║    총 응답시간:   ${String(Math.round(totalDuration / 1000)).padStart(6)}s
╠══════════════════════════════════════════════╣
║  비용:
║    추정 비용:    $${estimatedCost.toFixed(4).padStart(8)}
║    1,000명 추정: $${(estimatedCost * (1000 / Math.max(totalCalls, 1)) * 5).toFixed(2).padStart(8)}/일
╚══════════════════════════════════════════════╝`);
}

async function main() {
  const args = process.argv.slice(2);

  try {
    if (args.includes("--realtime")) {
      // 실시간 상태
      console.log("\n🔴 실시간 상태:");
      const status = await getRealtimeStatus();
      if (status) {
        console.log(`  마지막 호출: ${status.lastCallAt?.toDate?.() || "N/A"}`);
        console.log(`  마지막 Provider: ${status.lastProvider || "N/A"}`);
        console.log(`  마지막 성공: ${status.lastSuccess ? "✅" : "❌"}`);
        console.log(`  마지막 응답시간: ${status.lastDurationMs || "N/A"}ms`);
        if (status.lastError) {
          console.log(`  마지막 에러: ${status.lastError}`);
          console.log(`  에러 시간: ${status.lastErrorAt?.toDate?.() || "N/A"}`);
        }
      } else {
        console.log("  데이터 없음");
      }
    } else if (args.includes("--week")) {
      // 최근 7일
      console.log("\n📈 최근 7일 통계:");
      let totalCost = 0;
      let totalCalls = 0;

      for (let i = 0; i < 7; i++) {
        const d = new Date();
        d.setDate(d.getDate() - i);
        const dateStr = d.toISOString().split("T")[0];
        const data = await getDailyStats(dateStr);

        if (data) {
          formatStats(dateStr, data);
          totalCost += data.estimatedCost || 0;
          totalCalls += data.totalCalls || 0;
        }
      }

      console.log(`\n📊 7일 합계: ${totalCalls}건, $${totalCost.toFixed(4)}`);
    } else {
      // 특정 날짜 또는 오늘
      const date = args[0] || new Date().toISOString().split("T")[0];
      const data = await getDailyStats(date);
      formatStats(date, data);

      // 에러 로그
      const errors = await getRecentErrors(date);
      if (errors.length > 0) {
        console.log(`\n❌ 최근 에러 (${errors.length}건):`);
        errors.forEach((err, i) => {
          console.log(`  ${i + 1}. [${err.provider}] ${err.error}`);
        });
      }

      // 폴백 로그
      const fallbacks = await getRecentFallbacks(date);
      if (fallbacks.length > 0) {
        console.log(`\n🔄 최근 폴백 (${fallbacks.length}건):`);
        fallbacks.forEach((fb, i) => {
          console.log(
            `  ${i + 1}. ${fb.fromProvider} → ${fb.toProvider} (사유: ${fb.reason})`
          );
        });
      }
    }
  } catch (error) {
    console.error("오류:", error.message);
  }

  process.exit(0);
}

main();

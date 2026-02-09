// Quick monitoring check - uses firebase-admin from functions/node_modules
const admin = require('../../functions/node_modules/firebase-admin');
const {GoogleAuth} = require('../../functions/node_modules/google-auth-library');
const path = require('path');
const fs = require('fs');

// Firebase ADC 경로 설정
const adcPath = path.join(
  process.env.HOME,
  '.config/firebase/gmkid6841_gmail_com_application_default_credentials.json'
);

if (fs.existsSync(adcPath)) {
  process.env.GOOGLE_APPLICATION_CREDENTIALS = adcPath;
}

admin.initializeApp({projectId: 'walkwalkddog'});
const db = admin.firestore();
const today = new Date().toISOString().split('T')[0];

async function main() {
  try {
    const doc = await db.collection('monitoring').doc('daily-' + today).get();
    if (!doc.exists) {
      console.log('모니터링 데이터 없음');
      process.exit(0);
    }

    const d = doc.data();
    const avg = d.totalCalls > 0 ? Math.round(d.totalDurationMs / d.totalCalls) : 0;
    const successRate = d.totalCalls > 0 ? ((d.successCount / d.totalCalls) * 100).toFixed(1) : '0';

    console.log('╔══════════════════════════════════════╗');
    console.log('║  모니터링 리포트: ' + today + '  ║');
    console.log('╠══════════════════════════════════════╣');
    console.log('║  총 호출:    ' + (d.totalCalls || 0));
    console.log('║  성공:       ' + (d.successCount || 0) + ' (' + successRate + '%)');
    console.log('║  실패:       ' + (d.failCount || 0));
    console.log('║  Pixazo:     ' + (d.pixazoCount || 0));
    console.log('║  OpenAI:     ' + (d.openaiCount || 0));
    console.log('║  폴백:       ' + (d.fallbackCount || 0));
    console.log('║  평균응답:   ' + avg + 'ms');
    console.log('║  추정비용:   $' + (d.estimatedCost || 0).toFixed(4));
    console.log('╚══════════════════════════════════════╝');

    // 실시간 상태도 확인
    const rtDoc = await db.collection('monitoring').doc('realtime').get();
    if (rtDoc.exists) {
      const rt = rtDoc.data();
      console.log('\n실시간 상태:');
      console.log('  마지막 Provider: ' + (rt.lastProvider || 'N/A'));
      console.log('  마지막 성공: ' + (rt.lastSuccess ? 'Yes' : 'No'));
      console.log('  마지막 응답: ' + (rt.lastDurationMs || 'N/A') + 'ms');
    }
  } catch (err) {
    console.error('Error:', err.message);
  }
  process.exit(0);
}

main();

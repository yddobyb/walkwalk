/**
 * 일일 한도 초과 테스트
 * test-user-001로 여러 번 호출해서 한도 도달 시 에러 확인
 */

import { initializeApp } from 'firebase/app';
import { getFunctions, httpsCallable } from 'firebase/functions';

const firebaseConfig = {
  apiKey: "AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  authDomain: "walkwalkddog.firebaseapp.com",
  projectId: "walkwalkddog",
  storageBucket: "walkwalkddog.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456"
};

const app = initializeApp(firebaseConfig);
const functions = getFunctions(app, 'us-central1');

async function testRateLimit() {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║     🧪 일일 한도 초과 테스트                                 ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');
  console.log('⚠️  이 테스트는 API를 여러 번 호출합니다 (비용 발생)');
  console.log('');

  const genStickerFree = httpsCallable(functions, 'genStickerFree');
  const userId = 'rate-limit-test-user';

  // 현재 사용량 확인을 위해 먼저 11번 시도
  // (새 사용자이므로 0부터 시작)
  const maxAttempts = 12; // 10번 성공 + 1번 실패 예상 + 1번 여유

  for (let i = 1; i <= maxAttempts; i++) {
    console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
    console.log(`📋 시도 ${i}/${maxAttempts}`);

    try {
      const startTime = Date.now();
      const result = await genStickerFree({
        petId: `rate-limit-test-${i}`,
        breed: "Shiba Inu",
        color: "orange",
        accessory: "none",
        style: "sticker-flat",
        size: 512,
        bg: "white",
        userId: userId
      });
      const elapsed = Date.now() - startTime;

      console.log(`✅ 성공 (${(elapsed/1000).toFixed(1)}초) - 사용량: ${i}/10`);

      // 10번 성공하면 다음은 실패해야 함
      if (i >= 10) {
        console.log('');
        console.log('⚠️  10회 도달! 다음 호출은 실패해야 합니다...');
      }

    } catch (error) {
      console.log('');
      if (error.code === 'functions/resource-exhausted') {
        console.log('🎉 한도 초과 에러 정상 발생!');
        console.log(`   ❌ Error Code: ${error.code}`);
        console.log(`   📝 Message: ${error.message}`);
        console.log('');
        console.log('✅ 일일 한도 제한이 정상적으로 작동합니다!');
        break;
      } else {
        console.log(`❌ 예상치 못한 에러: ${error.code}`);
        console.log(`   Message: ${error.message}`);
      }
    }

    // API 부하 방지 (2초 대기)
    if (i < maxAttempts) {
      await new Promise(resolve => setTimeout(resolve, 2000));
    }
  }

  console.log('');
  console.log('테스트 완료!');
}

testRateLimit();

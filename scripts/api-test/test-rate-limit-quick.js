/**
 * 일일 한도 초과 테스트 (빠른 버전)
 * test-user-001 사용 (현재 2/10)
 * 9번 더 호출해서 한도 초과 확인
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
  console.log('📊 test-user-001 현재 사용량: 2/10');
  console.log('🎯 목표: 8번 성공 → 10/10 도달 → 9번째 호출에서 에러');
  console.log('');

  const genStickerFree = httpsCallable(functions, 'genStickerFree');
  const userId = 'test-user-001';

  let currentCount = 2; // 현재 사용량
  const maxAttempts = 10; // 8번 성공 + 1번 실패 + 1번 여유

  for (let i = 1; i <= maxAttempts; i++) {
    console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
    console.log(`📋 호출 ${i}/${maxAttempts} (예상 사용량: ${currentCount + 1}/10)`);

    const startTime = Date.now();

    try {
      const result = await genStickerFree({
        petId: `rate-limit-test-${Date.now()}`,
        breed: "Beagle",
        color: "brown",
        accessory: "none",
        style: "sticker-flat",
        size: 512,
        bg: "white",
        userId: userId
      });
      const elapsed = Date.now() - startTime;
      currentCount++;

      console.log(`✅ 성공! (${(elapsed/1000).toFixed(1)}초)`);
      console.log(`   📊 현재 사용량: ${currentCount}/10`);
      console.log(`   🎯 Provider: ${result.data?.data?.provider || 'unknown'}`);

      if (currentCount >= 10) {
        console.log('');
        console.log('⚠️  10회 도달! 다음 호출은 실패해야 합니다...');
      }

    } catch (error) {
      const elapsed = Date.now() - startTime;
      console.log('');

      if (error.code === 'functions/resource-exhausted') {
        console.log('╔════════════════════════════════════════════════════════════╗');
        console.log('║  🎉 한도 초과 에러 정상 발생!                               ║');
        console.log('╚════════════════════════════════════════════════════════════╝');
        console.log('');
        console.log(`   ❌ Error Code: ${error.code}`);
        console.log(`   📝 Message: ${error.message}`);
        console.log(`   ⏱️  응답 시간: ${(elapsed/1000).toFixed(2)}초`);
        console.log('');
        console.log('✅ 일일 한도 제한 (10회/일) 정상 작동 확인!');
        console.log('');
        return true; // 테스트 성공
      } else {
        console.log(`❌ 예상치 못한 에러: ${error.code}`);
        console.log(`   Message: ${error.message}`);
        return false; // 테스트 실패
      }
    }

    // API 부하 방지 (1.5초 대기)
    if (i < maxAttempts) {
      process.stdout.write('   ⏳ 다음 호출까지 1.5초 대기...\r');
      await new Promise(resolve => setTimeout(resolve, 1500));
      process.stdout.write('                                    \r');
    }
  }

  console.log('');
  console.log('⚠️  10번 호출했지만 에러가 발생하지 않았습니다.');
  console.log('   한도 제한이 제대로 작동하지 않을 수 있습니다.');
  return false;
}

testRateLimit().then(success => {
  console.log('');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(success ? '✅ 테스트 통과!' : '❌ 테스트 실패');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  process.exit(success ? 0 : 1);
});

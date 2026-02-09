/**
 * 부하 테스트 스크립트
 *
 * Phase 6: 동시 다중 요청 및 연속 요청 테스트
 *
 * 사용법:
 *   node scripts/api-test/load-test.js                  # 전체 테스트
 *   node scripts/api-test/load-test.js --concurrent 5   # 동시 5명
 *   node scripts/api-test/load-test.js --sequential 10  # 연속 10회
 */

import { initializeApp } from 'firebase/app';
import { getFunctions, httpsCallable } from 'firebase/functions';

// Firebase 설정
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
const genStickerFree = httpsCallable(functions, 'genStickerFree');

// 테스트 요청 생성
const breeds = ['Shiba Inu', 'Golden Retriever', 'Poodle', 'Husky', 'Beagle', 'Bulldog', 'Pomeranian', 'Labrador'];
const colors = ['golden', 'brown', 'black', 'white', 'gray', 'cream'];
const accessories = ['none', 'bandana', 'glasses', 'bowtie', 'hat', 'collar'];

function randomRequest(userId) {
  return {
    petId: `load-test-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`,
    breed: breeds[Math.floor(Math.random() * breeds.length)],
    color: colors[Math.floor(Math.random() * colors.length)],
    accessory: accessories[Math.floor(Math.random() * accessories.length)],
    style: 'sticker-flat',
    size: 512,
    bg: 'white',
    userId: userId,
  };
}

// 단일 요청 실행
async function singleRequest(userId, index) {
  const req = randomRequest(userId);
  const startTime = Date.now();

  try {
    const result = await genStickerFree(req);
    const duration = Date.now() - startTime;
    const data = result.data;

    return {
      index,
      userId,
      success: true,
      provider: data.data?.provider || 'unknown',
      durationMs: duration,
      breed: req.breed,
      error: null,
    };
  } catch (error) {
    const duration = Date.now() - startTime;
    return {
      index,
      userId,
      success: false,
      provider: 'none',
      durationMs: duration,
      breed: req.breed,
      error: error.code || error.message,
    };
  }
}

// 동시 요청 테스트
async function concurrentTest(numUsers) {
  console.log(`\n🔥 동시 ${numUsers}명 요청 테스트`);
  console.log('─'.repeat(50));

  const startTime = Date.now();
  const promises = [];

  for (let i = 0; i < numUsers; i++) {
    promises.push(singleRequest(`concurrent-user-${i}`, i));
  }

  const results = await Promise.all(promises);
  const totalDuration = Date.now() - startTime;

  // 결과 분석
  const successes = results.filter(r => r.success);
  const failures = results.filter(r => !r.success);
  const avgDuration = results.reduce((sum, r) => sum + r.durationMs, 0) / results.length;
  const maxDuration = Math.max(...results.map(r => r.durationMs));
  const minDuration = Math.min(...results.map(r => r.durationMs));

  console.log(`\n📊 동시 ${numUsers}명 결과:`);
  console.log(`  총 소요시간: ${(totalDuration / 1000).toFixed(1)}초`);
  console.log(`  성공: ${successes.length}/${numUsers} (${((successes.length / numUsers) * 100).toFixed(0)}%)`);
  console.log(`  실패: ${failures.length}/${numUsers}`);
  console.log(`  평균 응답: ${Math.round(avgDuration)}ms`);
  console.log(`  최소 응답: ${Math.round(minDuration)}ms`);
  console.log(`  최대 응답: ${Math.round(maxDuration)}ms`);

  // 개별 결과
  results.forEach(r => {
    const icon = r.success ? '✅' : '❌';
    const info = r.success ? `${r.provider} ${r.durationMs}ms` : `${r.error} ${r.durationMs}ms`;
    console.log(`  ${icon} User ${r.index}: ${r.breed} → ${info}`);
  });

  if (failures.length > 0) {
    console.log(`\n  ❌ 실패 원인:`);
    failures.forEach(f => {
      console.log(`    - User ${f.index}: ${f.error}`);
    });
  }

  return { successes: successes.length, failures: failures.length, avgDuration, totalDuration };
}

// 순차 요청 테스트
async function sequentialTest(numRequests) {
  console.log(`\n📋 연속 ${numRequests}회 순차 요청 테스트`);
  console.log('─'.repeat(50));

  const results = [];
  const userId = `sequential-user-${Date.now()}`;

  for (let i = 0; i < numRequests; i++) {
    console.log(`  [${i + 1}/${numRequests}] 요청 중...`);
    const result = await singleRequest(userId, i);
    results.push(result);

    const icon = result.success ? '✅' : '❌';
    const info = result.success
      ? `${result.provider} ${result.durationMs}ms`
      : `${result.error} ${result.durationMs}ms`;
    console.log(`  ${icon} #${i + 1}: ${result.breed} → ${info}`);

    // 레이트 리밋 방지를 위한 대기 (1초)
    if (i < numRequests - 1) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  // 결과 분석
  const successes = results.filter(r => r.success);
  const failures = results.filter(r => !r.success);
  const durations = successes.map(r => r.durationMs);
  const avgDuration = durations.length > 0 ? durations.reduce((a, b) => a + b, 0) / durations.length : 0;

  // Provider 분포
  const providerCounts = {};
  successes.forEach(r => {
    providerCounts[r.provider] = (providerCounts[r.provider] || 0) + 1;
  });

  console.log(`\n📊 연속 ${numRequests}회 결과:`);
  console.log(`  성공: ${successes.length}/${numRequests} (${((successes.length / numRequests) * 100).toFixed(0)}%)`);
  console.log(`  실패: ${failures.length}/${numRequests}`);
  console.log(`  평균 응답: ${Math.round(avgDuration)}ms`);
  console.log(`  Provider 분포:`);
  Object.entries(providerCounts).forEach(([provider, count]) => {
    console.log(`    ${provider}: ${count}회 (${((count / successes.length) * 100).toFixed(0)}%)`);
  });

  if (failures.length > 0) {
    console.log(`  실패 원인:`);
    const errorCounts = {};
    failures.forEach(f => {
      errorCounts[f.error] = (errorCounts[f.error] || 0) + 1;
    });
    Object.entries(errorCounts).forEach(([error, count]) => {
      console.log(`    ${error}: ${count}건`);
    });
  }

  return { successes: successes.length, failures: failures.length, avgDuration };
}

// 메인 실행
async function main() {
  const args = process.argv.slice(2);

  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║       🔥 Phase 6: 부하 테스트                              ║');
  console.log('╚════════════════════════════════════════════════════════════╝');

  const startTime = Date.now();

  try {
    if (args.includes('--concurrent')) {
      const idx = args.indexOf('--concurrent');
      const num = parseInt(args[idx + 1]) || 5;
      await concurrentTest(num);
    } else if (args.includes('--sequential')) {
      const idx = args.indexOf('--sequential');
      const num = parseInt(args[idx + 1]) || 10;
      await sequentialTest(num);
    } else {
      // 전체 테스트 수행
      console.log('\n🏁 전체 부하 테스트 시작\n');

      // 1. 동시 3명
      const c3 = await concurrentTest(3);

      // 잠시 대기
      console.log('\n⏳ 10초 대기...');
      await new Promise(resolve => setTimeout(resolve, 10000));

      // 2. 동시 5명
      const c5 = await concurrentTest(5);

      // 잠시 대기
      console.log('\n⏳ 10초 대기...');
      await new Promise(resolve => setTimeout(resolve, 10000));

      // 3. 연속 5회
      const s5 = await sequentialTest(5);

      // 종합 리포트
      const totalDuration = Date.now() - startTime;
      console.log('\n');
      console.log('╔════════════════════════════════════════════════════════════╗');
      console.log('║       📊 종합 부하 테스트 리포트                            ║');
      console.log('╠════════════════════════════════════════════════════════════╣');
      console.log(`║  총 소요시간: ${(totalDuration / 1000).toFixed(0)}초`);
      console.log(`║`);
      console.log(`║  동시 3명:  성공 ${c3.successes}/3, 평균 ${Math.round(c3.avgDuration)}ms`);
      console.log(`║  동시 5명:  성공 ${c5.successes}/5, 평균 ${Math.round(c5.avgDuration)}ms`);
      console.log(`║  연속 5회:  성공 ${s5.successes}/5, 평균 ${Math.round(s5.avgDuration)}ms`);
      console.log(`║`);
      const totalSuccess = c3.successes + c5.successes + s5.successes;
      const totalRequests = 3 + 5 + 5;
      console.log(`║  전체 성공률: ${totalSuccess}/${totalRequests} (${((totalSuccess / totalRequests) * 100).toFixed(0)}%)`);
      console.log(`╚════════════════════════════════════════════════════════════╝`);
    }
  } catch (error) {
    console.error('❌ 테스트 오류:', error.message);
  }

  process.exit(0);
}

main();

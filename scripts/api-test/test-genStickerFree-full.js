/**
 * genStickerFree Firebase Function 전체 테스트
 *
 * 테스트 시나리오:
 * 1. 다양한 견종 테스트
 * 2. 다양한 악세서리 테스트
 * 3. 다양한 스타일 테스트
 */

import { initializeApp } from 'firebase/app';
import { getFunctions, httpsCallable } from 'firebase/functions';
import fs from 'fs';

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

async function runTests() {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║     🧪 genStickerFree 전체 통합 테스트                      ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');

  const genStickerFree = httpsCallable(functions, 'genStickerFree');

  const testCases = [
    {
      name: "테스트 1: Golden Retriever + glasses",
      request: {
        petId: "test-golden-001",
        breed: "Golden Retriever",
        color: "golden",
        accessory: "glasses",
        style: "sticker-flat",
        size: 512,
        bg: "white",
        userId: "test-user-001"
      }
    },
    {
      name: "테스트 2: Poodle + bowtie + 3D 스타일",
      request: {
        petId: "test-poodle-001",
        breed: "Poodle",
        color: "white",
        accessory: "bowtie",
        style: "sticker-3d",
        size: 512,
        bg: "white",
        userId: "test-user-002"
      }
    },
    {
      name: "테스트 3: Corgi + hat",
      request: {
        petId: "test-corgi-001",
        breed: "Welsh Corgi",
        color: "brown and white",
        accessory: "hat",
        style: "sticker-flat",
        size: 512,
        bg: "white",
        userId: "test-user-003"
      }
    }
  ];

  const results = [];

  for (let i = 0; i < testCases.length; i++) {
    const testCase = testCases[i];
    console.log('');
    console.log('━'.repeat(60));
    console.log(`📋 ${testCase.name}`);
    console.log('━'.repeat(60));

    const startTime = Date.now();

    try {
      console.log('⏳ API 호출 중...');
      const result = await genStickerFree(testCase.request);
      const elapsed = Date.now() - startTime;

      const data = result.data?.data;

      console.log('');
      console.log('✅ 성공!');
      console.log(`   ⏱️  시간: ${(elapsed/1000).toFixed(2)}초`);
      console.log(`   🎯 Provider: ${data?.provider || 'unknown'}`);
      console.log(`   💰 비용: $${data?.estimatedCost || 0}`);
      console.log(`   📐 크기: ${data?.size?.width}x${data?.size?.height}`);

      // 이미지 저장
      if (data?.image_base64) {
        if (!fs.existsSync('output')) {
          fs.mkdirSync('output');
        }
        const buffer = Buffer.from(data.image_base64, 'base64');
        const filename = `output/test${i+1}-${testCase.request.breed.replace(/\s+/g, '')}-${data.provider}.webp`;
        fs.writeFileSync(filename, buffer);
        console.log(`   💾 저장: ${filename}`);
      }

      results.push({
        name: testCase.name,
        success: true,
        provider: data?.provider,
        time: elapsed,
        cost: data?.estimatedCost
      });

    } catch (error) {
      const elapsed = Date.now() - startTime;
      console.log('');
      console.log('❌ 실패!');
      console.log(`   ⏱️  시간: ${(elapsed/1000).toFixed(2)}초`);
      console.log(`   🔴 에러: ${error.message}`);

      results.push({
        name: testCase.name,
        success: false,
        error: error.message,
        time: elapsed
      });
    }

    // API 부하 방지를 위해 테스트 간 3초 대기
    if (i < testCases.length - 1) {
      console.log('');
      console.log('⏳ 다음 테스트까지 3초 대기...');
      await new Promise(resolve => setTimeout(resolve, 3000));
    }
  }

  // 결과 요약
  console.log('');
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║                    📊 테스트 결과 요약                       ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');

  const successCount = results.filter(r => r.success).length;
  const totalCost = results.filter(r => r.success).reduce((sum, r) => sum + (r.cost || 0), 0);
  const avgTime = results.filter(r => r.success).reduce((sum, r) => sum + r.time, 0) / successCount;

  console.log(`총 테스트: ${results.length}개`);
  console.log(`성공: ${successCount}개`);
  console.log(`실패: ${results.length - successCount}개`);
  console.log(`평균 응답 시간: ${(avgTime/1000).toFixed(2)}초`);
  console.log(`총 비용: $${totalCost.toFixed(4)}`);
  console.log('');

  results.forEach((r, i) => {
    const status = r.success ? '✅' : '❌';
    const detail = r.success
      ? `${r.provider} | ${(r.time/1000).toFixed(2)}초 | $${r.cost}`
      : r.error;
    console.log(`${status} 테스트 ${i+1}: ${detail}`);
  });

  console.log('');
  console.log('테스트 완료!');
}

runTests();

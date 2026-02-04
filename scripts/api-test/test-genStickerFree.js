/**
 * genStickerFree Firebase Function 테스트
 *
 * 2단계 폴백 시스템 테스트:
 * 1차: Pixazo → 2차: OpenAI
 */

import { initializeApp } from 'firebase/app';
import { getFunctions, httpsCallable, connectFunctionsEmulator } from 'firebase/functions';
import fs from 'fs';

// Firebase 설정 (walkwalkddog 프로젝트)
const firebaseConfig = {
  apiKey: "AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", // 실제 키 필요 없음 (callable function)
  authDomain: "walkwalkddog.firebaseapp.com",
  projectId: "walkwalkddog",
  storageBucket: "walkwalkddog.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456"
};

// Firebase 초기화
const app = initializeApp(firebaseConfig);
const functions = getFunctions(app, 'us-central1');

// 프로덕션 함수 호출 (에뮬레이터 사용 안함)
// connectFunctionsEmulator(functions, 'localhost', 5001);

async function testGenStickerFree() {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║       🎨 genStickerFree Function Test                      ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');

  const genStickerFree = httpsCallable(functions, 'genStickerFree');

  const testCases = [
    {
      name: "기본 테스트 (Shiba Inu)",
      request: {
        petId: "test-pet-001",
        breed: "Shiba Inu",
        color: "orange",
        accessory: "bandana",
        style: "sticker-flat",
        size: 512,
        bg: "white",
        userId: "test-user-001"
      }
    }
  ];

  for (const testCase of testCases) {
    console.log('━'.repeat(60));
    console.log(`📋 Test: ${testCase.name}`);
    console.log('━'.repeat(60));
    console.log(`📝 Request:`, JSON.stringify(testCase.request, null, 2));
    console.log('');

    const startTime = Date.now();

    try {
      console.log('⏳ Calling genStickerFree...');
      const result = await genStickerFree(testCase.request);
      const elapsed = Date.now() - startTime;

      console.log('');
      console.log('✅ SUCCESS');
      console.log(`⏱️  Total Time: ${elapsed}ms (${(elapsed/1000).toFixed(2)}s)`);

      if (result.data) {
        const data = result.data;
        console.log(`🎯 Provider: ${data.data?.provider || 'unknown'}`);
        console.log(`📊 Provider Name: ${data.data?.providerName || 'unknown'}`);
        console.log(`💰 Estimated Cost: $${data.data?.estimatedCost || 0}`);
        console.log(`📐 Size: ${data.data?.size?.width}x${data.data?.size?.height}`);
        console.log(`🖼️  Image Base64 Length: ${data.data?.image_base64?.length || 0} chars`);

        // 시도 정보 출력
        if (data.data?.attempts) {
          console.log('');
          console.log('📊 Attempts:');
          for (const attempt of data.data.attempts) {
            const status = attempt.success ? '✅' : '❌';
            console.log(`   ${status} ${attempt.provider}: ${attempt.durationMs}ms ${attempt.error || ''}`);
          }
        }

        // 이미지 저장
        if (data.data?.image_base64) {
          if (!fs.existsSync('output')) {
            fs.mkdirSync('output');
          }
          const buffer = Buffer.from(data.data.image_base64, 'base64');
          const filename = `output/genStickerFree-${data.data.provider}-${Date.now()}.webp`;
          fs.writeFileSync(filename, buffer);
          console.log(`💾 Image saved to: ${filename}`);
        }
      }

    } catch (error) {
      const elapsed = Date.now() - startTime;
      console.log('');
      console.log('❌ FAILED');
      console.log(`⏱️  Time before error: ${elapsed}ms`);
      console.log(`🔴 Error: ${error.message}`);
      if (error.code) {
        console.log(`🔴 Code: ${error.code}`);
      }
      if (error.details) {
        console.log(`🔴 Details: ${JSON.stringify(error.details)}`);
      }
    }

    console.log('');
  }

  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║                    Test Complete                           ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
}

testGenStickerFree();

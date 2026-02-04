/**
 * freeImageUsage 사용량 확인 스크립트
 */

import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  authDomain: "walkwalkddog.firebaseapp.com",
  projectId: "walkwalkddog",
  storageBucket: "walkwalkddog.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function checkUsage() {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║     📊 freeImageUsage 사용량 확인                           ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');

  try {
    const usageRef = collection(db, 'freeImageUsage');
    const snapshot = await getDocs(usageRef);

    if (snapshot.empty) {
      console.log('📭 사용량 기록이 없습니다.');
      return;
    }

    console.log(`📋 총 ${snapshot.size}명의 사용자 기록 발견\n`);

    const today = new Date().toISOString().split('T')[0];
    console.log(`📅 오늘 날짜: ${today}\n`);
    console.log('━'.repeat(60));

    snapshot.forEach(doc => {
      const data = doc.data();
      const isToday = data.date === today;
      const status = isToday ? '🟢 오늘' : '⚪ 이전';

      console.log(`👤 User: ${doc.id}`);
      console.log(`   ${status} 날짜: ${data.date}`);
      console.log(`   📊 사용량: ${data.count}/10`);
      console.log(`   🎯 마지막 Provider: ${data.lastProvider || 'N/A'}`);

      if (data.count >= 10) {
        console.log(`   ⚠️  일일 한도 도달!`);
      } else {
        console.log(`   ✅ 남은 횟수: ${10 - data.count}회`);
      }
      console.log('');
    });

    console.log('━'.repeat(60));
    console.log('');
    console.log('💡 일일 한도: 10회/일 (무료 사용자)');
    console.log('   한도 초과 시 "resource-exhausted" 에러 반환');

  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

checkUsage();

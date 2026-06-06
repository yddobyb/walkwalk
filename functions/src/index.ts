import * as admin from "firebase-admin";

// Firebase Admin 초기화
admin.initializeApp();

// 함수 export
// 프리미엄 사용자용 (Gemini API)
export {genSticker} from "./genSticker";

// 무료 사용자용 (Cloudflare → OpenAI 폴백)
export {genStickerFree} from "./genStickerFree";

// 할당량 조회
export {quota} from "./quota";

// LLM 대화 프록시 (API 키 서버 사이드 관리)
export {chatWithPet} from "./chatWithPet";

// 구독 상태 동기화 (클라이언트 직접 쓰기 차단 → Cloud Function 경유)
export {syncSubscription} from "./syncSubscription";

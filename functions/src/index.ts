import * as admin from "firebase-admin";

// Firebase Admin 초기화
admin.initializeApp();

// 함수 export
// 프리미엄 사용자용 (Gemini API)
export {genSticker} from "./genSticker";

// 무료 사용자용 (Pixazo → OpenAI 폴백)
export {genStickerFree} from "./genStickerFree";

// 할당량 조회
export {quota} from "./quota";

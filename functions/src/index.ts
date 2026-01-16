import * as admin from "firebase-admin";

// Firebase Admin 초기화
admin.initializeApp();

// 함수 export
export {genSticker} from "./genSticker";
export {quota} from "./quota";

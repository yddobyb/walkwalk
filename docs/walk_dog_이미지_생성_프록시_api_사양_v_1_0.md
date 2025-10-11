# WalkDog – 이미지 생성 프록시(API) 사양 v1.0 (2025년 9월 업데이트)

## 1) 목적
클라이언트 키 노출 방지, 과금/쿼터 제어, 캐시 및 정책 필터를 위해 Firebase Functions 기반 **프록시 API**를 정의한다. 이미지 생성기는 Google Gemini 2.5 Flash Image Preview 등 클라우드 제공자를 사용.

## 2) 보안/인증
- **Firebase Auth**: 익명 로그인 허용.
- **App Check**: 필수. 실패 시 403.
- **레이트리밋**: uid/IP 기준 `3회/5분`, `10회/일`(기본). 초과 시 429.
- **환경변수**: `IMG_ENDPOINT, IMG_API_KEY, MAX_SIZE=512, DAILY_QUOTA=10`.

## 3) 엔드포인트
### 3.1 POST `/genSticker`
- 용도: 품종/색/액세서리 기반 **정면 스티커** 1장 생성.
- 요청 필드
  - `petId`(string, 필수)
  - `breed`(string) – 예: "Shiba Inu"
  - `color`(string) – 예: "orange"
  - `accessory`(enum) – `bandana|glasses|none`
  - `style`(string, 기본 `sticker-flat`)
  - `size`(int, 기본 512, 최대 `MAX_SIZE`)
  - `bg`(enum) – `transparent|white`(기본)
  - `seed`(int, 기본 `hash(petId)`)
- 응답 필드
  - `image_base64`(WebP), `mime`(`image/webp`), `seed`(int), `inferenceId`(string), `cached`(bool)

### 3.2 POST `/genPose`
- 용도: **Image‑to‑Image**로 걷는 포즈 등 변형.
- 요청 필드
  - `petId`(string, 필수)
  - `baseKey`(string) 또는 `base_image_b64`(string, WebP)
  - `pose`(enum) – `walking-side`
  - `strength`(float 0.2–0.4, 기본 0.3)
  - `seed`(int)
- 응답: `/genSticker`와 동일

### 3.3 GET `/quota`
- 용도: 남은 일일 생성 가능 횟수.
- 응답: `remaining`(int), `resetAt`(ISO8601)

## 4) 캐시/아이템포턴시
- 캐시 키: `hash(petId, breed, color, accessory, style, size, seed)`.
- 동일 키 히트 시 즉시 반환(`cached=true`).
- **아이템포턴시 규칙**: 동일 `petId+seed` 조합은 **최초 성공 결과 고정**. 강제 재생성은 `force=true`.

## 5) 프롬프트 정책(서버)
- 텍스트: `{breed} dog, {color} coat, {accessory} accessory, cute sticker, front view, simple shading, 2D flat, white background`
- 네거티브: `watermark, text, extra limbs, photorealistic`
- 시드: `seed = hash(petId)`로 일관성 확보.

## 6) 유효성 검증
- `size ≤ MAX_SIZE`, `pose ∈ enum`, `strength ∈ [0.2,0.4]`.
- 금칙어/부적절 이미지 요청은 422.

## 7) 오류 사양
| Code | 의미 | 클라이언트 동작 |
|---|---|---|
| 400 | 잘못된 요청 | 사용자 입력 검토 알림 |
| 401/403 | 인증/App Check 실패 | 재인증/앱 업데이트 유도 |
| 422 | 콘텐츠 정책 위반 | 문구 수정 안내 |
| 429 | 쿼터 초과 | 다음 날/시간 안내, 재시도 금지 |
| 5xx | 공급자/네트 오류 | 3회 지수 재시도, 이후 폴백 |

## 8) 타임아웃/성능
- Functions 처리 타임아웃: 20s(Cold start 고려 30s).
- 클라이언트 요청 타임아웃: 15~20s. 5xx/429만 재시도(최대 3회).

## 9) 모니터링/로깅(PII 없음)
`ts, uid, petId, endpoint, provider, latencyMs, cached, size, seed, quotaRemain, errorCode`

## 10) 정책/보존
- 생성 파일은 서버에 **장기 보존하지 않음**(30일 만료) — 클라이언트 캐시에 의존.
- 워터마크/SynthID 등 제공자 정책 준수.

## 11) 버전관리
- `v1` 고정. 호환 불가 변경은 `/v2/*` 신설.
- `X-Api-Version` 요청 헤더 허용(미지정 시 최신).

## 12) 클라이언트 가이드(비기능)
- 프리패치: 커스터마이즈 저장 후 즉시 호출해 사용자 대기 최소화.
- 오프라인: 네트워크 없으면 **벡터 아바타로 폴백** + “나중에 생성” 버튼.
- 리트라이: 5xx/429만. 400/422는 즉시 사용자 문구 수정 유도.

## 13) 테스트 항목
- 캐시 히트 응답 지연 ≤ 300ms.
- 최초 생성 지연 중앙값 ≤ 6s(Cold 제외).
- 429 케이스에서 적절한 안내 메시지 및 재시도 차단.


# WalkDog Firebase Functions

WalkDog 앱의 이미지 생성 서비스를 위한 Firebase Cloud Functions입니다.

## 환경 설정

### 1. Gemini API 키 발급

1. [Google AI Studio](https://aistudio.google.com/apikey)에 접속
2. "Get API key" 또는 "API 키 만들기" 클릭
3. API 키 복사

### 2. Firebase Functions 환경 변수 설정

```bash
# Gemini API 설정
firebase functions:config:set \
  gemini.api_key="YOUR_GEMINI_API_KEY" \
  gemini.endpoint="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent" \
  limits.daily_quota="20" \
  limits.rate_limit_per_5min="3"

# 설정 확인
firebase functions:config:get
```

### 3. 로컬 개발용 환경 변수

로컬 에뮬레이터에서 테스트하려면 `.runtimeconfig.json` 파일을 생성하세요:

```bash
firebase functions:config:get > .runtimeconfig.json
```

**주의:** `.runtimeconfig.json`은 `.gitignore`에 포함되어 있어 커밋되지 않습니다.

## 개발 명령어

```bash
# TypeScript 컴파일
npm run build

# 컴파일 + watch 모드
npm run build:watch

# ESLint 검사
npm run lint

# 로컬 에뮬레이터 실행
npm run serve

# Functions 배포
npm run deploy

# 로그 확인
npm run logs
```

## 프로젝트 구조

```
functions/
├── src/
│   ├── index.ts              # 메인 엔트리포인트
│   ├── genSticker.ts         # 스티커 생성 함수 (Phase 2)
│   ├── quota.ts              # 할당량 조회 함수 (Phase 2)
│   └── utils/
│       ├── gemini.ts         # Gemini API 클라이언트 (Phase 2)
│       ├── cache.ts          # Firebase Storage 캐시 (Phase 2)
│       ├── rateLimit.ts      # Firestore 레이트 리밋 (Phase 2)
│       └── validation.ts     # 입력 검증 (Phase 2)
├── lib/                      # 컴파일된 JavaScript (자동 생성)
├── package.json
├── tsconfig.json
└── .eslintrc.js
```

## API 엔드포인트

### genSticker (Cloud Function)
펫 스티커 이미지를 생성합니다.

**요청:**
```typescript
{
  petId: string;
  breed: string;
  color: string;
  accessories: string[];
  prompt?: string;
  seed?: number;
}
```

**응답:**
```typescript
{
  imageUrl: string;
  cached: boolean;
  quotaRemaining: number;
}
```

### quota (Cloud Function)
사용자의 일일 할당량을 조회합니다.

**요청:** 없음 (인증된 사용자 기반)

**응답:**
```typescript
{
  used: number;
  limit: number;
  resetAt: string;
}
```

## 비용 전략

- **무료 티어 최대 활용**: Gemini 2.5 Flash Image Preview (일일 500개 무료)
- **캐싱**: 75%+ 히트율 목표로 API 호출 최소화
- **레이트 리밋**:
  - 5분당 3회
  - 일일 10회 (사용자당)
- **예상 비용**: 0원 (개발/베타/초기 런칭 단계)

## 보안

- **App Check**: 모든 함수는 Firebase App Check로 보호됨
- **인증**: Firebase Authentication 필수
- **레이트 리밋**: Firestore로 사용자별 제한 적용
- **입력 검증**: 모든 입력 파라미터 검증

## 배포

```bash
# 1. 빌드 및 린트 확인
npm run build
npm run lint

# 2. Functions 배포
firebase deploy --only functions

# 3. 배포 확인
firebase functions:list
```

## 문제 해결

### 1. "Gemini API Error: Invalid API Key"
- API 키가 올바른지 확인
- `firebase functions:config:get`으로 설정 확인
- 로컬 개발 시 `.runtimeconfig.json` 파일 확인

### 2. "Rate limit exceeded"
- 사용자가 5분당 3회 또는 일일 10회 제한 초과
- Firestore의 `user_quotas` 컬렉션 확인

### 3. "App Check verification failed"
- Flutter 앱에서 App Check 초기화 확인
- Debug token 설정 (개발 환경)

## Phase 2에서 구현 예정

- `genSticker.ts`: 스티커 생성 로직
- `quota.ts`: 할당량 조회 로직
- `utils/`: 유틸리티 모듈들
- App Check 검증
- Firestore 레이트 리밋
- Firebase Storage 캐싱

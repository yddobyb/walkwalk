# Firebase Functions 환경 설정 가이드

## 단계별 설정

### Step 1: Gemini API 키 발급 ⭐

1. **Google AI Studio 접속**
   - URL: https://aistudio.google.com/apikey
   - Google 계정으로 로그인

2. **API 키 생성**
   - "Get API key" 버튼 클릭
   - 기존 프로젝트 선택 또는 새 프로젝트 생성
   - API 키 복사 (예: AIzaSy...)

3. **API 키 확인**
   - 키가 "AIza"로 시작하는지 확인
   - 약 39자 길이

### Step 2: Firebase Functions 환경 변수 설정

터미널에서 아래 명령어를 실행하세요. `YOUR_GEMINI_API_KEY`를 실제 API 키로 교체하세요:

```bash
cd "/Users/parkyoungbin/Desktop/flutter assa/walk_dog"

firebase functions:config:set \
  gemini.api_key="YOUR_GEMINI_API_KEY" \
  gemini.endpoint="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent" \
  limits.daily_quota="20" \
  limits.rate_limit_per_5min="3"
```

**예시:**
```bash
firebase functions:config:set \
  gemini.api_key="AIzaSyABC123DEF456GHI789JKL012MNO345PQR" \
  gemini.endpoint="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent" \
  limits.daily_quota="20" \
  limits.rate_limit_per_5min="3"
```

### Step 3: 설정 확인

```bash
# 저장된 환경 변수 확인
firebase functions:config:get

# 출력 예상:
# {
#   "gemini": {
#     "api_key": "AIzaSy...",
#     "endpoint": "https://generativelanguage.googleapis.com/..."
#   },
#   "limits": {
#     "daily_quota": "20",
#     "rate_limit_per_5min": "3"
#   }
# }
```

### Step 4: 로컬 개발 환경 설정 (선택 사항)

로컬 에뮬레이터에서 테스트하려면:

```bash
cd functions
firebase functions:config:get > .runtimeconfig.json
```

이 파일은 자동으로 `.gitignore`에 포함되어 Git에 커밋되지 않습니다.

---

## 환경 변수 설명

| 키 | 값 | 설명 |
|---|---|---|
| `gemini.api_key` | `AIzaSy...` | Google AI Studio에서 발급받은 Gemini API 키 |
| `gemini.endpoint` | `https://generativelanguage.googleapis.com/...` | Gemini API 엔드포인트 |
| `limits.daily_quota` | `20` | 프로젝트 전체 일일 생성 목표 (무료 티어: 500개) |
| `limits.rate_limit_per_5min` | `3` | 사용자당 5분당 최대 요청 수 |

---

## 다음 단계

환경 변수 설정이 완료되면 Phase 2로 진행하세요:
- `genSticker.ts`: 스티커 생성 함수 구현
- `quota.ts`: 할당량 조회 함수 구현
- 유틸리티 모듈 구현

---

## 문제 해결

### "Error: HTTP Error: 403, permission denied"
- Firebase 프로젝트에 로그인되어 있는지 확인
- `firebase login` 다시 실행
- `firebase use walkwalkddog`로 프로젝트 선택

### "Invalid API key"
- API 키가 "AIza"로 시작하는지 확인
- 복사 시 공백이나 줄바꿈이 포함되지 않았는지 확인
- Google AI Studio에서 키가 활성화되어 있는지 확인

### "Command not found: firebase"
- Firebase CLI 재설치: `npm install -g firebase-tools`
- 버전 확인: `firebase --version` (13.0.0 이상 필요)

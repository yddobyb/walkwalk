# Firebase Remote Config 설정 가이드

## 개요
Firebase Remote Config를 사용하여 OpenRouter API 키와 레이트 리밋 설정을 클라우드에서 관리합니다.

### 장점
- ✅ 앱 재배포 없이 API 키 변경 가능
- ✅ 안전한 API 키 관리 (코드에 하드코딩 안 함)
- ✅ 환경별 설정 관리 (개발/프로덕션)
- ✅ A/B 테스트 지원
- ✅ 사용자 그룹별 다른 설정 제공 가능

## 전제조건
- Firebase 프로젝트 생성 완료 (`walkwalkddog`)
- Firebase CLI 로그인 완료
- OpenRouter API 키 발급 완료

## 1단계: Firebase Console에서 Remote Config 설정

### 1.1 Firebase Console 접속
1. https://console.firebase.google.com 접속
2. `walkwalkddog` 프로젝트 선택
3. 왼쪽 메뉴에서 **Engage > Remote Config** 선택

### 1.2 파라미터 추가
다음 3개의 파라미터를 추가합니다:

#### 파라미터 1: `openrouter_api_key`
- **Data type**: String
- **Default value**: `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`
- **Description**: OpenRouter API key for DeepSeek R1 model

#### 파라미터 2: `rate_limit_daily`
- **Data type**: Number
- **Default value**: `80`
- **Description**: Maximum daily API requests (OpenRouter free tier: 100/day, margin: 20)

#### 파라미터 3: `rate_limit_hourly`
- **Data type**: Number
- **Default value**: `20`
- **Description**: Maximum hourly API requests

### 1.3 변경사항 게시
1. 모든 파라미터 추가 완료 후 **Publish changes** 버튼 클릭
2. 변경 이유 입력 (예: "Initial API key setup for Week 3")
3. **Publish** 클릭

## 2단계: 앱에서 Remote Config 확인

### 2.1 테스트 앱 실행
```bash
cd "/Users/parkyoungbin/Desktop/flutter assa/walk_dog"
flutter run -d <device-id> --target=lib/test_remote_config.dart
```

### 2.2 콘솔 로그 확인
다음과 같은 로그가 출력되어야 합니다:

```
======================================
🔧 Remote Config 테스트 시작
======================================

📱 Step 1: Firebase 초기화
   결과: 성공 ✅

☁️ Step 2: Remote Config 초기화
   결과: 성공 ✅

📊 Step 3: Remote Config 파라미터 확인
   - openrouter_api_key: sk-or-v1-...3051
   - rate_limit_daily: 80
   - rate_limit_hourly: 20
   - enable_debug_logs: false

🔐 API 키 유효성: 유효 ✅

🔑 Step 4: ApiConfig에서 API 키 가져오기
   API 키: sk-or-v1-...3051
   결과: 성공 ✅

======================================
✅ Remote Config 테스트 완료
======================================
```

### 2.3 테스트 실패 시
Remote Config 초기화가 실패하면:
1. Firebase Console에서 파라미터가 올바르게 설정되었는지 확인
2. **Publish changes**를 클릭했는지 확인
3. 앱을 재시작 (Hot Reload 안 됨)

## 3단계: 우선순위 시스템 확인

API 키 로드 우선순위:
1. **Firebase Remote Config** (최우선)
2. **환경 변수** (`--dart-define=OPENROUTER_API_KEY`)
3. **에러 발생** (둘 다 없으면)

### 환경 변수 폴백 테스트
Remote Config 없이 환경 변수만 사용:
```bash
flutter run -d <device-id> --dart-define=OPENROUTER_API_KEY=sk-or-v1-...
```

## 4단계: 프로덕션 빌드

### iOS Release 빌드
```bash
flutter build ios --release
```

### Android Release 빌드
```bash
flutter build apk --release
```

**중요**: Release 빌드에서는 Remote Config가 자동으로 사용됩니다. 환경 변수는 필요하지 않습니다.

## 5단계: Remote Config 변경 (운영 중)

### API 키 교체
1. Firebase Console > Remote Config 접속
2. `openrouter_api_key` 파라미터 편집
3. 새 API 키 입력
4. **Publish changes** 클릭
5. 앱 재시작 시 자동으로 새 API 키 적용 (재배포 불필요)

### 레이트 리밋 조정
1. `rate_limit_daily` 또는 `rate_limit_hourly` 파라미터 편집
2. 새 값 입력 (예: `100` → `150`)
3. **Publish changes** 클릭
4. 앱 재시작 시 자동으로 새 제한 적용

## 트러블슈팅

### 문제 1: Remote Config 값이 비어있음
**증상:**
```
   - openrouter_api_key: (empty)
   - rate_limit_daily: 0
```

**해결:**
1. Firebase Console에서 파라미터가 **Published** 상태인지 확인
2. 파라미터 이름 철자 확인 (`openrouter_api_key`, `rate_limit_daily`, `rate_limit_hourly`)
3. 앱 완전 재시작 (Hot Reload 안 됨)

### 문제 2: Remote Config 초기화 실패
**증상:**
```
❌ RemoteConfig - Initialization failed: ...
```

**해결:**
1. `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) 파일 확인
2. Firebase 프로젝트 ID 일치 확인 (`walkwalkddog`)
3. 인터넷 연결 확인
4. Firebase Console에서 Remote Config API 활성화 확인

### 문제 3: API 키 유효성 검증 실패
**증상:**
```
🔐 API 키 유효성: 무효 ❌
   ⚠️ API 키가 "sk-or-"로 시작하지 않습니다.
```

**해결:**
1. Firebase Console에서 API 키가 `sk-or-v1-`로 시작하는지 확인
2. 복사/붙여넣기 시 공백이나 특수문자가 포함되지 않았는지 확인
3. OpenRouter 대시보드에서 API 키 재확인

### 문제 4: 환경 변수가 우선 적용됨
**증상:**
```
✅ ApiConfig - Using API key from environment variable
```

**원인:**
- 환경 변수가 설정되어 있으면 Remote Config보다 우선 적용됨

**해결 (Remote Config 우선 적용하려면):**
1. lib/core/config/api_config.dart:35-73 코드 확인
2. 환경 변수 제거하고 실행:
```bash
flutter run -d <device-id>  # --dart-define 없이
```

## 코드 참조

### RemoteConfigService
- **파일**: `lib/services/config/remote_config_service.dart`
- **메서드**:
  - `initialize()` - Remote Config 초기화 및 fetch
  - `getOpenRouterApiKey()` - API 키 가져오기
  - `getRateLimitDaily()` - 일일 제한 가져오기
  - `getRateLimitHourly()` - 시간당 제한 가져오기

### ApiConfig
- **파일**: `lib/core/config/api_config.dart`
- **메서드**:
  - `getOpenRouterApiKey()` - 우선순위 시스템 (Remote Config → 환경 변수)
  - `isValidApiKey()` - API 키 유효성 검증

### 테스트 앱
- **파일**: `lib/test_remote_config.dart`
- **실행**: `flutter run --target=lib/test_remote_config.dart`

## 추가 설정 (선택사항)

### 조건부 값 (Conditional Values)
사용자 그룹별로 다른 API 키 제공:
1. Firebase Console > Remote Config
2. `openrouter_api_key` 파라미터 선택
3. **Add value for condition** 클릭
4. 조건 생성 (예: "Beta Testers")
5. 조건별 다른 API 키 입력
6. **Publish changes**

### A/B 테스트
레이트 리밋 A/B 테스트:
1. Firebase Console > Remote Config
2. **Create experiment** 클릭
3. `rate_limit_daily` 파라미터 선택
4. 두 그룹 설정 (예: 80 vs 100)
5. 실험 시작

## 참고 문서
- [Firebase Remote Config 공식 문서](https://firebase.google.com/docs/remote-config)
- [Flutter Firebase Remote Config](https://firebase.flutter.dev/docs/remote-config/overview)
- [OpenRouter API 문서](https://openrouter.ai/docs)

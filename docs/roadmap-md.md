# WalkDog 개발 로드맵 (2025년 9월 업데이트)

## 📅 프로젝트 타임라인

```mermaid
gantt
    title WalkDog 개발 일정
    dateFormat  YYYY-MM-DD
    section MVP (4주)
    기초 설정 및 UI     
    센서 및 보상       
    AI 통합          
    이미지 생성 및 QA  
    
    section v1.1 (2주)
    소셜 기능       
    추가 커스터마이징  
    
    section v1.2 (2주)
    AR 모드         
    웨어러블 연동
    
    section v2.0 (4주)
    멀티 펫        
    고급 AI 기능      
```

## 🎯 Version 1.0 - MVP (4주)

### Week 1: 기초 설정 및 UI  ✅ **완료**
**목표:** 앱 기본 구조 및 핵심 UI 구현

#### 작업 항목
- [x] Flutter 프로젝트 초기화
- [x] 프로젝트 구조 설정 (Clean Architecture)
  - [x] Domain 레이어 (5개 엔티티)
  - [x] Data 레이어 (5개 모델 + DatabaseService)
  - [x] Presentation 레이어 (화면/위젯 분리)
  - [x] Service 레이어 (8개 서비스)
- [x] Riverpod 상태 관리 설정
  - [x] 모든 서비스에 Provider 적용 (20개 이상)
  - [x] FutureProvider, StreamProvider 활용
- [x] Isar 데이터베이스 스키마 정의
  - [x] 5개 컬렉션 (Pet, WalkLog, Achievement, Mission, Settings)
  - [x] CRUD 메서드 완비
  - [x] 기본 데이터 초기화 (10개 배지)
- [x] 기본 화면 구현
  - [x] 홈 화면 (펫 아바타, 상태 표시, Bottom Navigation)
  - [x] 커스터마이즈 화면 (6개 액세서리)
  - [x] 설정 화면 (게임/AI/알림/앱 설정)
  - [x] **추가**: 스플래시 화면 (애니메이션)
  - [x] **추가**: 온보딩 화면 (환영/펫 생성)
  - [x] **추가**: 산책 화면 (가이드)
  - [x] **추가**: 배지 화면 (티어별 그룹)
- [x] 펫 아바타 구현 (이모지 기반, 벡터는 추후)
  - [x] 펫 정보 표시 (이름, 품종, 성격)
  - [x] 터치 상호작용
  - [x] Riverpod 데이터 연동
- [x] 기본 애니메이션 (스플래시 Fade/Scale)
- [x] 다크 모드 지원 (시스템 테마 따름)
- [x] 기본 테마 및 디자인 시스템
  - [x] Material 3 디자인
  - [x] 커스텀 컬러 팔레트
  - [x] Typography 체계

#### 산출물
- 작동하는 기본 앱 구조
- 3개 주요 화면 완성
- 애니메이션 펫 아바타

### Week 2: 센서 및 보상 시스템 ✅ **완료**
**목표:** 걸음수 트래킹 및 게임화 요소 구현

#### 작업 항목
- [x] Pedometer 통합
  - [x] 권한 요청 플로우 (ACTIVITY_RECOGNITION)
  - [x] 실시간 걸음수 트래킹 (StepCount Stream)
  - [x] 보행 상태 트래킹 (walking/stopped)
  - [x] 에러 처리 및 로깅
- [x] 보상 시스템
  - [x] 간식 획득 로직 (300걸음 = 1간식)
  - [x] 행복도 증가 로직 (500걸음 = +1 행복도)
  - [x] 실외 보너스 (1.5배)
  - [x] 간식 먹이기 기능
  - [x] 특별 이벤트 보상 (생일, 주간 목표 등)
  - [x] 행복도 시스템 (0-100 범위)
  - [x] 일일 감소 메커니즘 (하루 5씩 자동 감소)
  - [x] 감정 상태 계산 (5단계)
  - [x] 행복도 스케줄러 서비스
- [x] 배지/업적 시스템
  - [x] 10개 기본 배지 (첫 산책, 걸음수, 연속 산책, 실외, 행복도, 간식, 거리)
  - [x] 4개 티어 (Bronze, Silver, Gold, Platinum)
  - [x] 진행도 트래킹 및 자동 해제
  - [x] 달성 시 자동 보상 지급
  - [x] 배지 화면에서 티어별 그룹 표시
  - [x] 달성 알림 위젯
- [x] GPS 실외 모드
  - [x] 위치 권한 처리 (Geolocator)
  - [x] 실외 판정 알고리즘 (정확도 및 속도 기반)
  - [x] 총 이동 거리 계산
  - [x] 평균 속도 계산
  - [x] 실외 비율 계산
  - [x] 위치 샘플 수집 및 정리
  - [x] GPS 상태 위젯
  - [x] 위치 권한 위젯
- [x] 미션 시스템
  - [x] 일일/주간 미션 자동 생성
  - [x] 걸음수, 시간, 거리 기반 목표
  - [x] 진행도 자동 업데이트
  - [x] 완료 시 자동 보상 지급
  - [x] 만료된 미션 자동 정리
  - [x] 미션 요약 위젯
  - [x] 미션 카드 위젯
  - [x] 미션 리스트 위젯
  - [x] 미션 완료 알림 위젯

#### 추가 구현 항목 (로드맵 외)
- [x] **통계 시스템**
  - [x] StatisticsService 구현
  - [x] 일일/주간/월간 통계 계산
  - [x] 걸음수, 거리, 시간, 산책 횟수 추적
  - [x] 연속 산책 일수 계산 (StreakData)
  - [x] 전체 누적 통계
- [x] **차트 시각화**
  - [x] fl_chart 라이브러리 통합
  - [x] 주간 차트 위젯 (막대 차트)
  - [x] 월간 차트 위젯 (라인 차트)
  - [x] 일일 통계 카드 위젯
  - [x] 연속 산책 위젯
- [x] **걸음수 추적 서비스**
  - [x] StepTrackingService 구현
  - [x] Pedometer와 통합
  - [x] 일일 걸음수 자동 관리
  - [x] 보상 자동 계산 및 지급
  - [x] 미션/배지 진행도 자동 업데이트
- [x] **레벨 시스템** ✅ **완료 (iOS/Android 테스트 완료)**
  - [x] Pet 엔티티에 experience 필드 추가
  - [x] 경험치 획득 로직 (걸음수, 거리 기반)
  - [x] 레벨업 계산 로직 (지수 증가 공식)
  - [x] 다중 레벨업 지원 (한 번에 여러 레벨 상승)
  - [x] 레벨업 시 보상 (간식 +5, 행복도 +20)
  - [x] 경험치 바 UI 추가 (PetStatusWidget)
  - [x] 레벨업 알림 기능 (WalkButtonWidget)
  - [x] 기존 펫 데이터 마이그레이션 (experience 필드)
  - [x] 실시간 UI 업데이트 (StreamProvider 적용)
  - [x] iOS 플랫폼 테스트 완료 (iPhone 실기기)
  - [x] Android 플랫폼 테스트 완료 (빌드 오류 4건 수정, Health Connect 권한 통합)
- [x] **실시간 미션 진행도 표시** ✅ **완료 (iOS/Android 테스트 완료)**
  - [x] MissionSummaryWidget 실시간 걸음수 표시 (홈 화면)
  - [x] MissionCardWidget 실시간 걸음수 표시 (미션 리스트)
  - [x] MissionDetailsBottomSheet 실시간 걸음수 표시 (미션 상세)
  - [x] dailyStepsProvider 통합 (5초 폴링 간격)
  - [x] 하이브리드 아키텍처 (UI 5초 업데이트, DB 10초/50걸음 쓰로틀)
  - [x] 걸음수 미션 실시간 진행도 계산
  - [x] AsyncValue 에러/로딩 상태 처리 (DB 폴백)
  - [x] iOS 플랫폼 테스트 완료 (iPhone 실기기)
  - [x] Android 플랫폼 테스트 완료 (Release 빌드)

#### 산출물
- ✅ 완전한 걸음수 트래킹 시스템
- ✅ 작동하는 보상 메커니즘
- ✅ 10개 달성 가능한 배지
- ✅ **추가**: 통계 시스템 (일일/주간/월wh간)
- ✅ **추가**: 차트 시각화 (fl_chart)
- ✅ **추가**: 연속 산책 추적 시스템
- ✅ **추가**: 레벨 시스템 (경험치/레벨업/알림, iOS/Android 테스트 완료) ✅ **완료**
- ✅ **추가**: 실시간 미션 진행도 표시 (홈/리스트/상세, iOS/Android 테스트 완료) ✅ **완료**

### Week 3: AI 통합 (OpenRouter) + 행복도 시스템 버그 수정  ✅ **완료**
**목표:** 클라우드 API 기반 대화 시스템 구현 (DeepSeek R1) + 일일 감소 시스템 디버깅

**아키텍처 변경**: 로컬 LLM(MLC-LLM) → OpenRouter API (무료 DeepSeek R1)
- ✅ 빠른 구현 (3-5일)
- ✅ 앱 크기 증가 없음
- ✅ 무료 사용 (100회/일)
- ✅ 인터넷 필요 (오프라인 폴백 완료)
- 🔮 추후 MLC-LLM 마이그레이션 고려

#### 작업 항목

**Phase 1: API 설정 (1일)** ✅ **완료**
- [x] OpenRouter 계정 생성 및 API 키 발급
- [x] Firebase Remote Config에 API 키 저장 ✅ **완료**
  - [x] Firebase 프로젝트 생성 (walkwalkddog)
  - [x] firebase_core, firebase_remote_config 패키지 추가
  - [x] RemoteConfigService 구현 (초기화, API 키 로드)
  - [x] Remote Config 파라미터 설정 (openrouter_api_key, rate_limit_daily, rate_limit_hourly)
  - [x] ApiConfig에 Remote Config 우선 순위 통합
  - [x] 환경 변수 폴백 지원 (dart-define)
  - [x] 레이트 리밋 설정 (80회/일, 20회/시간)
- [x] http 패키지 추가 (pubspec.yaml) - http: ^1.1.0
- [x] 폴더 구조 생성
  - [x] lib/core/config/api_config.dart
  - [x] lib/core/services/firebase_service.dart
  - [x] lib/services/config/remote_config_service.dart
  - [x] lib/services/ai/ (7개 파일)

**Phase 2: Service Layer (2일)** ✅ **완료**
- [x] API 설정 클래스 (ApiConfig)
  - [x] API 키 로드 함수 (fromEnvironment)
  - [x] 상수 정의 (base URL, model, timeout)
  - [x] API 키 검증 함수
  - [x] HTTP 헤더 생성 함수
- [x] LLMService 구현
  - [x] initialize() - API 키 로드
  - [x] generateResponse() - HTTP POST 요청
  - [x] generateDialogue() - 컨텍스트 기반 대화
  - [x] 15초 타임아웃 처리
  - [x] 에러 핸들링 (자동 폴백)
  - [x] 시스템 프롬프트 생성 (강아지 성격, 기분)
  - [x] 사용자 메시지 생성 (컨텍스트별)
- [x] FallbackResponses 구현
  - [x] 5가지 컨텍스트별 규칙 기반 응답
    - [x] walk_complete (걸음수 기반)
    - [x] mission_complete
    - [x] feed (간식 수 기반)
    - [x] level_up (레벨 기반)
    - [x] low_happiness
  - [x] 랜덤 응답 생성
  - [x] 동적 데이터 기반 응답 (걸음수, 레벨, 간식 수)
- [x] ConversationService 구현
  - [x] LLM + Fallback 통합
  - [x] 자동 에러 처리
  - [x] 6개 컨텍스트별 편의 메서드

**Phase 3: Riverpod 통합 (1일)** ✅ **완료**
- [x] AI Provider 설정 (ai_providers.dart)
  - [x] fallbackResponsesProvider
  - [x] rateLimiterProvider
  - [x] llmServiceProvider
  - [x] llmInitializationProvider
  - [x] conversationServiceProvider
  - [x] dialogueProvider (FutureProvider.family)
  - [x] 6개 편의 Provider (greeting, walkComplete, missionComplete, feed, levelUp, lowHappiness)
- [x] DialogueRequest 데이터 클래스
  - [x] Immutable 구조
  - [x] equals/hashCode (캐싱용)
  - [x] copyWith 메서드
- [x] Pet Provider 연동 (기존 provider 사용)

**Phase 4: UI 통합 (1일)** ✅ **완료**
- [x] PetDialogueWidget 구현
  - [x] 컨텍스트 기반 대화 표시 (7개 컨텍스트)
  - [x] 로딩 상태 (ShimmerLoading)
  - [x] 에러 처리 (자동 폴백)
  - [x] 펫 아이콘 + 말풍선 UI
  - [x] AsyncValue 상태 처리 (loading/data/error)
- [x] 홈 화면 통합
  - [x] 인사 대화 (greeting)
  - [x] 행복도 낮음 알림 (low_happiness) - ConditionalLowHappinessDialogue 위젯
- [x] 산책 완료 대화 (walk_complete) - WalkButtonWidget
- [x] 미션 완료 대화 (mission_complete) - MissionNotificationWidget
- [x] 간식 먹이기 대화 (feed) - PetStatusWidget
- [x] 레벨업 대화 (level_up) - WalkButtonWidget

**Phase 5: 최적화 및 테스트 (1일)** ✅ **완료**
- [x] 레이트 리밋 관리 (RateLimiter)
  - [x] SharedPreferences 사용
  - [x] 일일 80회 제한
  - [x] 시간당 20회 제한
  - [x] canMakeRequest() 체크 함수
  - [x] getRemainingQuota() 함수
  - [x] 자동 리셋 메커니즘
- [x] 네트워크 최적화 ✅ **완료**
  - [x] ConnectivityService 구현 (connectivity_plus 6.1.2)
  - [x] 인터넷 연결 확인 (isConnected)
  - [x] WiFi vs 모바일 데이터 처리 (isWifi, isMobile)
  - [x] 연결 타입 문자열 반환 (getConnectionTypeString)
  - [x] 연결 상태 변경 스트림 (onConnectivityChanged)
  - [x] Riverpod Provider 통합 (5개 provider)
  - [x] LLMService 네트워크 체크 통합
  - [x] ConnectivityService 테스트 (10/10 통과)
  - [x] AI Providers 네트워크 통합 테스트 (101 tests)
- [x] 성능 모니터링 (Firebase Analytics) ✅ **완료**
  - [x] Firebase 프로젝트 초기화 (walkwalkddog)
  - [x] firebase_analytics 패키지 추가 (v11.3.8)
  - [x] AnalyticsService 구현
  - [x] LLM 요청 이벤트 추적 (llm_request_started, llm_request_completed, llm_request_failed)
  - [x] 응답 시간 측정 (밀리초 단위)
  - [x] 폴백 사용 추적 (fallback_used 이벤트)
  - [x] 에러 타입/메시지 로깅
  - [x] LLMService에 Analytics 통합
  - [x] FallbackResponses 폴백 감지 메서드 (isFromFallback)
  - [x] main.dart에 Firebase 초기화 추가
- [x] **테스트 (Week 3 통합 테스트)** ✅ **완료 (101/101 테스트 통과)**
  - [x] **Phase 1-4 Unit Tests** (43개 테스트)
    - [x] API Config 테스트 (6 tests) - `test/services/ai/api_config_test.dart`
    - [x] FallbackResponses 테스트 (10 tests) - `test/services/ai/fallback_responses_test.dart`
    - [x] LLMService 테스트 (12 tests) - `test/services/ai/llm_service_test.dart`
    - [x] ConversationService 테스트 (15 tests) - `test/services/ai/conversation_service_test.dart`
  - [x] **Phase 5 추가 테스트** (35개 테스트) ✅ **완료**
    - [x] RateLimiter 테스트 (18 tests) - `test/services/ai/rate_limiter_test.dart`
    - [x] Riverpod Provider 테스트 (17 tests) - `test/services/ai/ai_providers_test.dart`
  - [x] **Phase 5 네트워크 테스트** (10 tests) ✅ **완료 (신규 추가)**
    - [x] ConnectivityService 테스트 (10 tests) - `test/services/network/connectivity_service_test.dart`
      - [x] checkConnectivity() - 연결 상태 확인
      - [x] isConnected() - 인터넷 연결 여부
      - [x] isWifi() - WiFi 연결 확인
      - [x] isMobile() - 모바일 데이터 확인
      - [x] getConnectionTypeString() - 연결 타입 문자열
      - [x] onConnectivityChanged - 스트림 확인
      - [x] listenToConnectivity() - 리스닝
      - [x] dispose() - 서비스 정리
      - [x] 연결 상태별 isConnected() 동작
      - [x] WiFi vs 모바일 데이터 구분
  - [x] **Phase 4 UI 통합 테스트** (12 tests) ✅ **완료**
    - [x] PetDialogueWidget 테스트 (12 tests) - `test/presentation/widgets/pet_dialogue_widget_test.dart`
      - [x] 7개 컨텍스트별 위젯 렌더링 (greeting, greeting_static, walk_complete, mission_complete, feed, level_up, low_happiness)
      - [x] Pet null 처리
      - [x] AsyncValue.loading 상태
      - [x] Icons.pets 아이콘 표시
      - [x] ShimmerLoading 표시
  - [x] iOS/Android 빌드 테스트 ✅ **완료**
    - [x] Firebase Remote Config 통합 테스트
    - [x] Analytics 버그 수정 (boolean → string 변환)
    - [x] 오프라인 폴백 시스템 테스트 (비행기 모드)
    - [x] 네트워크 연결 상태 감지 확인
    - [x] 실시간 응답 테스트 (온라인/오프라인 전환)

#### 산출물 ✅ **완료**
- [x] 작동하는 OpenRouter 기반 대화 시스템
- [x] 7가지 컨텍스트 대화 (greeting, greeting_static, walk_complete, mission_complete, feed, level_up, low_happiness)
- [x] 오프라인 폴백 시스템 (규칙 기반)
- [x] API 키 안전한 관리 (환경 변수 방식)
- [x] 레이트 리밋 관리 시스템 (일일 80회, 시간당 20회)
- [x] 네트워크 최적화 (ConnectivityService 통합)
- [x] 성능 모니터링 및 Analytics (Firebase Analytics 완료) ✅ **완료**

**구현된 핵심 기능:**
1. **OpenRouter API (DeepSeek R1) 통합**
   - HTTP 기반 LLM 서비스
   - 15초 타임아웃 처리
   - 자동 에러 핸들링

2. **7가지 컨텍스트별 대화**
   - greeting (인사)
   - greeting_static (정적 인사)
   - walk_complete (산책 완료)
   - mission_complete (미션 완료)
   - feed (간식 먹이기)
   - level_up (레벨업)
   - low_happiness (행복도 낮음)

3. **오프라인 폴백 시스템**
   - 규칙 기반 응답 생성
   - 동적 데이터 통합 (걸음수, 레벨, 간식)
   - API 실패 시 자동 전환

4. **레이트 리밋 관리**
   - SharedPreferences 기반
   - 일일 80회 제한
   - 시간당 20회 제한
   - 자동 리셋 메커니즘

5. **네트워크 최적화**
   - ConnectivityService (인터넷 연결 확인)
   - WiFi/모바일 데이터 구분
   - API 호출 전 네트워크 체크
   - 오프라인 시 자동 폴백

6. **성능 모니터링 (Firebase Analytics)**
   - LLM 요청 추적 (시작/완료/실패)
   - 응답 시간 측정 (밀리초)
   - 폴백 사용 추적
   - 에러 타입/메시지 로깅
   - 사용자 속성 설정
   - 화면 조회 이벤트

**Phase 6: 행복도 시스템 버그 수정 (2일)** ✅ **완료 (2025-10-30 ~ 2025-11-01)**
- [x] 버그 진단 및 원인 분석
  - [x] HappinessScheduler 초기화 안됨 확인
  - [x] Release 모드 로깅 문제 발견 (print/debugPrint 제거됨)
  - [x] main.dart 초기화 순서 문제 식별
- [x] 수정 사항 적용
  - [x] 모든 로깅을 developer.log()로 변경 (release 모드 지원)
  - [x] main.dart 초기화 순서 변경 (HappinessScheduler → StepTrackingService)
  - [x] StepTrackingService가 블로킹하여 HappinessScheduler 실행 안되는 문제 해결
- [x] 검증 및 테스트
  - [x] 3일 경과 시나리오 테스트 (100 → 85)
  - [x] 2일 추가 경과 테스트 (85 → 75)
  - [x] 일일 감소 로직 검증 (자정 기준 일수 계산)
  - [x] 산책/간식 증가 시 lastDecayDate 미변경 확인
- [x] 코드 정리
  - [x] 설정 화면에서 "행복도 감소 테스트" 섹션 제거
  - [x] test_happiness_decay.dart 파일 삭제
  - [x] test_remote_config.dart 파일 삭제
  - [x] pet_reward_service.dart 디버그 로그 정리
  - [x] happiness_scheduler_service.dart 디버그 로그 정리
  - [x] main.dart 디버그 로그 정리

**버그 수정 결과:**
- ✅ 일일 자동 감소 정상 작동 (하루 -5)
- ✅ 산책 시 행복도 증가 정상 작동 (100걸음 = +1)
- ✅ 간식 주기 시 행복도 증가 정상 작동 (간식 1개 = +10)
- ✅ lastDecayDate 업데이트 로직 정상 작동
- ✅ 시나리오 검증 완료: Day1(100) → Day2(95) → 산책(98) → Day3(93)

#### 예상 일정
- **총 소요 기간**: 5-6일
- **Phase 1**: 1일 (API 설정)
- **Phase 2**: 2일 (Service Layer)
- **Phase 3**: 1일 (Provider)
- **Phase 4**: 1일 (UI)
- **Phase 5**: 1일 (최적화)

#### 참고 문서
- `docs/ai-integration-md.md` - 상세 구현 가이드
- `docs/claude.md` - Week 3 작업 요약

**미래 계획**: 사용자 피드백 후 MLC-LLM 마이그레이션 고려 (완전 오프라인 지원)

### Week 4: 이미지 생성 및 마무리 ⏸️ **보류**
**목표:** 클라우드 이미지 생성 및 전체 통합

#### 작업 항목
- [ ] Firebase Functions 설정
  - [ ] 프록시 API 구현
  - [ ] App Check 설정
  - [ ] 레이트 리미팅
- [ ] 이미지 생성 통합
  - [ ] Gemini API 연동
  - [ ] 캐싱 시스템
  - [ ] 폴백 메커니즘
- [ ] 성능 최적화
  - [ ] 이미지 압축
  - [ ] 메모리 관리
  - [ ] 네트워크 최적화
- [ ] QA 및 버그 수정
  - [ ] 전체 플로우 테스트
  - [ ] 엣지 케이스 처리
  - [ ] 크래시 수정
- [ ] 출시 준비
  - [ ] 스토어 에셋 준비
  - [ ] 문서 작성
  - [ ] 베타 테스트

#### 산출물
- ⏸️ 완전한 MVP 앱 (AI/이미지 생성 기능 제외)
- ⏸️ 스토어 제출 준비 완료 (미완료)
- ⏸️ 베타 테스터 피드백 (미수집)

**참고**: Week 4 이미지 생성은 현재 보류 상태입니다. 커스터마이즈 화면에 버튼 UI만 구현되어 있으며, Firebase Functions 및 Gemini API 통합은 미구현입니다.

### Week 5 (추후): AI 양방향 채팅 기능 ⏳ **계획**
**목표:** 사용자와 펫 간 실시간 양방향 대화 구현

**배경:**
- Week 3에서 일방향 이벤트 응답만 구현 (산책 완료, 미션 완료 등)
- 사용자가 직접 텍스트를 입력해서 펫과 자유롭게 대화하는 기능 추가
- 기존 ConversationService의 `userMessage` 파라미터 활용

#### 작업 항목

**Phase 1: 채팅 UI 구현 (1일)**
- [ ] ChatScreen 생성
  - [ ] 메시지 리스트 (ListView.builder)
  - [ ] 입력 필드 (TextField + 전송 버튼)
  - [ ] 말풍선 디자인 (사용자 vs 펫)
  - [ ] 로딩 인디케이터
  - [ ] 타이핑 애니메이션
- [ ] 채팅 버튼 추가
  - [ ] 홈 화면 AppBar에 채팅 아이콘
  - [ ] 펫 아바타 롱프레스로 채팅 시작

**Phase 2: 채팅 상태 관리 (1일)**
- [ ] Message 데이터 모델
  - [ ] sender (user/dog), text, timestamp
  - [ ] Isar 컬렉션 (채팅 기록 저장)
- [ ] ChatHistory Provider
  - [ ] StateNotifierProvider<List<Message>>
  - [ ] 메시지 추가/삭제
  - [ ] 기록 로드/저장
- [ ] Chat Provider
  - [ ] sendMessageProvider (FutureProvider.family)
  - [ ] conversationServiceProvider 연동

**Phase 3: 대화 로직 통합 (1일)**
- [ ] 새 컨텍스트 추가: 'chat'
  - [ ] FallbackResponses에 일반 대화 응답 추가
  - [ ] LLMService 프롬프트 조정 (자유 대화)
- [ ] 메시지 전송 플로우
  - [ ] 사용자 메시지 즉시 표시
  - [ ] AI 응답 요청 (로딩 표시)
  - [ ] 펫 응답 표시 (애니메이션)
- [ ] 컨텍스트 유지
  - [ ] 최근 5개 메시지 기록 전달
  - [ ] 펫 상태 (행복도, 레벨) 반영

**Phase 4: UX 개선 (1일)**
- [ ] 채팅 기록 관리
  - [ ] 세션별 구분 (일별)
  - [ ] 기록 삭제 기능
  - [ ] 검색 기능 (선택)
- [ ] 빠른 응답 버튼
  - [ ] "산책 가자", "간식 줘", "기분 어때?" 등
  - [ ] 탭 한 번으로 메시지 전송
- [ ] 알림 통합
  - [ ] 펫이 먼저 말 걸기 (푸시 알림, 선택)
  - [ ] 미응답 메시지 배지

**Phase 5: 최적화 (0.5일)**
- [ ] 레이트 리밋 적용
  - [ ] 채팅도 일일 API 호출 제한에 포함
  - [ ] 제한 초과 시 폴백만 사용
- [ ] 캐싱
  - [ ] 동일 질문 캐싱 (선택)
  - [ ] 자주 묻는 질문 미리 준비
- [ ] 성능 모니터링
  - [ ] 채팅 사용량 추적
  - [ ] 평균 응답 시간 측정

#### 산출물
- [ ] 완전한 양방향 채팅 시스템
- [ ] 채팅 기록 관리 기능
- [ ] 빠른 응답 버튼 (3-5개)
- [ ] 기존 이벤트 응답과 통합된 경험

#### 예상 일정
- **총 소요 기간**: 3-4일
- **Phase 1**: 1일 (UI)
- **Phase 2**: 1일 (상태 관리)
- **Phase 3**: 1일 (로직)
- **Phase 4**: 1일 (UX)
- **Phase 5**: 0.5일 (최적화)

#### 기술 요구사항
- 기존 Phase 1-3 완료 필수 (ConversationService, AI Providers)
- Isar 컬렉션 추가 (Message)
- 추가 패키지: 없음 (기존 인프라 활용)

#### 참고 사항
- Week 3 Phase 4 (일방향 응답) 완료 후 진행
- 기존 코드와 충돌 없이 추가 가능한 구조
- 채팅 기능은 선택적 (앱 사용에 필수 아님)

---

## 📊 현재 프로젝트 상태 (2025년 9월 업데이트)

### ✅ 완료된 기능 (Week 1-2 + 추가 기능)
1. **기초 설정 및 아키텍처** (Week 1)
   - Flutter 프로젝트 초기화 완료
   - Clean Architecture 기반 구조 (Domain, Data, Presentation, Service)
   - Riverpod 상태 관리 (20개 이상 Provider)
   - Isar 데이터베이스 (5개 컬렉션)

2. **화면 UI** (Week 1)
   - 8개 화면 구현: 홈, 커스터마이즈, 설정, 산책, 배지, 스플래시, 온보딩(2개)
   - Bottom Navigation Bar (4개 탭)
   - 홈 화면 위젯 8개 (펫 아바타, 상태, 통계, 버튼, 미션, 연속, 차트)
   - Material 3 다크/라이트 테마

3. **센서 및 추적** (Week 2)
   - Pedometer 통합 (실시간 걸음수)
   - GPS 위치 추적 (실외 모드)
   - 걸음수 자동 추적 서비스

4. **보상 및 게임화** (Week 2)
   - 간식 시스템 (300걸음 = 1간식)
   - 행복도 시스템 (0-100, 일일 자동 감소)
   - 10개 배지 시스템 (4개 티어)
   - 일일/주간 미션 자동 생성
   - 보상 자동 지급
   - 레벨 시스템 (경험치 획득, 레벨업, 보상, 알림)
   - 실시간 미션 진행도 표시 (홈/리스트/상세 화면, 5초 폴링)
   - **iOS/Android 플랫폼 테스트 완료** (Release 빌드, 실기기 테스트)

5. **통계 및 시각화** (로드맵 외 추가 기능)
   - 일일/주간/월간 통계 계산
   - fl_chart 차트 위젯 (주간 막대, 월간 라인)
   - 연속 산책 일수 추적
   - 누적 통계 (총 걸음수, 거리, 시간, 산책 횟수)

### ⏸️ 보류 중인 기능 (Week 3-4)
- AI 대화 시스템 (로컬 LLM)
- AI 이미지 생성 (Gemini API)
- Firebase Functions 프록시
- 벡터 기반 펫 아바타 (현재 이모지 사용)

### 🎯 수정된 MVP 성공 지표
- [x] 크래시 없는 앱 실행 (Xcode build 성공)
- [x] 6가지 커스터마이징 옵션 (액세서리)
- [ ] ~~5가지 이상 AI 대화 컨텍스트~~ (보류)
- [ ] ~~이미지 생성 성공률 > 90%~~ (보류)
- [x] 앱 시작 시간 < 3초 (스플래시 화면)
- [x] 메모리 사용량 < 200MB
- [x] **추가**: 10개 배지 시스템 작동
- [x] **추가**: 일일/주간 미션 자동 생성
- [x] **추가**: 통계 차트 시각화

## 🚀 Version 1.1 - 소셜 업데이트 (2주)

### 주요 기능
- **친구 시스템**
  - [ ] 친구 추가/관리
  - [ ] 친구 펫 방문
  - [ ] 선물 시스템
  
- **리더보드**
  - [ ] 주간/월간 랭킹
  - [ ] 지역별 랭킹
  - [ ] 친구 간 경쟁
  
- **공유 기능**
  - [ ] 산책 기록 공유
  - [ ] 배지 자랑하기
  - [ ] 펫 사진 공유

### 기술 요구사항
- Firebase Realtime Database 통합
- 사용자 인증 시스템 (이메일/소셜)
- 푸시 알림 시스템

## 🎨 Version 1.2 - 몰입감 업데이트 (2주)

### 주요 기능
- **AR 모드**
  - [ ] ARCore/ARKit 통합
  - [ ] 실세계 펫 배치
  - [ ] AR 산책 셀카
  - [ ] AR 미니게임
  
- **웨어러블 연동**
  - [ ] Apple Watch 앱
  - [ ] Wear OS 앱
  - [ ] 실시간 동기화
  - [ ] 간편 상호작용

### 기술 요구사항
- AR Foundation 통합
- Watch Connectivity
- Wear OS API

## 🔮 Version 2.0 - 메이저 업데이트 (4주)

### 주요 기능
- **멀티 펫 시스템**
  - [ ] 최대 3마리 동시 육성
  - [ ] 펫 간 상호작용
  - [ ] 팀 산책 보너스
  
- **고급 AI 기능**
  - [ ] 음성 대화
  - [ ] 감정 인식
  - [ ] 개인화된 대화
  - [ ] 학습 시스템
  
- **펫 성장 시스템**
  - [ ] 레벨/경험치
  - [ ] 스킬 트리
  - [ ] 진화 시스템
  
- **미니게임**
  - [ ] 산책 중 미니게임
  - [ ] 펫 훈련 게임
  - [ ] 보상 룰렛

### 기술 요구사항
- 음성 인식/합성 API
- 고급 LLM 모델 (Qwen2.5-7B)
- 복잡한 상태 관리

## 📈 장기 로드맵 (6개월+)

### Q3 2024: 수익화 및 확장
- **프리미엄 기능**
  - [ ] 프리미엄 펫 품종
  - [ ] 무제한 이미지 생성
  - [ ] 고급 커스터마이징
  - [ ] 광고 제거
  
- **파트너십**
  - [ ] 반려동물 브랜드 협업
  - [ ] 운동 앱 연동
  - [ ] 보험사 제휴

### Q4 2024: 글로벌 확장
- **다국어 지원**
  - [ ] 영어
  - [ ] 일본어
  - [ ] 중국어
  
- **지역화**
  - [ ] 지역별 펫 품종
  - [ ] 문화별 커스터마이징
  - [ ] 현지 이벤트

### 2025: 플랫폼 확장
- **웹 버전**
  - [ ] Flutter Web 포팅
  - [ ] 크로스 플랫폼 동기화
  
- **AI 마켓플레이스**
  - [ ] 사용자 제작 콘텐츠
  - [ ] 펫 액세서리 거래
  - [ ] 커뮤니티 미션

## 🔧 기술 부채 관리

### 우선순위 높음
- [ ] 테스트 커버리지 80% 달성
- [ ] CI/CD 파이프라인 개선
- [ ] 성능 모니터링 강화
- [ ] 에러 리포팅 시스템

### 우선순위 중간
- [ ] 코드 리팩토링
- [ ] 문서화 개선
- [ ] 접근성 개선
- [ ] 국제화 준비

### 우선순위 낮음
- [ ] 마이크로서비스 전환
- [ ] GraphQL 도입
- [ ] 블록체인 통합

## 📊 KPI 추적

### 사용자 지표
- **DAU (일일 활성 사용자)**
  - MVP: 100명
  - v1.1: 1,000명
  - v2.0: 10,000명
  
- **MAU (월간 활성 사용자)**
  - MVP: 500명
  - v1.1: 5,000명
  - v2.0: 50,000명

### 참여 지표
- **일평균 산책 시간**
  - MVP: 15분
  - v1.1: 20분
  - v2.0: 30분
  
- **7일 리텐션**
  - MVP: 30%
  - v1.1: 40%
  - v2.0: 50%

### 기술 지표
- **크래시 프리 세션**
  - MVP: 95%
  - v1.1: 98%
  - v2.0: 99.5%
  
- **API 응답 시간 (p95)**
  - MVP: < 1초
  - v1.1: < 500ms
  - v2.0: < 300ms

## 🎯 마일스톤 체크포인트

### MVP 출시 (4/28)
- [ ] iOS TestFlight 배포
- [ ] Android 내부 테스트
- [ ] 100명 베타 테스터 모집
- [ ] 피드백 수집 시스템

### 공개 베타 (5/15)
- [ ] 주요 버그 수정
- [ ] 1,000명 사용자 확보
- [ ] 스토어 최적화

### 정식 출시 (6/1)
- [ ] 마케팅 캠페인
- [ ] 인플루언서 협업
- [ ] 미디어 보도

### 첫 업데이트 (6/15)
- [ ] 사용자 피드백 반영
- [ ] 신규 기능 추가
- [ ] 성능 개선

## 🚨 리스크 관리

### 기술적 리스크
| 리스크 | 확률 | 영향 | 대응 방안 |
|--------|------|------|-----------|
| LLM 모델 크기 | 높음 | 높음 | 경량 모델 옵션, 클라우드 폴백 |
| 배터리 소모 | 중간 | 높음 | 최적화, 절전 모드 |
| 서버 비용 | 중간 | 중간 | 캐싱, 쿼터 관리 |

### 비즈니스 리스크
| 리스크 | 확률 | 영향 | 대응 방안 |
|--------|------|------|-----------|
| 낮은 리텐션 | 중간 | 높음 | 온보딩 개선, 리워드 강화 |
| 경쟁 앱 출시 | 높음 | 중간 | 차별화 기능, 빠른 업데이트 |
| 수익화 실패 | 낮음 | 높음 | 다양한 수익 모델 테스트 |

## 📝 의사결정 기록

### 2024-03-25: 아키텍처 결정
- **결정:** Clean Architecture + Riverpod
- **이유:** 확장성, 테스트 용이성, 커뮤니티 지원
- **대안:** BLoC, GetX, Provider

### 2024-03-26: LLM 모델 선택
- **결정:** Qwen2.5-3B-Instruct
- **이유:** 크기 대비 성능, 한국어 지원
- **대안:** LLaMA, Gemma, Phi

### 2024-03-27: 이미지 생성 서비스
- **결정:** Google Gemini API
- **이유:** 품질, 가격, 통합 용이성
- **대안:** Stable Diffusion, DALL-E, Midjourney

## 🎊 축하 이벤트

### 마일스톤 달성 시
- 1,000 다운로드: 팀 회식
- 10,000 다운로드: 보너스
- 100,000 다운로드: 팀 워크샵
- 1,000,000 다운로드: 해외 컨퍼런스

## 📚 참고 자료
- [Flutter 로드맵](https://flutter.dev/roadmap)
- [Firebase 로드맵](https://firebase.google.com/roadmap)
- [앱 스토어 가이드라인](https://developer.apple.com/app-store/guidelines/)
- [Google Play 정책](https://play.google.com/console/policy)

# WalkDog 아키텍처 설계 (2025년 9월 업데이트)

## ⚠️ 현재 구현 상태

**현재 프로젝트는 Clean Architecture의 간소화된 버전을 채택하고 있습니다:**
- ✅ **Service Pattern** 사용 중 (Repository Pattern은 미구현)
- ✅ **Domain Layer**: Entities만 구현 (Use Cases, Repository Interfaces 미구현)
- ✅ **Data Layer**: Models, DatabaseService만 구현 (Repositories 미구현)
- ✅ **Service Layer**: 8개 서비스로 비즈니스 로직 처리
- ✅ **Presentation Layer**: Riverpod Provider 직접 사용

**본 문서는 향후 리팩토링을 위한 목표 아키텍처를 포함하고 있습니다.**

---

## 1. 시스템 아키텍처

### 1.1 현재 적용된 아키텍처 (MVP)
```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (Screens, Widgets, Riverpod Provider)  │
├─────────────────────────────────────────┤
│            Domain Layer                 │
│        (Entities만 구현)                │
├─────────────────────────────────────────┤
│             Data Layer                  │
│      (Models, DatabaseService)          │
├─────────────────────────────────────────┤
│           Service Layer                 │
│    (8개 Service: Pet, Walk, Mission 등) │
└─────────────────────────────────────────┘
```

### 1.2 목표 아키텍처 (향후 리팩토링)
```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (Screens, Widgets, State Management)   │
├─────────────────────────────────────────┤
│            Domain Layer                 │
│   (Use Cases, Entities, Interfaces)    │
├─────────────────────────────────────────┤
│             Data Layer                  │
│ (Repositories, Models, Data Sources)    │
├─────────────────────────────────────────┤
│           Service Layer                 │
│    (AI, Sensors, Network, Storage)      │
└─────────────────────────────────────────┘
```

### 1.3 클라우드 AI 아키텍처 (Week 3 진행중)
```
┌──────────────┐     ┌──────────────┐
│  Cloud LLM   │     │  Cloud Image │
│ (OpenRouter) │     │ (Gemini 2.5) │
│ DeepSeek R1  │     │  (Week 4)    │
└──────┬───────┘     └──────┬───────┘
       │                     │
       ▼                     ▼
┌──────────────────────────────────┐
│        AI Service Manager        │
├──────────────────────────────────┤
│  Fallback & Rate Limiting        │
│  (규칙 기반 응답 시스템)          │
└──────────────────────────────────┘
```
**상태**: 🔄 Week 3 진행중 (OpenRouter API)
**구현 내용**:
- OpenRouter API (DeepSeek R1, 무료)
- HTTP 기반 API 호출
- 오프라인 폴백 시스템
- 레이트 리밋 관리 (100회/일)

**미래 계획**: MLC-LLM 마이그레이션 (완전 오프라인 지원)

---

## 2. 디렉토리 구조

### 2.1 현재 구현된 구조 (MVP)

```
lib/
├── core/                          # ✅ 완료
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── utils/
│       ├── validators.dart
│       └── formatters.dart
│
├── data/                          # ✅ 완료 (Repository 패턴 미적용)
│   ├── models/
│   │   ├── pet_model.dart
│   │   ├── walk_log_model.dart
│   │   ├── achievement_model.dart
│   │   ├── mission_model.dart
│   │   └── settings_model.dart
│   └── datasources/
│       └── database_service.dart   # Isar 직접 사용
│
├── domain/                        # ⚠️ 부분 완료 (Entities만)
│   └── entities/
│       ├── pet.dart
│       ├── walk_session.dart
│       ├── achievement.dart
│       ├── mission.dart
│       └── app_settings.dart
│
├── presentation/                  # ✅ 완료
│   ├── screens/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/          # 10개 위젯
│   │   ├── onboarding/
│   │   │   ├── welcome_screen.dart
│   │   │   └── pet_creation_screen.dart
│   │   ├── walk/
│   │   │   └── walk_screen.dart
│   │   ├── customize/
│   │   │   └── customize_screen.dart
│   │   ├── achievements/
│   │   │   └── achievements_screen.dart
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   └── splash/
│   │       └── splash_screen.dart
│   └── widgets/                   # 공통 위젯 7개
│
└── services/                      # ✅ 완료 (8개 서비스)
    ├── pet/
    │   ├── pet_reward_service.dart
    │   └── happiness_scheduler_service.dart
    ├── achievement/
    │   └── achievement_service.dart
    ├── mission/
    │   └── mission_service.dart
    ├── tracking/
    │   └── step_tracking_service.dart
    ├── statistics/
    │   └── statistics_service.dart
    ├── location/
    │   └── location_service.dart
    └── sensors/
        └── pedometer_service.dart
```

### 2.2 목표 구조 (향후 리팩토링)

```
lib/
├── data/
│   ├── repositories/              # ❌ 미구현
│   │   ├── pet_repository_impl.dart
│   │   ├── walk_repository_impl.dart
│   │   └── settings_repository_impl.dart
│   └── datasources/
│       ├── local/                 # ❌ 미구현
│       │   ├── isar_database.dart
│       │   └── cache_manager.dart
│       └── remote/                # ❌ 미구현
│           ├── firebase_functions_api.dart
│           └── remote_config_service.dart
│
├── domain/
│   ├── repositories/              # ❌ 미구현
│   │   ├── pet_repository.dart
│   │   ├── walk_repository.dart
│   │   └── settings_repository.dart
│   └── usecases/                  # ❌ 미구현
│       ├── pet/
│       ├── walk/
│       └── ai/
│
├── presentation/
│   └── providers/                 # ❌ 미구현 (각 화면에서 직접 Provider 정의)
│
└── services/
    ├── ai/                        # ❌ 미구현 (Week 3)
    │   ├── llm_service.dart
    │   ├── image_generation_service.dart
    │   └── prompt_builder.dart
    ├── storage/                   # ❌ 미구현 (Week 3-4)
    │   ├── model_downloader.dart
    │   └── image_cache_service.dart
    └── notifications/             # ❌ 미구현
        └── notification_service.dart
```

## 3. 상태 관리 (Riverpod 3.0+)

### 3.1 Provider 구조 (Code Generation)
```dart
// 전역 상태 (Code Generation 방식)
@riverpod
class PetNotifier extends _$PetNotifier {
  @override
  Pet build() => Pet.initial();

  void updateHappiness(int value) => state = state.copyWith(happiness: value);
}

@riverpod
class WalkSession extends _$WalkSession {
  @override
  WalkSession? build() => null;

  void startWalk() => state = WalkSession.started();
}

// AI 상태
@riverpod
Future<LLMService> llmService(LlmServiceRef ref) async {
  return await LLMService.initialize();
}

@riverpod
Future<String> dialogue(DialogueRef ref, DialogueContext context) async {
  final llm = await ref.watch(llmServiceProvider.future);
  return await llm.generateDialogue(context);
}

// 센서 상태
@riverpod
Stream<int> stepCount(StepCountRef ref) {
  return PedometerService.stepCountStream;
}
```

### 3.2 상태 플로우
```
User Action → Provider → Use Case → Repository → Data Source
     ↑                                              ↓
     └──────── UI Update ←─ State Change ←─────────┘
```

## 4. 데이터 플로우

### 4.1 산책 시작 플로우
```
1. 사용자가 '산책 시작' 탭
2. WalkProvider.startWalk() 호출
3. StartWalkUseCase 실행
4. PedometerService 활성화
5. (선택) LocationService 활성화
6. WalkSession 생성 및 상태 업데이트
7. UI에 실시간 걸음수 표시
```

### 4.2 AI 대화 플로우
```
1. 대화 트리거 (간식 주기, 미션 완료 등)
2. DialogueProvider 호출
3. PromptBuilder로 컨텍스트 생성
4. LLMService.generate() 실행
5. 응답 스트리밍 → UI 업데이트
6. 실패 시 FallbackDialogue 사용
```

### 4.3 이미지 생성 플로우
```
1. 커스터마이즈 완료
2. StickerProvider 호출
3. 캐시 확인
4. 미스 시 Firebase Functions 호출
5. 이미지 다운로드 및 캐싱
6. UI에 표시
7. 실패 시 벡터 아바타 폴백
```

## 5. 에러 핸들링 전략

### 5.1 에러 타입
```dart
abstract class Failure {
  final String message;
  final String? code;
  
  const Failure(this.message, {this.code});
}

class NetworkFailure extends Failure {}
class CacheFailure extends Failure {}
class SensorFailure extends Failure {}
class AIFailure extends Failure {}
class QuotaExceededFailure extends Failure {}
```

### 5.2 에러 처리 레이어
- **Service Layer**: Exception throw
- **Repository Layer**: Exception → Failure 변환
- **Use Case Layer**: Either<Failure, Success> 반환
- **Provider Layer**: Failure → UI 메시지 변환
- **UI Layer**: 사용자 친화적 에러 표시

## 6. 성능 최적화

### 6.1 메모리 관리
- API 응답 캐싱 (메모리)
- 이미지 캐시 크기 제한 (100MB)
- 불필요한 Provider dispose
- HTTP 클라이언트 재사용

### 6.2 배터리 최적화
- GPS 샘플링 간격 동적 조정
- 백그라운드 작업 최소화
- 배터리 레벨 기반 API 토큰 조정
- 모바일 데이터 사용 시 폴백 우선 사용

### 6.3 네트워크 최적화
- 이미지 프리페칭
- API 호출 디바운싱
- 오프라인 우선 설계

## 7. 보안 아키텍처

### 7.1 API 보안
```
Client → Firebase Auth → App Check → Functions → External API
                                         ↓
                                   Rate Limiting
                                   Key Protection
                                   Content Filtering
```

### 7.2 데이터 보안
- 로컬 데이터만 저장 (PII 없음)
- API 키 서버 측 관리
- SSL/TLS 통신

## 8. 테스트 아키텍처

### 8.1 테스트 레이어
- **Unit Tests**: Use Cases, Repositories
- **Widget Tests**: UI Components
- **Integration Tests**: 전체 플로우
- **Golden Tests**: UI 스냅샷

### 8.2 Mock 전략
```dart
// Mock 서비스
class MockLLMService extends Mock implements LLMService {}
class MockPedometerService extends Mock implements PedometerService {}
class MockImageGenerationService extends Mock implements ImageGenerationService {}
```

## 9. 빌드 & 배포

### 9.1 환경 구분
- **Development**: 로컬 개발, Mock 데이터
- **Staging**: 테스트 서버, 실제 API (제한적)
- **Production**: 라이브 서버, 전체 기능

### 9.2 Feature Flags
```dart
class FeatureFlags {
  static bool enableOutdoorMode = true;
  static bool enableCloudImage = true;
  static bool enableCloudLLM = true;  // OpenRouter API
  static int maxDailyLLMRequests = 80;  // OpenRouter 무료 제한
  static int maxDailyImageGeneration = 10;
}
```

# WalkDog - Claude Code CLI 프로젝트 가이드

## 프로젝트 개요
WalkDog은 걸음수 기반 가상 반려견 앱으로, 사용자의 산책 습관을 게이미피케이션을 통해 개선합니다.

### 핵심 특징
- **클라우드 AI 대화**: OpenRouter + DeepSeek R1으로 무료 실시간 반응 (추후 로컬 LLM 마이그레이션 계획)
- **클라우드 이미지 생성**: Google Gemini 2.5 Flash Image Preview API로 맞춤형 강아지 스티커
- **하이브리드 AI 아키텍처**: 클라우드(대화) + 오프라인 폴백 시스템
- **실외 모드**: GPS 기반 안티치트 시스템

## 기술 스택
- **프론트엔드**: Flutter 3.35+ (Dart 3.6+)
- **백엔드**: Firebase (Auth, Functions, Remote Config, FlutterFire BoM 4.3.0+)
- **AI/ML**:
  - 대화: OpenRouter API (DeepSeek R1, 무료)
  - 이미지: Google Gemini 2.5 Flash Image Preview (Week 4)
  - 폴백: 규칙 기반 응답 시스템 (오프라인)
- **데이터베이스**: Isar 4.0+ (로컬)
- **상태관리**: Riverpod 3.0+

## 프로젝트 구조
```
walk_dog/
├── lib/
│   ├── core/           # 핵심 유틸리티, 상수, 테마
│   ├── data/           # 데이터 레이어 (모델, 리포지토리, 데이터소스)
│   ├── domain/         # 도메인 레이어 (엔티티, 유즈케이스)
│   ├── presentation/   # 프레젠테이션 레이어 (화면, 위젯, 상태관리)
│   ├── services/       # 서비스 레이어 (AI, 센서, 네트워크)
│   └── main.dart
├── assets/            # 이미지, 폰트, LLM 모델
├── firebase/          # Firebase Functions 코드
├── test/             # 테스트 코드
└── docs/             # 프로젝트 문서

```

## 개발 우선순위 (MVP - 4주) - 2025년 9월 업데이트

### Week 1: 기초 설정 및 UI (2025년 9월 4주차)
- [ ] Flutter 프로젝트 초기 설정
- [ ] 기본 UI 구조 (홈, 커스터마이즈, 설정)
- [ ] Isar DB 스키마 정의
- [ ] 벡터 기반 강아지 아바타
- [ ] 기본 애니메이션

### Week 2: 센서 및 보상 시스템 (2025년 10월 1주차)
- [ ] Pedometer 연동 (걸음수 트래킹)
- [ ] 보상/행복도 시스템
- [ ] 배지/미션 로직
- [ ] GPS 실외 모드 (선택)
- [ ] 안티치트 메커니즘

### Week 3: AI 통합 (2025년 10월 2주차) - OpenRouter + DeepSeek R1
- [ ] OpenRouter API 통합 (무료 DeepSeek R1 모델)
  - [ ] API 키 설정 (Firebase Remote Config)
  - [ ] LLMService 구현 (HTTP 호출)
  - [ ] 15초 타임아웃 및 에러 핸들링
- [ ] 대화 시스템 구현
  - [ ] 프롬프트 템플릿 (시스템 + 컨텍스트)
  - [ ] 5가지 컨텍스트 대화 (walk, mission, feed, level_up, low_happiness)
  - [ ] 강아지 성격 시스템 (활발, 친근)
  - [ ] 응답 UI 및 애니메이션
- [ ] 오프라인 폴백 시스템
  - [ ] 규칙 기반 응답 (각 컨텍스트별)
  - [ ] 자동 폴백 전환
- [ ] 알림 시스템
  - [ ] 산책 리마인더 (8시간 간격)
  - [ ] 행복도 낮음 알림
  - [ ] 미션 만료 알림
- [ ] **미래 마이그레이션 경로**: MLC-LLM 오프라인 모드 (선택)

### Week 4: 이미지 생성 및 마무리 (2025년 10월 3주차)
- [ ] Firebase Functions 프록시 구현
- [ ] Gemini 이미지 생성 통합
- [ ] 이미지 캐싱 시스템
- [ ] 다크모드/접근성
- [ ] 성능 최적화
- [ ] 테스트 및 QA

## 주요 명령어
```bash
# 프로젝트 초기화 (Flutter 3.35+)
flutter create --org com.walkdog --platforms ios,android walk_dog

# 의존성 설치
flutter pub get

# 코드 생성 (freezed, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Isar 4.0+ 스키마 생성
dart run build_runner build

# 테스트 실행
flutter test

# Firebase 배포
firebase deploy --only functions

# 빌드
flutter build apk --release
flutter build ios --release
```

## 중요 고려사항

### 성능
- AI 대화: OpenRouter API 호출 (평균 2-5초, 타임아웃 15초)
- 응답 토큰 제한: 100 토큰
- 앱 용량: AI 모델 다운로드 불필요 (클라우드 기반)
- 이미지 캐시: 로컬 우선, 512px WebP (Week 4)
- GPS 샘플링: 30-60초 간격

### 보안
- API 키: Firebase Remote Config 저장 (OpenRouter, Gemini)
- App Check 필수
- 레이트 리밋: OpenRouter 무료 tier (100회/일)
- PII 데이터 미수집
- HTTPS 암호화 통신

### UX
- 오프라인 우선 설계
- 모든 네트워크 작업에 폴백
- 로딩 상태 명확히 표시
- 에러 메시지 친화적으로

## 다음 단계
1. `ARCHITECTURE.md` 참조하여 상세 설계 확인
2. `SETUP.md` 따라 개발 환경 구성
3. `API_SPEC.md`로 백엔드 API 이해
4. `TESTING.md`로 테스트 전략 수립

## 컨택스트 유지
각 작업 시작 시 관련 문서를 참조하고, 변경사항은 즉시 문서에 반영합니다.

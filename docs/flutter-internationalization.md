# Flutter 다국어(국제화) 구현 가이드

> WalkDog 앱의 한국어/영어 다국어 지원 구현 완료 문서

---

## 📋 목차

1. [개요](#개요)
2. [Flutter 공식 국제화 방법](#flutter-공식-국제화-방법)
3. [프로젝트 설정](#프로젝트-설정)
4. [ARB 파일 구조](#arb-파일-구조)
5. [코드에서 사용하기](#코드에서-사용하기)
6. [AI 다국어 지원](#ai-다국어-지원)
7. [전체 워크플로우](#전체-워크플로우)
8. [트러블슈팅](#트러블슈팅)

---

## 개요

### 구현 목표
- ✅ Flutter 공식 국제화 방식 사용 (ARB 파일 기반)
- ✅ 한국어(ko), 영어(en) 지원
- ✅ UI 텍스트 다국어화
- ✅ AI 대화 응답 다국어화 (LLM + Fallback)
- ✅ 설정 화면에서 언어 변경 가능

### 지원 언어
| 언어 | Locale Code | ARB 파일 |
|-----|-------------|----------|
| 한국어 | `ko` | `app_ko.arb` |
| 영어 | `en` | `app_en.arb` |

---

## Flutter 공식 국제화 방법

Flutter는 **ARB (Application Resource Bundle)** 파일 기반 국제화를 공식 지원합니다.

### ARB란?
- JSON 형식의 번역 파일 포맷
- Google에서 개발한 국제화 표준
- 각 언어별로 하나의 ARB 파일 생성
- Flutter가 자동으로 Dart 코드 생성

### 작동 원리

```
1. ARB 파일 작성 (app_en.arb, app_ko.arb)
   ↓
2. flutter pub get 실행
   ↓
3. Flutter가 자동으로 AppLocalizations 클래스 생성
   ↓
4. 코드에서 AppLocalizations.of(context) 사용
```

---

## 프로젝트 설정

### 1. pubspec.yaml 설정

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:  # 필수!
    sdk: flutter

flutter:
  # 코드 자동 생성 활성화
  generate: true
```

**핵심 포인트:**
- `flutter_localizations`: Flutter SDK에 포함된 국제화 패키지
- `generate: true`: ARB → Dart 코드 자동 생성 활성화

### 2. l10n.yaml 설정

**파일 위치:** `/walk_dog/l10n.yaml`

```yaml
# ARB 파일이 위치한 디렉토리
arb-dir: lib/l10n

# 템플릿 ARB 파일 (기준 언어)
template-arb-file: app_en.arb

# 생성될 Dart 파일명
output-localization-file: app_localizations.dart

# 생성될 클래스명
output-class: AppLocalizations

# Nullable getter 비활성화 (더 깔끔한 API)
nullable-getter: false
```

**각 설정의 의미:**
- `arb-dir`: ARB 파일들이 저장된 폴더
- `template-arb-file`: 기준이 되는 ARB 파일 (보통 영어)
- `output-class`: 생성될 클래스 이름
- `nullable-getter: false`: `AppLocalizations.of(context)!` 대신 `AppLocalizations.of(context)` 사용 가능

---

## ARB 파일 구조

### 파일 위치
```
walk_dog/
└── lib/
    └── l10n/
        ├── app_en.arb  # 영어 (템플릿)
        └── app_ko.arb  # 한국어
```

### ARB 파일 기본 구조

```json
{
  "@@locale": "en",

  "appName": "WalkDog",
  "@appName": {
    "description": "The application name"
  },

  "settings": "Settings",
  "@settings": {
    "description": "Settings screen title"
  }
}
```

**구조 설명:**
1. `"@@locale"`: 해당 파일의 언어 코드
2. `"키"`: 실제 번역된 텍스트
3. `"@키"`: 메타데이터 (설명, 플레이스홀더 등)

### 플레이스홀더 사용

변수를 포함한 텍스트는 플레이스홀더를 사용합니다.

```json
{
  "dailyGoalSteps": "{steps} steps",
  "@dailyGoalSteps": {
    "description": "Daily goal with step count",
    "placeholders": {
      "steps": {
        "type": "int",
        "example": "5000"
      }
    }
  }
}
```

**코드에서 사용:**
```dart
AppLocalizations.of(context).dailyGoalSteps(5000)
// 결과: "5000 steps" (영어) 또는 "5000 걸음" (한국어)
```

### 복수형 처리

```json
{
  "treatsCount": "{count} treats",
  "@treatsCount": {
    "description": "Treats count",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

---

## 코드에서 사용하기

### 1. main.dart 설정

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return MaterialApp(
      // 지원 언어 목록
      supportedLocales: const [
        Locale('ko'), // 한국어
        Locale('en'), // 영어
      ],

      // Localization Delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 현재 선택된 언어
      locale: settingsAsync.when(
        data: (settings) => Locale(settings.locale),
        loading: () => const Locale('ko'),
        error: (_, __) => const Locale('ko'),
      ),

      // ...
    );
  }
}
```

**핵심 포인트:**
- `supportedLocales`: 앱이 지원하는 언어 목록
- `AppLocalizations.delegate`: 자동 생성된 델리게이트
- `locale`: 현재 선택된 언어 (SettingsModel에서 가져옴)

### 2. 위젯에서 사용

```dart
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AppLocalizations 인스턴스 가져오기
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings), // "Settings" 또는 "설정"
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.language), // "Language" 또는 "언어"
            subtitle: Text(l10n.languageKorean), // "Korean" 또는 "한국어"
          ),
          ListTile(
            title: Text(l10n.dailyGoalSteps(5000)), // "5000 steps" 또는 "5000 걸음"
          ),
        ],
      ),
    );
  }
}
```

**사용 패턴:**
1. `AppLocalizations.of(context)` 호출
2. 생성된 getter/메서드 사용
3. 플레이스홀더가 있으면 파라미터 전달

### 3. 언어 변경 구현

**SettingsModel에 locale 필드 추가**

```dart
@collection
class SettingsModel {
  // ...
  late String locale; // "ko", "en", etc.
}
```

**언어 변경 메서드**

```dart
// SettingsService
Future<void> updateLocale(String localeCode) async {
  final settings = await loadSettings();
  settings.locale = localeCode;
  await _databaseService.saveSettings(settings);
}

// SettingsNotifier
Future<void> updateLocale(String localeCode) async {
  await _service.updateLocale(localeCode);
  await _loadSettings(); // UI 자동 갱신
}
```

**UI에서 언어 변경**

```dart
// Settings 화면
ElevatedButton(
  onPressed: () async {
    await ref.read(settingsNotifierProvider.notifier).updateLocale('en');
    // MaterialApp이 자동으로 locale 변경을 감지하고 UI 갱신
  },
  child: Text('English'),
),
```

---

## AI 다국어 지원

AI 대화 응답도 사용자 언어에 맞춰 제공됩니다.

### 구현 범위

1. **LLM 응답** (OpenRouter API)
   - 시스템 프롬프트 다국어화
   - 사용자 메시지 다국어화
   - 기분 설명 다국어화

2. **Fallback 응답** (오프라인/API 실패 시)
   - 8가지 컨텍스트별 응답 다국어화
   - 랜덤 응답 풀 다국어화

### 수정된 파일 목록

| 파일 | 역할 | 수정 내용 |
|-----|------|----------|
| `dialogue_request.dart` | AI 요청 데이터 클래스 | `locale` 필드 추가 |
| `llm_service.dart` | LLM API 호출 | 프롬프트 동적 생성 (한/영) |
| `fallback_responses.dart` | 오프라인 응답 | 8개 메서드 다국어화 |
| `conversation_service.dart` | 통합 서비스 | locale 파라미터 전달 |
| `ai_providers.dart` | Riverpod Providers | locale 전달 |
| `pet_dialogue_widget.dart` | UI 위젯 | Settings에서 locale 주입 |

### DialogueRequest에 locale 추가

```dart
class DialogueRequest {
  final String dogName;
  final String dogBreed;
  final int happinessLevel;
  final String context;
  final Map<String, dynamic>? contextData;
  final String locale; // 추가됨!

  const DialogueRequest({
    required this.dogName,
    required this.dogBreed,
    required this.happinessLevel,
    required this.context,
    this.contextData,
    required this.locale, // 필수 파라미터
  });
}
```

### LLMService 다국어 프롬프트

```dart
String _buildSystemPrompt({
  required String dogName,
  required String dogBreed,
  required int happinessLevel,
  required String locale,
}) {
  final mood = _getMood(happinessLevel, locale);

  if (locale == 'ko') {
    return '''
당신은 $dogName이라는 이름의 $dogBreed 강아지입니다.
현재 기분: $mood

규칙:
1. 항상 강아지 말투로 대답하세요 ("멍멍!", "왈왈!" 사용)
2. 짧고 친근한 한 문장으로 대답하세요
''';
  } else {
    return '''
You are a $dogBreed dog named $dogName.
Current mood: $mood

Rules:
1. Always respond in dog-like manner (use "Woof!", "Bark!")
2. Keep responses short and friendly
''';
  }
}
```

**7가지 컨텍스트 모두 다국어화:**
- `walk_complete`: 산책 완료
- `mission_complete`: 미션 완료
- `feed`: 간식 먹기
- `level_up`: 레벨업
- `low_happiness`: 행복도 낮음
- `greeting`: 랜덤 인사
- `greeting_static`: 시간대별 인사

### FallbackResponses 다국어화

```dart
String _getWalkCompleteResponse(Map<String, dynamic>? data, String locale) {
  final steps = data?['steps'] ?? 0;

  if (locale == 'ko') {
    final responses = <String>[
      if (steps > 10000) ...[
        '와! 오늘 정말 많이 걸었네요! 최고예요! 멍멍!',
        '10,000걸음 넘었어요! 대단해요! 왈왈!',
      ],
      // ...
    ];
    return responses[_random.nextInt(responses.length)];
  } else {
    final responses = <String>[
      if (steps > 10000) ...[
        'Wow! We walked so much today! Amazing! Woof!',
        'Over 10,000 steps! You\'re awesome! Bark!',
      ],
      // ...
    ];
    return responses[_random.nextInt(responses.length)];
  }
}
```

### PetDialogueWidget에서 locale 주입

```dart
class PetDialogueWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petTrackingProvider);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return petAsync.when(
      data: (pet) {
        // Settings에서 locale 추출
        final locale = settingsAsync.when(
          data: (settings) => settings.locale,
          loading: () => 'ko',
          error: (_, __) => 'ko',
        );

        // DialogueRequest 생성 시 locale 전달
        final request = DialogueRequest(
          dogName: pet.name,
          dogBreed: pet.breed,
          happinessLevel: pet.happiness,
          context: this.context,
          contextData: this.contextData,
          locale: locale, // ← 여기!
        );

        final dialogueAsync = ref.watch(dialogueProvider(request));
        return _buildDialogueBubble(context, theme, dialogueAsync);
      },
      // ...
    );
  }
}
```

---

## 전체 워크플로우

### 1. UI 다국어화 워크플로우

```
사용자가 설정에서 언어 변경 (한국어 → 영어)
    ↓
SettingsNotifier.updateLocale('en') 호출
    ↓
SettingsModel.locale = 'en' 저장 (Isar DB)
    ↓
settingsNotifierProvider 상태 변경
    ↓
MaterialApp의 locale이 Locale('en')으로 변경
    ↓
Flutter가 자동으로 전체 UI 리빌드
    ↓
AppLocalizations.of(context)가 영어 텍스트 반환
    ↓
✅ 모든 UI 텍스트가 영어로 변경됨
```

### 2. AI 다국어화 워크플로우

```
PetDialogueWidget 빌드
    ↓
settingsNotifierProvider에서 locale 추출 ('en')
    ↓
DialogueRequest(locale: 'en') 생성
    ↓
dialogueProvider 호출
    ↓
ConversationService.getResponse(locale: 'en')
    ↓
┌─ 인터넷 연결 있음 ─────────┐  ┌─ 인터넷 연결 없음 ──────────┐
│ LLMService.generateDialogue │  │ FallbackResponses.getResponse │
│ - 영어 시스템 프롬프트 생성  │  │ - locale == 'en' 체크        │
│ - 영어 사용자 메시지 생성    │  │ - 영어 응답 풀에서 랜덤 선택  │
│ - OpenRouter API 호출       │  │ - 영어 응답 반환             │
│ - AI가 영어로 응답          │  └───────────────────────────┘
└────────────────────────────┘
    ↓
✅ 강아지가 영어로 대화함!
```

### 3. 언어 전환 시 동작

| 항목 | 한국어 (locale: 'ko') | 영어 (locale: 'en') |
|-----|----------------------|---------------------|
| UI 텍스트 | app_ko.arb에서 로드 | app_en.arb에서 로드 |
| AI 시스템 프롬프트 | 한국어 프롬프트 | 영어 프롬프트 |
| AI 응답 | 한국어 대화 | 영어 대화 |
| Fallback 응답 | 한국어 응답 풀 | 영어 응답 풀 |

---

## 트러블슈팅

### 1. "AppLocalizations를 찾을 수 없습니다"

**증상:**
```dart
import 'l10n/app_localizations.dart'; // ❌ 파일 없음
```

**해결:**
```bash
flutter pub get
# 또는
flutter clean && flutter pub get
```

ARB 파일이 변경되면 항상 `flutter pub get`을 실행해야 Dart 코드가 재생성됩니다.

---

### 2. "The getter 'xxx' isn't defined"

**증상:**
```dart
AppLocalizations.of(context).newKey // ❌ 정의되지 않음
```

**원인:** ARB 파일에는 추가했지만 코드 생성이 안 됨

**해결:**
1. ARB 파일에 키가 올바르게 추가되었는지 확인
2. `flutter pub get` 실행
3. IDE 재시작 (VSCode/Android Studio)

---

### 3. "locale이 변경되지 않습니다"

**증상:** Settings에서 언어 변경했는데 UI가 안 바뀜

**체크리스트:**
1. ✅ SettingsModel에 locale 필드 추가했는지?
2. ✅ MaterialApp에 locale 바인딩했는지?
3. ✅ settingsNotifierProvider.notifier.updateLocale() 호출했는지?
4. ✅ 앱을 핫 리로드/재시작했는지?

---

### 4. "AI가 영어로 설정했는데 한국어로 답해요"

**증상:** UI는 영어인데 AI는 한국어로 응답

**원인:** DialogueRequest에 locale 전달 안 함

**해결:**
```dart
// ❌ 잘못된 코드
final request = DialogueRequest(
  dogName: pet.name,
  dogBreed: pet.breed,
  happinessLevel: pet.happiness,
  context: 'greeting',
  // locale이 없음!
);

// ✅ 올바른 코드
final settingsAsync = ref.watch(settingsNotifierProvider);
final locale = settingsAsync.when(
  data: (settings) => settings.locale,
  loading: () => 'ko',
  error: (_, __) => 'ko',
);

final request = DialogueRequest(
  dogName: pet.name,
  dogBreed: pet.breed,
  happinessLevel: pet.happiness,
  context: 'greeting',
  locale: locale, // ← 필수!
);
```

---

### 5. "플레이스홀더가 작동하지 않습니다"

**증상:**
```dart
AppLocalizations.of(context).dailyGoalSteps(5000) // ❌ 메서드가 없음
```

**원인:** ARB 파일의 플레이스홀더 정의가 잘못됨

**올바른 ARB 형식:**
```json
{
  "dailyGoalSteps": "{steps} steps",
  "@dailyGoalSteps": {
    "placeholders": {
      "steps": {
        "type": "int"
      }
    }
  }
}
```

---

## 파일 구조 요약

```
walk_dog/
├── l10n.yaml                          # 국제화 설정
├── pubspec.yaml                       # generate: true 설정
├── lib/
│   ├── l10n/
│   │   ├── app_en.arb                # 영어 번역
│   │   └── app_ko.arb                # 한국어 번역
│   ├── main.dart                     # MaterialApp 설정
│   ├── data/models/
│   │   └── settings_model.dart       # locale 필드
│   ├── services/
│   │   ├── settings/
│   │   │   └── settings_service.dart # locale 저장/로드
│   │   └── ai/
│   │       ├── dialogue_request.dart # locale 필드
│   │       ├── llm_service.dart      # 다국어 프롬프트
│   │       ├── fallback_responses.dart # 다국어 응답
│   │       ├── conversation_service.dart
│   │       └── ai_providers.dart
│   └── presentation/
│       ├── screens/
│       │   ├── settings/
│       │   │   └── settings_screen.dart # 언어 변경 UI
│       │   └── home/widgets/
│       │       └── pet_dialogue_widget.dart # locale 주입
│       └── ...
└── .dart_tool/flutter_gen/gen_l10n/
    └── app_localizations.dart        # 자동 생성 (Git 제외)
```

---

## 구현 통계

### UI 다국어화
- **ARB 파일**: 2개 (한국어, 영어)
- **번역 키**: 약 400개
- **지원 화면**: 전체 화면 (Home, Walk, Settings, Achievements, etc.)

### AI 다국어화
- **수정된 파일**: 6개
- **다국어 프롬프트**: 시스템 프롬프트 + 7가지 컨텍스트
- **다국어 폴백**: 8가지 컨텍스트 × 각 3~8개 응답
- **총 AI 응답 수**: 약 100개 (한국어/영어 각각)

---

## 참고 자료

- [Flutter 공식 국제화 가이드](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB 파일 형식 스펙](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [flutter_localizations 패키지](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)
- [Intl 패키지](https://pub.dev/packages/intl)

---

## 작성 정보

- **작성일**: 2025년 1월 (Week 3)
- **작성자**: Claude Code + 사용자 협업
- **Flutter 버전**: 3.x
- **프로젝트**: WalkDog - Virtual Pet Walking App
- **구현 범위**: UI 전체 + AI 대화 시스템

---

**문서 끝** 🎉

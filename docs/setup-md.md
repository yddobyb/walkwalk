# WalkDog 개발 환경 설정 가이드 (2025년 9월 업데이트)

## ⚠️ 현재 구현 상태

**현재 MVP 단계로 최소한의 패키지만 설치되어 있습니다:**
- ✅ **Flutter & Dart SDK**
- ✅ **로컬 DB (Isar)**
- ✅ **센서 (Pedometer, Geolocator)**
- ✅ **상태 관리 (Riverpod)**
- ⏸️ **Firebase** (Week 4에 설치 예정)
- ⏸️ **AI/ML** (Week 3에 설치 예정)

**본 문서는 전체 시스템 구성을 위한 목표 설정을 포함합니다.**

---

## 필수 도구 설치

### 1. Flutter 환경
```bash
# Flutter 3.35+ 설치
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# 환경 확인
flutter doctor

# 필요한 플랫폼 설정
flutter config --enable-ios
flutter config --enable-android
```

### 2. Firebase CLI
```bash
# Node.js 18+ 필요
npm install -g firebase-tools

# 로그인
firebase login

# 프로젝트 초기화
firebase init
# Functions, Hosting, Remote Config 선택
```

### 3. 개발 도구
- **IDE**: VS Code 또는 Android Studio
- **Extensions**:
  - Flutter
  - Dart
  - Firebase
  - Error Lens
  - GitLens

## 프로젝트 초기화

### 1. Flutter 프로젝트 생성
```bash
flutter create --org com.walkdog \
  --platforms ios,android \
  --project-name walk_dog \
  walk_dog

cd walk_dog
```

### 2. 의존성 설치

#### 현재 설치된 패키지 (MVP - Week 1-2)
```yaml
# pubspec.yaml (현재 상태)
name: walk_dog
description: "WalkDog"
version: 1.0.0+1

environment:
  sdk: ^3.8.1

dependencies:
  flutter:
    sdk: flutter

  # UI & Icons
  cupertino_icons: ^1.0.8

  # 상태 관리 (Riverpod) ✅
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # 로컬 DB (Isar) ✅
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.1

  # 센서 & 권한 (Week 1-2) ✅
  pedometer: ^4.1.1
  permission_handler: ^12.0.1
  geolocator: ^14.0.2

  # 유틸리티 ✅
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  uuid: ^4.4.0
  shared_preferences: ^2.2.2
  intl: ^0.19.0

  # 차트 ✅
  fl_chart: ^0.69.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # 린팅
  flutter_lints: ^5.0.0

  # 코드 생성
  build_runner: ^2.4.10
  freezed: ^2.5.1
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0
  isar_generator: ^3.1.0+1
```

#### 향후 추가 예정 패키지 (Week 3-4)

**Firebase 패키지** (Week 4):
```yaml
# ⏸️ 미설치 - Week 4에 추가 예정
firebase_core: ^3.1.1
firebase_auth: ^5.1.1
firebase_functions: ^5.0.1
firebase_remote_config: ^5.0.1
firebase_app_check: ^0.3.0
```

**AI/ML 패키지** (Week 3):
```yaml
# ⏸️ 미설치 - Week 3에 추가 예정
flutter_tflite: ^1.0.1  # MLC-LLM wrapper 필요
```

**네트워킹 패키지** (Week 4):
```yaml
# ⏸️ 미설치 - Week 4에 추가 예정
dio: ^5.5.0+1
dio_cache_interceptor: ^3.5.0
connectivity_plus: ^6.0.3
```

**UI/UX 패키지** (향후):
```yaml
# ⏸️ 미설치 - 향후 추가 예정
flutter_animate: ^4.5.0
lottie: ^3.1.2
cached_network_image: ^3.3.1
flutter_svg: ^2.0.10+1
shimmer: ^3.0.0
```

**알림 패키지** (향후):
```yaml
# ⏸️ 미설치 - 향후 추가 예정
flutter_local_notifications: ^17.2.2
```

**기타 패키지** (향후):
```yaml
# ⏸️ 미설치 - 향후 추가 예정
url_launcher: ^6.3.0
share_plus: ^10.0.0
package_info_plus: ^8.0.0
```

**테스팅 도구** (향후):
```yaml
# ⏸️ 미설치 - 향후 추가 예정
mockito: ^5.4.4
mock_web_server: ^5.0.0
golden_toolkit: ^0.15.0
custom_lint: ^0.6.4
riverpod_lint: ^2.3.10
```

### 3. 의존성 설치 실행
```bash
flutter pub get
```

## Firebase 설정 (⏸️ Week 4에 구현 예정)

### 1. Firebase 프로젝트 생성
```bash
# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# Firebase 프로젝트 구성
flutterfire configure

# 선택: iOS, Android
# 프로젝트 이름: walk-dog-app
```

### 2. Firebase Functions 설정
```bash
cd firebase/functions
npm init -y
npm install firebase-functions firebase-admin axios sharp

# TypeScript 설정 (선택사항)
npm install -D typescript @types/node
npx tsc --init
```

### 3. Firebase Functions 환경 변수
```bash
# .env 파일 생성 (functions 디렉토리)
IMG_ENDPOINT=https://generativelanguage.googleapis.com/v1beta/
IMG_API_KEY=your_gemini_api_key
MAX_SIZE=512
DAILY_QUOTA=10

# Firebase에 설정
firebase functions:config:set \
  gemini.api_key="your_api_key" \
  gemini.endpoint="https://..." \
  limits.daily_quota="10" \
  limits.max_size="512"
```

## 플랫폼별 설정

### Android 설정
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.INTERNET"/>

<!-- android/app/build.gradle -->
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
    }
}
```

### iOS 설정
```xml
<!-- ios/Runner/Info.plist -->
<key>NSMotionUsageDescription</key>
<string>걸음수를 측정하여 강아지의 행복도를 높입니다</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>실외 산책 모드에서 정확한 거리 측정을 위해 필요합니다</string>
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>location</string>
</array>
```

## LLM 모델 설정 (⏸️ Week 3에 구현 예정)

### 1. MLC-LLM 설정
```bash
# MLC-LLM 라이브러리 다운로드
# assets/models/ 디렉토리에 배치

mkdir -p assets/models
cd assets/models

# Qwen2.5-3B 모델 다운로드 (약 1GB)
# 실제 다운로드 링크는 MLC-LLM 문서 참조
wget https://huggingface.co/mlc-ai/Qwen2.5-3B-Instruct-q4f16_1-MLC/...
```

### 2. Flutter 에셋 등록
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/models/
    - assets/images/
    - assets/lottie/
    - assets/fonts/
```

## 개발 스크립트

### 1. Makefile 생성
```makefile
# Makefile
.PHONY: get clean build watch test

get:
	flutter pub get

clean:
	flutter clean
	flutter pub get

build:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

test:
	flutter test

test-integration:
	flutter test integration_test

analyze:
	flutter analyze
	dart run custom_lint

format:
	dart format lib test --line-length=100

run-dev:
	flutter run --dart-define=ENV=dev

run-prod:
	flutter run --dart-define=ENV=prod --release

build-apk:
	flutter build apk --release

build-ios:
	flutter build ios --release

deploy-functions:
	cd firebase && firebase deploy --only functions
```

## 환경 구성

### 1. 환경별 설정 파일
```dart
// lib/core/config/env_config.dart
class EnvConfig {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  static bool get isDev => env == 'dev';
  static bool get isStaging => env == 'staging';
  static bool get isProd => env == 'prod';
  
  static String get apiBaseUrl {
    switch (env) {
      case 'dev':
        return 'http://localhost:5001/walk-dog-dev/us-central1';
      case 'staging':
        return 'https://walk-dog-staging.cloudfunctions.net';
      case 'prod':
        return 'https://walk-dog-app.cloudfunctions.net';
      default:
        return 'http://localhost:5001/walk-dog-dev/us-central1';
    }
  }
}
```

### 2. VS Code 실행 구성
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=ENV=dev"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=ENV=staging"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=ENV=prod", "--release"]
    }
  ]
}
```

## 프로젝트 구조 생성

```bash
# 디렉토리 구조 생성 스크립트
#!/bin/bash

# Core 디렉토리
mkdir -p lib/core/{constants,theme,utils,errors,config}

# Data 레이어
mkdir -p lib/data/{models,repositories,datasources/{local,remote}}

# Domain 레이어
mkdir -p lib/domain/{entities,repositories,usecases/{pet,walk,ai}}

# Presentation 레이어
mkdir -p lib/presentation/{screens/{home,customize,walk,achievements,settings}/widgets,providers,widgets/common}

# Services
mkdir -p lib/services/{ai,sensors,storage,notifications}

# Firebase Functions
mkdir -p firebase/functions/src

# 테스트
mkdir -p test/{unit,widget,integration}

# 문서
mkdir -p docs/{api,guides,decisions}

# 에셋
mkdir -p assets/{images,lottie,models,fonts}

echo "프로젝트 구조 생성 완료!"
```

## 초기 파일 생성

```bash
# 기본 파일 생성
touch lib/main.dart
touch lib/app.dart
touch lib/core/constants/app_constants.dart
touch lib/core/theme/app_theme.dart
touch lib/data/models/pet_model.dart
touch lib/domain/entities/pet.dart
touch lib/presentation/screens/home/home_screen.dart
touch firebase/functions/src/index.ts

echo "초기 파일 생성 완료!"
```

## 다음 단계

1. **Git 초기화**
   ```bash
   git init
   git add .
   git commit -m "Initial project setup"
   ```

2. **첫 실행**
   ```bash
   flutter run
   ```

3. **코드 생성 실행**
   ```bash
   dart run build_runner build
   ```

4. **Firebase 배포 테스트**
   ```bash
   cd firebase
   firebase emulators:start
   ```

## 트러블슈팅

### 문제: iOS 빌드 실패
```bash
cd ios
pod install
pod update
```

### 문제: Android Gradle 동기화 실패
```bash
cd android
./gradlew clean
./gradlew build
```

### 문제: MLC-LLM 로딩 실패
- 모델 파일 경로 확인
- 메모리 부족 확인 (최소 2GB RAM 필요)
- 모델 포맷 확인 (q4f16_1)

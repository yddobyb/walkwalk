# WalkDog 배포 가이드 (2025년 9월 업데이트)

## 1. 사전 준비

### 1.1 필수 계정 및 도구
- [ ] Apple Developer Account (iOS)
- [ ] Google Play Console Account (Android)
- [ ] Firebase 프로젝트 (Production)
- [ ] Google Cloud Platform 계정
- [ ] Gemini API 키
- [ ] 도메인 (선택사항)

### 1.2 환경 구분
```yaml
environments:
  dev:
    firebase_project: walk-dog-dev
    bundle_id: com.walkdog.app.dev
    android_package: com.walkdog.app.dev
    
  staging:
    firebase_project: walk-dog-staging
    bundle_id: com.walkdog.app.staging
    android_package: com.walkdog.app.staging
    
  prod:
    firebase_project: walk-dog-app
    bundle_id: com.walkdog.app
    android_package: com.walkdog.app
```

## 2. Firebase 설정

### 2.1 프로덕션 Firebase 프로젝트 생성
```bash
# Firebase CLI로 프로젝트 생성
firebase projects:create walk-dog-app --display-name "WalkDog Production"

# 프로젝트 선택
firebase use walk-dog-app

# 필요한 서비스 활성화
firebase init functions
firebase init hosting
firebase init firestore
firebase init storage
```

### 2.2 Firebase Functions 환경 변수 설정
```bash
# Gemini API 설정
firebase functions:config:set \
  gemini.api_key="YOUR_PRODUCTION_API_KEY" \
  gemini.endpoint="https://generativelanguage.googleapis.com/v1beta/" \
  limits.daily_quota="20" \
  limits.max_size="512"

# App Check 설정
firebase functions:config:set \
  appcheck.debug_token="YOUR_DEBUG_TOKEN" \
  appcheck.enforce="true"

# 기타 설정
firebase functions:config:set \
  env.name="production" \
  features.outdoor_mode="true" \
  features.cloud_image="true" \
  features.missions="true"

# 설정 확인
firebase functions:config:get
```

### 2.3 Firebase Functions 배포
```bash
# 의존성 설치
cd firebase/functions
npm install

# TypeScript 컴파일 (사용 시)
npm run build

# 함수 배포
firebase deploy --only functions

# 특정 함수만 배포
firebase deploy --only functions:genSticker,functions:syncProgress
```

### 2.4 Remote Config 설정
```json
{
  "gameplay": {
    "stepPerTreat": 300,
    "happinessPerTreat": 8,
    "happinessPer100Steps": 2,
    "dailyHappinessDecay": 10,
    "outdoorBonus": 1.2,
    "maxDailyTreats": 50
  },
  "ai": {
    "maxTokens": 60,
    "temperature": 0.7,
    "enableLocalLLM": true,
    "enableCloudImage": true,
    "imageQuotaDaily": 20
  },
  "features": {
    "outdoorModeEnabled": true,
    "missionsEnabled": true,
    "socialFeaturesEnabled": false,
    "arModeEnabled": false
  }
}
```

## 3. 앱 빌드 및 서명

### 3.1 Android 빌드

#### 키스토어 생성
```bash
# 키스토어 생성 (최초 1회)
keytool -genkey -v -keystore ~/walkdog-release.keystore \
  -alias walkdog -keyalg RSA -keysize 2048 -validity 10000

# key.properties 파일 생성
cat > android/key.properties << EOF
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=walkdog
storeFile=/Users/USERNAME/walkdog-release.keystore
EOF

# .gitignore에 추가
echo "android/key.properties" >> .gitignore
echo "*.keystore" >> .gitignore
```

#### build.gradle 설정
```gradle
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### APK/AAB 빌드
```bash
# APK 빌드
flutter build apk --release --dart-define=ENV=prod

# App Bundle 빌드 (Play Store 권장)
flutter build appbundle --release --dart-define=ENV=prod

# 분할 APK 빌드 (아키텍처별)
flutter build apk --split-per-abi --release --dart-define=ENV=prod
```

### 3.2 iOS 빌드

#### 인증서 및 프로비저닝 프로파일
```bash
# Xcode에서 자동 서명 설정
open ios/Runner.xcworkspace

# 또는 Fastlane 사용
cd ios
fastlane match appstore  # App Store 프로파일
fastlane match development  # 개발 프로파일
```

#### Info.plist 설정
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>WalkDog</string>
<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

#### IPA 빌드
```bash
# iOS 앱 빌드
flutter build ios --release --dart-define=ENV=prod

# IPA 생성 (Xcode 필요)
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner -configuration Release \
  -archivePath build/Runner.xcarchive archive

xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist exportOptions.plist
```

## 4. 스토어 배포

### 4.1 Google Play Store

#### 앱 정보 준비
```yaml
app_info:
  title: "WalkDog - 산책형 가상 반려견"
  short_description: "걸을수록 행복해지는 AI 강아지와 함께 건강한 산책 습관을!"
  full_description: |
    WalkDog은 당신의 산책 파트너가 되어줄 가상 반려견 앱입니다.
    
    주요 기능:
    • AI 기반 대화형 강아지
    • 걸음수 기반 보상 시스템
    • 맞춤형 강아지 커스터마이징
    • 실외 산책 모드
    • 다양한 미션과 배지
  
  category: "건강 및 피트니스"
  content_rating: "모든 연령"
  
screenshots:
  phone:
    - home_screen.png      # 2220x1080
    - walk_tracking.png    
    - customize.png
    - achievements.png
  tablet:
    - tablet_home.png      # 2560x1600
    - tablet_walk.png
    
feature_graphic: feature.png  # 1024x500
icon: icon_512.png            # 512x512
```

#### Play Console 업로드
```bash
# 1. Google Play Console 접속
# 2. 새 앱 만들기
# 3. 앱 정보 입력
# 4. 스토어 등록정보 작성
# 5. 콘텐츠 등급 설문 완료
# 6. 가격 및 배포 설정

# AAB 업로드 (내부 테스트)
# Production > Releases > Create release
# Upload app bundle

# 단계별 출시
# 1. 내부 테스트 (팀원)
# 2. 비공개 베타 (100명)
# 3. 공개 베타 (1000명)
# 4. 프로덕션 (단계적 출시 10% → 50% → 100%)
```

### 4.2 Apple App Store

#### App Store Connect 설정
```yaml
app_info:
  name: "WalkDog"
  subtitle: "AI 강아지와 함께하는 건강한 산책"
  privacy_policy_url: "https://walkdog.app/privacy"
  marketing_url: "https://walkdog.app"
  
  keywords:
    - 산책
    - 반려견
    - 가상펫
    - 운동
    - 건강
    - AI
    - 걷기
    
  description: |
    최대 4000자 설명...
    
  whats_new: |
    버전 1.0.0
    - 첫 출시
    
screenshots:
  iphone_6_5:  # iPhone 14 Pro Max
    - screen1_1290x2796.png
    - screen2_1290x2796.png
  iphone_5_5:  # iPhone 8 Plus
    - screen1_1242x2208.png
  ipad_12_9:   # iPad Pro
    - screen1_2048x2732.png
```

#### TestFlight 배포
```bash
# 1. Xcode에서 Archive
# Product > Archive

# 2. Organizer에서 업로드
# Window > Organizer > Upload to App Store Connect

# 3. TestFlight 설정
# - 내부 테스터 추가
# - 외부 테스터 그룹 생성
# - 베타 앱 심사 제출

# 4. 피드백 수집
```

## 5. CI/CD 파이프라인

### 5.1 GitHub Actions 배포 워크플로우
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-java@v3
        with:
          java-version: '11'
          
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - name: Decode keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/keystore.jks
          echo "storeFile=keystore.jks" >> android/key.properties
          echo "storePassword=${{ secrets.STORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          
      - name: Build AAB
        run: |
          flutter pub get
          flutter build appbundle --release --dart-define=ENV=prod
          
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_SERVICE_ACCOUNT }}
          packageName: com.walkdog.app
          releaseFiles: build/app/outputs/bundle/release/*.aab
          track: internal
          
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - name: Install certificates
        uses: apple-actions/import-codesign-certs@v1
        with:
          p12-file-base64: ${{ secrets.CERTIFICATES_P12 }}
          p12-password: ${{ secrets.CERTIFICATES_PASSWORD }}
          
      - name: Install provisioning profile
        uses: akiojin/install-provisioning-profile-github-action@v1
        with:
          base64: ${{ secrets.PROVISIONING_PROFILE }}
          
      - name: Build IPA
        run: |
          flutter pub get
          flutter build ios --release --dart-define=ENV=prod --no-codesign
          cd ios
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner -configuration Release \
            -archivePath build/Runner.xcarchive \
            archive CODE_SIGN_IDENTITY="${{ secrets.CODE_SIGN_IDENTITY }}"
          xcodebuild -exportArchive \
            -archivePath build/Runner.xcarchive \
            -exportPath build/ipa \
            -exportOptionsPlist exportOptions.plist
            
      - name: Upload to TestFlight
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: ios/build/ipa/Runner.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_PRIVATE_KEY }}
          
  deploy-functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Deploy to Firebase
        run: |
          npm install -g firebase-tools
          cd firebase/functions
          npm ci
          firebase deploy --only functions --token "${{ secrets.FIREBASE_TOKEN }}"
```

### 5.2 Fastlane 설정
```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Push a new release to TestFlight"
  lane :beta do
    build_app(
      scheme: "Runner",
      export_method: "app-store",
      configuration: "Release"
    )
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end
  
  desc "Push a new release to App Store"
  lane :release do
    build_app(
      scheme: "Runner",
      export_method: "app-store",
      configuration: "Release"
    )
    upload_to_app_store(
      skip_metadata: false,
      skip_screenshots: false,
      submit_for_review: true,
      automatic_release: true,
      submission_information: {
        add_id_info_uses_idfa: false
      }
    )
  end
end
```

## 6. 모니터링 설정

### 6.1 Firebase Crashlytics
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  // Crashlytics 초기화
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(MyApp());
}
```

### 6.2 Firebase Analytics
```dart
// lib/services/analytics_service.dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // 주요 이벤트 트래킹
  void logWalkStarted() {
    _analytics.logEvent(name: 'walk_started');
  }
  
  void logWalkCompleted({
    required int steps,
    required int duration,
    required int treatsEarned,
  }) {
    _analytics.logEvent(
      name: 'walk_completed',
      parameters: {
        'steps': steps,
        'duration_seconds': duration,
        'treats_earned': treatsEarned,
      },
    );
  }
  
  void logStickerGenerated({
    required String breed,
    required String accessory,
    required bool cached,
  }) {
    _analytics.logEvent(
      name: 'sticker_generated',
      parameters: {
        'breed': breed,
        'accessory': accessory,
        'cached': cached,
      },
    );
  }
}
```

### 6.3 Performance Monitoring
```dart
// Firebase Performance 설정
void trackNetworkRequest() async {
  final HttpMetric metric = FirebasePerformance.instance
      .newHttpMetric('https://api.example.com/genSticker', HttpMethod.Post);
  
  await metric.start();
  
  try {
    // API 호출
    final response = await http.post(uri);
    metric.httpResponseCode = response.statusCode;
    metric.responseContentType = response.headers['content-type'];
    metric.responsePayloadSize = response.contentLength;
  } finally {
    await metric.stop();
  }
}
```

## 7. 출시 체크리스트

### 7.1 기능 체크리스트
- [ ] 모든 핵심 기능 작동 확인
- [ ] 센서 권한 처리 정상 작동
- [ ] AI 대화 생성 정상 작동
- [ ] 이미지 생성 및 캐싱 정상 작동
- [ ] 오프라인 모드 정상 작동
- [ ] 다크 모드 지원
- [ ] 다국어 지원 (선택)

### 7.2 성능 체크리스트
- [ ] 앱 시작 시간 < 3초
- [ ] LLM 응답 시간 < 500ms
- [ ] 이미지 생성 시간 < 3초
- [ ] 메모리 사용량 < 200MB
- [ ] 배터리 소모 최적화

### 7.3 보안 체크리스트
- [ ] API 키 서버 측 보호
- [ ] App Check 활성화
- [ ] 민감 정보 로컬 저장 금지
- [ ] ProGuard/R8 난독화 (Android)
- [ ] 인증서 피닝 (선택)

### 7.4 스토어 체크리스트
- [ ] 앱 아이콘 (모든 크기)
- [ ] 스크린샷 (모든 기기)
- [ ] 앱 설명 (현지화)
- [ ] 개인정보 처리방침
- [ ] 이용약관
- [ ] 콘텐츠 등급
- [ ] 연락처 정보

## 8. 롤백 계획

### 8.1 긴급 롤백 시나리오
```bash
# Remote Config로 기능 비활성화
firebase remoteconfig:set features.cloudImageEnabled false --project walk-dog-app

# Firebase Functions 이전 버전으로 롤백
firebase functions:delete genSticker --project walk-dog-app
firebase deploy --only functions:genSticker --project walk-dog-app

# 앱 스토어 롤백
# Google Play: 이전 버전 활성화
# App Store: 긴급 업데이트 제출
```

### 8.2 데이터 백업
```bash
# Firestore 백업 (일일)
gcloud firestore export gs://walk-dog-backups/$(date +%Y%m%d)

# 복원
gcloud firestore import gs://walk-dog-backups/20240315
```

## 9. 배포 후 모니터링

### 9.1 주요 지표
- Crash-free users rate > 99%
- ANR rate < 0.5%
- 일일 활성 사용자 (DAU)
- 평균 세션 시간
- API 응답 시간 p95
- 이미지 생성 성공률

### 9.2 알림 설정
```javascript
// Firebase Functions 알림
exports.monitorErrors = functions.pubsub.schedule('every 5 minutes').onRun(async (context) => {
  const errorRate = await getErrorRate();
  if (errorRate > 0.05) { // 5% 이상
    await sendSlackAlert(`High error rate: ${errorRate * 100}%`);
  }
});
```

## 10. 버전 관리

### 10.1 버전 규칙
```
Major.Minor.Patch+BuildNumber
1.0.0+1   - 초기 출시
1.0.1+2   - 버그 수정
1.1.0+10  - 새 기능
2.0.0+100 - 메이저 업데이트
```

### 10.2 변경 로그
```markdown
# CHANGELOG.md

## [1.0.0] - 2024-04-01
### Added
- 초기 출시
- 기본 산책 기능
- AI 대화 시스템
- 스티커 생성
- 배지 시스템

### Fixed
- N/A

### Changed
- N/A
```

# WalkDog 문제 해결 가이드 (2025년 9월 업데이트)

## 1. 개발 환경 문제

### 1.1 Flutter 관련

#### 문제: Flutter doctor 오류
```bash
# 증상
[✗] Android toolchain - develop for Android devices
    ✗ Android SDK not found
```

**해결방법:**
```bash
# Android SDK 경로 설정
flutter config --android-sdk /path/to/android/sdk

# 라이선스 동의
flutter doctor --android-licenses

# 도구 재설치
sdkmanager --update
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

#### 문제: Dart SDK 버전 충돌
```
Error: The current Dart SDK version is 2.19.0.
Because walk_dog requires SDK version >=3.5.0 <4.0.0, version solving failed.
```

**해결방법:**
```bash
# Flutter 업그레이드
flutter upgrade

# 특정 버전 설치
flutter downgrade 3.24.0

# 채널 변경
flutter channel stable
flutter upgrade
```

### 1.2 의존성 관련

#### 문제: Pub get 실패
```
Running "flutter pub get" in walk_dog...
Because walk_dog depends on isar ^3.1.0 which doesn't exist, version solving failed.
```

**해결방법:**
```bash
# 캐시 청소
flutter clean
flutter pub cache repair

# 오프라인 모드 해제
flutter pub get --no-offline

# 특정 패키지 재설치
flutter pub remove isar
flutter pub add isar:^3.1.0+1
```

#### 문제: Build runner 충돌
```
[SEVERE] Conflicting outputs
```

**해결방법:**
```bash
# 기존 생성 파일 삭제
dart run build_runner clean

# 강제 재생성
dart run build_runner build --delete-conflicting-outputs

# Watch 모드 재시작
pkill -f "dart.*build_runner"
dart run build_runner watch --delete-conflicting-outputs
```

## 2. 빌드 문제

### 2.1 Android 빌드

#### 문제: Gradle 빌드 실패
```
FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':app:processReleaseResources'.
```

**해결방법:**
```bash
# Gradle 캐시 삭제
cd android
./gradlew clean
./gradlew --stop

# 의존성 재동기화
./gradlew dependencies --refresh-dependencies

# 메모리 증가
echo "org.gradle.jvmargs=-Xmx4096m" >> gradle.properties
```

#### 문제: Multidex 오류
```
Cannot fit requested classes in a single dex file
```

**해결방법:**
```gradle
// android/app/build.gradle
android {
    defaultConfig {
        multiDexEnabled true
    }
}

dependencies {
    implementation 'com.android.support:multidex:2.0.1'
}
```

#### 문제: 서명 키 오류
```
Keystore was tampered with, or password was incorrect
```

**해결방법:**
```bash
# 키스토어 확인
keytool -list -v -keystore ~/walkdog-release.keystore

# 키 별칭 확인
keytool -list -keystore ~/walkdog-release.keystore | grep Alias

# key.properties 재생성
cat > android/key.properties << EOF
storePassword=정확한_비밀번호
keyPassword=정확한_비밀번호
keyAlias=정확한_별칭
storeFile=/절대/경로/keystore.jks
EOF
```

### 2.2 iOS 빌드

#### 문제: CocoaPods 오류
```
[!] Unable to find a specification for 'Firebase/Core'
```

**해결방법:**
```bash
cd ios
# Pod 캐시 삭제
pod cache clean --all
rm -rf Pods
rm Podfile.lock

# 재설치
pod repo update
pod install --repo-update

# M1 Mac의 경우
arch -x86_64 pod install
```

#### 문제: 프로비저닝 프로파일 오류
```
No profiles for 'com.walkdog.app' were found
```

**해결방법:**
```bash
# Xcode에서 자동 서명 재설정
open ios/Runner.xcworkspace
# Signing & Capabilities > Automatically manage signing 체크 해제 후 재체크

# 수동 프로파일 설치
open ~/Library/MobileDevice/Provisioning\ Profiles/
# 오래된 프로파일 삭제 후 새로 다운로드

# Fastlane match 사용
fastlane match nuke distribution
fastlane match appstore
```

#### 문제: 아카이브 실패
```
error: No profiles for 'com.walkdog.app' were found
```

**해결방법:**
```bash
# 빌드 설정 확인
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner

# 클린 빌드
flutter clean
cd ios
xcodebuild clean -workspace Runner.xcworkspace -scheme Runner
flutter build ios --release
```

## 3. 런타임 문제

### 3.1 센서 관련

#### 문제: 걸음수가 측정되지 않음
**진단:**
```dart
// 권한 확인
final status = await Permission.activityRecognition.status;
print('Activity permission: $status');

// 센서 가용성 확인
final isAvailable = await Pedometer.isStepCountAvailable();
print('Step counter available: $isAvailable');
```

**해결방법:**
```dart
// 권한 재요청
if (status.isDenied) {
  final result = await Permission.activityRecognition.request();
  if (result.isPermanentlyDenied) {
    openAppSettings();
  }
}

// 폴백 구현
if (!isAvailable) {
  // 가속도계 기반 대체 구현
  accelerometerEvents.listen((event) {
    // 간단한 걸음 감지 알고리즘
  });
}
```

#### 문제: GPS 위치가 업데이트되지 않음
**해결방법:**
```dart
// 위치 서비스 활성화 확인
final serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) {
  // 사용자에게 활성화 요청
  await Geolocator.openLocationSettings();
}

// 정확도 설정 조정
final position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
  forceAndroidLocationManager: true, // Android에서 Google Play Services 우회
);
```

### 3.2 AI 관련

#### 문제: LLM 모델 로딩 실패
```
Failed to load model: Out of memory
```

**해결방법:**
```dart
// 메모리 체크
Future<bool> hasEnoughMemory() async {
  final info = await DeviceInfoPlugin().androidInfo;
  final totalMemory = info.totalMem;
  final availableMemory = await getAvailableMemory();
  
  // 최소 2GB 여유 메모리 필요
  return availableMemory > 2 * 1024 * 1024 * 1024;
}

// 모델 크기 축소
// q4 대신 q3 사용
const MODEL_NAME = "qwen2.5-1.5b-instruct-q3f16_1"; // 더 작은 모델

// 메모리 정리
await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
await Future.delayed(Duration(seconds: 1));
// 앱 재시작
```

#### 문제: 이미지 생성 실패
```
FirebaseFunctionsException: RESOURCE_EXHAUSTED
```

**해결방법:**
```dart
// 할당량 확인
final quota = await api.getQuota();
if (quota.remaining == 0) {
  // 로컬 벡터 이미지로 폴백
  return VectorPetAvatar(
    breed: breed,
    color: color,
    accessory: accessory,
  );
}

// 재시도 로직
try {
  return await RetryPolicy.execute(
    () => api.generateSticker(request),
    retryIf: (e) => e is FirebaseFunctionsException && 
                     e.code != 'RESOURCE_EXHAUSTED',
  );
} catch (e) {
  // 캐시된 이미지 사용
  return getCachedImage() ?? getDefaultImage();
}
```

### 3.3 데이터베이스 관련

#### 문제: Isar 초기화 실패
```
IsarError: Cannot open database
```

**해결방법:**
```dart
// 데이터베이스 복구
Future<void> repairDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final dbPath = '${dir.path}/default.isar';
  
  // 손상된 DB 백업
  if (await File(dbPath).exists()) {
    await File(dbPath).copy('${dbPath}.backup');
    await File(dbPath).delete();
  }
  
  // 재초기화
  final isar = await Isar.open(
    schemas,
    directory: dir.path,
    inspector: kDebugMode,
  );
}

// 스키마 마이그레이션
@collection
class PetModelV2 extends PetModel {
  // 새 필드 추가 시 기본값 제공
  late String newField = '';
}
```

## 4. 성능 문제

### 4.1 메모리 누수

#### 문제: 메모리 사용량 지속 증가
**진단:**
```dart
// 메모리 모니터링
Timer.periodic(Duration(minutes: 1), (_) {
  final usage = ProcessInfo.currentRss / 1024 / 1024;
  print('Memory usage: ${usage.toStringAsFixed(2)} MB');
  
  if (usage > 300) {
    // 경고 로그
    FirebaseCrashlytics.instance.log('High memory usage: $usage MB');
  }
});
```

**해결방법:**
```dart
// 1. Stream 구독 해제
class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen(handler);
  }
  
  @override
  void dispose() {
    _subscription?.cancel(); // 중요!
    super.dispose();
  }
}

// 2. 이미지 캐시 제한
class ImageCacheManager {
  static void configure() {
    PaintingBinding.instance.imageCache.maximumSize = 50;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
  }
  
  static void clear() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}

// 3. Provider dispose
ref.onDispose(() {
  // 정리 작업
  controller.dispose();
  timer?.cancel();
});
```

### 4.2 UI 렌더링 문제

#### 문제: 버벅거림 (Jank)
**진단:**
```dart
// 성능 오버레이 활성화
MaterialApp(
  showPerformanceOverlay: kDebugMode,
  // ...
);
```

**해결방법:**
```dart
// 1. 무거운 작업 분리
Future<void> heavyComputation() async {
  await compute(_isolateFunction, data);
}

// 2. 리스트 최적화
ListView.builder(
  itemCount: items.length,
  cacheExtent: 200, // 캐시 영역 증가
  addAutomaticKeepAlives: false, // 불필요한 유지 방지
  addRepaintBoundaries: false, // 리페인트 경계 최적화
  itemBuilder: (context, index) {
    return const OptimizedListItem(); // const 위젯 사용
  },
);

// 3. 애니메이션 최적화
AnimatedBuilder(
  animation: animation,
  builder: (context, child) {
    return Transform.translate(
      offset: Offset(animation.value, 0),
      child: child, // child 재사용
    );
  },
  child: const ExpensiveWidget(), // 한 번만 빌드
);
```

## 5. 네트워크 문제

### 5.1 Firebase Functions

#### 문제: 함수 타임아웃
```
DEADLINE_EXCEEDED: Deadline exceeded
```

**해결방법:**
```typescript
// functions/index.ts
export const genSticker = functions
  .runWith({
    timeoutSeconds: 60, // 증가
    memory: '1GB', // 메모리 증가
  })
  .https.onCall(async (data, context) => {
    // 타임아웃 체크
    const timeout = setTimeout(() => {
      throw new functions.https.HttpsError(
        'deadline-exceeded',
        'Processing timeout'
      );
    }, 55000); // 5초 여유
    
    try {
      // 처리
      const result = await processImage(data);
      clearTimeout(timeout);
      return result;
    } catch (error) {
      clearTimeout(timeout);
      throw error;
    }
  });
```

#### 문제: Cold Start 지연
**해결방법:**
```typescript
// 최소 인스턴스 유지
export const genSticker = functions
  .runWith({
    minInstances: 1, // Warm 상태 유지
    maxInstances: 10,
  })
  .https.onCall(handler);

// 정기적 핑
export const keepWarm = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    // 가벼운 작업 수행
    console.log('Keep warm ping');
  });
```

### 5.2 오프라인 처리

#### 문제: 네트워크 없을 때 앱 멈춤
**해결방법:**
```dart
// 네트워크 상태 모니터링
class NetworkService {
  Stream<bool> get connectivityStream {
    return Connectivity().onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }
  
  Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return false;
    
    // 실제 연결 테스트
    try {
      final response = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// 오프라인 우선 설계
class OfflineFirstRepository {
  Future<Pet> getPet() async {
    // 1. 로컬 먼저
    final local = await localDataSource.getPet();
    if (local != null) return local;
    
    // 2. 네트워크 확인
    if (await networkService.hasConnection()) {
      try {
        final remote = await remoteDataSource.getPet();
        await localDataSource.savePet(remote);
        return remote;
      } catch (e) {
        // 네트워크 실패
      }
    }
    
    // 3. 기본값
    return Pet.defaultPet();
  }
}
```

## 6. 프로덕션 문제

### 6.1 크래시 대응

#### 실시간 크래시 모니터링
```dart
// 크래시 자동 보고
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  // 치명적 오류 캐치
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    
    // 사용자에게 알림
    if (kReleaseMode) {
      showErrorDialog('앱에 문제가 발생했습니다. 재시작해주세요.');
    }
  };
  
  // 비동기 오류 캐치
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
      reason: 'Uncaught async error',
    );
    return true;
  };
  
  // Zone에서 실행
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}
```

### 6.2 긴급 패치

#### 핫픽스 배포 프로세스
```bash
# 1. 핫픽스 브랜치 생성
git checkout -b hotfix/1.0.1 tags/v1.0.0

# 2. 수정 적용
# ... 코드 수정 ...

# 3. 버전 업데이트
# pubspec.yaml: version: 1.0.1+2

# 4. 긴급 빌드
flutter build appbundle --release --dart-define=ENV=prod
flutter build ios --release --dart-define=ENV=prod

# 5. 빠른 심사 요청
# Google Play: 긴급 업데이트 요청
# App Store: Expedited Review 요청

# 6. Remote Config로 임시 조치
firebase remoteconfig:set maintenance.enabled true \
  --project walk-dog-app
```

## 7. 디버깅 도구

### 7.1 로깅 시스템
```dart
// lib/core/utils/logger.dart
class Logger {
  static void d(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('🔵 DEBUG: $message');
      if (error != null) debugPrint('Error: $error');
    }
  }
  
  static void i(String message) {
    debugPrint('🟢 INFO: $message');
    FirebaseCrashlytics.instance.log(message);
  }
  
  static void w(String message, [dynamic error]) {
    debugPrint('🟡 WARNING: $message');
    if (error != null) debugPrint('Error: $error');
    FirebaseCrashlytics.instance.log('WARNING: $message');
  }
  
  static void e(String message, dynamic error, [StackTrace? stack]) {
    debugPrint('🔴 ERROR: $message');
    debugPrint('Error: $error');
    if (stack != null) debugPrint('Stack: $stack');
    
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: message,
    );
  }
}
```

### 7.2 디버그 패널
```dart
// 개발자 옵션 화면
class DebugPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug Panel')),
      body: ListView(
        children: [
          // 환경 정보
          ListTile(
            title: Text('Environment'),
            subtitle: Text(EnvConfig.env),
          ),
          
          // API 엔드포인트
          ListTile(
            title: Text('API Endpoint'),
            subtitle: Text(EnvConfig.apiBaseUrl),
          ),
          
          // 캐시 클리어
          ListTile(
            title: Text('Clear Cache'),
            onTap: () async {
              await ImageCacheService().clear();
              await Isar.getInstance()?.close();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared')),
              );
            },
          ),
          
          // 크래시 테스트
          if (kDebugMode)
            ListTile(
              title: Text('Test Crash'),
              onTap: () {
                FirebaseCrashlytics.instance.crash();
              },
            ),
          
          // 로그 뷰어
          ListTile(
            title: Text('View Logs'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => LogViewer(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
```

## 8. FAQ

### Q: 앱이 자꾸 크래시됩니다
**A:** 
1. 최신 버전 확인
2. 앱 데이터 삭제 후 재설치
3. 기기 재시작
4. 메모리 부족 확인

### Q: 걸음수가 정확하지 않아요
**A:**
1. 권한 설정 확인 (설정 > 앱 > WalkDog > 권한)
2. 배터리 최적화 제외 설정
3. 다른 피트니스 앱과 충돌 확인
4. 기기 센서 보정 (설정 > 모션)

### Q: AI 대화가 안 나와요
**A:**
1. 모델 다운로드 확인
2. 저장 공간 확인 (2GB 이상)
3. 앱 재시작
4. 오프라인 모드 확인

### Q: 이미지가 생성되지 않아요
**A:**
1. 네트워크 연결 확인
2. 일일 할당량 확인
3. 캐시된 이미지 사용
4. 벡터 이미지로 대체

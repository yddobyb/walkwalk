# WalkDog 테스트 전략 (2025년 9월 업데이트)

## 1. 테스트 피라미드

```
         ╱╲
        ╱E2E╲       (5%)  - 엔드투엔드 테스트
       ╱──────╲
      ╱Integration╲  (20%) - 통합 테스트  
     ╱──────────────╲
    ╱  Widget Tests  ╲ (30%) - 위젯 테스트
   ╱──────────────────╲
  ╱    Unit Tests      ╲ (45%) - 단위 테스트
 ╱──────────────────────╲
```

## 2. 단위 테스트 (Unit Tests)

### 2.1 Domain Layer 테스트
```dart
// test/unit/domain/usecases/feed_pet_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([PetRepository])
void main() {
  late FeedPetUseCase feedPetUseCase;
  late MockPetRepository mockPetRepository;
  
  setUp(() {
    mockPetRepository = MockPetRepository();
    feedPetUseCase = FeedPetUseCase(mockPetRepository);
  });
  
  group('FeedPetUseCase', () {
    test('should increase happiness when feeding pet', () async {
      // Arrange
      final pet = Pet(
        id: '1',
        name: '뽀삐',
        happiness: 50,
        treats: 5,
      );
      
      when(mockPetRepository.getPet('1'))
          .thenAnswer((_) async => Right(pet));
      when(mockPetRepository.updatePet(any))
          .thenAnswer((_) async => Right(unit));
      
      // Act
      final result = await feedPetUseCase.execute('1');
      
      // Assert
      expect(result.isRight(), true);
      verify(mockPetRepository.updatePet(any)).called(1);
      
      final capturedPet = verify(
        mockPetRepository.updatePet(captureAny)
      ).captured.single as Pet;
      
      expect(capturedPet.happiness, 58); // +8 happiness
      expect(capturedPet.treats, 4); // -1 treat
    });
    
    test('should fail when pet has no treats', () async {
      // Arrange
      final pet = Pet(
        id: '1',
        name: '뽀삐',
        happiness: 50,
        treats: 0,
      );
      
      when(mockPetRepository.getPet('1'))
          .thenAnswer((_) async => Right(pet));
      
      // Act
      final result = await feedPetUseCase.execute('1');
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InsufficientTreatsFailure>()),
        (_) => fail('Should have failed'),
      );
    });
  });
}
```

### 2.2 Service Layer 테스트
```dart
// test/unit/services/sensors/pedometer_service_test.dart
void main() {
  late PedometerService pedometerService;
  late MockPedometer mockPedometer;
  
  setUp(() {
    mockPedometer = MockPedometer();
    pedometerService = PedometerService(mockPedometer);
  });
  
  group('PedometerService', () {
    test('should emit step count updates', () async {
      // Arrange
      final stepController = StreamController<StepCount>();
      when(mockPedometer.stepCountStream)
          .thenAnswer((_) => stepController.stream);
      
      // Act
      final stream = pedometerService.startTracking();
      
      // Assert
      expectLater(
        stream,
        emitsInOrder([
          StepData(steps: 100, timestamp: any),
          StepData(steps: 150, timestamp: any),
          StepData(steps: 200, timestamp: any),
        ]),
      );
      
      // Emit test data
      stepController.add(StepCount(steps: 100, timeStamp: DateTime.now()));
      stepController.add(StepCount(steps: 150, timeStamp: DateTime.now()));
      stepController.add(StepCount(steps: 200, timeStamp: DateTime.now()));
    });
    
    test('should calculate step difference correctly', () {
      // Arrange
      pedometerService.setInitialSteps(1000);
      
      // Act & Assert
      expect(pedometerService.calculateDifference(1100), 100);
      expect(pedometerService.calculateDifference(1050), 50);
      expect(pedometerService.calculateDifference(900), 0); // 음수 방지
    });
  });
}
```

### 2.3 Repository 테스트
```dart
// test/unit/data/repositories/pet_repository_impl_test.dart
void main() {
  late PetRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  
  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = PetRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });
  
  group('PetRepository', () {
    test('should return pet from local data source', () async {
      // Arrange
      final petModel = PetModel(
        id: '1',
        name: '뽀삐',
        happiness: 80,
      );
      
      when(mockLocalDataSource.getPet('1'))
          .thenAnswer((_) async => petModel);
      
      // Act
      final result = await repository.getPet('1');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (pet) {
          expect(pet.id, '1');
          expect(pet.name, '뽀삐');
          expect(pet.happiness, 80);
        },
      );
      
      verify(mockLocalDataSource.getPet('1')).called(1);
      verifyNever(mockRemoteDataSource.getPet('1'));
    });
  });
}
```

## 3. 위젯 테스트 (Widget Tests)

### 3.1 화면 위젯 테스트
```dart
// test/widget/screens/home_screen_test.dart
void main() {
  testWidgets('Home screen displays pet avatar and stats', (tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          petProvider.overrideWith((_) => PetNotifier(testPet)),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    
    // Act
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('뽀삐'), findsOneWidget);
    expect(find.text('행복도: 80'), findsOneWidget);
    expect(find.text('간식: 5개'), findsOneWidget);
    expect(find.byType(PetAvatar), findsOneWidget);
    expect(find.byIcon(Icons.directions_walk), findsOneWidget);
  });
  
  testWidgets('Walk button starts walk session', (tester) async {
    // Arrange
    final mockWalkNotifier = MockWalkNotifier();
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          walkSessionProvider.overrideWith((_) => mockWalkNotifier),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    
    // Act
    await tester.tap(find.byKey(Key('walk_button')));
    await tester.pumpAndSettle();
    
    // Assert
    verify(mockWalkNotifier.startWalk()).called(1);
    expect(find.text('산책 중...'), findsOneWidget);
  });
}
```

### 3.2 커스텀 위젯 테스트
```dart
// test/widget/widgets/happiness_bar_test.dart
void main() {
  testWidgets('HappinessBar shows correct progress', (tester) async {
    // Test different happiness levels
    for (final happiness in [0, 25, 50, 75, 100]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HappinessBar(happiness: happiness),
          ),
        ),
      );
      
      // Find the progress indicator
      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      
      expect(progressIndicator.value, happiness / 100);
      
      // Verify color based on happiness
      if (happiness < 30) {
        expect(progressIndicator.color, Colors.red);
      } else if (happiness < 60) {
        expect(progressIndicator.color, Colors.orange);
      } else {
        expect(progressIndicator.color, Colors.green);
      }
    }
  });
}
```

### 3.3 골든 테스트
```dart
// test/widget/golden/pet_avatar_golden_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('PetAvatar renders correctly', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
      ])
      ..addScenario(
        widget: PetAvatar(
          breed: 'Shiba Inu',
          color: 'orange',
          accessory: PetAccessory.bandana,
          happiness: 80,
        ),
        name: 'happy_shiba_with_bandana',
      )
      ..addScenario(
        widget: PetAvatar(
          breed: 'Poodle',
          color: 'white',
          accessory: PetAccessory.glasses,
          happiness: 30,
        ),
        name: 'sad_poodle_with_glasses',
      );
    
    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'pet_avatar_variations');
  });
}
```

## 4. 통합 테스트 (Integration Tests)

### 4.1 전체 산책 플로우 테스트
```dart
// integration_test/walk_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete walk flow test', (tester) async {
    // 앱 시작
    app.main();
    await tester.pumpAndSettle();
    
    // 1. 온보딩 통과
    await tester.tap(find.text('권한 허용'));
    await tester.pumpAndSettle();
    
    // 2. 펫 커스터마이즈
    await tester.tap(find.text('커스터마이즈'));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(Key('pet_name_input')), '뽀삐');
    await tester.tap(find.text('Shiba Inu'));
    await tester.tap(find.text('Orange'));
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();
    
    // 3. 산책 시작
    await tester.tap(find.byKey(Key('walk_button')));
    await tester.pumpAndSettle();
    
    // 4. 걸음수 시뮬레이션 (테스트 환경)
    await simulateSteps(500);
    await tester.pumpAndSettle();
    
    // 5. 간식 획득 확인
    expect(find.text('간식 1개 획득!'), findsOneWidget);
    
    // 6. 산책 종료
    await tester.tap(find.text('산책 종료'));
    await tester.pumpAndSettle();
    
    // 7. 결과 확인
    expect(find.textContaining('500걸음'), findsOneWidget);
    expect(find.textContaining('간식 1개'), findsOneWidget);
    
    // 8. 펫에게 간식 주기
    await tester.tap(find.byIcon(Icons.cookie));
    await tester.pumpAndSettle();
    
    // 9. 행복도 증가 확인
    final happinessBar = tester.widget<HappinessBar>(
      find.byType(HappinessBar),
    );
    expect(happinessBar.happiness, greaterThan(50));
    
    // 10. AI 대화 확인
    expect(find.textContaining('멍멍'), findsOneWidget);
  });
}
```

### 4.2 센서 통합 테스트
```dart
// integration_test/sensor_integration_test.dart
void main() {
  testWidgets('Sensor integration test', (tester) async {
    // GPS 권한 시뮬레이션
    await grantLocationPermission();
    
    // 활동 인식 권한
    await grantActivityPermission();
    
    app.main();
    await tester.pumpAndSettle();
    
    // 실외 모드 활성화
    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('실외 모드'));
    await tester.pumpAndSettle();
    
    // 산책 시작
    await tester.tap(find.byKey(Key('walk_button')));
    await tester.pumpAndSettle();
    
    // GPS 위치 시뮬레이션
    await simulateLocationChanges([
      Location(37.5665, 126.9780), // 서울시청
      Location(37.5660, 126.9785), // 5m 이동
      Location(37.5655, 126.9790), // 10m 이동
    ]);
    
    // 걸음수 시뮬레이션
    await simulateSteps(100);
    
    await tester.pump(Duration(seconds: 5));
    
    // 실외 모드 보너스 확인
    expect(find.textContaining('실외 보너스'), findsOneWidget);
  });
}
```

## 5. 성능 테스트

### 5.1 벤치마크 테스트
```dart
// test/performance/ai_benchmark_test.dart
void main() {
  test('LLM response time benchmark', () async {
    final llm = LLMService();
    await llm.initialize();
    
    final stopwatch = Stopwatch()..start();
    
    await llm.generateDialogue(
      petName: '뽀삐',
      breed: 'Shiba Inu',
      personality: PetPersonality.cheerful,
      happiness: 80,
      context: 'feed',
    ).first;
    
    stopwatch.stop();
    
    // 목표: 500ms 이내 첫 토큰
    expect(stopwatch.elapsedMilliseconds, lessThan(500));
  });
  
  test('Image generation benchmark', () async {
    final service = ImageGenerationService(ImageCacheService());
    
    final stopwatch = Stopwatch()..start();
    
    await service.generateSticker(
      petId: 'test',
      breed: 'Shiba Inu',
      color: 'orange',
      accessory: PetAccessory.none,
    );
    
    stopwatch.stop();
    
    // 목표: 3초 이내 (캐시 미스)
    expect(stopwatch.elapsedMilliseconds, lessThan(3000));
  });
}
```

### 5.2 메모리 테스트
```dart
// test/performance/memory_test.dart
void main() {
  test('Memory usage during walk session', () async {
    final memoryBefore = await getMemoryUsage();
    
    // 30분 산책 시뮬레이션
    final walkService = WalkService();
    await walkService.startWalk();
    
    for (int i = 0; i < 1800; i++) { // 30분 = 1800초
      await walkService.recordStep(i * 2);
      await Future.delayed(Duration(seconds: 1));
    }
    
    await walkService.endWalk();
    
    final memoryAfter = await getMemoryUsage();
    final memoryIncrease = memoryAfter - memoryBefore;
    
    // 목표: 50MB 이하 메모리 증가
    expect(memoryIncrease, lessThan(50 * 1024 * 1024));
  });
}
```

## 6. 테스트 데이터 & Fixtures

### 6.1 테스트 데이터 생성
```dart
// test/fixtures/test_data.dart
class TestData {
  static Pet get testPet => Pet(
    id: 'test-pet-1',
    petId: 'uuid-test',
    name: '테스트 뽀삐',
    breed: 'Shiba Inu',
    color: 'orange',
    accessory: PetAccessory.bandana,
    happiness: 75,
    treats: 10,
    stepsToday: 500,
    totalSteps: 10000,
    personality: PetPersonality.cheerful,
    lastUpdate: DateTime.now(),
  );
  
  static WalkLog get testWalkLog => WalkLog(
    id: 'test-walk-1',
    sessionId: 'session-uuid',
    startTime: DateTime.now().subtract(Duration(minutes: 30)),
    endTime: DateTime.now(),
    totalSteps: 1500,
    duration: 1800,
    distance: 1200.0,
    avgSpeed: 2.4,
    isOutdoor: true,
    validOutdoorSamples: 15,
    treatsEarned: 5,
    happinessGained: 20,
  );
  
  static List<Achievement> get testAchievements => [
    Achievement(
      code: 'FIRST_WALK',
      title: '첫 산책',
      description: '첫 산책 완료',
      tier: AchievementTier.bronze,
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      code: 'STEPS_1K',
      title: '천 걸음',
      description: '1,000걸음 달성',
      tier: AchievementTier.silver,
      isUnlocked: false,
      currentProgress: 500,
      targetProgress: 1000,
    ),
  ];
}
```

### 6.2 Mock 생성 헬퍼
```dart
// test/fixtures/mock_factory.dart
class MockFactory {
  static MockPetRepository createMockPetRepository({
    Pet? pet,
    bool shouldFail = false,
  }) {
    final mock = MockPetRepository();
    
    if (shouldFail) {
      when(mock.getPet(any))
          .thenAnswer((_) async => Left(CacheFailure('Test failure')));
    } else {
      when(mock.getPet(any))
          .thenAnswer((_) async => Right(pet ?? TestData.testPet));
    }
    
    return mock;
  }
  
  static MockLLMService createMockLLMService({
    String response = "테스트 응답 멍멍!",
    bool shouldStream = true,
  }) {
    final mock = MockLLMService();
    
    if (shouldStream) {
      when(mock.generateDialogue(any))
          .thenAnswer((_) async* {
            for (final char in response.split('')) {
              yield char;
              await Future.delayed(Duration(milliseconds: 10));
            }
          });
    } else {
      when(mock.generateDialogue(any))
          .thenAnswer((_) async* {
            yield response;
          });
    }
    
    return mock;
  }
}
```

## 7. CI/CD 테스트 파이프라인

### 7.1 GitHub Actions 설정
```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Analyze
        run: flutter analyze
      
      - name: Format check
        run: dart format --output=none --set-exit-if-changed .
      
      - name: Run unit tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
      
      - name: Run widget tests
        run: flutter test test/widget
      
      - name: Run golden tests
        run: flutter test --update-goldens test/widget/golden
      
      - name: Build APK
        run: flutter build apk --debug
      
      - name: Run integration tests
        run: |
          flutter build apk --debug
          flutter test integration_test
```

## 8. 테스트 커버리지 목표

### 8.1 커버리지 기준
- **전체**: 80% 이상
- **Domain Layer**: 90% 이상
- **Data Layer**: 85% 이상
- **Presentation Layer**: 70% 이상
- **Services Layer**: 80% 이상

### 8.2 커버리지 측정
```bash
# 커버리지 생성
flutter test --coverage

# HTML 리포트 생성
genhtml coverage/lcov.info -o coverage/html

# 브라우저에서 열기
open coverage/html/index.html
```

## 9. 테스트 실행 스크립트

### 9.1 Makefile 테스트 명령
```makefile
# 전체 테스트
test-all:
	flutter test

# 단위 테스트만
test-unit:
	flutter test test/unit

# 위젯 테스트만
test-widget:
	flutter test test/widget

# 통합 테스트
test-integration:
	flutter test integration_test

# 골든 테스트 업데이트
test-golden-update:
	flutter test --update-goldens test/widget/golden

# 커버리지 리포트
test-coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

# 특정 파일 테스트
test-file:
	flutter test $(FILE)

# Watch 모드
test-watch:
	flutter test --reporter expanded --coverage --watch
```

## 10. 테스트 체크리스트

### 10.1 PR 체크리스트
- [ ] 모든 새 기능에 대한 단위 테스트 작성
- [ ] 주요 UI 변경사항에 대한 위젯 테스트 작성
- [ ] 골든 테스트 업데이트 (UI 변경 시)
- [ ] 통합 테스트 실행 및 통과
- [ ] 커버리지 80% 이상 유지
- [ ] 성능 테스트 통과 (해당 시)

### 10.2 릴리스 체크리스트
- [ ] 전체 테스트 스위트 통과
- [ ] 실기기 테스트 (iOS/Android)
- [ ] 성능 벤치마크 달성
- [ ] 메모리 누수 테스트 통과
- [ ] 센서 통합 테스트 통과
- [ ] 네트워크 오류 시나리오 테스트

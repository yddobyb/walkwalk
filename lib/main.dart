import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/firebase_service.dart';
import 'data/datasources/database_service.dart';
import 'services/analytics/analytics_service.dart';
import 'services/config/remote_config_service.dart';
import 'services/tracking/step_tracking_service.dart';
import 'services/pet/happiness_scheduler_service.dart';
import 'services/mission/mission_service.dart';
import 'services/settings/settings_service.dart';
import 'services/ai/ai_providers.dart';
import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Week 3: Firebase 초기화 (가장 먼저 실행)
  print('════════════════════════════════════════');
  print('  🔧 Starting Firebase initialization');
  print('════════════════════════════════════════');

  final firebaseInit = await FirebaseService.initialize();
  if (!firebaseInit) {
    print('❌ WARNING: Firebase initialization failed!');
    print('   AI features may not work without Firebase Remote Config');
  }

  // Week 3: Firebase Remote Config 초기화
  final remoteConfigInit = await RemoteConfigService.initialize();
  if (!remoteConfigInit) {
    print('❌ WARNING: Remote Config initialization failed!');
    print('   Falling back to environment variables for API key');
  }

  // Week 3: Firebase Analytics 초기화
  final analyticsInit = await AnalyticsService.initialize();
  if (!analyticsInit) {
    print('⚠️ WARNING: Analytics initialization failed!');
    print('   App will continue without analytics tracking');
  }

  print('════════════════════════════════════════');
  print('  Firebase Init Summary:');
  print('    - Firebase Core: ${firebaseInit ? "✅" : "❌"}');
  print('    - Remote Config: ${remoteConfigInit ? "✅" : "❌"}');
  print('    - Analytics: ${analyticsInit ? "✅" : "❌"}');
  print('════════════════════════════════════════');

  // intl 패키지 한국어 locale 초기화
  await initializeDateFormatting('ko_KR', null);

  // 데이터베이스 초기화
  await DatabaseService.instance;

  // 걸음수 트래킹 서비스 초기화 (UI 로드 전에 완료)
  await StepTrackingService().initialize().catchError((error) {
    debugPrint('Step tracking service initialization failed: $error');
    return false; // Return a default value for bool
  });

  // 행복도 스케줄러 초기화 (백그라운드에서)
  HappinessSchedulerService.instance.initialize().catchError((error) {
    debugPrint('Happiness scheduler initialization failed: $error');
    return null; // Return void
  });

  // 미션 서비스 초기화 (백그라운드에서)
  MissionService.instance.initialize().catchError((error) {
    debugPrint('Mission service initialization failed: $error');
    return null; // Return void
  });

  runApp(
    const ProviderScope(
      child: WalkDogApp(),
    ),
  );
}

class WalkDogApp extends ConsumerWidget {
  const WalkDogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    // LLM 초기화 (백그라운드에서)
    ref.watch(llmInitializationProvider);

    // 설정을 불러오는 동안 기본 테마로 표시
    final themeMode = settingsAsync.maybeWhen(
      data: (settings) => settings.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      orElse: () => ThemeMode.light,
    );

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}

/// 임시 환영 화면 (실제 홈 화면 구현 전까지 사용)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalkDog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 강아지 이모지 (임시 아이콘)
            const Text(
              '🐕',
              style: TextStyle(fontSize: 120),
            ),
            const SizedBox(height: 32),

            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            Text(
              AppConstants.appDescription,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                // TODO: 펫 생성 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('곧 펫 생성 화면이 준비될 예정입니다!'),
                  ),
                );
              },
              child: const Text('펫 만들기'),
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: () {
                // TODO: 기존 펫 불러오기
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('곧 펫 불러오기 기능이 준비될 예정입니다!'),
                  ),
                );
              },
              child: const Text('기존 펫 불러오기'),
            ),

            const Spacer(),

            // 앱 버전 정보
            Text(
              'Version ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
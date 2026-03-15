import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'l10n/app_localizations.dart';
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
import 'services/notification/notification_service.dart';
import 'services/storage/secure_storage_service.dart';
import 'services/subscription/revenue_cat_service.dart';
import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Secure Storage 초기화 (가장 먼저 — 다른 서비스가 의존)
  await SecureStorageService.initialize();

  // Week 3: Firebase 초기화
  await FirebaseService.initialize();
  await RemoteConfigService.initialize();
  await AnalyticsService.initialize();

  // 익명 로그인 (Firebase Functions + Firestore 동기화를 위해 먼저)
  try {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
    debugPrint('[AUTH] uid=${auth.currentUser?.uid}');
  } catch (e) {
    debugPrint('[AUTH] Anonymous authentication failed: $e');
  }

  // Phase 7: RevenueCat 초기화 (로그인 후 → Firestore 동기화 가능)
  await RevenueCatService.initialize();

  // intl 패키지 한국어 locale 초기화
  await initializeDateFormatting('ko_KR', null);

  // 데이터베이스 초기화
  await DatabaseService.instance;

  // 알림 서비스 초기화 (행복도 스케줄러가 알림을 사용하므로 먼저)
  final notifService = NotificationService.instance;
  await notifService.initialize().catchError((error) {
    debugPrint('❌ Notification service initialization failed: $error');
    return null;
  });

  // 조건부 산책 리마인더 스케줄 + 자정 타이머
  await notifService.scheduleConditionalReminders();
  notifService.startMidnightRescheduleTimer();

  // 행복도 스케줄러 초기화 (StepTrackingService보다 먼저)
  await HappinessSchedulerService.instance.initialize().catchError((error) {
    debugPrint('❌ Happiness scheduler initialization failed: $error');
    return null;
  });

  // 걸음수 트래킹 서비스 초기화 (스케줄러 이후에 실행)
  await StepTrackingService().initialize().catchError((error) {
    debugPrint('❌ Step tracking service initialization failed: $error');
    return false; // Return a default value for bool
  });

  // 미션 서비스 초기화 (백그라운드에서)
  MissionService.instance.initialize().catchError((error) {
    debugPrint('❌ Mission service initialization failed: $error');
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

    // 설정을 불러오는 동안 기본 테마 및 locale로 표시
    final themeMode = settingsAsync.maybeWhen(
      data: (settings) => settings.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      orElse: () => ThemeMode.light,
    );

    // Week 3: 설정된 locale 가져오기 (기본값: 한국어)
    final locale = settingsAsync.maybeWhen(
      data: (settings) => Locale(settings.locale),
      orElse: () => const Locale('ko'),
    );

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // Week 3: Localization 설정
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'), // 한국어
        Locale('en'), // 영어
      ],
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
              AppLocalizations.of(context).appDescription,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                // TODO: 펫 생성 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).petCreationComingSoon),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context).createPet),
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: () {
                // TODO: 기존 펫 불러오기
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).petLoadingComingSoon),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context).loadExistingPet),
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
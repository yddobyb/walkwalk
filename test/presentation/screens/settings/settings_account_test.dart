// test/presentation/screens/settings/settings_account_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:walk_dog/data/datasources/database_service.dart';
import 'package:walk_dog/data/models/settings_model.dart';
import 'package:walk_dog/l10n/app_localizations.dart';
import 'package:walk_dog/presentation/screens/settings/settings_screen.dart';
import 'package:walk_dog/services/settings/settings_service.dart';
import 'package:walk_dog/services/user/user_tier_providers.dart';
import 'package:walk_dog/services/user/user_tier_service.dart';

/// SettingsScreen 계정 섹션 위젯 테스트
///
/// _AccountSection이 Firebase 미초기화 환경에서도
/// 안전하게 렌더링되는지 검증.
///
/// 테스트 항목:
/// 1. 계정 섹션 렌더링 (Firebase 없이)
/// 2. 로그인 UI 노출 (익명 상태 기본값)
/// 3. 기존 구독 섹션과 공존
/// 4. 전체 설정 화면 안정성
void main() {
  /// l10n + provider 오버라이드를 포함한 테스트 위젯 빌더
  Widget buildTestWidget({
    UserTier tier = UserTier.free,
  }) {
    return ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(
          _FakeSettingsService(),
        ),
        currentUserTierProvider.overrideWith(
          () => _FakeCurrentUserTier(tier),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ko'),
        home: SettingsScreen(),
      ),
    );
  }

  group('SettingsScreen - Account Section', () {
    // ========================================================================
    // 1. 계정 섹션 렌더링
    // ========================================================================
    testWidgets('계정 섹션 타이틀 렌더링', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // '계정' 섹션 타이틀 확인
      expect(find.text('계정'), findsOneWidget);
    });

    // ========================================================================
    // 2. 익명 상태 기본값 → 로그인 옵션 표시
    // ========================================================================
    testWidgets('Firebase 미초기화 → 익명 상태 기본값 → 로그인 UI 표시',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 로그인 안내 텍스트 확인
      expect(find.text('로그인'), findsOneWidget);
      expect(
        find.text('데이터 백업 및 기기 간 동기화'),
        findsOneWidget,
      );
    });

    testWidgets('익명 상태에서 account_circle_outlined 아이콘 표시',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.account_circle_outlined),
        findsOneWidget,
      );
    });

    testWidgets('익명 상태에서 chevron_right 표시 (탭 가능 암시)',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 계정 섹션 + 구독 섹션 등 여러 곳에 chevron_right 가능
      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    // ========================================================================
    // 3. 기존 구독 섹션과 공존
    // ========================================================================
    testWidgets('계정 섹션과 구독 섹션 모두 렌더링', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 두 섹션 모두 존재
      expect(find.text('계정'), findsOneWidget);
      expect(find.text('구독'), findsOneWidget);
    });

    testWidgets('계정 섹션이 구독 섹션보다 위에 위치', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final accountFinder = find.text('계정');
      final subscriptionFinder = find.text('구독');

      // 둘 다 존재 확인
      expect(accountFinder, findsOneWidget);
      expect(subscriptionFinder, findsOneWidget);

      // 계정이 구독보다 위에 있는지 Y좌표로 확인
      final accountY = tester.getTopLeft(accountFinder).dy;
      final subscriptionY = tester.getTopLeft(subscriptionFinder).dy;
      expect(accountY, lessThan(subscriptionY));
    });

    // ========================================================================
    // 4. 기존 테스트 호환성 (구독 섹션 아이콘)
    // ========================================================================
    testWidgets('free tier - star_border 아이콘 여전히 존재', (tester) async {
      await tester.pumpWidget(buildTestWidget(tier: UserTier.free));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('premium tier - workspace_premium 아이콘 여전히 존재',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(tier: UserTier.premium));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    // ========================================================================
    // 5. 계정 타일 탭 → Bottom Sheet 표시
    // ========================================================================
    testWidgets('계정 연결 탭 → Bottom Sheet 표시', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // '로그인' 타일 탭
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      // Bottom Sheet에 Google 로그인 옵션 표시
      expect(find.text('Google로 로그인'), findsOneWidget);
    });

    // ========================================================================
    // 6. 전체 화면 안정성 (크래시 없음)
    // ========================================================================
    testWidgets('전체 설정 화면 렌더링 - 크래시 없음', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 주요 섹션 모두 렌더링
      expect(find.text('계정'), findsOneWidget);
      expect(find.text('구독'), findsOneWidget);
      expect(find.text('게임 설정'), findsOneWidget);
    });

    testWidgets('스크롤하여 모든 섹션 접근 가능', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      // 아래로 스크롤
      await tester.drag(listView, const Offset(0, -500));
      await tester.pumpAndSettle();

      // 하단 섹션도 렌더링
      expect(find.text('앱 설정'), findsOneWidget);
    });
  });
}

/// 테스트용 가짜 SettingsService
class _FakeSettingsService extends SettingsService {
  _FakeSettingsService() : super(DatabaseService());

  @override
  Future<SettingsModel> loadSettings() async {
    return SettingsModel.createDefault();
  }

  @override
  Future<void> updateDarkMode(bool enabled) async {}

  @override
  Future<void> updateNotifications(bool enabled) async {}

  @override
  Future<void> updateDailyStepGoal(int goal) async {}

  @override
  Future<void> updateLocale(String localeCode) async {}

  @override
  Future<void> updateMorningReminderTime(String time) async {}

  @override
  Future<void> updateEveningReminderTime(String time) async {}
}

/// 테스트용 가짜 CurrentUserTier AsyncNotifier
class _FakeCurrentUserTier extends CurrentUserTier {
  final UserTier _tier;

  _FakeCurrentUserTier(this._tier);

  @override
  Future<UserTier> build() async => _tier;
}

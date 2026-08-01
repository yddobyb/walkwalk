// test/presentation/screens/settings/settings_subscription_test.dart

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

/// SettingsScreen 구독 섹션 위젯 테스트
void main() {
  /// l10n + provider 오버라이드를 포함한 테스트 위젯 빌더
  Widget buildTestWidget({
    required UserTier tier,
  }) {
    return ProviderScope(
      overrides: [
        // SettingsService를 fake로 교체 → loadSettings()가 즉시 반환
        settingsServiceProvider.overrideWithValue(
          _FakeSettingsService(),
        ),
        // 사용자 등급 프로바이더 오버라이드
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

  group('SettingsScreen - Subscription Section', () {
    testWidgets('free tier shows star_border icon',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.free),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('free tier shows chevron_right trailing',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.free),
      );
      await tester.pumpAndSettle();

      // chevron_right 존재 확인 (구독 섹션 포함 여러 곳)
      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('premium tier shows workspace_premium icon',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.premium),
      );
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.workspace_premium),
        findsOneWidget,
      );
    });

    testWidgets('renders subscription section title',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.free),
      );
      await tester.pumpAndSettle();

      expect(find.text('구독'), findsOneWidget);
    });

    testWidgets('renders premium title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.free),
      );
      await tester.pumpAndSettle();

      expect(find.text('프리미엄'), findsOneWidget);
    });

    testWidgets('renders all settings sections', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.free),
      );
      await tester.pumpAndSettle();

      // 상단 섹션 확인
      expect(find.text('구독'), findsOneWidget);
      expect(find.text('게임 설정'), findsOneWidget);
      // '알림'은 섹션 타이틀 + 타일 타이틀로 2번 나타남
      expect(find.text('알림'), findsAtLeast(1));

      // 하단 섹션은 스크롤 후 확인
      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      // 고정 픽셀 드래그는 섹션이 추가될 때마다 깨지므로 scrollUntilVisible 사용.
      // scrollable에는 ListView가 아니라 그 안의 Scrollable을 넘겨야 한다.
      final scrollable = find.descendant(
        of: listView,
        matching: find.byType(Scrollable),
      );
      Future<void> scrollTo(Finder target) async {
        await tester.scrollUntilVisible(target, 200, scrollable: scrollable);
        await tester.pumpAndSettle();
      }

      await scrollTo(find.text('앱 설정'));
      expect(find.text('앱 설정'), findsOneWidget);

      // Phase 27: AI 고지·동의 섹션
      await scrollTo(find.text('AI 기능'));
      expect(find.text('AI 기능'), findsOneWidget);

      await scrollTo(find.text('정보'));
      expect(find.text('정보'), findsOneWidget);
    });

    testWidgets('tapping subscription navigates to paywall',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(tier: UserTier.free),
      );
      await tester.pumpAndSettle();

      // 프리미엄 타일 탭
      await tester.tap(find.text('프리미엄'));
      await tester.pumpAndSettle();

      // PaywallScreen으로 이동 (AppBar 타이틀로 확인)
      expect(find.text('프리미엄 구독'), findsOneWidget);
    });
  });
}

/// 테스트용 가짜 SettingsService
///
/// loadSettings()가 즉시 기본값을 반환하여
/// Isar DB 없이도 동작한다.
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

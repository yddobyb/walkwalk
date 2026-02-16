// test/presentation/screens/subscription/paywall_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:walk_dog/l10n/app_localizations.dart';
import 'package:walk_dog/presentation/screens/subscription/paywall_screen.dart';
import 'package:walk_dog/services/subscription/revenue_cat_service.dart';
import 'package:walk_dog/services/user/user_tier_providers.dart';
import 'package:walk_dog/services/user/user_tier_service.dart';

/// PaywallScreen 위젯 테스트
///
/// 테스트 항목:
/// 1. 기본 레이아웃 렌더링 (헤더, 혜택, 버튼)
/// 2. 구독 버튼 표시 확인
/// 3. 복원 버튼 표시 확인
/// 4. SDK 미설정 시 SnackBar 표시
void main() {
  /// l10n을 포함한 테스트 위젯 빌더
  Widget buildTestWidget({
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ko'),
        home: PaywallScreen(),
      ),
    );
  }

  group('PaywallScreen Widget Tests', () {
    testWidgets('renders AppBar with title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // AppBar가 렌더링되어야 함
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders header gradient container', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 헤더 텍스트 확인 (💎 이모지)
      expect(find.text('\u{1F48E}'), findsOneWidget);
    });

    testWidgets('renders 4 benefit tiles', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 4개의 체크 아이콘 (혜택 체크마크)
      expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    });

    testWidgets('renders benefit icons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 혜택 아이콘들
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.byIcon(Icons.all_inclusive), findsOneWidget);
      expect(find.byIcon(Icons.block), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
    });

    testWidgets('renders subscribe button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // ElevatedButton (구독 버튼)
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders restore button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // TextButton (복원 버튼)
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('renders price text with won symbol',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 기본 가격 표시 (₩4,900)
      expect(find.textContaining('\u20a94,900'), findsOneWidget);
    });

    testWidgets(
        'subscribe button shows snackbar when SDK unconfigured',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 구독 버튼이 화면 밖에 있을 수 있으므로 스크롤
      await tester.ensureVisible(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // SDK가 미설정 상태이므로 구독 버튼 탭 시 SnackBar 표시
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // SnackBar가 나타나야 함
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
        'restore button shows snackbar when SDK unconfigured',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 복원 버튼이 화면 밖에 있을 수 있으므로 스크롤
      await tester.ensureVisible(find.byType(TextButton));
      await tester.pumpAndSettle();

      // 복원 버튼 탭
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // SnackBar가 나타나야 함
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('is scrollable', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // SingleChildScrollView 존재
      expect(
        find.byType(SingleChildScrollView),
        findsOneWidget,
      );
    });

    testWidgets('has back button in AppBar', (tester) async {
      // Navigator 스택에 PaywallScreen을 push해서
      // 뒤로가기 버튼이 있는지 확인
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ko'),
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PaywallScreen(),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // PaywallScreen으로 이동
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      // 뒤로가기 버튼 확인
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}

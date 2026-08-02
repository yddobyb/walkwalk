// test/presentation/screens/subscription/paywall_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:walk_dog/l10n/app_localizations.dart';
import 'package:walk_dog/presentation/screens/subscription/paywall_screen.dart';

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
    testWidgets('renders hero header with close button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 새 디자인: AppBar 대신 커스텀 _HeroHeader + X 닫기 버튼
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
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

      // 새 디자인: check_circle_rounded 아이콘 사용
      expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(4));
    });

    testWidgets('renders benefit icons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 새 디자인: rounded 아이콘 버전 사용
      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
      expect(find.byIcon(Icons.all_inclusive_rounded), findsOneWidget);
      expect(find.byIcon(Icons.block_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);
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

    testWidgets('스토어 가격을 못 받으면 locale별 폴백 가격을 표시한다',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 가격은 스토어에서 받아오고 시장별로 다르므로(US/CA/KR), 특정 금액을
      // 하드코딩해 검사하면 가격을 조정할 때마다 테스트가 깨진다.
      // 여기서는 "폴백 문자열이 실제로 렌더링되는가"만 확인한다.
      final l10n = await AppLocalizations.delegate.load(const Locale('ko'));
      expect(find.textContaining(l10n.paywallPriceFallback), findsOneWidget);
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

    testWidgets('has close button when pushed via Navigator', (tester) async {
      // Navigator 스택에 PaywallScreen을 push해서
      // 새 디자인의 커스텀 X 닫기 버튼이 있는지 확인
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

      // 새 디자인: BackButton 대신 커스텀 X 닫기 버튼 (Icons.close_rounded)
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });
  });
}

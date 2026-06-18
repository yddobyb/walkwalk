import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/l10n/app_localizations.dart';
import 'package:walk_dog/presentation/screens/settings/widgets/link_account_sheet.dart';

/// LinkAccountSheet 렌더링/닫기 테스트.
/// Google/Apple 버튼 탭은 Firebase(AuthService)를 호출하므로 테스트하지 않고,
/// 시트가 상태별 카피로 렌더되는지 + "나중에"로 닫히는지만 검증한다.
Future<AppLocalizations> _openSheet(
  WidgetTester tester, {
  required bool isPremium,
}) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Builder(
        builder: (context) {
          l10n = AppLocalizations.of(context);
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () =>
                    LinkAccountSheet.show(context, isPremium: isPremium),
                child: const Text('open'),
              ),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return l10n;
}

void main() {
  group('LinkAccountSheet', () {
    testWidgets('프리미엄: 보호 카피 + Google + 나중에 렌더', (tester) async {
      final l10n = await _openSheet(tester, isPremium: true);

      expect(find.text(l10n.linkAccountTitlePremium), findsOneWidget);
      expect(find.text(l10n.signInWithGoogle), findsOneWidget);
      expect(find.text(l10n.linkAccountLater), findsOneWidget);
      // 프리미엄 히어로 이모지
      expect(find.text('💎'), findsOneWidget);
    });

    testWidgets('비프리미엄: 기본(백업) 카피 렌더', (tester) async {
      final l10n = await _openSheet(tester, isPremium: false);

      expect(find.text(l10n.linkAccountTitleDefault), findsOneWidget);
      expect(find.text(l10n.signInWithGoogle), findsOneWidget);
      // 기본 히어로 이모지
      expect(find.text('🔗'), findsOneWidget);
    });

    testWidgets('"나중에" 탭 시 시트가 닫힌다', (tester) async {
      final l10n = await _openSheet(tester, isPremium: true);
      expect(find.text(l10n.linkAccountTitlePremium), findsOneWidget);

      await tester.tap(find.text(l10n.linkAccountLater));
      await tester.pumpAndSettle();

      expect(find.text(l10n.linkAccountTitlePremium), findsNothing);
    });
  });
}

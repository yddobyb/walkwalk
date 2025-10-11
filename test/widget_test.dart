// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:walk_dog/main.dart';

void main() {
  testWidgets('WalkDog app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: WalkDogApp(),
      ),
    );

    // Verify that the app title is displayed multiple times (AppBar + Body)
    expect(find.text('WalkDog'), findsWidgets);

    // Verify that the welcome message is displayed
    expect(find.text('펫 만들기'), findsOneWidget);
    expect(find.text('기존 펫 불러오기'), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
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

    // Wait for the app to build (multiple frames for async operations)
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify that the app loads successfully by checking for MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that there are ElevatedButton widgets (for Create Pet and Load Existing Pet)
    expect(find.byType(ElevatedButton), findsWidgets);

    // Verify that the app title is displayed
    expect(find.text('WalkDog'), findsWidgets);
  });
}

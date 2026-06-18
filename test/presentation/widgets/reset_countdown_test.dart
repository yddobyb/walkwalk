import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/data/models/quota_response.dart';
import 'package:walk_dog/presentation/widgets/reset_countdown.dart';
import 'package:walk_dog/services/firebase/image_generation_providers.dart';

QuotaData _fakeQuota() => const QuotaData(
      remaining: 0,
      total: 5,
      used: 5,
      resetAt: '2026-01-02T00:00:00.000Z',
      nextResetIn: 3600,
    );

void main() {
  group('formatCountdown', () {
    test('1시간 이상 → h m s', () {
      expect(formatCountdown(13 * 3600 + 8 * 60 + 5), '13h 8m 5s');
    });
    test('1분 이상 → m s', () {
      expect(formatCountdown(8 * 60 + 5), '8m 5s');
    });
    test('1분 미만 → s', () {
      expect(formatCountdown(5), '5s');
    });
    test('0초', () {
      expect(formatCountdown(0), '0s');
    });
    test('음수는 0으로 클램프', () {
      expect(formatCountdown(-10), '0s');
    });
  });

  group('ResetCountdown 위젯', () {
    testWidgets('매 초 카운트다운이 감소한다', (tester) async {
      var now = DateTime.utc(2026, 1, 1, 0, 0, 0);
      final reset = now.add(const Duration(seconds: 10));

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ResetCountdown(
                resetAt: reset,
                label: (t) => t,
                autoRefresh: false,
                clock: () => now,
              ),
            ),
          ),
        ),
      );

      expect(find.text('10s'), findsOneWidget);

      now = now.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('9s'), findsOneWidget);

      now = now.add(const Duration(seconds: 4));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('5s'), findsOneWidget);

      // 타이머 정리
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('label 래퍼가 적용된다', (tester) async {
      final now = DateTime.utc(2026, 1, 1, 0, 0, 0);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ResetCountdown(
                resetAt: now.add(const Duration(minutes: 5, seconds: 3)),
                label: (t) => '$t 후 리셋',
                autoRefresh: false,
                clock: () => now,
              ),
            ),
          ),
        ),
      );

      expect(find.text('5m 3s 후 리셋'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('0초 도달 시 quotaProvider를 무효화(재조회)한다', (tester) async {
      var now = DateTime.utc(2026, 1, 1, 0, 0, 0);
      final reset = now.add(const Duration(seconds: 3));
      var fetchCount = 0;

      final container = ProviderContainer(
        overrides: [
          quotaProvider.overrideWith((ref) async {
            fetchCount++;
            return _fakeQuota();
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  ref.watch(quotaProvider); // 살아있게 유지 + 무효화 시 재빌드
                  return ResetCountdown(
                    resetAt: reset,
                    label: (t) => t,
                    autoRefresh: true,
                    clock: () => now,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      final before = fetchCount; // 최초 조회 1회
      expect(before, greaterThanOrEqualTo(1));

      // 리셋 시각을 넘긴다
      now = now.add(const Duration(seconds: 4));
      await tester.pump(const Duration(seconds: 1)); // 타이머 발화 → invalidate
      await tester.pump(); // 재조회 반영
      await tester.pump(const Duration(milliseconds: 10));

      expect(fetchCount, greaterThan(before)); // 자동 재조회 발생

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('autoRefresh:false면 0초여도 무효화하지 않는다', (tester) async {
      var now = DateTime.utc(2026, 1, 1, 0, 0, 0);
      final reset = now.add(const Duration(seconds: 2));
      var fetchCount = 0;

      final container = ProviderContainer(
        overrides: [
          quotaProvider.overrideWith((ref) async {
            fetchCount++;
            return _fakeQuota();
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  ref.watch(quotaProvider);
                  return ResetCountdown(
                    resetAt: reset,
                    label: (t) => t,
                    autoRefresh: false,
                    clock: () => now,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      final before = fetchCount;

      now = now.add(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(fetchCount, before); // 변화 없음

      await tester.pumpWidget(const SizedBox());
    });
  });
}

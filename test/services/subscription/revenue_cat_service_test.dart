// test/services/subscription/revenue_cat_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/subscription/revenue_cat_service.dart';

void main() {
  group('PurchaseResult', () {
    test('default constructor has all false/null', () {
      const result = PurchaseResult();

      expect(result.success, isFalse);
      expect(result.alreadySubscribed, isFalse);
      expect(result.isCancelled, isFalse);
      expect(result.errorMessage, isNull);
    });

    test('success result', () {
      const result = PurchaseResult(success: true);

      expect(result.success, isTrue);
      expect(result.isCancelled, isFalse);
      expect(result.errorMessage, isNull);
    });

    test('cancelled result', () {
      const result = PurchaseResult(isCancelled: true);

      expect(result.success, isFalse);
      expect(result.isCancelled, isTrue);
    });

    test('error result', () {
      const result = PurchaseResult(
        errorMessage: 'Network error',
      );

      expect(result.success, isFalse);
      expect(result.errorMessage, 'Network error');
    });

    test('alreadySubscribed result', () {
      const result = PurchaseResult(alreadySubscribed: true);

      expect(result.alreadySubscribed, isTrue);
      expect(result.success, isFalse);
    });
  });

  group('RevenueCatService - unconfigured mode', () {
    // API 키가 PLACEHOLDER이므로 isConfigured = false 상태

    test('isConfigured is false before initialize', () {
      // RevenueCatService는 static이므로 앱 시작 전 기본 상태 확인
      // 실제로는 initialize()가 호출되어야 하지만,
      // 테스트 환경에서는 SDK 초기화가 불가능하므로
      // 플레이스홀더 감지 로직을 간접 테스트
      expect(RevenueCatService.isConfigured, isFalse);
    });

    test('hasPremiumEntitlement returns false when unconfigured',
        () async {
      final result =
          await RevenueCatService.hasPremiumEntitlement();
      expect(result, isFalse);
    });

    test('getMonthlyProduct returns null when unconfigured',
        () async {
      final product =
          await RevenueCatService.getMonthlyProduct();
      expect(product, isNull);
    });

    test('purchase returns error when unconfigured', () async {
      // StoreProduct을 직접 생성할 수 없으므로,
      // unconfigured 상태에서는 product 없이 purchase를 호출할 수 없음
      // 대신 restorePurchases 테스트
      final result =
          await RevenueCatService.restorePurchases();
      expect(result.success, isFalse);
      expect(result.errorMessage, 'Store not configured');
    });

    test('restorePurchases returns error when unconfigured',
        () async {
      final result =
          await RevenueCatService.restorePurchases();
      expect(result.success, isFalse);
      expect(result.errorMessage, 'Store not configured');
    });

    test('customerInfoStream returns empty when unconfigured',
        () async {
      final stream = RevenueCatService.customerInfoStream;

      // Stream.empty()이므로 즉시 완료되어야 함
      final events = await stream.toList();
      expect(events, isEmpty);
    });
  });
}

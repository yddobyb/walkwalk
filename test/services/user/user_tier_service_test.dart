// test/services/user/user_tier_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/user/user_tier_service.dart';

void main() {
  group('UserTierService', () {
    late UserTierService service;

    setUp(() {
      service = UserTierService();
    });

    test('getCurrentTier returns free when RevenueCat unconfigured',
        () async {
      // RevenueCat API 키가 플레이스홀더이므로
      // hasPremiumEntitlement()는 항상 false 반환
      final tier = await service.getCurrentTier();
      expect(tier, equals(UserTier.free));
    });

    test('isPremium returns false when unconfigured', () async {
      final isPremium = await service.isPremium();
      expect(isPremium, isFalse);
    });

    test('isFree returns true when unconfigured', () async {
      final isFree = await service.isFree();
      expect(isFree, isTrue);
    });
  });

  group('UserTier enum', () {
    test('free tier has correct display name', () {
      expect(UserTier.free.displayName, equals('Free'));
    });

    test('premium tier has correct display name', () {
      expect(UserTier.premium.displayName, equals('Premium'));
    });

    test('free tier has daily limit of 10', () {
      expect(UserTier.free.dailyImageLimit, equals(10));
    });

    test('premium tier has daily limit of 50', () {
      expect(UserTier.premium.dailyImageLimit, equals(50));
    });

    test('free tier uses genStickerFree function', () {
      expect(
        UserTier.free.cloudFunctionName,
        equals('genStickerFree'),
      );
    });

    test('premium tier uses genSticker function', () {
      expect(
        UserTier.premium.cloudFunctionName,
        equals('genSticker'),
      );
    });

    test('UserTier has exactly 2 values', () {
      expect(UserTier.values.length, equals(2));
      expect(
        UserTier.values,
        containsAll([UserTier.free, UserTier.premium]),
      );
    });
  });

  group('UserTierExtension', () {
    test('all tiers have non-empty displayName', () {
      for (final tier in UserTier.values) {
        expect(tier.displayName, isNotEmpty);
      }
    });

    test('all tiers have positive dailyImageLimit', () {
      for (final tier in UserTier.values) {
        expect(tier.dailyImageLimit, greaterThan(0));
      }
    });

    test('premium limit is greater than free limit', () {
      expect(
        UserTier.premium.dailyImageLimit,
        greaterThan(UserTier.free.dailyImageLimit),
      );
    });

    test('all tiers have non-empty cloudFunctionName', () {
      for (final tier in UserTier.values) {
        expect(tier.cloudFunctionName, isNotEmpty);
      }
    });

    test('free and premium use different cloud functions', () {
      expect(
        UserTier.free.cloudFunctionName,
        isNot(equals(UserTier.premium.cloudFunctionName)),
      );
    });
  });
}

// test/services/user/user_tier_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/user/user_tier_service.dart';

void main() {
  group('UserTierService', () {
    late UserTierService service;

    setUp(() {
      service = UserTierService();
    });

    test('getCurrentTier returns free for MVP', () async {
      final tier = await service.getCurrentTier();
      expect(tier, equals(UserTier.free));
    });

    test('isPremium returns false for MVP', () async {
      final isPremium = await service.isPremium();
      expect(isPremium, isFalse);
    });

    test('isFree returns true for MVP', () async {
      final isFree = await service.isFree();
      expect(isFree, isTrue);
    });
  });

  group('UserTier', () {
    test('free tier has correct display name', () {
      expect(UserTier.free.displayName, equals('무료'));
    });

    test('premium tier has correct display name', () {
      expect(UserTier.premium.displayName, equals('프리미엄'));
    });

    test('free tier has daily limit of 10', () {
      expect(UserTier.free.dailyImageLimit, equals(10));
    });

    test('premium tier has daily limit of 50', () {
      expect(UserTier.premium.dailyImageLimit, equals(50));
    });

    test('free tier uses genStickerFree function', () {
      expect(UserTier.free.cloudFunctionName, equals('genStickerFree'));
    });

    test('premium tier uses genSticker function', () {
      expect(UserTier.premium.cloudFunctionName, equals('genSticker'));
    });
  });
}

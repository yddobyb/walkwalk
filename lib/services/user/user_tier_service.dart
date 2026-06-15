// lib/services/user/user_tier_service.dart

import 'package:flutter/foundation.dart';

import '../subscription/revenue_cat_service.dart';

/// 사용자 등급
enum UserTier {
  /// 무료 사용자 - genStickerFree 사용 (Cloudflare -> OpenAI 폴백)
  free,

  /// 프리미엄 사용자 - genSticker 사용 (Gemini)
  premium,
}

/// 사용자 등급 서비스
///
/// RevenueCat 엔타이틀먼트로 구독 상태를 확인한다.
/// SDK가 미설정(플레이스홀더 키)이면 모든 사용자를 무료로 처리.
class UserTierService {
  /// 현재 사용자 등급 조회
  Future<UserTier> getCurrentTier() async {
    debugPrint('[UserTier] Checking user tier...');

    final isPremium =
        await RevenueCatService.hasPremiumEntitlement();
    final tier =
        isPremium ? UserTier.premium : UserTier.free;

    debugPrint('[UserTier] Current tier: ${tier.name}');
    return tier;
  }

  /// 프리미엄 여부 확인
  Future<bool> isPremium() async {
    final tier = await getCurrentTier();
    return tier == UserTier.premium;
  }

  /// 무료 여부 확인
  Future<bool> isFree() async {
    final tier = await getCurrentTier();
    return tier == UserTier.free;
  }
}

/// UserTier 확장 메서드
extension UserTierExtension on UserTier {
  /// 표시 이름 (로그/디버그용, UI에는 l10n 사용)
  String get displayName {
    switch (this) {
      case UserTier.free:
        return 'Free';
      case UserTier.premium:
        return 'Premium';
    }
  }

  /// 일일 이미지 생성 기본 한도 (참고용 — 실제 한도는 서버 quota가 권위)
  /// 무료 2회(+리워드 광고 보너스 최대 2회), 프리미엄 5회
  int get dailyImageLimit {
    switch (this) {
      case UserTier.free:
        return 2;
      case UserTier.premium:
        return 5;
    }
  }

  /// 사용되는 Cloud Function 이름
  String get cloudFunctionName {
    switch (this) {
      case UserTier.free:
        return 'genStickerFree';
      case UserTier.premium:
        return 'genSticker';
    }
  }
}

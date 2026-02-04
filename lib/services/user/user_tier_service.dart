// lib/services/user/user_tier_service.dart

import 'package:flutter/foundation.dart';

/// 사용자 등급
///
/// MVP: 모든 사용자는 무료(free)로 시작
/// 추후: 프리미엄 구독 시스템 연동 예정
enum UserTier {
  /// 무료 사용자 - genStickerFree 사용 (Pixazo → OpenAI 폴백)
  free,

  /// 프리미엄 사용자 - genSticker 사용 (Gemini)
  premium,
}

/// 사용자 등급 서비스
///
/// MVP: 모든 사용자를 무료로 처리
/// 추후: Firestore에서 구독 상태 확인 또는 RevenueCat 등 연동
class UserTierService {
  /// 현재 사용자 등급 조회
  ///
  /// MVP: 항상 free 반환
  /// 추후: 실제 구독 상태 확인 로직 추가
  Future<UserTier> getCurrentTier() async {
    // TODO: 실제 구독 상태 확인 로직 구현
    // - Firestore에서 users/{uid}/subscription 확인
    // - 또는 RevenueCat SDK 사용
    // - 또는 StoreKit/Google Play Billing 연동

    debugPrint('👤 [UserTier] Checking user tier...');

    // MVP: 모든 사용자는 무료
    const tier = UserTier.free;
    debugPrint('👤 [UserTier] Current tier: ${tier.name}');

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
  /// 표시 이름
  String get displayName {
    switch (this) {
      case UserTier.free:
        return '무료';
      case UserTier.premium:
        return '프리미엄';
    }
  }

  /// 일일 이미지 생성 한도
  int get dailyImageLimit {
    switch (this) {
      case UserTier.free:
        return 10;
      case UserTier.premium:
        return 50;
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

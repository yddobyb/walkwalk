// lib/core/constants/ad_constants.dart
import 'dart:io';

/// AdMob 광고 ID 상수
///
/// ⚠️ 현재 [useTestAds] = true → 구글 공식 테스트 광고 단위 사용.
/// 출시 전 체크리스트:
///   1) useTestAds = false 로 변경
///   2) 아래 _real* 에 AdMob 콘솔에서 발급한 실제 광고 단위 ID 입력
///   3) AndroidManifest.xml / ios Info.plist 의 App ID도 실제값으로 교체
class AdConstants {
  AdConstants._();

  /// true면 구글 테스트 광고, false면 실제 광고 단위 사용
  static const bool useTestAds = true;

  /// 무료 유저가 리워드 광고로 추가 생성할 수 있는 최대 이미지 수 (기본 1 + 이만큼).
  /// 서버 genStickerFree 하드캡(=quota.ts의 free.dailyQuota + 이값)과 반드시 일치해야 함.
  /// Phase 28-9: 프리미엄(5장)과 격차를 벌리려고 무료를 최대 4장 → 2장으로 축소.
  static const int maxImageAdBonus = 1;

  // --- 구글 공식 테스트 광고 단위 ID (안전하게 테스트 광고만 노출) ---
  static const String _testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIos =
      'ca-app-pub-3940256099942544/1712485313';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos =
      'ca-app-pub-3940256099942544/2934735716';

  // --- 실제 광고 단위 ID (AdMob 계정 생성 후 입력) ---
  static const String _realRewardedAndroid = 'TODO_REPLACE_REWARDED_ANDROID';
  static const String _realRewardedIos = 'TODO_REPLACE_REWARDED_IOS';
  static const String _realInterstitialAndroid =
      'TODO_REPLACE_INTERSTITIAL_ANDROID';
  static const String _realInterstitialIos = 'TODO_REPLACE_INTERSTITIAL_IOS';
  static const String _realBannerAndroid = 'TODO_REPLACE_BANNER_ANDROID';
  static const String _realBannerIos = 'TODO_REPLACE_BANNER_IOS';

  /// 리워드 광고 단위 ID (플랫폼 + 테스트 여부 자동 선택)
  static String get rewardedUnitId {
    if (Platform.isIOS) {
      return useTestAds ? _testRewardedIos : _realRewardedIos;
    }
    return useTestAds ? _testRewardedAndroid : _realRewardedAndroid;
  }

  /// 전면 광고 단위 ID (플랫폼 + 테스트 여부 자동 선택)
  static String get interstitialUnitId {
    if (Platform.isIOS) {
      return useTestAds ? _testInterstitialIos : _realInterstitialIos;
    }
    return useTestAds ? _testInterstitialAndroid : _realInterstitialAndroid;
  }

  /// 배너 광고 단위 ID (커스터마이즈 탭 하단, Phase 28-10)
  static String get bannerUnitId {
    if (Platform.isIOS) {
      return useTestAds ? _testBannerIos : _realBannerIos;
    }
    return useTestAds ? _testBannerAndroid : _realBannerAndroid;
  }
}

// lib/services/ads/ad_service.dart
import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/ad_constants.dart';

/// 광고 서비스 (AdMob)
///
/// - UMP 동의(EEA GDPR) + iOS ATT 처리
/// - 리워드/전면 광고 로드·표시·자동 재로드
/// - 프리미엄 분기는 호출부(UI)가 isPremium 확인 후 호출 (프리미엄은 광고 미표시)
///
/// ⚠️ **[initialize]는 무료 이용자에게만 호출할 것** (Phase 28-8).
/// 예전엔 `main()`에서 등급과 무관하게 호출했는데, 그러면 광고를 없애려고
/// 결제한 이용자에게도 ATT 추적 동의 팝업이 뜨고 광고 요청이 나가면서
/// 광고 식별자가 AdMob으로 전달됐다. 처리방침의 "광고 식별자 처리(무료
/// 이용자 한정)"와 어긋나는 동작이었다.
/// 이제 [AdGate]가 등급이 확정된 뒤 free일 때만 호출한다.
///
/// ⚠️ 광고 단위/앱 ID는 테스트값([AdConstants.useTestAds]). 출시 전 실제 ID 교체.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _initialized = false;

  RewardedAd? _rewardedAd;
  bool _rewardedLoading = false;

  InterstitialAd? _interstitialAd;
  bool _interstitialLoading = false;

  bool get isRewardedReady => _rewardedAd != null;
  bool get isInterstitialReady => _interstitialAd != null;

  /// 초기화: iOS ATT + UMP 동의 → 광고 미리 로드.
  /// MobileAds.initialize() 이후 호출. 중복 호출은 무시.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // 0. AdMob SDK 초기화 — 무료 이용자로 확정된 뒤에야 SDK를 올린다.
    //    (예전엔 main()에서 등급 확인 전에 호출했다)
    try {
      await MobileAds.instance.initialize();
      debugPrint('[Ads] ✅ MobileAds initialized');
    } catch (e) {
      debugPrint('[Ads] ❌ MobileAds init failed: $e');
    }

    // 1. iOS ATT (App Tracking Transparency) — Android에서는 no-op
    if (Platform.isIOS) {
      try {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } catch (e) {
        debugPrint('[Ads] ATT request error: $e');
      }
    }

    // 2. UMP 동의 (EEA 대상이면 폼 표시, 아니면 통과)
    await _requestConsent();

    // 3. 광고 미리 로드
    loadRewarded();
    loadInterstitial();
  }

  /// UMP 동의 정보 갱신 + 필요 시 동의 폼 표시. EEA 비대상이면 즉시 완료.
  Future<void> _requestConsent() async {
    final completer = Completer<void>();
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          try {
            ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
              if (error != null) {
                debugPrint('[Ads] Consent form error: ${error.message}');
              } else {
                debugPrint('[Ads] ✅ Consent flow complete');
              }
              if (!completer.isCompleted) completer.complete();
            });
          } catch (e) {
            debugPrint('[Ads] Consent form exception: $e');
            if (!completer.isCompleted) completer.complete();
          }
        },
        (FormError error) {
          debugPrint('[Ads] Consent info error: ${error.message}');
          if (!completer.isCompleted) completer.complete();
        },
      );
    } catch (e) {
      debugPrint('[Ads] Consent request exception: $e');
      if (!completer.isCompleted) completer.complete();
    }
    return completer.future;
  }

  // ==================== 리워드 광고 ====================

  /// 리워드 광고 미리 로드 (이미 로드됐거나 로딩 중이면 무시)
  void loadRewarded() {
    if (_rewardedLoading || _rewardedAd != null) return;
    _rewardedLoading = true;
    RewardedAd.load(
      adUnitId: AdConstants.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoading = false;
          debugPrint('[Ads] ✅ Rewarded loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _rewardedLoading = false;
          debugPrint(
              '[Ads] ❌ Rewarded load failed: ${error.code} ${error.message}');
        },
      ),
    );
  }

  /// 리워드 광고 표시.
  /// - 보상 획득 시 [onReward] 호출
  /// - 광고가 준비 안 됐거나 표시 실패 시 [onUnavailable] 호출
  Future<void> showRewarded({
    required VoidCallback onReward,
    VoidCallback? onUnavailable,
  }) async {
    final ad = _rewardedAd;
    if (ad == null) {
      debugPrint('[Ads] Rewarded not ready — loading for next time');
      loadRewarded();
      onUnavailable?.call();
      return;
    }
    _rewardedAd = null; // 한 번 표시한 광고는 폐기

    // 보상은 광고가 닫혀 앱이 resume된 뒤 처리해야 한다.
    // onUserEarnedReward는 전면 광고가 떠 있는(앱 paused) 동안 호출돼,
    // 거기서 생성하면 상태는 바뀌어도 화면 리빌드가 안 돼 결과가 안 보였음.
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewarded(); // 다음 표시를 위해 미리 로드
        if (earned) onReward(); // 광고 닫힌 뒤(앱 resume) 보상 처리 → 화면 반영
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[Ads] Rewarded show failed: ${error.message}');
        ad.dispose();
        loadRewarded();
        onUnavailable?.call();
      },
    );

    await ad.show(onUserEarnedReward: (ad, reward) {
      debugPrint('[Ads] 🎁 Reward earned: ${reward.amount} ${reward.type}');
      earned = true; // 기록만 — 실제 보상 처리는 onAdDismissed에서
    });
  }

  // ==================== 전면 광고 ====================

  /// 전면 광고 미리 로드 (이미 로드됐거나 로딩 중이면 무시)
  void loadInterstitial() {
    if (_interstitialLoading || _interstitialAd != null) return;
    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdConstants.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoading = false;
          debugPrint('[Ads] ✅ Interstitial loaded');
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _interstitialLoading = false;
          debugPrint(
              '[Ads] ❌ Interstitial load failed: ${error.code} ${error.message}');
        },
      ),
    );
  }

  /// 전면 광고 표시. 준비 안 됐으면 표시 없이 다음을 위해 로드만.
  void showInterstitial() {
    final ad = _interstitialAd;
    if (ad == null) {
      debugPrint('[Ads] Interstitial not ready — loading for next time');
      loadInterstitial();
      return;
    }
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[Ads] Interstitial show failed: ${error.message}');
        ad.dispose();
        loadInterstitial();
      },
    );

    ad.show();
  }

  // ============ 산책 후 전면광고 ============
  // 사용자 요청: 첫 산책 완료부터 매 산책마다 전면광고 (면제·N회마다·일일캡 없음).
  // 프리미엄은 제외. 직전 광고 표시 후 재로드(~1-2초) 전이면 자연히 생략돼,
  // 빠른 시작/종료 연타 시 광고 도배는 방지된다.

  /// 산책 완료 시마다 전면광고 표시 (프리미엄 제외, 레벨업 산책은 호출부에서 제외).
  void maybeShowWalkInterstitial({required bool isPremium}) {
    if (isPremium) return;
    if (!isInterstitialReady) {
      loadInterstitial();
      return;
    }
    debugPrint('[Ads] Showing walk interstitial (every walk completion)');
    showInterstitial();
  }
}

/// AdService 프로바이더 (싱글톤 래핑)
final adServiceProvider = Provider<AdService>((ref) => AdService.instance);

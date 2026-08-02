// lib/presentation/widgets/ad_banner.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/ad_constants.dart';
import '../../services/user/user_tier_providers.dart';

/// 하단 배너 광고 (Phase 28-10).
///
/// 무료 이용자에게만 표시하고, 프리미엄이거나 아직 등급을 모르는 동안에는
/// **아무 공간도 차지하지 않는다**. 로드 실패 시에도 마찬가지라
/// 빈 회색 박스가 남지 않는다.
///
/// 배치 원칙(AdMob·Play 정책):
/// - 탭 가능한 요소 바로 옆에 붙이지 말 것 — 오클릭은 계정 정지 사유
/// - 콘텐츠를 가리지 않도록 스크롤 영역 **바깥** 하단에 둘 것
class AdBanner extends ConsumerStatefulWidget {
  const AdBanner({super.key});

  @override
  ConsumerState<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends ConsumerState<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _requested = false;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  void _load() {
    if (_requested) return;
    _requested = true;

    final ad = BannerAd(
      adUnitId: AdConstants.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[Ads] ❌ Banner load failed: ${error.code} ${error.message}');
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumUserProvider).valueOrNull;

    // 등급 미확정(null)이면 아직 아무것도 하지 않는다 —
    // 프리미엄인데 잠깐이라도 광고를 요청하는 일이 없도록.
    if (isPremium == null || isPremium) return const SizedBox.shrink();

    _load();

    if (!_loaded || _ad == null) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: SizedBox(
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}

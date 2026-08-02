// lib/services/ads/ad_gate.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user/user_tier_providers.dart';
import '../user/user_tier_service.dart';
import 'ad_service.dart';

/// 광고 SDK 초기화 게이트 (Phase 28-8).
///
/// 등급이 **free로 확정된 뒤에만** [AdService.initialize]를 호출한다.
///
/// 왜 필요한가: 예전엔 `main()`에서 등급과 무관하게 초기화했는데, 그러면
/// 광고를 없애려고 결제한 이용자에게도 ⓐ iOS ATT 추적 동의 팝업이 뜨고
/// ⓑ 광고 요청이 나가면서 광고 식별자가 AdMob으로 전달됐다.
/// 처리방침의 "광고 식별자 처리(무료 이용자 한정)"와 어긋나는 동작이었다.
/// `main()` 시점엔 로그인·Firestore 조회 전이라 등급을 알 수 없어서,
/// 등급 provider가 값을 낼 때까지 미루는 구조가 필요하다.
///
/// 등급 변동 처리:
/// - 프리미엄 → 무료(만료·해지): 이 시점에 초기화가 일어난다
/// - 무료 → 프리미엄(업그레이드): 이미 초기화된 SDK는 그대로 두되,
///   표시는 호출부의 `isPremium` 게이트가 계속 막는다
///   (초기화 자체를 되돌릴 수는 없으므로 "무료였던 적이 있으면 초기화됨"이 된다)
class AdGate extends ConsumerWidget {
  const AdGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 등급이 확정될 때마다 평가한다(최초 로드 + 이후 변동 모두).
    // 빌드 중 부수효과를 피해 프레임 이후로 미루며,
    // AdService.initialize()는 멱등이라 여러 번 불려도 초기화는 한 번뿐이다.
    final tier = ref.watch(currentUserTierProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeInit(tier));

    return child;
  }

  void _maybeInit(AsyncValue<UserTier> tier) {
    tier.whenData((value) {
      if (value == UserTier.premium) {
        debugPrint('[Ads] 프리미엄 — 광고 SDK 초기화를 건너뜁니다');
        return;
      }
      AdService.instance.initialize();
    });
  }
}

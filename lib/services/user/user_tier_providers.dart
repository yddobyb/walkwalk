// lib/services/user/user_tier_providers.dart

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../subscription/revenue_cat_service.dart';
import 'user_tier_service.dart';

part 'user_tier_providers.g.dart';

/// UserTierService 프로바이더
@riverpod
UserTierService userTierService(Ref ref) {
  return UserTierService();
}

/// 현재 사용자 등급 프로바이더
///
/// RevenueCat customerInfoStream을 구독하여
/// 구독 상태 변경 시 자동으로 갱신된다.
@Riverpod(keepAlive: true)
class CurrentUserTier extends _$CurrentUserTier {
  StreamSubscription<dynamic>? _sub;

  @override
  Future<UserTier> build() async {
    // 구독 변경 시 자동 갱신
    if (RevenueCatService.isConfigured) {
      _sub?.cancel();
      _sub = RevenueCatService.customerInfoStream.listen(
        (_) => ref.invalidateSelf(),
      );
      ref.onDispose(() => _sub?.cancel());
    }

    final service = ref.watch(userTierServiceProvider);
    return service.getCurrentTier();
  }
}

/// 프리미엄 여부 프로바이더
@riverpod
Future<bool> isPremiumUser(Ref ref) async {
  final tier = await ref.watch(currentUserTierProvider.future);
  return tier == UserTier.premium;
}

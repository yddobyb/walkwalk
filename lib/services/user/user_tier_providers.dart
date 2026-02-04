// lib/services/user/user_tier_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_tier_service.dart';

part 'user_tier_providers.g.dart';

/// UserTierService 프로바이더
@riverpod
UserTierService userTierService(Ref ref) {
  return UserTierService();
}

/// 현재 사용자 등급 프로바이더
@riverpod
Future<UserTier> currentUserTier(Ref ref) async {
  final service = ref.watch(userTierServiceProvider);
  return service.getCurrentTier();
}

/// 프리미엄 여부 프로바이더
@riverpod
Future<bool> isPremiumUser(Ref ref) async {
  final tier = await ref.watch(currentUserTierProvider.future);
  return tier == UserTier.premium;
}

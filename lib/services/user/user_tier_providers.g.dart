// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_tier_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userTierServiceHash() => r'20f067ca0170f79a86f69f85eb3710eb326a0570';

/// UserTierService 프로바이더
///
/// Copied from [userTierService].
@ProviderFor(userTierService)
final userTierServiceProvider = AutoDisposeProvider<UserTierService>.internal(
  userTierService,
  name: r'userTierServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userTierServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserTierServiceRef = AutoDisposeProviderRef<UserTierService>;
String _$isPremiumUserHash() => r'2320543c1fc3412957e04900b4ba840c01c7d8f4';

/// 프리미엄 여부 프로바이더
///
/// Copied from [isPremiumUser].
@ProviderFor(isPremiumUser)
final isPremiumUserProvider = AutoDisposeFutureProvider<bool>.internal(
  isPremiumUser,
  name: r'isPremiumUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPremiumUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsPremiumUserRef = AutoDisposeFutureProviderRef<bool>;
String _$currentUserTierHash() => r'0bc0b6f3c0eb7dd7388b36e25180543c60950bf7';

/// 현재 사용자 등급 프로바이더
///
/// RevenueCat customerInfoStream을 구독하여
/// 구독 상태 변경 시 자동으로 갱신된다.
///
/// Copied from [CurrentUserTier].
@ProviderFor(CurrentUserTier)
final currentUserTierProvider =
    AsyncNotifierProvider<CurrentUserTier, UserTier>.internal(
  CurrentUserTier.new,
  name: r'currentUserTierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserTierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUserTier = AsyncNotifier<UserTier>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

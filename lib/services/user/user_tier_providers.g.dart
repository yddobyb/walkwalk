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
String _$currentUserTierHash() => r'4489790a79a68d4202199d2aeee301e9eb33faeb';

/// 현재 사용자 등급 프로바이더
///
/// Copied from [currentUserTier].
@ProviderFor(currentUserTier)
final currentUserTierProvider = AutoDisposeFutureProvider<UserTier>.internal(
  currentUserTier,
  name: r'currentUserTierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserTierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserTierRef = AutoDisposeFutureProviderRef<UserTier>;
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

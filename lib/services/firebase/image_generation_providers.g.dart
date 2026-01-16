// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_generation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$imageCacheServiceHash() => r'cce93ea435aa7351bc1576a057f75f390f658010';

/// 이미지 캐시 서비스 프로바이더
///
/// Copied from [imageCacheService].
@ProviderFor(imageCacheService)
final imageCacheServiceProvider =
    AutoDisposeProvider<ImageCacheService>.internal(
  imageCacheService,
  name: r'imageCacheServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$imageCacheServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImageCacheServiceRef = AutoDisposeProviderRef<ImageCacheService>;
String _$imageGenerationServiceHash() =>
    r'2a713003acba878f49ba53421f6fd9c33e85f35c';

/// 이미지 생성 서비스 프로바이더
///
/// Copied from [imageGenerationService].
@ProviderFor(imageGenerationService)
final imageGenerationServiceProvider =
    AutoDisposeProvider<ImageGenerationService>.internal(
  imageGenerationService,
  name: r'imageGenerationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$imageGenerationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImageGenerationServiceRef
    = AutoDisposeProviderRef<ImageGenerationService>;
String _$quotaServiceHash() => r'270205f0c14299bb672c0357870320b9f9536bc8';

/// 할당량 서비스 프로바이더
///
/// Copied from [quotaService].
@ProviderFor(quotaService)
final quotaServiceProvider = AutoDisposeProvider<QuotaService>.internal(
  quotaService,
  name: r'quotaServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$quotaServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef QuotaServiceRef = AutoDisposeProviderRef<QuotaService>;
String _$quotaHash() => r'fa66e66f3d799b003bdb1bfa1a6080daaa509c7c';

/// 할당량 조회 프로바이더
///
/// Copied from [quota].
@ProviderFor(quota)
final quotaProvider = AutoDisposeFutureProvider<QuotaData>.internal(
  quota,
  name: r'quotaProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$quotaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef QuotaRef = AutoDisposeFutureProviderRef<QuotaData>;
String _$stickerGeneratorHash() => r'f9d6b796df517a24249b0d9cc896530b14c603cf';

/// 스티커 생성 프로바이더
///
/// Copied from [StickerGenerator].
@ProviderFor(StickerGenerator)
final stickerGeneratorProvider = AutoDisposeAsyncNotifierProvider<
    StickerGenerator, StickerResponse?>.internal(
  StickerGenerator.new,
  name: r'stickerGeneratorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stickerGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StickerGenerator = AutoDisposeAsyncNotifier<StickerResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

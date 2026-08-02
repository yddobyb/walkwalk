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
String _$quotaHash() => r'af545192fcf8abd6ced1a9fa6ac7b04418cb149f';

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
String _$stickerGeneratorHash() => r'62c63b9d61658f0da68003b9662cfc4d56f0581d';

/// 스티커 생성 프로바이더
///
/// 사용자 등급에 따라 적절한 Cloud Function 호출:
/// - Free: genStickerFree (Cloudflare → OpenAI 폴백)
/// - Premium: genSticker (Gemini)
///
/// keepAlive: 리워드 전면 광고(풀스크린) 동안 autoDispose로 상태가 리셋돼
/// 광고 후 생성 결과가 사라지던 문제 방지.
///
/// Copied from [StickerGenerator].
@ProviderFor(StickerGenerator)
final stickerGeneratorProvider =
    AsyncNotifierProvider<StickerGenerator, StickerResponse?>.internal(
  StickerGenerator.new,
  name: r'stickerGeneratorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stickerGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StickerGenerator = AsyncNotifier<StickerResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

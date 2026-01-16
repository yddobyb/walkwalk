// lib/services/firebase/image_generation_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/quota_response.dart';
import '../../data/models/sticker_request.dart';
import '../../data/models/sticker_response.dart';
import '../cache/image_cache_service.dart';
import 'image_generation_service.dart';
import 'quota_service.dart';

part 'image_generation_providers.g.dart';

/// 이미지 캐시 서비스 프로바이더
@riverpod
ImageCacheService imageCacheService(Ref ref) {
  return ImageCacheService();
}

/// 이미지 생성 서비스 프로바이더
@riverpod
ImageGenerationService imageGenerationService(Ref ref) {
  final cacheService = ref.watch(imageCacheServiceProvider);
  return ImageGenerationService(cacheService: cacheService);
}

/// 할당량 서비스 프로바이더
@riverpod
QuotaService quotaService(Ref ref) {
  return QuotaService();
}

/// 할당량 조회 프로바이더
@riverpod
Future<QuotaData> quota(Ref ref) async {
  final service = ref.watch(quotaServiceProvider);
  final response = await service.getQuota();
  return response.data;
}

/// 스티커 생성 프로바이더
@riverpod
class StickerGenerator extends _$StickerGenerator {
  @override
  FutureOr<StickerResponse?> build() {
    return null;
  }

  /// 스티커 생성
  Future<void> generate(StickerRequest request) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(imageGenerationServiceProvider);
      final response = await service.generateSticker(request);

      // 할당량 새로고침
      ref.invalidate(quotaProvider);

      return response;
    });
  }

  /// 상태 초기화
  void reset() {
    state = const AsyncValue.data(null);
  }
}

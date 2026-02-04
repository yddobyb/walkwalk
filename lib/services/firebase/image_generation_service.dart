// lib/services/firebase/image_generation_service.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/sticker_request.dart';
import '../../data/models/sticker_response.dart';
import '../cache/image_cache_service.dart';

/// 이미지 생성 서비스
///
/// Week 4: Firebase Cloud Functions를 통한 Gemini 이미지 생성
/// Phase 4: 로컬 이미지 캐싱 시스템 통합
///
/// Usage:
/// ```dart
/// final cacheService = ImageCacheService();
/// await cacheService.initialize();
/// final service = ImageGenerationService(cacheService: cacheService);
/// final response = await service.generateSticker(request);
/// final imageBytes = service.decodeBase64Image(response.data.imageBase64);
/// ```
class ImageGenerationService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');
  final ImageCacheService? cacheService;

  ImageGenerationService({this.cacheService});

  /// 스티커 생성
  ///
  /// [request] 스티커 생성 요청
  ///
  /// Returns: 스티커 응답 (Base64 인코딩된 WebP 이미지 포함)
  ///
  /// Phase 4: 로컬 캐시 우선 전략
  /// 1. 로컬 캐시 확인
  /// 2. 캐시 미스 → Cloud Functions 호출
  /// 3. 응답 로컬 캐시 저장
  ///
  /// Throws:
  /// - [FirebaseFunctionsException] API 호출 실패
  /// - [FormatException] 응답 파싱 실패
  Future<StickerResponse> generateSticker(StickerRequest request) async {
    try {
      print('🎨🎨🎨 [STICKER] Generating sticker for petId: ${request.petId}');
      print('   - Breed: ${request.breed}');
      print('   - Color: ${request.color}');
      print('   - Accessory: ${request.accessory.name}');
      print('   - Style: ${request.style.name}');
      print('   - Size: ${request.size}');
      print('   - Force: ${request.force}');

      // 인증 확인 및 필요시 재인증
      await _ensureAuthenticated();

      // Phase 4: 로컬 캐시 확인 (force=false일 때만)
      if (!request.force && cacheService != null) {
        final cachedImage = await cacheService!.getCachedImage(request);
        if (cachedImage != null) {
          debugPrint('✅ Using cached image (local)');
          final base64Image = base64Encode(cachedImage);
          return StickerResponse(
            success: true,
            data: StickerData(
              imageBase64: base64Image,
              mime: 'image/webp',
              seed: 0, // 캐시에서는 seed 알 수 없음
              cached: true,
              size: StickerSize(width: request.size, height: request.size),
              metadata: StickerMetadata(
                breed: request.breed,
                color: request.color,
                accessory: _accessoryToString(request.accessory),
                style: _styleToString(request.style),
              ),
            ),
          );
        }
      }

      // Phase 4: 네트워크 연결 확인
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.contains(ConnectivityResult.none);

      if (isOffline) {
        debugPrint('❌ Network offline - cannot generate new sticker');
        throw ImageGenerationException(
          code: 'offline',
          message: 'No internet connection. Please check your network and try again.',
        );
      }

      // 캐시 미스 → Cloud Functions 호출 (재시도 로직 포함)
      print('📞 [STICKER] Calling Cloud Functions...');
      final callable = _functions.httpsCallable('genSticker');

      // userId를 직접 전달 (auth context가 전달되지 않는 문제 우회)
      final user = FirebaseAuth.instance.currentUser;
      print('   - Auth user: ${user?.uid ?? "NOT AUTHENTICATED"}');

      final result = await _callWithRetry(() async {
        print('📡 [STICKER] Making API call to genSticker');
        return await callable.call<Map<String, dynamic>>({
          'petId': request.petId,
          'breed': request.breed,
          'color': request.color,
          'accessory': _accessoryToString(request.accessory),
          'style': _styleToString(request.style),
          'size': request.size,
          'bg': _backgroundToString(request.bg),
          if (request.seed != null) 'seed': request.seed,
          'force': request.force,
          'userId': user?.uid, // auth context 우회
        });
      });

      print('📦 [STICKER] Received result from Cloud Functions');
      print('   - Result type: ${result.runtimeType}');
      print('   - Result.data type: ${result.data.runtimeType}');

      // result.data는 Map<Object?, Object?>이므로 깊은 복사로 Map<String, dynamic>으로 변환
      final rawData = result.data as Map;
      final data = _deepCopyMap(rawData);
      print('✅ [STICKER] Data deep copy successful');
      print('   - Data keys: ${data.keys.join(", ")}');

      final response = StickerResponse.fromJson(data);
      print('✅ [STICKER] Response parsing successful');

      debugPrint('✅ Sticker generated successfully');
      debugPrint('   - Cached: ${response.data.cached}');
      debugPrint('   - Seed: ${response.data.seed}');
      debugPrint('   - Size: ${response.data.size.width}x${response.data.size.height}');

      // Phase 4: 로컬 캐시에 저장 (백엔드에서 캐시 미스인 경우만)
      if (!response.data.cached && cacheService != null) {
        final imageBytes = decodeBase64Image(response.data.imageBase64);
        await cacheService!.cacheImage(
          request,
          imageBytes,
          seed: response.data.seed,
        );
        debugPrint('💾 Image saved to local cache');
      }

      return response;
    } on FirebaseFunctionsException catch (e) {
      print('❌❌❌ [STICKER] FirebaseFunctionsException: ${e.code}');
      print('   Message: ${e.message}');
      print('   Details: ${e.details}');

      throw ImageGenerationException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    } catch (e, stackTrace) {
      print('❌❌❌ [STICKER] Unexpected error: $e');
      print('   Type: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');

      throw ImageGenerationException(
        code: 'unknown',
        message: e.toString(),
      );
    }
  }

  /// 무료 사용자용 스티커 생성
  ///
  /// [request] 스티커 생성 요청
  ///
  /// Returns: 스티커 응답 (Base64 인코딩된 WebP 이미지 포함)
  ///
  /// genStickerFree Cloud Function 호출 (Pixazo → OpenAI 폴백)
  /// 응답에 provider, estimatedCost, attempts 정보 포함
  ///
  /// Throws:
  /// - [FirebaseFunctionsException] API 호출 실패
  /// - [FormatException] 응답 파싱 실패
  Future<StickerResponse> generateStickerFree(StickerRequest request) async {
    try {
      debugPrint('🎨 [STICKER-FREE] Generating sticker for petId: ${request.petId}');
      debugPrint('   - Breed: ${request.breed}');
      debugPrint('   - Color: ${request.color}');
      debugPrint('   - Accessory: ${request.accessory.name}');
      debugPrint('   - Style: ${request.style.name}');
      debugPrint('   - Size: ${request.size}');
      debugPrint('   - Force: ${request.force}');

      // 인증 확인 및 필요시 재인증
      await _ensureAuthenticated();

      // Phase 4: 로컬 캐시 확인 (force=false일 때만)
      if (!request.force && cacheService != null) {
        final cachedImage = await cacheService!.getCachedImage(request);
        if (cachedImage != null) {
          debugPrint('✅ Using cached image (local)');
          final base64Image = base64Encode(cachedImage);
          return StickerResponse(
            success: true,
            data: StickerData(
              imageBase64: base64Image,
              mime: 'image/webp',
              seed: 0, // 캐시에서는 seed 알 수 없음
              cached: true,
              size: StickerSize(width: request.size, height: request.size),
              metadata: StickerMetadata(
                breed: request.breed,
                color: request.color,
                accessory: _accessoryToString(request.accessory),
                style: _styleToString(request.style),
              ),
              provider: 'cache',
              providerName: 'Local Cache',
              estimatedCost: 0,
            ),
          );
        }
      }

      // Phase 4: 네트워크 연결 확인
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.contains(ConnectivityResult.none);

      if (isOffline) {
        debugPrint('❌ Network offline - cannot generate new sticker');
        throw ImageGenerationException(
          code: 'offline',
          message: 'No internet connection. Please check your network and try again.',
        );
      }

      // Cloud Functions 호출 - genStickerFree (Pixazo → OpenAI 폴백)
      debugPrint('📞 [STICKER-FREE] Calling Cloud Functions (genStickerFree)...');
      final callable = _functions.httpsCallable('genStickerFree');

      final user = FirebaseAuth.instance.currentUser;
      debugPrint('   - Auth user: ${user?.uid ?? "NOT AUTHENTICATED"}');

      final result = await _callWithRetry(() async {
        debugPrint('📡 [STICKER-FREE] Making API call to genStickerFree');
        return await callable.call<Map<String, dynamic>>({
          'petId': request.petId,
          'breed': request.breed,
          'color': request.color,
          'accessory': _accessoryToString(request.accessory),
          'style': _styleToString(request.style),
          'size': request.size,
          'bg': _backgroundToString(request.bg),
          if (request.seed != null) 'seed': request.seed,
          'force': request.force,
          'userId': user?.uid, // auth context 우회
        });
      });

      debugPrint('📦 [STICKER-FREE] Received result from Cloud Functions');

      // result.data는 Map<Object?, Object?>이므로 깊은 복사로 변환
      final rawData = result.data as Map;
      final data = _deepCopyMap(rawData);
      debugPrint('✅ [STICKER-FREE] Data deep copy successful');
      debugPrint('   - Data keys: ${data.keys.join(", ")}');

      final response = StickerResponse.fromJson(data);
      debugPrint('✅ [STICKER-FREE] Response parsing successful');

      debugPrint('✅ Sticker generated successfully (Free tier)');
      debugPrint('   - Provider: ${response.data.provider ?? "unknown"}');
      debugPrint('   - Cost: \$${response.data.estimatedCost ?? 0}');
      debugPrint('   - Cached: ${response.data.cached}');
      debugPrint('   - Seed: ${response.data.seed}');
      debugPrint('   - Size: ${response.data.size.width}x${response.data.size.height}');

      // Phase 4: 로컬 캐시에 저장 (백엔드에서 캐시 미스인 경우만)
      if (!response.data.cached && cacheService != null) {
        final imageBytes = decodeBase64Image(response.data.imageBase64);
        await cacheService!.cacheImage(
          request,
          imageBytes,
          seed: response.data.seed,
        );
        debugPrint('💾 Image saved to local cache');
      }

      return response;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ [STICKER-FREE] FirebaseFunctionsException: ${e.code}');
      debugPrint('   Message: ${e.message}');
      debugPrint('   Details: ${e.details}');

      throw ImageGenerationException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ [STICKER-FREE] Unexpected error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');

      throw ImageGenerationException(
        code: 'unknown',
        message: e.toString(),
      );
    }
  }

  /// Base64 이미지 디코딩
  ///
  /// [base64String] Base64 인코딩된 이미지
  ///
  /// Returns: 디코딩된 이미지 바이트
  Uint8List decodeBase64Image(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('❌ Failed to decode base64 image: $e');
      throw const FormatException('Invalid base64 image data');
    }
  }

  // ========== Private Methods ==========

  /// 인증 확인 및 필요시 재인증
  ///
  /// Firebase Functions 호출 전에 인증 상태를 확인하고,
  /// 인증이 없으면 익명 로그인을 시도합니다.
  Future<void> _ensureAuthenticated() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      debugPrint('🔐 [AUTH] No user authenticated, attempting anonymous sign-in...');
      try {
        final credential = await auth.signInAnonymously();
        debugPrint('🔐 [AUTH] ✅ Anonymous sign-in successful: ${credential.user?.uid}');
      } catch (e) {
        debugPrint('🔐 [AUTH] ❌ Anonymous sign-in failed: $e');
        throw ImageGenerationException(
          code: 'unauthenticated',
          message: 'Failed to authenticate. Please restart the app.',
        );
      }
    } else {
      debugPrint('🔐 [AUTH] ✅ User already authenticated: ${user.uid}');
    }
  }

  /// 재시도 로직을 포함한 API 호출
  ///
  /// Phase 4: 자동 재시도
  /// - 최대 3회 재시도
  /// - 지수 백오프 (1초, 2초, 4초)
  /// - 특정 에러는 재시도하지 않음
  Future<T> _callWithRetry<T>(Future<T> Function() apiCall, {int maxRetries = 3}) async {
    int attempts = 0;
    Duration delay = const Duration(seconds: 1);

    while (attempts < maxRetries) {
      try {
        return await apiCall();
      } on FirebaseFunctionsException catch (e) {
        attempts++;

        // 재시도하지 않을 에러
        if (_isNonRetryableError(e.code)) {
          debugPrint('❌ Non-retryable error: ${e.code}');
          rethrow;
        }

        // 마지막 시도였으면 에러 던지기
        if (attempts >= maxRetries) {
          debugPrint('❌ Max retries reached ($maxRetries)');
          rethrow;
        }

        // 재시도 전 대기
        debugPrint('⏳ Retry attempt $attempts/$maxRetries after ${delay.inSeconds}s delay...');
        await Future.delayed(delay);

        // 지수 백오프
        delay *= 2;
      } catch (e) {
        debugPrint('❌ Unexpected error during retry: $e');
        rethrow;
      }
    }

    throw Exception('Unexpected: exceeded max retries');
  }

  /// 재시도하지 않을 에러 판단
  bool _isNonRetryableError(String code) {
    return const [
      'unauthenticated', // 인증 문제
      'invalid-argument', // 잘못된 요청
      'resource-exhausted', // 할당량 초과
      'failed-precondition', // App Check 실패
    ].contains(code);
  }

  // 깊은 복사를 수행하여 Map<Object?, Object?>를 Map<String, dynamic>으로 변환
  Map<String, dynamic> _deepCopyMap(Map rawMap) {
    final result = <String, dynamic>{};
    rawMap.forEach((key, value) {
      if (value is Map) {
        result[key.toString()] = _deepCopyMap(value);
      } else if (value is List) {
        result[key.toString()] = _deepCopyList(value);
      } else {
        result[key.toString()] = value;
      }
    });
    return result;
  }

  List<dynamic> _deepCopyList(List rawList) {
    return rawList.map((item) {
      if (item is Map) {
        return _deepCopyMap(item);
      } else if (item is List) {
        return _deepCopyList(item);
      } else {
        return item;
      }
    }).toList();
  }

  // Enum to String 변환
  String _accessoryToString(StickerAccessory accessory) {
    switch (accessory) {
      case StickerAccessory.none:
        return 'none';
      case StickerAccessory.bandana:
        return 'bandana';
      case StickerAccessory.glasses:
        return 'glasses';
      case StickerAccessory.bowtie:
        return 'bowtie';
      case StickerAccessory.hat:
        return 'hat';
      case StickerAccessory.collar:
        return 'collar';
    }
  }

  String _styleToString(StickerStyle style) {
    switch (style) {
      case StickerStyle.stickerFlat:
        return 'sticker-flat';
      case StickerStyle.sticker3d:
        return 'sticker-3d';
      case StickerStyle.realistic:
        return 'realistic';
    }
  }

  String _backgroundToString(StickerBackground bg) {
    switch (bg) {
      case StickerBackground.transparent:
        return 'transparent';
      case StickerBackground.white:
        return 'white';
      case StickerBackground.gradient:
        return 'gradient';
    }
  }
}

/// 이미지 생성 예외
class ImageGenerationException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  const ImageGenerationException({
    required this.code,
    required this.message,
    this.details,
  });

  /// 사용자 친화적 메시지
  String get userMessage {
    switch (code) {
      case 'offline':
        return '인터넷 연결이 없습니다. 네트워크를 확인하고 다시 시도해주세요.';
      case 'failed-precondition':
        return '앱 보안 인증이 필요합니다. 앱을 재시작해주세요.';
      case 'unauthenticated':
        return '로그인이 필요합니다.';
      case 'invalid-argument':
        return '잘못된 요청입니다. 다시 시도해주세요.';
      case 'resource-exhausted':
        return '일일 생성 한도를 초과했습니다. 내일 다시 시도해주세요.';
      case 'internal':
        return '이미지 생성에 실패했습니다. 잠시 후 다시 시도해주세요.';
      case 'deadline-exceeded':
        return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }

  @override
  String toString() => 'ImageGenerationException($code): $message';
}

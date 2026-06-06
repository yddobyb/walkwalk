// lib/data/models/sticker_response.dart
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sticker_response.freezed.dart';
part 'sticker_response.g.dart';

/// 스티커 생성 응답 모델
///
/// Week 4: Gemini 이미지 생성 API 응답
@freezed
class StickerResponse with _$StickerResponse {
  const factory StickerResponse({
    /// 성공 여부
    required bool success,

    /// 응답 데이터
    required StickerData data,
  }) = _StickerResponse;

  factory StickerResponse.fromJson(Map<String, dynamic> json) =>
      _$StickerResponseFromJson(json);
}

/// 스티커 데이터
@freezed
class StickerData with _$StickerData {
  const factory StickerData({
    /// Base64 인코딩된 WebP 이미지
    @JsonKey(name: 'image_base64') required String imageBase64,

    /// MIME 타입
    @Default("image/webp") String mime,

    /// 생성에 사용된 시드
    required int seed,

    /// 캐시 히트 여부
    @Default(false) bool cached,

    /// 이미지 크기
    required StickerSize size,

    /// 메타데이터 (cached: false일 때만)
    StickerMetadata? metadata,

    // === genStickerFree 추가 필드 ===

    /// 사용된 provider (cloudflare, openai) - genStickerFree 전용
    String? provider,

    /// Provider 표시 이름 - genStickerFree 전용
    String? providerName,

    /// 추정 비용 (USD) - genStickerFree 전용
    double? estimatedCost,

    /// Provider 시도 이력 - genStickerFree 전용
    List<ProviderAttempt>? attempts,
  }) = _StickerData;

  factory StickerData.fromJson(Map<String, dynamic> json) =>
      _$StickerDataFromJson(json);
}

/// 이미지 크기
@freezed
class StickerSize with _$StickerSize {
  const factory StickerSize({
    required int width,
    required int height,
  }) = _StickerSize;

  factory StickerSize.fromJson(Map<String, dynamic> json) =>
      _$StickerSizeFromJson(json);
}

/// 스티커 메타데이터
@freezed
class StickerMetadata with _$StickerMetadata {
  const factory StickerMetadata({
    required String breed,
    required String color,
    required String accessory,
    required String style,
  }) = _StickerMetadata;

  factory StickerMetadata.fromJson(Map<String, dynamic> json) =>
      _$StickerMetadataFromJson(json);
}

/// Provider 시도 이력 - genStickerFree 전용
@freezed
class ProviderAttempt with _$ProviderAttempt {
  const factory ProviderAttempt({
    /// Provider 이름 (cloudflare, openai)
    required String provider,

    /// 성공 여부
    required bool success,

    /// 소요 시간 (ms)
    required int durationMs,

    /// 에러 메시지 (실패 시)
    String? error,
  }) = _ProviderAttempt;

  factory ProviderAttempt.fromJson(Map<String, dynamic> json) =>
      _$ProviderAttemptFromJson(json);
}

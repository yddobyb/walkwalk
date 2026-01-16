// lib/data/models/sticker_request.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sticker_request.freezed.dart';
part 'sticker_request.g.dart';

/// 스티커 생성 요청 모델
///
/// Week 4: Gemini 이미지 생성 API 요청 파라미터
@freezed
class StickerRequest with _$StickerRequest {
  const factory StickerRequest({
    /// 펫 ID (필수)
    required String petId,

    /// 견종 (선택, 기본값: "Shiba Inu")
    @Default("Shiba Inu") String breed,

    /// 색상 (선택, 기본값: "orange")
    @Default("orange") String color,

    /// 액세서리 (선택, 기본값: "none")
    @Default(StickerAccessory.none) StickerAccessory accessory,

    /// 스타일 (선택, 기본값: "sticker-flat")
    @Default(StickerStyle.stickerFlat) StickerStyle style,

    /// 이미지 크기 (선택, 256-1024, 기본값: 512)
    @Default(512) int size,

    /// 배경 (선택, 기본값: "transparent")
    @Default(StickerBackground.transparent) StickerBackground bg,

    /// 시드값 (선택, 재생성 시 동일한 이미지 생성)
    int? seed,

    /// 캐시 무시 (선택, 기본값: false)
    @Default(false) bool force,
  }) = _StickerRequest;

  factory StickerRequest.fromJson(Map<String, dynamic> json) =>
      _$StickerRequestFromJson(json);
}

/// 액세서리 종류
enum StickerAccessory {
  @JsonValue("none")
  none,
  @JsonValue("bandana")
  bandana,
  @JsonValue("glasses")
  glasses,
  @JsonValue("bowtie")
  bowtie,
  @JsonValue("hat")
  hat,
  @JsonValue("collar")
  collar,
}

/// 스티커 스타일
enum StickerStyle {
  @JsonValue("sticker-flat")
  stickerFlat,
  @JsonValue("sticker-3d")
  sticker3d,
  @JsonValue("realistic")
  realistic,
}

/// 배경 종류
enum StickerBackground {
  @JsonValue("transparent")
  transparent,
  @JsonValue("white")
  white,
  @JsonValue("gradient")
  gradient,
}

// lib/data/models/quota_response.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quota_response.freezed.dart';
part 'quota_response.g.dart';

/// 할당량 조회 응답 모델
///
/// Week 4: 이미지 생성 할당량 조회 API 응답
@freezed
class QuotaResponse with _$QuotaResponse {
  const factory QuotaResponse({
    /// 성공 여부
    required bool success,

    /// 할당량 데이터
    required QuotaData data,
  }) = _QuotaResponse;

  factory QuotaResponse.fromJson(Map<String, dynamic> json) =>
      _$QuotaResponseFromJson(json);
}

/// 할당량 데이터
@freezed
class QuotaData with _$QuotaData {
  const factory QuotaData({
    /// 남은 할당량
    required int remaining,

    /// 전체 할당량
    required int total,

    /// 사용한 개수
    required int used,

    /// 리셋 시간 (ISO 8601)
    @JsonKey(name: 'resetAt') required String resetAt,

    /// 리셋까지 남은 시간 (초)
    @JsonKey(name: 'nextResetIn') required int nextResetIn,

    // === 프리미엄 통합을 위한 추가 필드 ===

    /// 사용자 등급 (free, premium)
    @Default('free') String tier,

    /// 등급 표시 이름 (무료, 프리미엄)
    @Default('무료') String tierDisplayName,

    /// 사용 중인 이미지 생성 provider (pixazo, gemini)
    @Default('pixazo') String provider,
  }) = _QuotaData;

  factory QuotaData.fromJson(Map<String, dynamic> json) =>
      _$QuotaDataFromJson(json);
}

/// 할당량 데이터 확장 메서드
extension QuotaDataX on QuotaData {
  /// 사용률 (0.0 ~ 1.0)
  double get usageRate => total > 0 ? used / total : 0.0;

  /// 남은 비율 (0.0 ~ 1.0)
  double get remainingRate => total > 0 ? remaining / total : 1.0;

  /// 리셋까지 남은 시간 (포맷된 문자열)
  String get formattedTimeUntilReset {
    final hours = nextResetIn ~/ 3600;
    final minutes = (nextResetIn % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours시간 $minutes분';
    } else {
      return '$minutes분';
    }
  }

  /// 할당량 소진 여부
  bool get isExhausted => remaining <= 0;

  /// 리셋 시간 DateTime
  DateTime get resetAtDateTime => DateTime.parse(resetAt);

  // === 프리미엄 통합을 위한 헬퍼 메서드 ===

  /// 프리미엄 사용자 여부
  bool get isPremium => tier == 'premium';

  /// 무료 사용자 여부
  bool get isFree => tier == 'free';

  /// Provider 표시 이름
  String get providerDisplayName {
    switch (provider) {
      case 'gemini':
        return 'Gemini (고품질)';
      case 'pixazo':
        return 'Pixazo';
      case 'openai':
        return 'OpenAI';
      default:
        return provider;
    }
  }

  /// 등급 아이콘 이모지
  String get tierEmoji => isPremium ? '💎' : '🆓';

  /// 등급 색상 (Hex)
  int get tierColorValue => isPremium ? 0xFFFFD700 : 0xFF4CAF50;
}

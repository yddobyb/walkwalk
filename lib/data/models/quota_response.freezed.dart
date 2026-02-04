// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quota_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuotaResponse _$QuotaResponseFromJson(Map<String, dynamic> json) {
  return _QuotaResponse.fromJson(json);
}

/// @nodoc
mixin _$QuotaResponse {
  /// 성공 여부
  bool get success => throw _privateConstructorUsedError;

  /// 할당량 데이터
  QuotaData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotaResponseCopyWith<QuotaResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaResponseCopyWith<$Res> {
  factory $QuotaResponseCopyWith(
          QuotaResponse value, $Res Function(QuotaResponse) then) =
      _$QuotaResponseCopyWithImpl<$Res, QuotaResponse>;
  @useResult
  $Res call({bool success, QuotaData data});

  $QuotaDataCopyWith<$Res> get data;
}

/// @nodoc
class _$QuotaResponseCopyWithImpl<$Res, $Val extends QuotaResponse>
    implements $QuotaResponseCopyWith<$Res> {
  _$QuotaResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as QuotaData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $QuotaDataCopyWith<$Res> get data {
    return $QuotaDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuotaResponseImplCopyWith<$Res>
    implements $QuotaResponseCopyWith<$Res> {
  factory _$$QuotaResponseImplCopyWith(
          _$QuotaResponseImpl value, $Res Function(_$QuotaResponseImpl) then) =
      __$$QuotaResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, QuotaData data});

  @override
  $QuotaDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$QuotaResponseImplCopyWithImpl<$Res>
    extends _$QuotaResponseCopyWithImpl<$Res, _$QuotaResponseImpl>
    implements _$$QuotaResponseImplCopyWith<$Res> {
  __$$QuotaResponseImplCopyWithImpl(
      _$QuotaResponseImpl _value, $Res Function(_$QuotaResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_$QuotaResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as QuotaData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotaResponseImpl implements _QuotaResponse {
  const _$QuotaResponseImpl({required this.success, required this.data});

  factory _$QuotaResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotaResponseImplFromJson(json);

  /// 성공 여부
  @override
  final bool success;

  /// 할당량 데이터
  @override
  final QuotaData data;

  @override
  String toString() {
    return 'QuotaResponse(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaResponseImplCopyWith<_$QuotaResponseImpl> get copyWith =>
      __$$QuotaResponseImplCopyWithImpl<_$QuotaResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotaResponseImplToJson(
      this,
    );
  }
}

abstract class _QuotaResponse implements QuotaResponse {
  const factory _QuotaResponse(
      {required final bool success,
      required final QuotaData data}) = _$QuotaResponseImpl;

  factory _QuotaResponse.fromJson(Map<String, dynamic> json) =
      _$QuotaResponseImpl.fromJson;

  @override

  /// 성공 여부
  bool get success;
  @override

  /// 할당량 데이터
  QuotaData get data;
  @override
  @JsonKey(ignore: true)
  _$$QuotaResponseImplCopyWith<_$QuotaResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuotaData _$QuotaDataFromJson(Map<String, dynamic> json) {
  return _QuotaData.fromJson(json);
}

/// @nodoc
mixin _$QuotaData {
  /// 남은 할당량
  int get remaining => throw _privateConstructorUsedError;

  /// 전체 할당량
  int get total => throw _privateConstructorUsedError;

  /// 사용한 개수
  int get used => throw _privateConstructorUsedError;

  /// 리셋 시간 (ISO 8601)
  @JsonKey(name: 'resetAt')
  String get resetAt => throw _privateConstructorUsedError;

  /// 리셋까지 남은 시간 (초)
  @JsonKey(name: 'nextResetIn')
  int get nextResetIn =>
      throw _privateConstructorUsedError; // === 프리미엄 통합을 위한 추가 필드 ===
  /// 사용자 등급 (free, premium)
  String get tier => throw _privateConstructorUsedError;

  /// 등급 표시 이름 (무료, 프리미엄)
  String get tierDisplayName => throw _privateConstructorUsedError;

  /// 사용 중인 이미지 생성 provider (pixazo, gemini)
  String get provider => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotaDataCopyWith<QuotaData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaDataCopyWith<$Res> {
  factory $QuotaDataCopyWith(QuotaData value, $Res Function(QuotaData) then) =
      _$QuotaDataCopyWithImpl<$Res, QuotaData>;
  @useResult
  $Res call(
      {int remaining,
      int total,
      int used,
      @JsonKey(name: 'resetAt') String resetAt,
      @JsonKey(name: 'nextResetIn') int nextResetIn,
      String tier,
      String tierDisplayName,
      String provider});
}

/// @nodoc
class _$QuotaDataCopyWithImpl<$Res, $Val extends QuotaData>
    implements $QuotaDataCopyWith<$Res> {
  _$QuotaDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remaining = null,
    Object? total = null,
    Object? used = null,
    Object? resetAt = null,
    Object? nextResetIn = null,
    Object? tier = null,
    Object? tierDisplayName = null,
    Object? provider = null,
  }) {
    return _then(_value.copyWith(
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as int,
      resetAt: null == resetAt
          ? _value.resetAt
          : resetAt // ignore: cast_nullable_to_non_nullable
              as String,
      nextResetIn: null == nextResetIn
          ? _value.nextResetIn
          : nextResetIn // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      tierDisplayName: null == tierDisplayName
          ? _value.tierDisplayName
          : tierDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuotaDataImplCopyWith<$Res>
    implements $QuotaDataCopyWith<$Res> {
  factory _$$QuotaDataImplCopyWith(
          _$QuotaDataImpl value, $Res Function(_$QuotaDataImpl) then) =
      __$$QuotaDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int remaining,
      int total,
      int used,
      @JsonKey(name: 'resetAt') String resetAt,
      @JsonKey(name: 'nextResetIn') int nextResetIn,
      String tier,
      String tierDisplayName,
      String provider});
}

/// @nodoc
class __$$QuotaDataImplCopyWithImpl<$Res>
    extends _$QuotaDataCopyWithImpl<$Res, _$QuotaDataImpl>
    implements _$$QuotaDataImplCopyWith<$Res> {
  __$$QuotaDataImplCopyWithImpl(
      _$QuotaDataImpl _value, $Res Function(_$QuotaDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remaining = null,
    Object? total = null,
    Object? used = null,
    Object? resetAt = null,
    Object? nextResetIn = null,
    Object? tier = null,
    Object? tierDisplayName = null,
    Object? provider = null,
  }) {
    return _then(_$QuotaDataImpl(
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as int,
      resetAt: null == resetAt
          ? _value.resetAt
          : resetAt // ignore: cast_nullable_to_non_nullable
              as String,
      nextResetIn: null == nextResetIn
          ? _value.nextResetIn
          : nextResetIn // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      tierDisplayName: null == tierDisplayName
          ? _value.tierDisplayName
          : tierDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotaDataImpl implements _QuotaData {
  const _$QuotaDataImpl(
      {required this.remaining,
      required this.total,
      required this.used,
      @JsonKey(name: 'resetAt') required this.resetAt,
      @JsonKey(name: 'nextResetIn') required this.nextResetIn,
      this.tier = 'free',
      this.tierDisplayName = '무료',
      this.provider = 'pixazo'});

  factory _$QuotaDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotaDataImplFromJson(json);

  /// 남은 할당량
  @override
  final int remaining;

  /// 전체 할당량
  @override
  final int total;

  /// 사용한 개수
  @override
  final int used;

  /// 리셋 시간 (ISO 8601)
  @override
  @JsonKey(name: 'resetAt')
  final String resetAt;

  /// 리셋까지 남은 시간 (초)
  @override
  @JsonKey(name: 'nextResetIn')
  final int nextResetIn;
// === 프리미엄 통합을 위한 추가 필드 ===
  /// 사용자 등급 (free, premium)
  @override
  @JsonKey()
  final String tier;

  /// 등급 표시 이름 (무료, 프리미엄)
  @override
  @JsonKey()
  final String tierDisplayName;

  /// 사용 중인 이미지 생성 provider (pixazo, gemini)
  @override
  @JsonKey()
  final String provider;

  @override
  String toString() {
    return 'QuotaData(remaining: $remaining, total: $total, used: $used, resetAt: $resetAt, nextResetIn: $nextResetIn, tier: $tier, tierDisplayName: $tierDisplayName, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaDataImpl &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.resetAt, resetAt) || other.resetAt == resetAt) &&
            (identical(other.nextResetIn, nextResetIn) ||
                other.nextResetIn == nextResetIn) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.tierDisplayName, tierDisplayName) ||
                other.tierDisplayName == tierDisplayName) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, remaining, total, used, resetAt,
      nextResetIn, tier, tierDisplayName, provider);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaDataImplCopyWith<_$QuotaDataImpl> get copyWith =>
      __$$QuotaDataImplCopyWithImpl<_$QuotaDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotaDataImplToJson(
      this,
    );
  }
}

abstract class _QuotaData implements QuotaData {
  const factory _QuotaData(
      {required final int remaining,
      required final int total,
      required final int used,
      @JsonKey(name: 'resetAt') required final String resetAt,
      @JsonKey(name: 'nextResetIn') required final int nextResetIn,
      final String tier,
      final String tierDisplayName,
      final String provider}) = _$QuotaDataImpl;

  factory _QuotaData.fromJson(Map<String, dynamic> json) =
      _$QuotaDataImpl.fromJson;

  @override

  /// 남은 할당량
  int get remaining;
  @override

  /// 전체 할당량
  int get total;
  @override

  /// 사용한 개수
  int get used;
  @override

  /// 리셋 시간 (ISO 8601)
  @JsonKey(name: 'resetAt')
  String get resetAt;
  @override

  /// 리셋까지 남은 시간 (초)
  @JsonKey(name: 'nextResetIn')
  int get nextResetIn;
  @override // === 프리미엄 통합을 위한 추가 필드 ===
  /// 사용자 등급 (free, premium)
  String get tier;
  @override

  /// 등급 표시 이름 (무료, 프리미엄)
  String get tierDisplayName;
  @override

  /// 사용 중인 이미지 생성 provider (pixazo, gemini)
  String get provider;
  @override
  @JsonKey(ignore: true)
  _$$QuotaDataImplCopyWith<_$QuotaDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

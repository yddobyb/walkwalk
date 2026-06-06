// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sticker_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StickerResponse _$StickerResponseFromJson(Map<String, dynamic> json) {
  return _StickerResponse.fromJson(json);
}

/// @nodoc
mixin _$StickerResponse {
  /// 성공 여부
  bool get success => throw _privateConstructorUsedError;

  /// 응답 데이터
  StickerData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StickerResponseCopyWith<StickerResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StickerResponseCopyWith<$Res> {
  factory $StickerResponseCopyWith(
          StickerResponse value, $Res Function(StickerResponse) then) =
      _$StickerResponseCopyWithImpl<$Res, StickerResponse>;
  @useResult
  $Res call({bool success, StickerData data});

  $StickerDataCopyWith<$Res> get data;
}

/// @nodoc
class _$StickerResponseCopyWithImpl<$Res, $Val extends StickerResponse>
    implements $StickerResponseCopyWith<$Res> {
  _$StickerResponseCopyWithImpl(this._value, this._then);

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
              as StickerData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StickerDataCopyWith<$Res> get data {
    return $StickerDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StickerResponseImplCopyWith<$Res>
    implements $StickerResponseCopyWith<$Res> {
  factory _$$StickerResponseImplCopyWith(_$StickerResponseImpl value,
          $Res Function(_$StickerResponseImpl) then) =
      __$$StickerResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, StickerData data});

  @override
  $StickerDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$StickerResponseImplCopyWithImpl<$Res>
    extends _$StickerResponseCopyWithImpl<$Res, _$StickerResponseImpl>
    implements _$$StickerResponseImplCopyWith<$Res> {
  __$$StickerResponseImplCopyWithImpl(
      _$StickerResponseImpl _value, $Res Function(_$StickerResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_$StickerResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StickerData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StickerResponseImpl implements _StickerResponse {
  const _$StickerResponseImpl({required this.success, required this.data});

  factory _$StickerResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StickerResponseImplFromJson(json);

  /// 성공 여부
  @override
  final bool success;

  /// 응답 데이터
  @override
  final StickerData data;

  @override
  String toString() {
    return 'StickerResponse(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StickerResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StickerResponseImplCopyWith<_$StickerResponseImpl> get copyWith =>
      __$$StickerResponseImplCopyWithImpl<_$StickerResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StickerResponseImplToJson(
      this,
    );
  }
}

abstract class _StickerResponse implements StickerResponse {
  const factory _StickerResponse(
      {required final bool success,
      required final StickerData data}) = _$StickerResponseImpl;

  factory _StickerResponse.fromJson(Map<String, dynamic> json) =
      _$StickerResponseImpl.fromJson;

  @override

  /// 성공 여부
  bool get success;
  @override

  /// 응답 데이터
  StickerData get data;
  @override
  @JsonKey(ignore: true)
  _$$StickerResponseImplCopyWith<_$StickerResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StickerData _$StickerDataFromJson(Map<String, dynamic> json) {
  return _StickerData.fromJson(json);
}

/// @nodoc
mixin _$StickerData {
  /// Base64 인코딩된 WebP 이미지
  @JsonKey(name: 'image_base64')
  String get imageBase64 => throw _privateConstructorUsedError;

  /// MIME 타입
  String get mime => throw _privateConstructorUsedError;

  /// 생성에 사용된 시드
  int get seed => throw _privateConstructorUsedError;

  /// 캐시 히트 여부
  bool get cached => throw _privateConstructorUsedError;

  /// 이미지 크기
  StickerSize get size => throw _privateConstructorUsedError;

  /// 메타데이터 (cached: false일 때만)
  StickerMetadata? get metadata =>
      throw _privateConstructorUsedError; // === genStickerFree 추가 필드 ===
  /// 사용된 provider (cloudflare, openai) - genStickerFree 전용
  String? get provider => throw _privateConstructorUsedError;

  /// Provider 표시 이름 - genStickerFree 전용
  String? get providerName => throw _privateConstructorUsedError;

  /// 추정 비용 (USD) - genStickerFree 전용
  double? get estimatedCost => throw _privateConstructorUsedError;

  /// Provider 시도 이력 - genStickerFree 전용
  List<ProviderAttempt>? get attempts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StickerDataCopyWith<StickerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StickerDataCopyWith<$Res> {
  factory $StickerDataCopyWith(
          StickerData value, $Res Function(StickerData) then) =
      _$StickerDataCopyWithImpl<$Res, StickerData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'image_base64') String imageBase64,
      String mime,
      int seed,
      bool cached,
      StickerSize size,
      StickerMetadata? metadata,
      String? provider,
      String? providerName,
      double? estimatedCost,
      List<ProviderAttempt>? attempts});

  $StickerSizeCopyWith<$Res> get size;
  $StickerMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$StickerDataCopyWithImpl<$Res, $Val extends StickerData>
    implements $StickerDataCopyWith<$Res> {
  _$StickerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageBase64 = null,
    Object? mime = null,
    Object? seed = null,
    Object? cached = null,
    Object? size = null,
    Object? metadata = freezed,
    Object? provider = freezed,
    Object? providerName = freezed,
    Object? estimatedCost = freezed,
    Object? attempts = freezed,
  }) {
    return _then(_value.copyWith(
      imageBase64: null == imageBase64
          ? _value.imageBase64
          : imageBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      mime: null == mime
          ? _value.mime
          : mime // ignore: cast_nullable_to_non_nullable
              as String,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as StickerSize,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as StickerMetadata?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerName: freezed == providerName
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedCost: freezed == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as double?,
      attempts: freezed == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as List<ProviderAttempt>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StickerSizeCopyWith<$Res> get size {
    return $StickerSizeCopyWith<$Res>(_value.size, (value) {
      return _then(_value.copyWith(size: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StickerMetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $StickerMetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StickerDataImplCopyWith<$Res>
    implements $StickerDataCopyWith<$Res> {
  factory _$$StickerDataImplCopyWith(
          _$StickerDataImpl value, $Res Function(_$StickerDataImpl) then) =
      __$$StickerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'image_base64') String imageBase64,
      String mime,
      int seed,
      bool cached,
      StickerSize size,
      StickerMetadata? metadata,
      String? provider,
      String? providerName,
      double? estimatedCost,
      List<ProviderAttempt>? attempts});

  @override
  $StickerSizeCopyWith<$Res> get size;
  @override
  $StickerMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$StickerDataImplCopyWithImpl<$Res>
    extends _$StickerDataCopyWithImpl<$Res, _$StickerDataImpl>
    implements _$$StickerDataImplCopyWith<$Res> {
  __$$StickerDataImplCopyWithImpl(
      _$StickerDataImpl _value, $Res Function(_$StickerDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageBase64 = null,
    Object? mime = null,
    Object? seed = null,
    Object? cached = null,
    Object? size = null,
    Object? metadata = freezed,
    Object? provider = freezed,
    Object? providerName = freezed,
    Object? estimatedCost = freezed,
    Object? attempts = freezed,
  }) {
    return _then(_$StickerDataImpl(
      imageBase64: null == imageBase64
          ? _value.imageBase64
          : imageBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      mime: null == mime
          ? _value.mime
          : mime // ignore: cast_nullable_to_non_nullable
              as String,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as StickerSize,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as StickerMetadata?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerName: freezed == providerName
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedCost: freezed == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as double?,
      attempts: freezed == attempts
          ? _value._attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as List<ProviderAttempt>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StickerDataImpl implements _StickerData {
  const _$StickerDataImpl(
      {@JsonKey(name: 'image_base64') required this.imageBase64,
      this.mime = "image/webp",
      required this.seed,
      this.cached = false,
      required this.size,
      this.metadata,
      this.provider,
      this.providerName,
      this.estimatedCost,
      final List<ProviderAttempt>? attempts})
      : _attempts = attempts;

  factory _$StickerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StickerDataImplFromJson(json);

  /// Base64 인코딩된 WebP 이미지
  @override
  @JsonKey(name: 'image_base64')
  final String imageBase64;

  /// MIME 타입
  @override
  @JsonKey()
  final String mime;

  /// 생성에 사용된 시드
  @override
  final int seed;

  /// 캐시 히트 여부
  @override
  @JsonKey()
  final bool cached;

  /// 이미지 크기
  @override
  final StickerSize size;

  /// 메타데이터 (cached: false일 때만)
  @override
  final StickerMetadata? metadata;
// === genStickerFree 추가 필드 ===
  /// 사용된 provider (cloudflare, openai) - genStickerFree 전용
  @override
  final String? provider;

  /// Provider 표시 이름 - genStickerFree 전용
  @override
  final String? providerName;

  /// 추정 비용 (USD) - genStickerFree 전용
  @override
  final double? estimatedCost;

  /// Provider 시도 이력 - genStickerFree 전용
  final List<ProviderAttempt>? _attempts;

  /// Provider 시도 이력 - genStickerFree 전용
  @override
  List<ProviderAttempt>? get attempts {
    final value = _attempts;
    if (value == null) return null;
    if (_attempts is EqualUnmodifiableListView) return _attempts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StickerData(imageBase64: $imageBase64, mime: $mime, seed: $seed, cached: $cached, size: $size, metadata: $metadata, provider: $provider, providerName: $providerName, estimatedCost: $estimatedCost, attempts: $attempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StickerDataImpl &&
            (identical(other.imageBase64, imageBase64) ||
                other.imageBase64 == imageBase64) &&
            (identical(other.mime, mime) || other.mime == mime) &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.cached, cached) || other.cached == cached) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerName, providerName) ||
                other.providerName == providerName) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            const DeepCollectionEquality().equals(other._attempts, _attempts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      imageBase64,
      mime,
      seed,
      cached,
      size,
      metadata,
      provider,
      providerName,
      estimatedCost,
      const DeepCollectionEquality().hash(_attempts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StickerDataImplCopyWith<_$StickerDataImpl> get copyWith =>
      __$$StickerDataImplCopyWithImpl<_$StickerDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StickerDataImplToJson(
      this,
    );
  }
}

abstract class _StickerData implements StickerData {
  const factory _StickerData(
      {@JsonKey(name: 'image_base64') required final String imageBase64,
      final String mime,
      required final int seed,
      final bool cached,
      required final StickerSize size,
      final StickerMetadata? metadata,
      final String? provider,
      final String? providerName,
      final double? estimatedCost,
      final List<ProviderAttempt>? attempts}) = _$StickerDataImpl;

  factory _StickerData.fromJson(Map<String, dynamic> json) =
      _$StickerDataImpl.fromJson;

  @override

  /// Base64 인코딩된 WebP 이미지
  @JsonKey(name: 'image_base64')
  String get imageBase64;
  @override

  /// MIME 타입
  String get mime;
  @override

  /// 생성에 사용된 시드
  int get seed;
  @override

  /// 캐시 히트 여부
  bool get cached;
  @override

  /// 이미지 크기
  StickerSize get size;
  @override

  /// 메타데이터 (cached: false일 때만)
  StickerMetadata? get metadata;
  @override // === genStickerFree 추가 필드 ===
  /// 사용된 provider (cloudflare, openai) - genStickerFree 전용
  String? get provider;
  @override

  /// Provider 표시 이름 - genStickerFree 전용
  String? get providerName;
  @override

  /// 추정 비용 (USD) - genStickerFree 전용
  double? get estimatedCost;
  @override

  /// Provider 시도 이력 - genStickerFree 전용
  List<ProviderAttempt>? get attempts;
  @override
  @JsonKey(ignore: true)
  _$$StickerDataImplCopyWith<_$StickerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StickerSize _$StickerSizeFromJson(Map<String, dynamic> json) {
  return _StickerSize.fromJson(json);
}

/// @nodoc
mixin _$StickerSize {
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StickerSizeCopyWith<StickerSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StickerSizeCopyWith<$Res> {
  factory $StickerSizeCopyWith(
          StickerSize value, $Res Function(StickerSize) then) =
      _$StickerSizeCopyWithImpl<$Res, StickerSize>;
  @useResult
  $Res call({int width, int height});
}

/// @nodoc
class _$StickerSizeCopyWithImpl<$Res, $Val extends StickerSize>
    implements $StickerSizeCopyWith<$Res> {
  _$StickerSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StickerSizeImplCopyWith<$Res>
    implements $StickerSizeCopyWith<$Res> {
  factory _$$StickerSizeImplCopyWith(
          _$StickerSizeImpl value, $Res Function(_$StickerSizeImpl) then) =
      __$$StickerSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int width, int height});
}

/// @nodoc
class __$$StickerSizeImplCopyWithImpl<$Res>
    extends _$StickerSizeCopyWithImpl<$Res, _$StickerSizeImpl>
    implements _$$StickerSizeImplCopyWith<$Res> {
  __$$StickerSizeImplCopyWithImpl(
      _$StickerSizeImpl _value, $Res Function(_$StickerSizeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$StickerSizeImpl(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StickerSizeImpl implements _StickerSize {
  const _$StickerSizeImpl({required this.width, required this.height});

  factory _$StickerSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$StickerSizeImplFromJson(json);

  @override
  final int width;
  @override
  final int height;

  @override
  String toString() {
    return 'StickerSize(width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StickerSizeImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, width, height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StickerSizeImplCopyWith<_$StickerSizeImpl> get copyWith =>
      __$$StickerSizeImplCopyWithImpl<_$StickerSizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StickerSizeImplToJson(
      this,
    );
  }
}

abstract class _StickerSize implements StickerSize {
  const factory _StickerSize(
      {required final int width,
      required final int height}) = _$StickerSizeImpl;

  factory _StickerSize.fromJson(Map<String, dynamic> json) =
      _$StickerSizeImpl.fromJson;

  @override
  int get width;
  @override
  int get height;
  @override
  @JsonKey(ignore: true)
  _$$StickerSizeImplCopyWith<_$StickerSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StickerMetadata _$StickerMetadataFromJson(Map<String, dynamic> json) {
  return _StickerMetadata.fromJson(json);
}

/// @nodoc
mixin _$StickerMetadata {
  String get breed => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get accessory => throw _privateConstructorUsedError;
  String get style => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StickerMetadataCopyWith<StickerMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StickerMetadataCopyWith<$Res> {
  factory $StickerMetadataCopyWith(
          StickerMetadata value, $Res Function(StickerMetadata) then) =
      _$StickerMetadataCopyWithImpl<$Res, StickerMetadata>;
  @useResult
  $Res call({String breed, String color, String accessory, String style});
}

/// @nodoc
class _$StickerMetadataCopyWithImpl<$Res, $Val extends StickerMetadata>
    implements $StickerMetadataCopyWith<$Res> {
  _$StickerMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breed = null,
    Object? color = null,
    Object? accessory = null,
    Object? style = null,
  }) {
    return _then(_value.copyWith(
      breed: null == breed
          ? _value.breed
          : breed // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      accessory: null == accessory
          ? _value.accessory
          : accessory // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StickerMetadataImplCopyWith<$Res>
    implements $StickerMetadataCopyWith<$Res> {
  factory _$$StickerMetadataImplCopyWith(_$StickerMetadataImpl value,
          $Res Function(_$StickerMetadataImpl) then) =
      __$$StickerMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String breed, String color, String accessory, String style});
}

/// @nodoc
class __$$StickerMetadataImplCopyWithImpl<$Res>
    extends _$StickerMetadataCopyWithImpl<$Res, _$StickerMetadataImpl>
    implements _$$StickerMetadataImplCopyWith<$Res> {
  __$$StickerMetadataImplCopyWithImpl(
      _$StickerMetadataImpl _value, $Res Function(_$StickerMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breed = null,
    Object? color = null,
    Object? accessory = null,
    Object? style = null,
  }) {
    return _then(_$StickerMetadataImpl(
      breed: null == breed
          ? _value.breed
          : breed // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      accessory: null == accessory
          ? _value.accessory
          : accessory // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StickerMetadataImpl implements _StickerMetadata {
  const _$StickerMetadataImpl(
      {required this.breed,
      required this.color,
      required this.accessory,
      required this.style});

  factory _$StickerMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StickerMetadataImplFromJson(json);

  @override
  final String breed;
  @override
  final String color;
  @override
  final String accessory;
  @override
  final String style;

  @override
  String toString() {
    return 'StickerMetadata(breed: $breed, color: $color, accessory: $accessory, style: $style)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StickerMetadataImpl &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.accessory, accessory) ||
                other.accessory == accessory) &&
            (identical(other.style, style) || other.style == style));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, breed, color, accessory, style);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StickerMetadataImplCopyWith<_$StickerMetadataImpl> get copyWith =>
      __$$StickerMetadataImplCopyWithImpl<_$StickerMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StickerMetadataImplToJson(
      this,
    );
  }
}

abstract class _StickerMetadata implements StickerMetadata {
  const factory _StickerMetadata(
      {required final String breed,
      required final String color,
      required final String accessory,
      required final String style}) = _$StickerMetadataImpl;

  factory _StickerMetadata.fromJson(Map<String, dynamic> json) =
      _$StickerMetadataImpl.fromJson;

  @override
  String get breed;
  @override
  String get color;
  @override
  String get accessory;
  @override
  String get style;
  @override
  @JsonKey(ignore: true)
  _$$StickerMetadataImplCopyWith<_$StickerMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProviderAttempt _$ProviderAttemptFromJson(Map<String, dynamic> json) {
  return _ProviderAttempt.fromJson(json);
}

/// @nodoc
mixin _$ProviderAttempt {
  /// Provider 이름 (cloudflare, openai)
  String get provider => throw _privateConstructorUsedError;

  /// 성공 여부
  bool get success => throw _privateConstructorUsedError;

  /// 소요 시간 (ms)
  int get durationMs => throw _privateConstructorUsedError;

  /// 에러 메시지 (실패 시)
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProviderAttemptCopyWith<ProviderAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderAttemptCopyWith<$Res> {
  factory $ProviderAttemptCopyWith(
          ProviderAttempt value, $Res Function(ProviderAttempt) then) =
      _$ProviderAttemptCopyWithImpl<$Res, ProviderAttempt>;
  @useResult
  $Res call({String provider, bool success, int durationMs, String? error});
}

/// @nodoc
class _$ProviderAttemptCopyWithImpl<$Res, $Val extends ProviderAttempt>
    implements $ProviderAttemptCopyWith<$Res> {
  _$ProviderAttemptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? success = null,
    Object? durationMs = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProviderAttemptImplCopyWith<$Res>
    implements $ProviderAttemptCopyWith<$Res> {
  factory _$$ProviderAttemptImplCopyWith(_$ProviderAttemptImpl value,
          $Res Function(_$ProviderAttemptImpl) then) =
      __$$ProviderAttemptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String provider, bool success, int durationMs, String? error});
}

/// @nodoc
class __$$ProviderAttemptImplCopyWithImpl<$Res>
    extends _$ProviderAttemptCopyWithImpl<$Res, _$ProviderAttemptImpl>
    implements _$$ProviderAttemptImplCopyWith<$Res> {
  __$$ProviderAttemptImplCopyWithImpl(
      _$ProviderAttemptImpl _value, $Res Function(_$ProviderAttemptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? success = null,
    Object? durationMs = null,
    Object? error = freezed,
  }) {
    return _then(_$ProviderAttemptImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProviderAttemptImpl implements _ProviderAttempt {
  const _$ProviderAttemptImpl(
      {required this.provider,
      required this.success,
      required this.durationMs,
      this.error});

  factory _$ProviderAttemptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProviderAttemptImplFromJson(json);

  /// Provider 이름 (cloudflare, openai)
  @override
  final String provider;

  /// 성공 여부
  @override
  final bool success;

  /// 소요 시간 (ms)
  @override
  final int durationMs;

  /// 에러 메시지 (실패 시)
  @override
  final String? error;

  @override
  String toString() {
    return 'ProviderAttempt(provider: $provider, success: $success, durationMs: $durationMs, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderAttemptImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, provider, success, durationMs, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderAttemptImplCopyWith<_$ProviderAttemptImpl> get copyWith =>
      __$$ProviderAttemptImplCopyWithImpl<_$ProviderAttemptImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProviderAttemptImplToJson(
      this,
    );
  }
}

abstract class _ProviderAttempt implements ProviderAttempt {
  const factory _ProviderAttempt(
      {required final String provider,
      required final bool success,
      required final int durationMs,
      final String? error}) = _$ProviderAttemptImpl;

  factory _ProviderAttempt.fromJson(Map<String, dynamic> json) =
      _$ProviderAttemptImpl.fromJson;

  @override

  /// Provider 이름 (cloudflare, openai)
  String get provider;
  @override

  /// 성공 여부
  bool get success;
  @override

  /// 소요 시간 (ms)
  int get durationMs;
  @override

  /// 에러 메시지 (실패 시)
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$ProviderAttemptImplCopyWith<_$ProviderAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

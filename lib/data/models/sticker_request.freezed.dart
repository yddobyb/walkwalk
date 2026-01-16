// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sticker_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StickerRequest _$StickerRequestFromJson(Map<String, dynamic> json) {
  return _StickerRequest.fromJson(json);
}

/// @nodoc
mixin _$StickerRequest {
  /// 펫 ID (필수)
  String get petId => throw _privateConstructorUsedError;

  /// 견종 (선택, 기본값: "Shiba Inu")
  String get breed => throw _privateConstructorUsedError;

  /// 색상 (선택, 기본값: "orange")
  String get color => throw _privateConstructorUsedError;

  /// 액세서리 (선택, 기본값: "none")
  StickerAccessory get accessory => throw _privateConstructorUsedError;

  /// 스타일 (선택, 기본값: "sticker-flat")
  StickerStyle get style => throw _privateConstructorUsedError;

  /// 이미지 크기 (선택, 256-1024, 기본값: 512)
  int get size => throw _privateConstructorUsedError;

  /// 배경 (선택, 기본값: "transparent")
  StickerBackground get bg => throw _privateConstructorUsedError;

  /// 시드값 (선택, 재생성 시 동일한 이미지 생성)
  int? get seed => throw _privateConstructorUsedError;

  /// 캐시 무시 (선택, 기본값: false)
  bool get force => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StickerRequestCopyWith<StickerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StickerRequestCopyWith<$Res> {
  factory $StickerRequestCopyWith(
          StickerRequest value, $Res Function(StickerRequest) then) =
      _$StickerRequestCopyWithImpl<$Res, StickerRequest>;
  @useResult
  $Res call(
      {String petId,
      String breed,
      String color,
      StickerAccessory accessory,
      StickerStyle style,
      int size,
      StickerBackground bg,
      int? seed,
      bool force});
}

/// @nodoc
class _$StickerRequestCopyWithImpl<$Res, $Val extends StickerRequest>
    implements $StickerRequestCopyWith<$Res> {
  _$StickerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petId = null,
    Object? breed = null,
    Object? color = null,
    Object? accessory = null,
    Object? style = null,
    Object? size = null,
    Object? bg = null,
    Object? seed = freezed,
    Object? force = null,
  }) {
    return _then(_value.copyWith(
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String,
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
              as StickerAccessory,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as StickerStyle,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      bg: null == bg
          ? _value.bg
          : bg // ignore: cast_nullable_to_non_nullable
              as StickerBackground,
      seed: freezed == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int?,
      force: null == force
          ? _value.force
          : force // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StickerRequestImplCopyWith<$Res>
    implements $StickerRequestCopyWith<$Res> {
  factory _$$StickerRequestImplCopyWith(_$StickerRequestImpl value,
          $Res Function(_$StickerRequestImpl) then) =
      __$$StickerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String petId,
      String breed,
      String color,
      StickerAccessory accessory,
      StickerStyle style,
      int size,
      StickerBackground bg,
      int? seed,
      bool force});
}

/// @nodoc
class __$$StickerRequestImplCopyWithImpl<$Res>
    extends _$StickerRequestCopyWithImpl<$Res, _$StickerRequestImpl>
    implements _$$StickerRequestImplCopyWith<$Res> {
  __$$StickerRequestImplCopyWithImpl(
      _$StickerRequestImpl _value, $Res Function(_$StickerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petId = null,
    Object? breed = null,
    Object? color = null,
    Object? accessory = null,
    Object? style = null,
    Object? size = null,
    Object? bg = null,
    Object? seed = freezed,
    Object? force = null,
  }) {
    return _then(_$StickerRequestImpl(
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String,
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
              as StickerAccessory,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as StickerStyle,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      bg: null == bg
          ? _value.bg
          : bg // ignore: cast_nullable_to_non_nullable
              as StickerBackground,
      seed: freezed == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int?,
      force: null == force
          ? _value.force
          : force // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StickerRequestImpl implements _StickerRequest {
  const _$StickerRequestImpl(
      {required this.petId,
      this.breed = "Shiba Inu",
      this.color = "orange",
      this.accessory = StickerAccessory.none,
      this.style = StickerStyle.stickerFlat,
      this.size = 512,
      this.bg = StickerBackground.transparent,
      this.seed,
      this.force = false});

  factory _$StickerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StickerRequestImplFromJson(json);

  /// 펫 ID (필수)
  @override
  final String petId;

  /// 견종 (선택, 기본값: "Shiba Inu")
  @override
  @JsonKey()
  final String breed;

  /// 색상 (선택, 기본값: "orange")
  @override
  @JsonKey()
  final String color;

  /// 액세서리 (선택, 기본값: "none")
  @override
  @JsonKey()
  final StickerAccessory accessory;

  /// 스타일 (선택, 기본값: "sticker-flat")
  @override
  @JsonKey()
  final StickerStyle style;

  /// 이미지 크기 (선택, 256-1024, 기본값: 512)
  @override
  @JsonKey()
  final int size;

  /// 배경 (선택, 기본값: "transparent")
  @override
  @JsonKey()
  final StickerBackground bg;

  /// 시드값 (선택, 재생성 시 동일한 이미지 생성)
  @override
  final int? seed;

  /// 캐시 무시 (선택, 기본값: false)
  @override
  @JsonKey()
  final bool force;

  @override
  String toString() {
    return 'StickerRequest(petId: $petId, breed: $breed, color: $color, accessory: $accessory, style: $style, size: $size, bg: $bg, seed: $seed, force: $force)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StickerRequestImpl &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.accessory, accessory) ||
                other.accessory == accessory) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.bg, bg) || other.bg == bg) &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.force, force) || other.force == force));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, petId, breed, color, accessory,
      style, size, bg, seed, force);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StickerRequestImplCopyWith<_$StickerRequestImpl> get copyWith =>
      __$$StickerRequestImplCopyWithImpl<_$StickerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StickerRequestImplToJson(
      this,
    );
  }
}

abstract class _StickerRequest implements StickerRequest {
  const factory _StickerRequest(
      {required final String petId,
      final String breed,
      final String color,
      final StickerAccessory accessory,
      final StickerStyle style,
      final int size,
      final StickerBackground bg,
      final int? seed,
      final bool force}) = _$StickerRequestImpl;

  factory _StickerRequest.fromJson(Map<String, dynamic> json) =
      _$StickerRequestImpl.fromJson;

  @override

  /// 펫 ID (필수)
  String get petId;
  @override

  /// 견종 (선택, 기본값: "Shiba Inu")
  String get breed;
  @override

  /// 색상 (선택, 기본값: "orange")
  String get color;
  @override

  /// 액세서리 (선택, 기본값: "none")
  StickerAccessory get accessory;
  @override

  /// 스타일 (선택, 기본값: "sticker-flat")
  StickerStyle get style;
  @override

  /// 이미지 크기 (선택, 256-1024, 기본값: 512)
  int get size;
  @override

  /// 배경 (선택, 기본값: "transparent")
  StickerBackground get bg;
  @override

  /// 시드값 (선택, 재생성 시 동일한 이미지 생성)
  int? get seed;
  @override

  /// 캐시 무시 (선택, 기본값: false)
  bool get force;
  @override
  @JsonKey(ignore: true)
  _$$StickerRequestImplCopyWith<_$StickerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

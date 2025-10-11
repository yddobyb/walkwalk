// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  String get code => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get iconPath => throw _privateConstructorUsedError;
  AchievementTier get tier => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;
  DateTime? get unlockedAt => throw _privateConstructorUsedError;
  int get currentProgress => throw _privateConstructorUsedError;
  int get targetProgress => throw _privateConstructorUsedError;
  int get treatReward => throw _privateConstructorUsedError;
  int get happinessReward => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
          Achievement value, $Res Function(Achievement) then) =
      _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call(
      {String code,
      String title,
      String description,
      String iconPath,
      AchievementTier tier,
      bool isUnlocked,
      DateTime? unlockedAt,
      int currentProgress,
      int targetProgress,
      int treatReward,
      int happinessReward});
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? title = null,
    Object? description = null,
    Object? iconPath = null,
    Object? tier = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? currentProgress = null,
    Object? targetProgress = null,
    Object? treatReward = null,
    Object? happinessReward = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AchievementTier,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      targetProgress: null == targetProgress
          ? _value.targetProgress
          : targetProgress // ignore: cast_nullable_to_non_nullable
              as int,
      treatReward: null == treatReward
          ? _value.treatReward
          : treatReward // ignore: cast_nullable_to_non_nullable
              as int,
      happinessReward: null == happinessReward
          ? _value.happinessReward
          : happinessReward // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
          _$AchievementImpl value, $Res Function(_$AchievementImpl) then) =
      __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String title,
      String description,
      String iconPath,
      AchievementTier tier,
      bool isUnlocked,
      DateTime? unlockedAt,
      int currentProgress,
      int targetProgress,
      int treatReward,
      int happinessReward});
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
      _$AchievementImpl _value, $Res Function(_$AchievementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? title = null,
    Object? description = null,
    Object? iconPath = null,
    Object? tier = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? currentProgress = null,
    Object? targetProgress = null,
    Object? treatReward = null,
    Object? happinessReward = null,
  }) {
    return _then(_$AchievementImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AchievementTier,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      targetProgress: null == targetProgress
          ? _value.targetProgress
          : targetProgress // ignore: cast_nullable_to_non_nullable
              as int,
      treatReward: null == treatReward
          ? _value.treatReward
          : treatReward // ignore: cast_nullable_to_non_nullable
              as int,
      happinessReward: null == happinessReward
          ? _value.happinessReward
          : happinessReward // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl(
      {required this.code,
      required this.title,
      required this.description,
      required this.iconPath,
      required this.tier,
      required this.isUnlocked,
      this.unlockedAt,
      required this.currentProgress,
      required this.targetProgress,
      required this.treatReward,
      required this.happinessReward});

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  final String code;
  @override
  final String title;
  @override
  final String description;
  @override
  final String iconPath;
  @override
  final AchievementTier tier;
  @override
  final bool isUnlocked;
  @override
  final DateTime? unlockedAt;
  @override
  final int currentProgress;
  @override
  final int targetProgress;
  @override
  final int treatReward;
  @override
  final int happinessReward;

  @override
  String toString() {
    return 'Achievement(code: $code, title: $title, description: $description, iconPath: $iconPath, tier: $tier, isUnlocked: $isUnlocked, unlockedAt: $unlockedAt, currentProgress: $currentProgress, targetProgress: $targetProgress, treatReward: $treatReward, happinessReward: $happinessReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.currentProgress, currentProgress) ||
                other.currentProgress == currentProgress) &&
            (identical(other.targetProgress, targetProgress) ||
                other.targetProgress == targetProgress) &&
            (identical(other.treatReward, treatReward) ||
                other.treatReward == treatReward) &&
            (identical(other.happinessReward, happinessReward) ||
                other.happinessReward == happinessReward));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      title,
      description,
      iconPath,
      tier,
      isUnlocked,
      unlockedAt,
      currentProgress,
      targetProgress,
      treatReward,
      happinessReward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(
      this,
    );
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement(
      {required final String code,
      required final String title,
      required final String description,
      required final String iconPath,
      required final AchievementTier tier,
      required final bool isUnlocked,
      final DateTime? unlockedAt,
      required final int currentProgress,
      required final int targetProgress,
      required final int treatReward,
      required final int happinessReward}) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  String get code;
  @override
  String get title;
  @override
  String get description;
  @override
  String get iconPath;
  @override
  AchievementTier get tier;
  @override
  bool get isUnlocked;
  @override
  DateTime? get unlockedAt;
  @override
  int get currentProgress;
  @override
  int get targetProgress;
  @override
  int get treatReward;
  @override
  int get happinessReward;
  @override
  @JsonKey(ignore: true)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return _Mission.fromJson(json);
}

/// @nodoc
mixin _$Mission {
  String get missionId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // daily, weekly, special
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get targetSteps => throw _privateConstructorUsedError;
  int get targetDuration => throw _privateConstructorUsedError; // 초
  double get targetDistance => throw _privateConstructorUsedError; // 미터
  int get treatReward => throw _privateConstructorUsedError;
  int get happinessReward => throw _privateConstructorUsedError;
  String? get badgeCode => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  int get currentProgress => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionCopyWith<Mission> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCopyWith<$Res> {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) then) =
      _$MissionCopyWithImpl<$Res, Mission>;
  @useResult
  $Res call(
      {String missionId,
      String type,
      String title,
      String description,
      int targetSteps,
      int targetDuration,
      double targetDistance,
      int treatReward,
      int happinessReward,
      String? badgeCode,
      bool isActive,
      bool isCompleted,
      DateTime? completedAt,
      DateTime expiresAt,
      int currentProgress});
}

/// @nodoc
class _$MissionCopyWithImpl<$Res, $Val extends Mission>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? missionId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? targetSteps = null,
    Object? targetDuration = null,
    Object? targetDistance = null,
    Object? treatReward = null,
    Object? happinessReward = null,
    Object? badgeCode = freezed,
    Object? isActive = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? expiresAt = null,
    Object? currentProgress = null,
  }) {
    return _then(_value.copyWith(
      missionId: null == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetSteps: null == targetSteps
          ? _value.targetSteps
          : targetSteps // ignore: cast_nullable_to_non_nullable
              as int,
      targetDuration: null == targetDuration
          ? _value.targetDuration
          : targetDuration // ignore: cast_nullable_to_non_nullable
              as int,
      targetDistance: null == targetDistance
          ? _value.targetDistance
          : targetDistance // ignore: cast_nullable_to_non_nullable
              as double,
      treatReward: null == treatReward
          ? _value.treatReward
          : treatReward // ignore: cast_nullable_to_non_nullable
              as int,
      happinessReward: null == happinessReward
          ? _value.happinessReward
          : happinessReward // ignore: cast_nullable_to_non_nullable
              as int,
      badgeCode: freezed == badgeCode
          ? _value.badgeCode
          : badgeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionImplCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$$MissionImplCopyWith(
          _$MissionImpl value, $Res Function(_$MissionImpl) then) =
      __$$MissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String missionId,
      String type,
      String title,
      String description,
      int targetSteps,
      int targetDuration,
      double targetDistance,
      int treatReward,
      int happinessReward,
      String? badgeCode,
      bool isActive,
      bool isCompleted,
      DateTime? completedAt,
      DateTime expiresAt,
      int currentProgress});
}

/// @nodoc
class __$$MissionImplCopyWithImpl<$Res>
    extends _$MissionCopyWithImpl<$Res, _$MissionImpl>
    implements _$$MissionImplCopyWith<$Res> {
  __$$MissionImplCopyWithImpl(
      _$MissionImpl _value, $Res Function(_$MissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? missionId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? targetSteps = null,
    Object? targetDuration = null,
    Object? targetDistance = null,
    Object? treatReward = null,
    Object? happinessReward = null,
    Object? badgeCode = freezed,
    Object? isActive = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? expiresAt = null,
    Object? currentProgress = null,
  }) {
    return _then(_$MissionImpl(
      missionId: null == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetSteps: null == targetSteps
          ? _value.targetSteps
          : targetSteps // ignore: cast_nullable_to_non_nullable
              as int,
      targetDuration: null == targetDuration
          ? _value.targetDuration
          : targetDuration // ignore: cast_nullable_to_non_nullable
              as int,
      targetDistance: null == targetDistance
          ? _value.targetDistance
          : targetDistance // ignore: cast_nullable_to_non_nullable
              as double,
      treatReward: null == treatReward
          ? _value.treatReward
          : treatReward // ignore: cast_nullable_to_non_nullable
              as int,
      happinessReward: null == happinessReward
          ? _value.happinessReward
          : happinessReward // ignore: cast_nullable_to_non_nullable
              as int,
      badgeCode: freezed == badgeCode
          ? _value.badgeCode
          : badgeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionImpl implements _Mission {
  const _$MissionImpl(
      {required this.missionId,
      required this.type,
      required this.title,
      required this.description,
      required this.targetSteps,
      required this.targetDuration,
      required this.targetDistance,
      required this.treatReward,
      required this.happinessReward,
      this.badgeCode,
      required this.isActive,
      required this.isCompleted,
      this.completedAt,
      required this.expiresAt,
      required this.currentProgress});

  factory _$MissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionImplFromJson(json);

  @override
  final String missionId;
  @override
  final String type;
// daily, weekly, special
  @override
  final String title;
  @override
  final String description;
  @override
  final int targetSteps;
  @override
  final int targetDuration;
// 초
  @override
  final double targetDistance;
// 미터
  @override
  final int treatReward;
  @override
  final int happinessReward;
  @override
  final String? badgeCode;
  @override
  final bool isActive;
  @override
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  final DateTime expiresAt;
  @override
  final int currentProgress;

  @override
  String toString() {
    return 'Mission(missionId: $missionId, type: $type, title: $title, description: $description, targetSteps: $targetSteps, targetDuration: $targetDuration, targetDistance: $targetDistance, treatReward: $treatReward, happinessReward: $happinessReward, badgeCode: $badgeCode, isActive: $isActive, isCompleted: $isCompleted, completedAt: $completedAt, expiresAt: $expiresAt, currentProgress: $currentProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionImpl &&
            (identical(other.missionId, missionId) ||
                other.missionId == missionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetSteps, targetSteps) ||
                other.targetSteps == targetSteps) &&
            (identical(other.targetDuration, targetDuration) ||
                other.targetDuration == targetDuration) &&
            (identical(other.targetDistance, targetDistance) ||
                other.targetDistance == targetDistance) &&
            (identical(other.treatReward, treatReward) ||
                other.treatReward == treatReward) &&
            (identical(other.happinessReward, happinessReward) ||
                other.happinessReward == happinessReward) &&
            (identical(other.badgeCode, badgeCode) ||
                other.badgeCode == badgeCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.currentProgress, currentProgress) ||
                other.currentProgress == currentProgress));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      missionId,
      type,
      title,
      description,
      targetSteps,
      targetDuration,
      targetDistance,
      treatReward,
      happinessReward,
      badgeCode,
      isActive,
      isCompleted,
      completedAt,
      expiresAt,
      currentProgress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      __$$MissionImplCopyWithImpl<_$MissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionImplToJson(
      this,
    );
  }
}

abstract class _Mission implements Mission {
  const factory _Mission(
      {required final String missionId,
      required final String type,
      required final String title,
      required final String description,
      required final int targetSteps,
      required final int targetDuration,
      required final double targetDistance,
      required final int treatReward,
      required final int happinessReward,
      final String? badgeCode,
      required final bool isActive,
      required final bool isCompleted,
      final DateTime? completedAt,
      required final DateTime expiresAt,
      required final int currentProgress}) = _$MissionImpl;

  factory _Mission.fromJson(Map<String, dynamic> json) = _$MissionImpl.fromJson;

  @override
  String get missionId;
  @override
  String get type;
  @override // daily, weekly, special
  String get title;
  @override
  String get description;
  @override
  int get targetSteps;
  @override
  int get targetDuration;
  @override // 초
  double get targetDistance;
  @override // 미터
  int get treatReward;
  @override
  int get happinessReward;
  @override
  String? get badgeCode;
  @override
  bool get isActive;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  DateTime get expiresAt;
  @override
  int get currentProgress;
  @override
  @JsonKey(ignore: true)
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

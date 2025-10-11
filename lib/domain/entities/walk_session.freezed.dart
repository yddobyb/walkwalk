// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalkSession _$WalkSessionFromJson(Map<String, dynamic> json) {
  return _WalkSession.fromJson(json);
}

/// @nodoc
mixin _$WalkSession {
  String get sessionId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  int get totalSteps => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError; // 초 단위
  double get distance => throw _privateConstructorUsedError; // 미터 단위
  double get avgSpeed => throw _privateConstructorUsedError; // km/h
  bool get isOutdoor => throw _privateConstructorUsedError;
  int get validOutdoorSamples => throw _privateConstructorUsedError;
  List<LocationSample> get locationSamples =>
      throw _privateConstructorUsedError;
  int get treatsEarned => throw _privateConstructorUsedError;
  int get happinessGained => throw _privateConstructorUsedError;
  List<MissionCompleted> get missionsCompleted =>
      throw _privateConstructorUsedError;
  String? get weatherCondition => throw _privateConstructorUsedError;
  double? get airQuality => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalkSessionCopyWith<WalkSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalkSessionCopyWith<$Res> {
  factory $WalkSessionCopyWith(
          WalkSession value, $Res Function(WalkSession) then) =
      _$WalkSessionCopyWithImpl<$Res, WalkSession>;
  @useResult
  $Res call(
      {String sessionId,
      DateTime startTime,
      DateTime endTime,
      int totalSteps,
      int duration,
      double distance,
      double avgSpeed,
      bool isOutdoor,
      int validOutdoorSamples,
      List<LocationSample> locationSamples,
      int treatsEarned,
      int happinessGained,
      List<MissionCompleted> missionsCompleted,
      String? weatherCondition,
      double? airQuality});
}

/// @nodoc
class _$WalkSessionCopyWithImpl<$Res, $Val extends WalkSession>
    implements $WalkSessionCopyWith<$Res> {
  _$WalkSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalSteps = null,
    Object? duration = null,
    Object? distance = null,
    Object? avgSpeed = null,
    Object? isOutdoor = null,
    Object? validOutdoorSamples = null,
    Object? locationSamples = null,
    Object? treatsEarned = null,
    Object? happinessGained = null,
    Object? missionsCompleted = null,
    Object? weatherCondition = freezed,
    Object? airQuality = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      avgSpeed: null == avgSpeed
          ? _value.avgSpeed
          : avgSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      isOutdoor: null == isOutdoor
          ? _value.isOutdoor
          : isOutdoor // ignore: cast_nullable_to_non_nullable
              as bool,
      validOutdoorSamples: null == validOutdoorSamples
          ? _value.validOutdoorSamples
          : validOutdoorSamples // ignore: cast_nullable_to_non_nullable
              as int,
      locationSamples: null == locationSamples
          ? _value.locationSamples
          : locationSamples // ignore: cast_nullable_to_non_nullable
              as List<LocationSample>,
      treatsEarned: null == treatsEarned
          ? _value.treatsEarned
          : treatsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      happinessGained: null == happinessGained
          ? _value.happinessGained
          : happinessGained // ignore: cast_nullable_to_non_nullable
              as int,
      missionsCompleted: null == missionsCompleted
          ? _value.missionsCompleted
          : missionsCompleted // ignore: cast_nullable_to_non_nullable
              as List<MissionCompleted>,
      weatherCondition: freezed == weatherCondition
          ? _value.weatherCondition
          : weatherCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      airQuality: freezed == airQuality
          ? _value.airQuality
          : airQuality // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalkSessionImplCopyWith<$Res>
    implements $WalkSessionCopyWith<$Res> {
  factory _$$WalkSessionImplCopyWith(
          _$WalkSessionImpl value, $Res Function(_$WalkSessionImpl) then) =
      __$$WalkSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      DateTime startTime,
      DateTime endTime,
      int totalSteps,
      int duration,
      double distance,
      double avgSpeed,
      bool isOutdoor,
      int validOutdoorSamples,
      List<LocationSample> locationSamples,
      int treatsEarned,
      int happinessGained,
      List<MissionCompleted> missionsCompleted,
      String? weatherCondition,
      double? airQuality});
}

/// @nodoc
class __$$WalkSessionImplCopyWithImpl<$Res>
    extends _$WalkSessionCopyWithImpl<$Res, _$WalkSessionImpl>
    implements _$$WalkSessionImplCopyWith<$Res> {
  __$$WalkSessionImplCopyWithImpl(
      _$WalkSessionImpl _value, $Res Function(_$WalkSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalSteps = null,
    Object? duration = null,
    Object? distance = null,
    Object? avgSpeed = null,
    Object? isOutdoor = null,
    Object? validOutdoorSamples = null,
    Object? locationSamples = null,
    Object? treatsEarned = null,
    Object? happinessGained = null,
    Object? missionsCompleted = null,
    Object? weatherCondition = freezed,
    Object? airQuality = freezed,
  }) {
    return _then(_$WalkSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      avgSpeed: null == avgSpeed
          ? _value.avgSpeed
          : avgSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      isOutdoor: null == isOutdoor
          ? _value.isOutdoor
          : isOutdoor // ignore: cast_nullable_to_non_nullable
              as bool,
      validOutdoorSamples: null == validOutdoorSamples
          ? _value.validOutdoorSamples
          : validOutdoorSamples // ignore: cast_nullable_to_non_nullable
              as int,
      locationSamples: null == locationSamples
          ? _value._locationSamples
          : locationSamples // ignore: cast_nullable_to_non_nullable
              as List<LocationSample>,
      treatsEarned: null == treatsEarned
          ? _value.treatsEarned
          : treatsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      happinessGained: null == happinessGained
          ? _value.happinessGained
          : happinessGained // ignore: cast_nullable_to_non_nullable
              as int,
      missionsCompleted: null == missionsCompleted
          ? _value._missionsCompleted
          : missionsCompleted // ignore: cast_nullable_to_non_nullable
              as List<MissionCompleted>,
      weatherCondition: freezed == weatherCondition
          ? _value.weatherCondition
          : weatherCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      airQuality: freezed == airQuality
          ? _value.airQuality
          : airQuality // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalkSessionImpl implements _WalkSession {
  const _$WalkSessionImpl(
      {required this.sessionId,
      required this.startTime,
      required this.endTime,
      required this.totalSteps,
      required this.duration,
      required this.distance,
      required this.avgSpeed,
      required this.isOutdoor,
      required this.validOutdoorSamples,
      required final List<LocationSample> locationSamples,
      required this.treatsEarned,
      required this.happinessGained,
      required final List<MissionCompleted> missionsCompleted,
      this.weatherCondition,
      this.airQuality})
      : _locationSamples = locationSamples,
        _missionsCompleted = missionsCompleted;

  factory _$WalkSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalkSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final int totalSteps;
  @override
  final int duration;
// 초 단위
  @override
  final double distance;
// 미터 단위
  @override
  final double avgSpeed;
// km/h
  @override
  final bool isOutdoor;
  @override
  final int validOutdoorSamples;
  final List<LocationSample> _locationSamples;
  @override
  List<LocationSample> get locationSamples {
    if (_locationSamples is EqualUnmodifiableListView) return _locationSamples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationSamples);
  }

  @override
  final int treatsEarned;
  @override
  final int happinessGained;
  final List<MissionCompleted> _missionsCompleted;
  @override
  List<MissionCompleted> get missionsCompleted {
    if (_missionsCompleted is EqualUnmodifiableListView)
      return _missionsCompleted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missionsCompleted);
  }

  @override
  final String? weatherCondition;
  @override
  final double? airQuality;

  @override
  String toString() {
    return 'WalkSession(sessionId: $sessionId, startTime: $startTime, endTime: $endTime, totalSteps: $totalSteps, duration: $duration, distance: $distance, avgSpeed: $avgSpeed, isOutdoor: $isOutdoor, validOutdoorSamples: $validOutdoorSamples, locationSamples: $locationSamples, treatsEarned: $treatsEarned, happinessGained: $happinessGained, missionsCompleted: $missionsCompleted, weatherCondition: $weatherCondition, airQuality: $airQuality)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalkSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.avgSpeed, avgSpeed) ||
                other.avgSpeed == avgSpeed) &&
            (identical(other.isOutdoor, isOutdoor) ||
                other.isOutdoor == isOutdoor) &&
            (identical(other.validOutdoorSamples, validOutdoorSamples) ||
                other.validOutdoorSamples == validOutdoorSamples) &&
            const DeepCollectionEquality()
                .equals(other._locationSamples, _locationSamples) &&
            (identical(other.treatsEarned, treatsEarned) ||
                other.treatsEarned == treatsEarned) &&
            (identical(other.happinessGained, happinessGained) ||
                other.happinessGained == happinessGained) &&
            const DeepCollectionEquality()
                .equals(other._missionsCompleted, _missionsCompleted) &&
            (identical(other.weatherCondition, weatherCondition) ||
                other.weatherCondition == weatherCondition) &&
            (identical(other.airQuality, airQuality) ||
                other.airQuality == airQuality));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      startTime,
      endTime,
      totalSteps,
      duration,
      distance,
      avgSpeed,
      isOutdoor,
      validOutdoorSamples,
      const DeepCollectionEquality().hash(_locationSamples),
      treatsEarned,
      happinessGained,
      const DeepCollectionEquality().hash(_missionsCompleted),
      weatherCondition,
      airQuality);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalkSessionImplCopyWith<_$WalkSessionImpl> get copyWith =>
      __$$WalkSessionImplCopyWithImpl<_$WalkSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalkSessionImplToJson(
      this,
    );
  }
}

abstract class _WalkSession implements WalkSession {
  const factory _WalkSession(
      {required final String sessionId,
      required final DateTime startTime,
      required final DateTime endTime,
      required final int totalSteps,
      required final int duration,
      required final double distance,
      required final double avgSpeed,
      required final bool isOutdoor,
      required final int validOutdoorSamples,
      required final List<LocationSample> locationSamples,
      required final int treatsEarned,
      required final int happinessGained,
      required final List<MissionCompleted> missionsCompleted,
      final String? weatherCondition,
      final double? airQuality}) = _$WalkSessionImpl;

  factory _WalkSession.fromJson(Map<String, dynamic> json) =
      _$WalkSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  int get totalSteps;
  @override
  int get duration;
  @override // 초 단위
  double get distance;
  @override // 미터 단위
  double get avgSpeed;
  @override // km/h
  bool get isOutdoor;
  @override
  int get validOutdoorSamples;
  @override
  List<LocationSample> get locationSamples;
  @override
  int get treatsEarned;
  @override
  int get happinessGained;
  @override
  List<MissionCompleted> get missionsCompleted;
  @override
  String? get weatherCondition;
  @override
  double? get airQuality;
  @override
  @JsonKey(ignore: true)
  _$$WalkSessionImplCopyWith<_$WalkSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationSample _$LocationSampleFromJson(Map<String, dynamic> json) {
  return _LocationSample.fromJson(json);
}

/// @nodoc
mixin _$LocationSample {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError; // 미터 단위
  double get speed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationSampleCopyWith<LocationSample> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationSampleCopyWith<$Res> {
  factory $LocationSampleCopyWith(
          LocationSample value, $Res Function(LocationSample) then) =
      _$LocationSampleCopyWithImpl<$Res, LocationSample>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      DateTime timestamp,
      double accuracy,
      double speed});
}

/// @nodoc
class _$LocationSampleCopyWithImpl<$Res, $Val extends LocationSample>
    implements $LocationSampleCopyWith<$Res> {
  _$LocationSampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? timestamp = null,
    Object? accuracy = null,
    Object? speed = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationSampleImplCopyWith<$Res>
    implements $LocationSampleCopyWith<$Res> {
  factory _$$LocationSampleImplCopyWith(_$LocationSampleImpl value,
          $Res Function(_$LocationSampleImpl) then) =
      __$$LocationSampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      DateTime timestamp,
      double accuracy,
      double speed});
}

/// @nodoc
class __$$LocationSampleImplCopyWithImpl<$Res>
    extends _$LocationSampleCopyWithImpl<$Res, _$LocationSampleImpl>
    implements _$$LocationSampleImplCopyWith<$Res> {
  __$$LocationSampleImplCopyWithImpl(
      _$LocationSampleImpl _value, $Res Function(_$LocationSampleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? timestamp = null,
    Object? accuracy = null,
    Object? speed = null,
  }) {
    return _then(_$LocationSampleImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationSampleImpl implements _LocationSample {
  const _$LocationSampleImpl(
      {required this.latitude,
      required this.longitude,
      required this.timestamp,
      required this.accuracy,
      required this.speed});

  factory _$LocationSampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationSampleImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final DateTime timestamp;
  @override
  final double accuracy;
// 미터 단위
  @override
  final double speed;

  @override
  String toString() {
    return 'LocationSample(latitude: $latitude, longitude: $longitude, timestamp: $timestamp, accuracy: $accuracy, speed: $speed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationSampleImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.speed, speed) || other.speed == speed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, latitude, longitude, timestamp, accuracy, speed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationSampleImplCopyWith<_$LocationSampleImpl> get copyWith =>
      __$$LocationSampleImplCopyWithImpl<_$LocationSampleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationSampleImplToJson(
      this,
    );
  }
}

abstract class _LocationSample implements LocationSample {
  const factory _LocationSample(
      {required final double latitude,
      required final double longitude,
      required final DateTime timestamp,
      required final double accuracy,
      required final double speed}) = _$LocationSampleImpl;

  factory _LocationSample.fromJson(Map<String, dynamic> json) =
      _$LocationSampleImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  DateTime get timestamp;
  @override
  double get accuracy;
  @override // 미터 단위
  double get speed;
  @override
  @JsonKey(ignore: true)
  _$$LocationSampleImplCopyWith<_$LocationSampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionCompleted _$MissionCompletedFromJson(Map<String, dynamic> json) {
  return _MissionCompleted.fromJson(json);
}

/// @nodoc
mixin _$MissionCompleted {
  String get missionId => throw _privateConstructorUsedError;
  String get missionType => throw _privateConstructorUsedError;
  int get rewardAmount => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionCompletedCopyWith<MissionCompleted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCompletedCopyWith<$Res> {
  factory $MissionCompletedCopyWith(
          MissionCompleted value, $Res Function(MissionCompleted) then) =
      _$MissionCompletedCopyWithImpl<$Res, MissionCompleted>;
  @useResult
  $Res call(
      {String missionId,
      String missionType,
      int rewardAmount,
      DateTime completedAt});
}

/// @nodoc
class _$MissionCompletedCopyWithImpl<$Res, $Val extends MissionCompleted>
    implements $MissionCompletedCopyWith<$Res> {
  _$MissionCompletedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? missionId = null,
    Object? missionType = null,
    Object? rewardAmount = null,
    Object? completedAt = null,
  }) {
    return _then(_value.copyWith(
      missionId: null == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String,
      missionType: null == missionType
          ? _value.missionType
          : missionType // ignore: cast_nullable_to_non_nullable
              as String,
      rewardAmount: null == rewardAmount
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as int,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionCompletedImplCopyWith<$Res>
    implements $MissionCompletedCopyWith<$Res> {
  factory _$$MissionCompletedImplCopyWith(_$MissionCompletedImpl value,
          $Res Function(_$MissionCompletedImpl) then) =
      __$$MissionCompletedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String missionId,
      String missionType,
      int rewardAmount,
      DateTime completedAt});
}

/// @nodoc
class __$$MissionCompletedImplCopyWithImpl<$Res>
    extends _$MissionCompletedCopyWithImpl<$Res, _$MissionCompletedImpl>
    implements _$$MissionCompletedImplCopyWith<$Res> {
  __$$MissionCompletedImplCopyWithImpl(_$MissionCompletedImpl _value,
      $Res Function(_$MissionCompletedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? missionId = null,
    Object? missionType = null,
    Object? rewardAmount = null,
    Object? completedAt = null,
  }) {
    return _then(_$MissionCompletedImpl(
      missionId: null == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String,
      missionType: null == missionType
          ? _value.missionType
          : missionType // ignore: cast_nullable_to_non_nullable
              as String,
      rewardAmount: null == rewardAmount
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as int,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionCompletedImpl implements _MissionCompleted {
  const _$MissionCompletedImpl(
      {required this.missionId,
      required this.missionType,
      required this.rewardAmount,
      required this.completedAt});

  factory _$MissionCompletedImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionCompletedImplFromJson(json);

  @override
  final String missionId;
  @override
  final String missionType;
  @override
  final int rewardAmount;
  @override
  final DateTime completedAt;

  @override
  String toString() {
    return 'MissionCompleted(missionId: $missionId, missionType: $missionType, rewardAmount: $rewardAmount, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionCompletedImpl &&
            (identical(other.missionId, missionId) ||
                other.missionId == missionId) &&
            (identical(other.missionType, missionType) ||
                other.missionType == missionType) &&
            (identical(other.rewardAmount, rewardAmount) ||
                other.rewardAmount == rewardAmount) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, missionId, missionType, rewardAmount, completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionCompletedImplCopyWith<_$MissionCompletedImpl> get copyWith =>
      __$$MissionCompletedImplCopyWithImpl<_$MissionCompletedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionCompletedImplToJson(
      this,
    );
  }
}

abstract class _MissionCompleted implements MissionCompleted {
  const factory _MissionCompleted(
      {required final String missionId,
      required final String missionType,
      required final int rewardAmount,
      required final DateTime completedAt}) = _$MissionCompletedImpl;

  factory _MissionCompleted.fromJson(Map<String, dynamic> json) =
      _$MissionCompletedImpl.fromJson;

  @override
  String get missionId;
  @override
  String get missionType;
  @override
  int get rewardAmount;
  @override
  DateTime get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$MissionCompletedImplCopyWith<_$MissionCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

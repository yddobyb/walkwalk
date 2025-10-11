// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalkSessionImpl _$$WalkSessionImplFromJson(Map<String, dynamic> json) =>
    _$WalkSessionImpl(
      sessionId: json['sessionId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      totalSteps: (json['totalSteps'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      avgSpeed: (json['avgSpeed'] as num).toDouble(),
      isOutdoor: json['isOutdoor'] as bool,
      validOutdoorSamples: (json['validOutdoorSamples'] as num).toInt(),
      locationSamples: (json['locationSamples'] as List<dynamic>)
          .map((e) => LocationSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      treatsEarned: (json['treatsEarned'] as num).toInt(),
      happinessGained: (json['happinessGained'] as num).toInt(),
      missionsCompleted: (json['missionsCompleted'] as List<dynamic>)
          .map((e) => MissionCompleted.fromJson(e as Map<String, dynamic>))
          .toList(),
      weatherCondition: json['weatherCondition'] as String?,
      airQuality: (json['airQuality'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$WalkSessionImplToJson(_$WalkSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'totalSteps': instance.totalSteps,
      'duration': instance.duration,
      'distance': instance.distance,
      'avgSpeed': instance.avgSpeed,
      'isOutdoor': instance.isOutdoor,
      'validOutdoorSamples': instance.validOutdoorSamples,
      'locationSamples': instance.locationSamples,
      'treatsEarned': instance.treatsEarned,
      'happinessGained': instance.happinessGained,
      'missionsCompleted': instance.missionsCompleted,
      'weatherCondition': instance.weatherCondition,
      'airQuality': instance.airQuality,
    };

_$LocationSampleImpl _$$LocationSampleImplFromJson(Map<String, dynamic> json) =>
    _$LocationSampleImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      accuracy: (json['accuracy'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
    );

Map<String, dynamic> _$$LocationSampleImplToJson(
        _$LocationSampleImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timestamp': instance.timestamp.toIso8601String(),
      'accuracy': instance.accuracy,
      'speed': instance.speed,
    };

_$MissionCompletedImpl _$$MissionCompletedImplFromJson(
        Map<String, dynamic> json) =>
    _$MissionCompletedImpl(
      missionId: json['missionId'] as String,
      missionType: json['missionType'] as String,
      rewardAmount: (json['rewardAmount'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$MissionCompletedImplToJson(
        _$MissionCompletedImpl instance) =>
    <String, dynamic>{
      'missionId': instance.missionId,
      'missionType': instance.missionType,
      'rewardAmount': instance.rewardAmount,
      'completedAt': instance.completedAt.toIso8601String(),
    };

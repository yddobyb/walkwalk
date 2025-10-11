// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MissionImpl _$$MissionImplFromJson(Map<String, dynamic> json) =>
    _$MissionImpl(
      missionId: json['missionId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetSteps: (json['targetSteps'] as num).toInt(),
      targetDuration: (json['targetDuration'] as num).toInt(),
      targetDistance: (json['targetDistance'] as num).toDouble(),
      treatReward: (json['treatReward'] as num).toInt(),
      happinessReward: (json['happinessReward'] as num).toInt(),
      badgeCode: json['badgeCode'] as String?,
      isActive: json['isActive'] as bool,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      currentProgress: (json['currentProgress'] as num).toInt(),
    );

Map<String, dynamic> _$$MissionImplToJson(_$MissionImpl instance) =>
    <String, dynamic>{
      'missionId': instance.missionId,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'targetSteps': instance.targetSteps,
      'targetDuration': instance.targetDuration,
      'targetDistance': instance.targetDistance,
      'treatReward': instance.treatReward,
      'happinessReward': instance.happinessReward,
      'badgeCode': instance.badgeCode,
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'currentProgress': instance.currentProgress,
    };

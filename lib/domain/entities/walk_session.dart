// lib/domain/entities/walk_session.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_session.freezed.dart';
part 'walk_session.g.dart';

@freezed
class WalkSession with _$WalkSession {
  const factory WalkSession({
    required String sessionId,
    required DateTime startTime,
    required DateTime endTime,
    required int totalSteps,
    required int duration, // 초 단위
    required double distance, // 미터 단위
    required double avgSpeed, // km/h
    required bool isOutdoor,
    required int validOutdoorSamples,
    required List<LocationSample> locationSamples,
    required int treatsEarned,
    required int happinessGained,
    required List<MissionCompleted> missionsCompleted,
    String? weatherCondition,
    double? airQuality,
  }) = _WalkSession;

  factory WalkSession.fromJson(Map<String, dynamic> json) => _$WalkSessionFromJson(json);
}

@freezed
class LocationSample with _$LocationSample {
  const factory LocationSample({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    required double accuracy, // 미터 단위
    required double speed, // m/s
  }) = _LocationSample;

  factory LocationSample.fromJson(Map<String, dynamic> json) => _$LocationSampleFromJson(json);
}

@freezed
class MissionCompleted with _$MissionCompleted {
  const factory MissionCompleted({
    required String missionId,
    required String missionType,
    required int rewardAmount,
    required DateTime completedAt,
  }) = _MissionCompleted;

  factory MissionCompleted.fromJson(Map<String, dynamic> json) => _$MissionCompletedFromJson(json);
}
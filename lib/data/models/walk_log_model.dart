// lib/data/models/walk_log_model.dart
import 'package:isar/isar.dart';
import '../../domain/entities/walk_session.dart';

part 'walk_log_model.g.dart';

@collection
class WalkLogModel {
  Id id = Isar.autoIncrement;

  late String sessionId; // UUID
  late DateTime startTime;
  late DateTime endTime;

  // 기본 데이터
  late int totalSteps;
  late int duration; // 초 단위
  late double distance; // 미터 단위
  late double avgSpeed; // km/h

  // 실외 모드 데이터
  late bool isOutdoor;
  late int validOutdoorSamples; // 유효 GPS 샘플 수

  late List<LocationSampleModel> locationSamples;

  // 보상
  late int treatsEarned;
  late int happinessGained;

  late List<MissionCompletedModel> missionsCompleted;

  // 메타데이터
  String? weatherCondition; // 날씨 (선택)
  double? airQuality; // 공기질 지수 (선택)

  // 도메인 엔티티로 변환
  WalkSession toDomain() {
    return WalkSession(
      sessionId: sessionId,
      startTime: startTime,
      endTime: endTime,
      totalSteps: totalSteps,
      duration: duration,
      distance: distance,
      avgSpeed: avgSpeed,
      isOutdoor: isOutdoor,
      validOutdoorSamples: validOutdoorSamples,
      locationSamples: locationSamples.map((e) => e.toDomain()).toList(),
      treatsEarned: treatsEarned,
      happinessGained: happinessGained,
      missionsCompleted: missionsCompleted.map((e) => e.toDomain()).toList(),
      weatherCondition: weatherCondition,
      airQuality: airQuality,
    );
  }

  /// 데이터베이스 서비스 호환성을 위한 별칭 메서드
  WalkSession toWalkSession() => toDomain();

  // 도메인 엔티티에서 생성
  static WalkLogModel fromDomain(WalkSession walkSession) {
    return WalkLogModel()
      ..sessionId = walkSession.sessionId
      ..startTime = walkSession.startTime
      ..endTime = walkSession.endTime
      ..totalSteps = walkSession.totalSteps
      ..duration = walkSession.duration
      ..distance = walkSession.distance
      ..avgSpeed = walkSession.avgSpeed
      ..isOutdoor = walkSession.isOutdoor
      ..validOutdoorSamples = walkSession.validOutdoorSamples
      ..locationSamples = walkSession.locationSamples
          .map((e) => LocationSampleModel.fromDomain(e))
          .toList()
      ..treatsEarned = walkSession.treatsEarned
      ..happinessGained = walkSession.happinessGained
      ..missionsCompleted = walkSession.missionsCompleted
          .map((e) => MissionCompletedModel.fromDomain(e))
          .toList()
      ..weatherCondition = walkSession.weatherCondition
      ..airQuality = walkSession.airQuality;
  }

  /// 데이터베이스 서비스 호환성을 위한 별칭 메서드
  static WalkLogModel fromWalkSession(WalkSession walkSession) => fromDomain(walkSession);
}

@embedded
class LocationSampleModel {
  late double latitude;
  late double longitude;
  late DateTime timestamp;
  late double accuracy; // 미터 단위
  late double speed; // m/s

  LocationSample toDomain() {
    return LocationSample(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      accuracy: accuracy,
      speed: speed,
    );
  }

  static LocationSampleModel fromDomain(LocationSample locationSample) {
    return LocationSampleModel()
      ..latitude = locationSample.latitude
      ..longitude = locationSample.longitude
      ..timestamp = locationSample.timestamp
      ..accuracy = locationSample.accuracy
      ..speed = locationSample.speed;
  }
}

@embedded
class MissionCompletedModel {
  late String missionId;
  late String missionType;
  late int rewardAmount;
  late DateTime completedAt;

  MissionCompleted toDomain() {
    return MissionCompleted(
      missionId: missionId,
      missionType: missionType,
      rewardAmount: rewardAmount,
      completedAt: completedAt,
    );
  }

  static MissionCompletedModel fromDomain(MissionCompleted missionCompleted) {
    return MissionCompletedModel()
      ..missionId = missionCompleted.missionId
      ..missionType = missionCompleted.missionType
      ..rewardAmount = missionCompleted.rewardAmount
      ..completedAt = missionCompleted.completedAt;
  }
}
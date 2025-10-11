// lib/data/models/mission_model.dart
import 'package:isar/isar.dart';
import '../../domain/entities/mission.dart';

part 'mission_model.g.dart';

@collection
class MissionModel {
  Id id = Isar.autoIncrement;

  late String missionId;
  late String type; // daily, weekly, special
  late String title;
  late String description;

  // 조건
  late int targetSteps;
  late int targetDuration; // 초
  late double targetDistance; // 미터

  // 보상
  late int treatReward;
  late int happinessReward;
  String? badgeCode; // 연결된 배지

  // 상태
  late bool isActive;
  late bool isCompleted;
  DateTime? completedAt;
  late DateTime expiresAt;

  // 진행도
  late int currentProgress;

  // targetProgress는 조건에 따라 결정됨 (targetSteps, targetDuration, targetDistance 중 하나)
  int get targetProgress {
    if (targetSteps > 0) return targetSteps;
    if (targetDuration > 0) return targetDuration;
    if (targetDistance > 0) return targetDistance.round();
    return 1;
  }

  // 도메인 엔티티로 변환
  Mission toDomain() {
    return Mission(
      missionId: missionId,
      type: type,
      title: title,
      description: description,
      targetSteps: targetSteps,
      targetDuration: targetDuration,
      targetDistance: targetDistance,
      treatReward: treatReward,
      happinessReward: happinessReward,
      badgeCode: badgeCode,
      isActive: isActive,
      isCompleted: isCompleted,
      completedAt: completedAt,
      expiresAt: expiresAt,
      currentProgress: currentProgress,
    );
  }

  // 도메인 엔티티에서 생성
  static MissionModel fromDomain(Mission mission) {
    return MissionModel()
      ..missionId = mission.missionId
      ..type = mission.type
      ..title = mission.title
      ..description = mission.description
      ..targetSteps = mission.targetSteps
      ..targetDuration = mission.targetDuration
      ..targetDistance = mission.targetDistance
      ..treatReward = mission.treatReward
      ..happinessReward = mission.happinessReward
      ..badgeCode = mission.badgeCode
      ..isActive = mission.isActive
      ..isCompleted = mission.isCompleted
      ..completedAt = mission.completedAt
      ..expiresAt = mission.expiresAt
      ..currentProgress = mission.currentProgress;
  }

  /// 데이터베이스 서비스 호환성을 위한 별칭 메서드
  Mission toEntity() => toDomain();
}
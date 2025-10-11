// lib/domain/entities/mission.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission.freezed.dart';
part 'mission.g.dart';

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String missionId,
    required String type, // daily, weekly, special
    required String title,
    required String description,
    required int targetSteps,
    required int targetDuration, // 초
    required double targetDistance, // 미터
    required int treatReward,
    required int happinessReward,
    String? badgeCode,
    required bool isActive,
    required bool isCompleted,
    DateTime? completedAt,
    required DateTime expiresAt,
    required int currentProgress,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
}
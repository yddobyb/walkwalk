// lib/domain/entities/achievement.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String code,
    required String title,
    required String description,
    required String iconPath,
    required AchievementTier tier,
    required bool isUnlocked,
    DateTime? unlockedAt,
    required int currentProgress,
    required int targetProgress,
    required int treatReward,
    required int happinessReward,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
}

enum AchievementTier {
  bronze,
  silver,
  gold,
  platinum,
}
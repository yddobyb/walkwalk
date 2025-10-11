// lib/data/models/achievement_model.dart
import 'package:isar/isar.dart';
import '../../domain/entities/achievement.dart';

part 'achievement_model.g.dart';

@collection
class AchievementModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String code; // STEPS_1K, STREAK_7, etc.

  late String title;
  late String description;
  late String iconPath;

  @Enumerated(EnumType.name)
  late AchievementTier tier;

  late bool isUnlocked;
  DateTime? unlockedAt;

  // 진행도
  late int currentProgress;
  late int targetProgress;

  // 보상
  late int treatReward;
  late int happinessReward;

  // 도메인 엔티티로 변환
  Achievement toDomain() {
    return Achievement(
      code: code,
      title: title,
      description: description,
      iconPath: iconPath,
      tier: tier,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
      currentProgress: currentProgress,
      targetProgress: targetProgress,
      treatReward: treatReward,
      happinessReward: happinessReward,
    );
  }

  // 도메인 엔티티에서 생성
  static AchievementModel fromDomain(Achievement achievement) {
    return AchievementModel()
      ..code = achievement.code
      ..title = achievement.title
      ..description = achievement.description
      ..iconPath = achievement.iconPath
      ..tier = achievement.tier
      ..isUnlocked = achievement.isUnlocked
      ..unlockedAt = achievement.unlockedAt
      ..currentProgress = achievement.currentProgress
      ..targetProgress = achievement.targetProgress
      ..treatReward = achievement.treatReward
      ..happinessReward = achievement.happinessReward;
  }
}
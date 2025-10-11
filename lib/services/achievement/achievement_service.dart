// lib/services/achievement/achievement_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/database_service.dart';
import '../../domain/entities/achievement.dart';
import '../pet/pet_reward_service.dart';

/// 배지/업적 시스템 관리 서비스
/// - 진행도 추적 및 업데이트
/// - 배지 해제 알림
/// - 보상 적용
class AchievementService {
  static AchievementService? _instance;
  static AchievementService get instance {
    _instance ??= AchievementService._();
    return _instance!;
  }

  AchievementService._();

  final DatabaseService _databaseService = DatabaseService();
  final PetRewardService _rewardService = PetRewardService.instance;

  // 새로 해제된 배지 스트림
  final StreamController<Achievement> _newUnlockedController = StreamController<Achievement>.broadcast();
  Stream<Achievement> get newUnlockedStream => _newUnlockedController.stream;

  /// 걸음수 기반 배지 진행도 업데이트
  Future<List<Achievement>> updateStepsAchievements(int totalSteps) async {
    final newlyUnlocked = <Achievement>[];

    try {
      // 걸음수 관련 배지들
      final stepsAchievements = [
        'STEPS_1K',    // 1,000걸음
        'STEPS_5K',    // 5,000걸음
        'STEPS_10K',   // 10,000걸음
      ];

      for (final code in stepsAchievements) {
        final achievement = await _updateAchievementProgress(code, totalSteps);
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      debugPrint('AchievementService - Steps achievements updated: ${newlyUnlocked.length} newly unlocked');
    } catch (e) {
      debugPrint('AchievementService - Error updating steps achievements: $e');
    }

    return newlyUnlocked;
  }

  /// 거리 기반 배지 진행도 업데이트
  Future<List<Achievement>> updateDistanceAchievements(double totalDistanceMeters) async {
    final newlyUnlocked = <Achievement>[];

    try {
      // 거리 관련 배지들
      final distanceAchievements = [
        'DISTANCE_1KM',  // 1km
      ];

      for (final code in distanceAchievements) {
        final achievement = await _updateAchievementProgress(code, totalDistanceMeters.round());
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      debugPrint('AchievementService - Distance achievements updated: ${newlyUnlocked.length} newly unlocked');
    } catch (e) {
      debugPrint('AchievementService - Error updating distance achievements: $e');
    }

    return newlyUnlocked;
  }

  /// 연속 산책 배지 진행도 업데이트
  Future<List<Achievement>> updateStreakAchievements(int currentStreak) async {
    final newlyUnlocked = <Achievement>[];

    try {
      // 연속 산책 관련 배지들
      final streakAchievements = [
        'STREAK_3',    // 3일 연속
        'STREAK_7',    // 7일 연속
      ];

      for (final code in streakAchievements) {
        final achievement = await _updateAchievementProgress(code, currentStreak);
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      debugPrint('AchievementService - Streak achievements updated: ${newlyUnlocked.length} newly unlocked');
    } catch (e) {
      debugPrint('AchievementService - Error updating streak achievements: $e');
    }

    return newlyUnlocked;
  }

  /// 행복도 기반 배지 진행도 업데이트
  Future<List<Achievement>> updateHappinessAchievements(int happiness) async {
    final newlyUnlocked = <Achievement>[];

    try {
      // 행복도 관련 배지들
      final happinessAchievements = [
        'HAPPY_100',   // 행복도 100
      ];

      for (final code in happinessAchievements) {
        final achievement = await _updateAchievementProgress(code, happiness);
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      debugPrint('AchievementService - Happiness achievements updated: ${newlyUnlocked.length} newly unlocked');
    } catch (e) {
      debugPrint('AchievementService - Error updating happiness achievements: $e');
    }

    return newlyUnlocked;
  }

  /// 간식 기반 배지 진행도 업데이트
  Future<List<Achievement>> updateTreatsAchievements(int totalTreats) async {
    final newlyUnlocked = <Achievement>[];

    try {
      // 간식 관련 배지들
      final treatsAchievements = [
        'TREATS_100',  // 간식 100개
      ];

      for (final code in treatsAchievements) {
        final achievement = await _updateAchievementProgress(code, totalTreats);
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      debugPrint('AchievementService - Treats achievements updated: ${newlyUnlocked.length} newly unlocked');
    } catch (e) {
      debugPrint('AchievementService - Error updating treats achievements: $e');
    }

    return newlyUnlocked;
  }

  /// 특별 배지 해제 (첫 산책, 첫 실외 산책 등)
  Future<Achievement?> unlockSpecialAchievement(String code) async {
    try {
      final achievement = await _updateAchievementProgress(code, 1);
      if (achievement != null) {
        debugPrint('AchievementService - Special achievement unlocked: $code');
      }
      return achievement;
    } catch (e) {
      debugPrint('AchievementService - Error unlocking special achievement: $e');
      return null;
    }
  }

  /// 산책 완료 시 종합 배지 체크
  Future<List<Achievement>> checkWalkCompletionAchievements({
    required int totalSteps,
    required double totalDistanceMeters,
    required int currentStreak,
    required bool isFirstWalk,
    required bool isFirstOutdoorWalk,
  }) async {
    final allNewlyUnlocked = <Achievement>[];

    try {
      // 걸음수 배지
      final stepsUnlocked = await updateStepsAchievements(totalSteps);
      allNewlyUnlocked.addAll(stepsUnlocked);

      // 거리 배지
      final distanceUnlocked = await updateDistanceAchievements(totalDistanceMeters);
      allNewlyUnlocked.addAll(distanceUnlocked);

      // 연속 산책 배지
      final streakUnlocked = await updateStreakAchievements(currentStreak);
      allNewlyUnlocked.addAll(streakUnlocked);

      // 특별 배지들
      if (isFirstWalk) {
        final firstWalk = await unlockSpecialAchievement('FIRST_WALK');
        if (firstWalk != null) allNewlyUnlocked.add(firstWalk);
      }

      if (isFirstOutdoorWalk) {
        final firstOutdoor = await unlockSpecialAchievement('OUTDOOR_FIRST');
        if (firstOutdoor != null) allNewlyUnlocked.add(firstOutdoor);
      }

      // 새로 해제된 배지에 대한 보상 적용
      if (allNewlyUnlocked.isNotEmpty) {
        await _applyAchievementRewards(allNewlyUnlocked);
      }

      debugPrint('AchievementService - Walk completion check: ${allNewlyUnlocked.length} achievements unlocked');
    } catch (e) {
      debugPrint('AchievementService - Error checking walk completion achievements: $e');
    }

    return allNewlyUnlocked;
  }

  /// 내부 메서드: 배지 진행도 업데이트
  Future<Achievement?> _updateAchievementProgress(String code, int progress) async {
    try {
      await _databaseService.updateAchievementProgress(code, progress);

      // 업데이트된 배지 정보 가져오기
      final achievementModels = await _databaseService.getAllAchievements();
      final achievementModel = achievementModels.where((a) => a.code == code).firstOrNull;

      if (achievementModel != null && achievementModel.isUnlocked && achievementModel.unlockedAt != null) {
        // 방금 해제된 배지인지 확인 (1초 이내)
        final timeDiff = DateTime.now().difference(achievementModel.unlockedAt!);
        if (timeDiff.inSeconds <= 1) {
          final achievement = achievementModel.toDomain();
          _newUnlockedController.add(achievement);
          return achievement;
        }
      }
    } catch (e) {
      debugPrint('AchievementService - Error updating achievement progress for $code: $e');
    }

    return null;
  }

  /// 내부 메서드: 배지 보상 적용
  Future<void> _applyAchievementRewards(List<Achievement> achievements) async {
    try {
      final activePet = await _rewardService.getActivePet();
      if (activePet == null) return;

      int totalTreats = 0;
      int totalHappiness = 0;

      for (final achievement in achievements) {
        totalTreats += achievement.treatReward;
        totalHappiness += achievement.happinessReward;
      }

      if (totalTreats > 0 || totalHappiness > 0) {
        await _rewardService.addRewards(
          activePet.petId,
          treats: totalTreats,
          happiness: totalHappiness,
        );

        debugPrint('AchievementService - Applied rewards: +$totalTreats treats, +$totalHappiness happiness');
      }
    } catch (e) {
      debugPrint('AchievementService - Error applying achievement rewards: $e');
    }
  }

  /// 모든 배지 가져오기
  Future<List<Achievement>> getAllAchievements() async {
    try {
      final achievementModels = await _databaseService.getAllAchievements();
      return achievementModels.map((model) => model.toDomain()).toList();
    } catch (e) {
      debugPrint('AchievementService - Error getting all achievements: $e');
      return [];
    }
  }

  /// 해제된 배지만 가져오기
  Future<List<Achievement>> getUnlockedAchievements() async {
    try {
      final achievementModels = await _databaseService.getUnlockedAchievements();
      return achievementModels.map((model) => model.toDomain()).toList();
    } catch (e) {
      debugPrint('AchievementService - Error getting unlocked achievements: $e');
      return [];
    }
  }

  /// 미해제 배지만 가져오기
  Future<List<Achievement>> getLockedAchievements() async {
    try {
      final allAchievements = await getAllAchievements();
      return allAchievements.where((a) => !a.isUnlocked).toList();
    } catch (e) {
      debugPrint('AchievementService - Error getting locked achievements: $e');
      return [];
    }
  }

  /// 서비스 정리
  void dispose() {
    _newUnlockedController.close();
    debugPrint('AchievementService - Disposed');
  }
}

/// Riverpod Provider
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService.instance;
});

/// 모든 배지 Provider
final allAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.read(achievementServiceProvider);
  return await service.getAllAchievements();
});

/// 해제된 배지 Provider
final unlockedAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.read(achievementServiceProvider);
  return await service.getUnlockedAchievements();
});

/// 미해제 배지 Provider
final lockedAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.read(achievementServiceProvider);
  return await service.getLockedAchievements();
});

/// 새로 해제된 배지 스트림 Provider
final newUnlockedAchievementProvider = StreamProvider<Achievement>((ref) {
  final service = ref.read(achievementServiceProvider);
  return service.newUnlockedStream;
});
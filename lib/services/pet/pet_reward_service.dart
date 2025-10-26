// lib/services/pet/pet_reward_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/walk_session.dart';
import '../../data/datasources/database_service.dart';

/// 펫 보상 시스템을 관리하는 서비스
/// - 걸음수 기반 간식 계산
/// - 행복도 관리 및 일일 감소
/// - 보상 및 패널티 적용
class PetRewardService {
  static PetRewardService? _instance;
  static PetRewardService get instance {
    _instance ??= PetRewardService._();
    return _instance!;
  }

  PetRewardService._();

  final DatabaseService _databaseService = DatabaseService();

  /// 걸음수를 기반으로 획득할 간식 수 계산
  int calculateTreatsFromSteps(int steps, {bool isOutdoor = false}) {
    if (steps < AppConstants.minStepsForReward) return 0;

    int baseTreats = steps ~/ AppConstants.stepsPerTreat;

    // 실외 산책 시 보너스 적용
    if (isOutdoor) {
      baseTreats = (baseTreats * AppConstants.outdoorBonusMultiplier).round();
    }

    return baseTreats;
  }

  /// 걸음수를 기반으로 획득할 행복도 계산
  int calculateHappinessFromSteps(int steps, {bool isOutdoor = false}) {
    if (steps < AppConstants.minStepsForReward) return 0;

    int baseHappiness = steps ~/ AppConstants.stepsPerHappiness;

    // 실외 산책 시 보너스 적용
    if (isOutdoor) {
      baseHappiness = (baseHappiness * AppConstants.outdoorBonusMultiplier).round();
    }

    return baseHappiness;
  }

  /// 걸음수를 기반으로 획득할 경험치 계산
  int calculateExperienceFromSteps(int steps, {bool isOutdoor = false}) {
    if (steps < AppConstants.minStepsForReward) return 0;

    int baseExperience = steps ~/ AppConstants.stepsPerExperience;

    // 실외 산책 시 보너스 적용
    if (isOutdoor) {
      baseExperience = (baseExperience * AppConstants.outdoorBonusMultiplier).round();
    }

    return baseExperience;
  }

  /// 거리를 기반으로 획득할 경험치 계산 (미터 단위)
  int calculateExperienceFromDistance(double distanceMeters, {bool isOutdoor = false}) {
    if (distanceMeters < 0) return 0;

    int baseExperience = distanceMeters ~/ AppConstants.distancePerExperience;

    // 실외 산책 시 보너스 적용
    if (isOutdoor) {
      baseExperience = (baseExperience * AppConstants.outdoorBonusMultiplier).round();
    }

    return baseExperience;
  }

  /// 특정 레벨에 필요한 총 경험치 계산
  int calculateRequiredExperience(int level) {
    if (level <= 1) return 0;
    if (level > AppConstants.maxLevel) return calculateRequiredExperience(AppConstants.maxLevel);

    // 지수 증가 공식: baseXP * (scalingFactor ^ (level - 1))
    int requiredXP = (AppConstants.baseExperiencePerLevel *
      pow(AppConstants.experienceScalingFactor, level - 1)).round();

    return requiredXP;
  }

  /// 레벨업 확인 및 처리 (보상 포함)
  /// 반환: (레벨업 발생 여부, 업데이트된 Pet)
  Future<(bool, Pet?)> checkAndApplyLevelUp(Pet pet) async {
    if (pet.level >= AppConstants.maxLevel) {
      return (false, pet);
    }

    final requiredXP = calculateRequiredExperience(pet.level + 1);

    if (pet.experience >= requiredXP) {
      // 레벨업!
      final newLevel = pet.level + 1;
      final remainingXP = pet.experience - requiredXP; // 남은 경험치

      final updatedPet = pet.copyWith(
        level: newLevel,
        experience: remainingXP,
        treats: min(pet.treats + AppConstants.levelUpTreatsReward, AppConstants.maxTreats),
        happiness: min(pet.happiness + AppConstants.levelUpHappinessReward, AppConstants.maxHappiness),
        lastUpdate: DateTime.now(),
      );

      await _databaseService.savePet(updatedPet);

      // 다중 레벨업 처리 (경험치가 여러 레벨을 넘길 경우)
      return await checkAndApplyLevelUp(updatedPet);
    }

    return (false, pet);
  }

  /// 산책 세션 완료 시 보상 계산 및 적용
  Future<Pet?> applyWalkRewards(String petId, WalkSession walkSession) async {
    final pet = await _databaseService.getPetById(petId);
    if (pet == null) return null;

    // 보상 계산
    final treatsEarned = calculateTreatsFromSteps(
      walkSession.totalSteps,
      isOutdoor: walkSession.isOutdoor,
    );

    final happinessGained = calculateHappinessFromSteps(
      walkSession.totalSteps,
      isOutdoor: walkSession.isOutdoor,
    );

    // 경험치 계산 (걸음수 + 거리 기반)
    final expFromSteps = calculateExperienceFromSteps(
      walkSession.totalSteps,
      isOutdoor: walkSession.isOutdoor,
    );
    final expFromDistance = calculateExperienceFromDistance(
      walkSession.distance,
      isOutdoor: walkSession.isOutdoor,
    );
    final totalExpGained = expFromSteps + expFromDistance;

    // 펫 상태 업데이트
    var updatedPet = pet.copyWith(
      treats: min(pet.treats + treatsEarned, AppConstants.maxTreats),
      happiness: min(pet.happiness + happinessGained, AppConstants.maxHappiness),
      experience: pet.experience + totalExpGained,
      stepsToday: pet.stepsToday + walkSession.totalSteps,
      totalSteps: pet.totalSteps + walkSession.totalSteps,
      lastUpdate: DateTime.now(),
      avgDailySteps: _calculateUpdatedAvgDailySteps(pet, walkSession.totalSteps),
    );

    // 데이터베이스에 저장
    await _databaseService.savePet(updatedPet);

    // 레벨업 체크 및 처리
    final (leveledUp, finalPet) = await checkAndApplyLevelUp(updatedPet);

    return finalPet ?? updatedPet;
  }

  /// 간식 소모 (펫에게 간식 주기)
  Future<Pet?> feedTreat(String petId, int treatCount) async {
    final pet = await _databaseService.getPetById(petId);
    if (pet == null || pet.treats < treatCount) return null;

    final happinessGain = treatCount * AppConstants.happinessPerTreat;

    final updatedPet = pet.copyWith(
      treats: pet.treats - treatCount,
      happiness: min(pet.happiness + happinessGain, AppConstants.maxHappiness),
      lastUpdate: DateTime.now(),
    );

    await _databaseService.savePet(updatedPet);
    return updatedPet;
  }

  /// 일일 행복도 자연 감소 적용
  /// 마지막 감소 적용일로부터 지난 일수만큼 누적 감소 적용
  Future<Pet?> applyDailyHappinessDecay(String petId) async {
    final pet = await _databaseService.getPetById(petId);
    if (pet == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDecayDate = pet.lastDecayDate;

    // 지난 일수 계산
    int daysPassed = 0;

    if (lastDecayDate == null) {
      // 첫 감소 적용 (기존 데이터 호환)
      // 생성일로부터 지난 일수 계산
      final createdDay = DateTime(pet.createdAt.year, pet.createdAt.month, pet.createdAt.day);
      daysPassed = today.difference(createdDay).inDays;
    } else {
      // lastDecayDate로부터 지난 일수 계산
      final lastDecayDay = DateTime(lastDecayDate.year, lastDecayDate.month, lastDecayDate.day);
      daysPassed = today.difference(lastDecayDay).inDays;
    }

    // 지난 일수가 0이면 이미 오늘 감소 적용됨
    if (daysPassed <= 0) {
      debugPrint('PetRewardService - No decay needed. Days passed: $daysPassed');
      return pet;
    }

    // 누적 감소량 계산 (지난 일수 × 일일 감소량)
    final totalDecay = daysPassed * AppConstants.happinessDecayPerDay;
    final newHappiness = max(pet.happiness - totalDecay, AppConstants.minHappiness);

    debugPrint('PetRewardService - Applying $daysPassed days of decay. Total decay: -$totalDecay (${pet.happiness} → $newHappiness)');

    final updatedPet = pet.copyWith(
      happiness: newHappiness,
      stepsToday: 0, // 새로운 날이므로 오늘 걸음수 초기화
      lastDecayDate: now, // 감소 적용 날짜 업데이트
      lastUpdate: now,
    );

    await _databaseService.savePet(updatedPet);
    return updatedPet;
  }

  /// 연속 산책 일수 업데이트
  Future<Pet?> updateWalkStreak(String petId) async {
    final pet = await _databaseService.getPetById(petId);
    if (pet == null) return null;

    final now = DateTime.now();
    final lastUpdate = pet.lastUpdate;

    // 어제 산책했는지 확인
    final yesterday = now.subtract(const Duration(days: 1));
    final wasYesterday = lastUpdate.day == yesterday.day &&
                        lastUpdate.month == yesterday.month &&
                        lastUpdate.year == yesterday.year;

    // 오늘 이미 산책했는지 확인
    final wasToday = lastUpdate.day == now.day &&
                    lastUpdate.month == now.month &&
                    lastUpdate.year == now.year;

    int newConsecutiveDays = pet.consecutiveDays;

    if (wasYesterday && !wasToday) {
      // 어제 산책했고 오늘 첫 산책인 경우 연속일 증가
      newConsecutiveDays = pet.consecutiveDays + 1;
    } else if (!wasYesterday && !wasToday) {
      // 연속이 끊어진 경우 1부터 시작
      newConsecutiveDays = 1;
    }
    // wasToday인 경우 이미 오늘 산책했으므로 변경하지 않음

    final updatedPet = pet.copyWith(
      consecutiveDays: newConsecutiveDays,
      bestStreak: max(pet.bestStreak, newConsecutiveDays),
      lastUpdate: now,
    );

    await _databaseService.savePet(updatedPet);
    return updatedPet;
  }

  /// 일평균 걸음수 계산
  double _calculateUpdatedAvgDailySteps(Pet pet, int newSteps) {
    final daysSinceCreation = DateTime.now().difference(pet.createdAt).inDays + 1;
    final totalStepsIncludingNew = pet.totalSteps + newSteps;
    return totalStepsIncludingNew / daysSinceCreation;
  }

  /// 펫의 현재 상태를 기반으로 감정 상태 계산
  PetMood calculatePetMood(Pet pet) {
    if (pet.happiness >= 80) {
      return PetMood.veryHappy;
    } else if (pet.happiness >= 60) {
      return PetMood.happy;
    } else if (pet.happiness >= 40) {
      return PetMood.neutral;
    } else if (pet.happiness >= 20) {
      return PetMood.sad;
    } else {
      return PetMood.verySad;
    }
  }

  /// 보상 요약 정보 생성
  RewardSummary calculateRewardSummary(WalkSession walkSession) {
    final treatsEarned = calculateTreatsFromSteps(
      walkSession.totalSteps,
      isOutdoor: walkSession.isOutdoor,
    );

    final happinessGained = calculateHappinessFromSteps(
      walkSession.totalSteps,
      isOutdoor: walkSession.isOutdoor,
    );

    return RewardSummary(
      steps: walkSession.totalSteps,
      treatsEarned: treatsEarned,
      happinessGained: happinessGained,
      isOutdoor: walkSession.isOutdoor,
      duration: walkSession.duration,
      distance: walkSession.distance,
    );
  }

  /// 특별 이벤트 보상 (생일, 기념일 등)
  Future<Pet?> applySpecialEventReward(String petId, SpecialEventType eventType) async {
    final pet = await _databaseService.getPetById(petId);
    if (pet == null) return null;

    int bonusTreats = 0;
    int bonusHappiness = 0;

    switch (eventType) {
      case SpecialEventType.birthday:
        bonusTreats = 20;
        bonusHappiness = 30;
        break;
      case SpecialEventType.weeklyGoalAchieved:
        bonusTreats = 10;
        bonusHappiness = 20;
        break;
      case SpecialEventType.monthlyGoalAchieved:
        bonusTreats = 30;
        bonusHappiness = 50;
        break;
      case SpecialEventType.perfectWeek:
        bonusTreats = 50;
        bonusHappiness = 50;
        break;
    }

    final updatedPet = pet.copyWith(
      treats: min(pet.treats + bonusTreats, AppConstants.maxTreats),
      happiness: min(pet.happiness + bonusHappiness, AppConstants.maxHappiness),
      lastUpdate: DateTime.now(),
    );

    await _databaseService.savePet(updatedPet);
    return updatedPet;
  }

  /// 펫에게 직접 보상 추가 (배지 보상 등)
  Future<Pet?> addRewards(String petId, {int treats = 0, int happiness = 0}) async {
    final pet = await _databaseService.getPetById(petId);
    if (pet == null) return null;

    final updatedPet = pet.copyWith(
      treats: min(pet.treats + treats, AppConstants.maxTreats),
      happiness: min(pet.happiness + happiness, AppConstants.maxHappiness),
      lastUpdate: DateTime.now(),
    );

    await _databaseService.savePet(updatedPet);
    return updatedPet;
  }

  /// 현재 활성 펫 가져오기
  Future<Pet?> getActivePet() async {
    final pets = await _databaseService.getAllPets();
    if (pets.isEmpty) return null;

    try {
      return pets.firstWhere((pet) => pet.isActive);
    } catch (e) {
      // isActive인 펫이 없으면 첫 번째 펫 반환
      return pets.first;
    }
  }
}

/// 펫의 감정 상태
enum PetMood {
  veryHappy,  // 매우 기쁨 (80-100)
  happy,      // 기쁨 (60-79)
  neutral,    // 보통 (40-59)
  sad,        // 슬픔 (20-39)
  verySad,    // 매우 슬픔 (0-19)
}

/// 특별 이벤트 타입
enum SpecialEventType {
  birthday,
  weeklyGoalAchieved,
  monthlyGoalAchieved,
  perfectWeek,
}

/// 보상 요약 정보
class RewardSummary {
  final int steps;
  final int treatsEarned;
  final int happinessGained;
  final bool isOutdoor;
  final int duration;
  final double distance;

  const RewardSummary({
    required this.steps,
    required this.treatsEarned,
    required this.happinessGained,
    required this.isOutdoor,
    required this.duration,
    required this.distance,
  });
}

/// Riverpod Provider
final petRewardServiceProvider = Provider<PetRewardService>((ref) {
  return PetRewardService.instance;
});

/// 활성 펫 Provider
final activePetProvider = FutureProvider<Pet?>((ref) async {
  final rewardService = ref.read(petRewardServiceProvider);
  return await rewardService.getActivePet();
});

/// 펫 무드 Provider
final petMoodProvider = Provider<PetMood?>((ref) {
  final petAsync = ref.watch(activePetProvider);
  return petAsync.when(
    data: (pet) => pet != null ? ref.read(petRewardServiceProvider).calculatePetMood(pet) : null,
    loading: () => null,
    error: (_, __) => null,
  );
});
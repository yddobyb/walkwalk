// lib/data/datasources/database_service.dart
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pet_model.dart';
import '../models/walk_log_model.dart';
import '../models/achievement_model.dart';
import '../models/mission_model.dart';
import '../models/settings_model.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/walk_session.dart';
import '../../core/constants/app_constants.dart';

class DatabaseService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;
    return await _initializeIsar();
  }

  static Future<Isar> _initializeIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        PetModelSchema,
        WalkLogModelSchema,
        AchievementModelSchema,
        MissionModelSchema,
        SettingsModelSchema,
      ],
      directory: dir.path,
      name: 'walkdog_db',
      inspector: true, // 개발 시에만 true
    );

    await _initializeDefaultData();
    return _isar!;
  }

  static Future<void> _initializeDefaultData() async {
    if (_isar == null) return;

    try {
      // 기본 설정이 없으면 생성
      final existingSettings = await _isar!.settingsModels.get(AppConstants.settingsId);
      if (existingSettings == null) {
        await _isar!.writeTxn(() async {
          await _isar!.settingsModels.put(SettingsModel.createDefault());
        });
      }

      // 기본 배지 데이터 초기화
      final achievementCount = await _isar!.achievementModels.count();
      if (achievementCount == 0) {
        await _initializeDefaultAchievements();
      }

      // 기존 펫 데이터 마이그레이션: experience 필드가 음수이면 0으로 수정
      await _migratePetExperience();
    } catch (e) {
      debugPrint('Failed to initialize default data: $e');
      rethrow; // 초기화 실패는 critical하므로 재throw
    }
  }

  /// 기존 펫 데이터의 experience 필드 마이그레이션
  static Future<void> _migratePetExperience() async {
    if (_isar == null) return;

    try {
      final allPets = await _isar!.petModels.where().findAll();
      final petsToUpdate = <PetModel>[];

      for (final pet in allPets) {
        // experience가 음수이거나 비정상적으로 큰 값이면 0으로 수정
        if (pet.experience < 0 || pet.experience > 1000000) {
          debugPrint('DatabaseService - Migrating pet "${pet.name}": experience ${pet.experience} -> 0');
          pet.experience = 0;
          petsToUpdate.add(pet);
        }
      }

      if (petsToUpdate.isNotEmpty) {
        await _isar!.writeTxn(() async {
          await _isar!.petModels.putAll(petsToUpdate);
        });
        debugPrint('DatabaseService - ✅ Migrated ${petsToUpdate.length} pet(s) experience field');
      }
    } catch (e) {
      debugPrint('DatabaseService - Failed to migrate pet experience: $e');
      // 마이그레이션 실패는 critical하지 않으므로 로그만 출력
    }
  }

  static Future<void> _initializeDefaultAchievements() async {
    if (_isar == null) return;

    final achievements = [
      AchievementModel()
        ..code = "FIRST_WALK"
        ..title = "첫 산책"
        ..description = "첫 번째 산책을 완료했어요!"
        ..iconPath = "assets/badges/first_walk.png"
        ..tier = AchievementTier.bronze
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 1
        ..treatReward = 5
        ..happinessReward = 10,

      AchievementModel()
        ..code = "STEPS_1K"
        ..title = "천 걸음"
        ..description = "누적 1,000걸음 달성!"
        ..iconPath = "assets/badges/steps_1k.png"
        ..tier = AchievementTier.bronze
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 1000
        ..treatReward = 10
        ..happinessReward = 15,

      AchievementModel()
        ..code = "STEPS_5K"
        ..title = "오천 걸음"
        ..description = "누적 5,000걸음 달성!"
        ..iconPath = "assets/badges/steps_5k.png"
        ..tier = AchievementTier.silver
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 5000
        ..treatReward = 20
        ..happinessReward = 25,

      AchievementModel()
        ..code = "STEPS_10K"
        ..title = "만 걸음"
        ..description = "누적 10,000걸음 달성!"
        ..iconPath = "assets/badges/steps_10k.png"
        ..tier = AchievementTier.gold
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 10000
        ..treatReward = 50
        ..happinessReward = 50,

      AchievementModel()
        ..code = "STREAK_3"
        ..title = "3일 연속"
        ..description = "3일 연속 산책 완료!"
        ..iconPath = "assets/badges/streak_3.png"
        ..tier = AchievementTier.bronze
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 3
        ..treatReward = 15
        ..happinessReward = 20,

      AchievementModel()
        ..code = "STREAK_7"
        ..title = "1주일 연속"
        ..description = "7일 연속 산책 완료!"
        ..iconPath = "assets/badges/streak_7.png"
        ..tier = AchievementTier.silver
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 7
        ..treatReward = 30
        ..happinessReward = 40,

      AchievementModel()
        ..code = "OUTDOOR_FIRST"
        ..title = "첫 실외 산책"
        ..description = "첫 번째 실외 산책을 완료했어요!"
        ..iconPath = "assets/badges/outdoor_first.png"
        ..tier = AchievementTier.bronze
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 1
        ..treatReward = 15
        ..happinessReward = 20,

      AchievementModel()
        ..code = "HAPPY_100"
        ..title = "최고 행복도"
        ..description = "행복도 100에 도달했어요!"
        ..iconPath = "assets/badges/happy_100.png"
        ..tier = AchievementTier.gold
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 100
        ..treatReward = 25
        ..happinessReward = 0,

      AchievementModel()
        ..code = "TREATS_100"
        ..title = "간식 부자"
        ..description = "간식 100개를 모았어요!"
        ..iconPath = "assets/badges/treats_100.png"
        ..tier = AchievementTier.silver
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 100
        ..treatReward = 0
        ..happinessReward = 30,

      AchievementModel()
        ..code = "DISTANCE_1KM"
        ..title = "1km 달성"
        ..description = "누적 1km 산책 완료!"
        ..iconPath = "assets/badges/distance_1km.png"
        ..tier = AchievementTier.bronze
        ..isUnlocked = false
        ..currentProgress = 0
        ..targetProgress = 1000 // 미터 단위
        ..treatReward = 20
        ..happinessReward = 25,
    ];

    try {
      await _isar!.writeTxn(() async {
        await _isar!.achievementModels.putAll(achievements);
      });
    } catch (e) {
      debugPrint('Failed to initialize default achievements: $e');
      rethrow;
    }
  }

  // === Pet 관련 메서드 ===

  /// 새로운 펫 저장
  Future<void> savePet(dynamic pet) async {
    try {
      final isar = await instance;

      // 기존 펫 찾기 (petId로 조회)
      final existingPet = await isar.petModels.filter().petIdEqualTo(pet.petId).findFirst();

      final petModel = PetModel.fromDomain(pet);

      // 기존 펫이 있으면 id 유지 (unique index violation 방지)
      if (existingPet != null) {
        petModel.id = existingPet.id;
      }

      await isar.writeTxn(() async {
        await isar.petModels.put(petModel);
      });
      print('✅ DatabaseService - Pet saved successfully: ${pet.name} (happiness: ${pet.happiness})');
    } catch (e) {
      print('❌ DatabaseService - Failed to save pet: $e');
      rethrow;
    }
  }

  /// 모든 펫 가져오기
  Future<List<dynamic>> getAllPets() async {
    final isar = await instance;
    final petModels = await isar.petModels.where().findAll();
    return petModels.map((model) => model.toDomain()).toList();
  }

  /// 펫 ID로 펫 가져오기
  Future<dynamic> getPetById(String petId) async {
    final isar = await instance;
    final petModel = await isar.petModels.filter().petIdEqualTo(petId).findFirst();
    return petModel?.toDomain();
  }

  /// 펫 삭제
  Future<void> deletePet(String petId) async {
    try {
      final isar = await instance;
      await isar.writeTxn(() async {
        await isar.petModels.filter().petIdEqualTo(petId).deleteFirst();
      });
    } catch (e) {
      debugPrint('Failed to delete pet: $e');
      rethrow;
    }
  }

  // === Walk Session 관련 메서드 ===

  /// 산책 세션 저장
  Future<void> saveWalkSession(dynamic walkSession) async {
    try {
      final isar = await instance;
      final walkLogModel = WalkLogModel.fromWalkSession(walkSession);

      await isar.writeTxn(() async {
        await isar.walkLogModels.put(walkLogModel);
      });
    } catch (e) {
      debugPrint('Failed to save walk session: $e');
      rethrow;
    }
  }

  /// 모든 산책 세션 가져오기
  Future<List<WalkSession>> getAllWalkSessions() async {
    final isar = await instance;
    final walkLogModels = await isar.walkLogModels.where().sortByStartTimeDesc().findAll();
    return walkLogModels.map((model) => model.toWalkSession()).toList();
  }

  /// 날짜별 산책 세션 가져오기
  Future<List<WalkSession>> getWalkSessionsByDate(DateTime date) async {
    final isar = await instance;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final walkLogModels = await isar.walkLogModels
        .filter()
        .startTimeBetween(startOfDay, endOfDay)
        .findAll();

    return walkLogModels.map((model) => model.toWalkSession()).toList();
  }

  // === Achievement 관련 메서드 ===

  /// 모든 배지 가져오기
  Future<List<AchievementModel>> getAllAchievements() async {
    final isar = await instance;
    return await isar.achievementModels.where().findAll();
  }

  /// 배지 진행도 업데이트
  Future<void> updateAchievementProgress(String code, int progress) async {
    try {
      final isar = await instance;
      final achievement = await isar.achievementModels.filter().codeEqualTo(code).findFirst();

      if (achievement != null) {
        achievement.currentProgress = progress;
        if (progress >= achievement.targetProgress && !achievement.isUnlocked) {
          achievement.isUnlocked = true;
          achievement.unlockedAt = DateTime.now();
        }

        await isar.writeTxn(() async {
          await isar.achievementModels.put(achievement);
        });
      }
    } catch (e) {
      debugPrint('Failed to update achievement progress: $e');
      rethrow;
    }
  }

  /// 잠금 해제된 배지 가져오기
  Future<List<AchievementModel>> getUnlockedAchievements() async {
    final isar = await instance;
    return await isar.achievementModels.filter().isUnlockedEqualTo(true).findAll();
  }

  // === Mission 관련 메서드 ===

  /// 활성 미션 가져오기
  Future<List<Mission>> getActiveMissions() async {
    final isar = await instance;
    final now = DateTime.now();
    final missionModels = await isar.missionModels
        .filter()
        .isActiveEqualTo(true)
        .and()
        .expiresAtGreaterThan(now)
        .findAll();

    return missionModels.map((model) => model.toDomain()).toList();
  }

  /// 활성 미션 실시간 감시 (Stream) - 데이터베이스 변경 시 자동 업데이트
  Stream<List<Mission>> watchActiveMissions() async* {
    final isar = await instance;

    // Isar의 watch 기능을 사용하여 실시간 업데이트
    await for (final _ in isar.missionModels.watchLazy()) {
      final now = DateTime.now();
      final missionModels = await isar.missionModels
          .filter()
          .isActiveEqualTo(true)
          .and()
          .expiresAtGreaterThan(now)
          .findAll();

      yield missionModels.map((model) => model.toDomain()).toList();
    }
  }

  /// 미션 진행도 업데이트
  Future<void> updateMissionProgress(String missionId, int progress) async {
    try {
      final isar = await instance;
      final mission = await isar.missionModels.filter().missionIdEqualTo(missionId).findFirst();

      if (mission != null) {
        mission.currentProgress = progress;
        if (progress >= mission.targetProgress && !mission.isCompleted) {
          mission.isCompleted = true;
          mission.completedAt = DateTime.now();
        }

        await isar.writeTxn(() async {
          await isar.missionModels.put(mission);
        });
      }
    } catch (e) {
      debugPrint('Failed to update mission progress: $e');
      rethrow;
    }
  }

  /// 미션 저장
  Future<void> saveMission(Mission mission) async {
    try {
      final isar = await instance;
      final missionModel = MissionModel.fromDomain(mission);

      await isar.writeTxn(() async {
        await isar.missionModels.put(missionModel);
      });
    } catch (e) {
      debugPrint('Failed to save mission: $e');
      rethrow;
    }
  }

  /// 여러 미션 일괄 저장
  Future<void> saveMissions(List<Mission> missions) async {
    try {
      final isar = await instance;
      final missionModels = missions.map((mission) => MissionModel.fromDomain(mission)).toList();

      await isar.writeTxn(() async {
        await isar.missionModels.putAll(missionModels);
      });
    } catch (e) {
      debugPrint('Failed to save missions: $e');
      rethrow;
    }
  }

  /// 만료된 미션 제거
  Future<void> removeExpiredMissions() async {
    try {
      final isar = await instance;
      final now = DateTime.now();

      final expiredMissions = await isar.missionModels
          .filter()
          .expiresAtLessThan(now)
          .findAll();

      if (expiredMissions.isNotEmpty) {
        await isar.writeTxn(() async {
          final ids = expiredMissions.map((mission) => mission.id).toList();
          await isar.missionModels.deleteAll(ids);
        });
      }
    } catch (e) {
      debugPrint('Failed to remove expired missions: $e');
      rethrow;
    }
  }

  /// 중복 미션 제거 (같은 타입과 제목의 미션)
  Future<void> removeDuplicateMissions() async {
    try {
      final isar = await instance;
      // 활성 상태인 미션만 가져오기
      final activeMissions = await isar.missionModels
          .filter()
          .isActiveEqualTo(true)
          .findAll();

      debugPrint('DatabaseService - Found ${activeMissions.length} active missions');

      // 타입과 제목으로 그룹화
      final Map<String, List<MissionModel>> missionGroups = {};
      for (final mission in activeMissions) {
        final key = '${mission.type}_${mission.title}';
        missionGroups[key] ??= [];
        missionGroups[key]!.add(mission);
      }

      // 중복된 그룹 로그 출력
      for (final entry in missionGroups.entries) {
        if (entry.value.length > 1) {
          debugPrint('DatabaseService - Found ${entry.value.length} duplicates of "${entry.key}"');
        }
      }

      // 각 그룹에서 최신 것만 남기고 나머지 삭제
      final List<int> idsToDelete = [];
      for (final group in missionGroups.values) {
        if (group.length > 1) {
          // ID 기준으로 정렬 (최신순)
          group.sort((a, b) => b.id.compareTo(a.id));
          // 첫 번째(최신)를 제외한 나머지 삭제 대상에 추가
          final toDelete = group.skip(1).toList();
          for (final mission in toDelete) {
            debugPrint('DatabaseService - Deleting duplicate: ${mission.title} (id: ${mission.id})');
            idsToDelete.add(mission.id);
          }
        }
      }

      if (idsToDelete.isNotEmpty) {
        await isar.writeTxn(() async {
          await isar.missionModels.deleteAll(idsToDelete);
        });
        debugPrint('DatabaseService - ✅ Removed ${idsToDelete.length} duplicate missions');
      } else {
        debugPrint('DatabaseService - No duplicate missions found');
      }
    } catch (e) {
      debugPrint('DatabaseService - ❌ Failed to remove duplicate missions: $e');
      rethrow;
    }
  }

  /// 일일 미션 목표값 업데이트
  Future<void> updateDailyMissionGoal(int newGoal) async {
    try {
      final isar = await instance;

      // "오늘의 걸음수 목표" 미션 찾기
      final missions = await isar.missionModels
          .filter()
          .typeEqualTo('daily')
          .and()
          .titleEqualTo('오늘의 걸음수 목표')
          .and()
          .isActiveEqualTo(true)
          .findAll();

      if (missions.isNotEmpty) {
        await isar.writeTxn(() async {
          for (final mission in missions) {
            mission.targetSteps = newGoal;
            mission.description = '$newGoal걸음 걷기';
            await isar.missionModels.put(mission);
          }
        });
        debugPrint('DatabaseService - Updated ${missions.length} daily mission(s) to $newGoal steps');
      }
    } catch (e) {
      debugPrint('Failed to update daily mission goal: $e');
      rethrow;
    }
  }

  /// 주간 미션 목표값 업데이트
  Future<void> updateWeeklyMissionGoal(int newGoal) async {
    try {
      final isar = await instance;

      // "이번 주 걸음수 챌린지" 미션 찾기
      final missions = await isar.missionModels
          .filter()
          .typeEqualTo('weekly')
          .and()
          .titleEqualTo('이번 주 걸음수 챌린지')
          .and()
          .isActiveEqualTo(true)
          .findAll();

      if (missions.isNotEmpty) {
        await isar.writeTxn(() async {
          for (final mission in missions) {
            mission.targetSteps = newGoal;
            mission.description = '$newGoal걸음 걷기';
            await isar.missionModels.put(mission);
          }
        });
        debugPrint('DatabaseService - Updated ${missions.length} weekly mission(s) to $newGoal steps');
      }
    } catch (e) {
      debugPrint('Failed to update weekly mission goal: $e');
      rethrow;
    }
  }

  /// 특정 타입의 미션 가져오기
  Future<List<Mission>> getMissionsByType(String type) async {
    final isar = await instance;
    final missionModels = await isar.missionModels
        .filter()
        .typeEqualTo(type)
        .and()
        .isActiveEqualTo(true)
        .findAll();

    return missionModels.map((model) => model.toDomain()).toList();
  }

  /// 완료된 미션 가져오기
  Future<List<Mission>> getCompletedMissions() async {
    final isar = await instance;
    final missionModels = await isar.missionModels
        .filter()
        .isCompletedEqualTo(true)
        .findAll();

    return missionModels.map((model) => model.toDomain()).toList();
  }

  // === Settings 관련 메서드 ===

  /// 설정 가져오기
  Future<SettingsModel?> getSettings() async {
    final isar = await instance;
    return await isar.settingsModels.get(AppConstants.settingsId);
  }

  /// 설정 저장
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final isar = await instance;
      await isar.writeTxn(() async {
        await isar.settingsModels.put(settings);
      });
    } catch (e) {
      debugPrint('Failed to save settings: $e');
      rethrow;
    }
  }

  // === 초기화 메서드 ===

  /// 데이터베이스 초기화 (인스턴스 버전)
  Future<void> initialize() async {
    await instance; // 싱글톤 인스턴스 확보
  }

  // 데이터베이스 닫기
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  // 모든 데이터 삭제 (개발/테스트용)
  static Future<void> clearAll() async {
    try {
      if (_isar == null) return;
      await _isar!.writeTxn(() async {
        await _isar!.clear();
      });
      await _initializeDefaultData();
    } catch (e) {
      debugPrint('Failed to clear all data: $e');
      rethrow;
    }
  }
}
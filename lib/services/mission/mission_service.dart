// lib/services/mission/mission_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/mission.dart';
import '../../data/datasources/database_service.dart';
import '../../data/models/mission_model.dart';
import '../pet/pet_reward_service.dart';
import '../achievement/achievement_service.dart';
import '../../l10n/app_localizations.dart';

/// 미션 시스템을 관리하는 서비스
/// - 일일/주간 미션 생성 및 관리
/// - 미션 진행도 추적 및 완료 처리
/// - 미션 완료 시 보상 지급
class MissionService {
  static MissionService? _instance;
  static MissionService get instance {
    _instance ??= MissionService._();
    return _instance!;
  }

  MissionService._();

  final DatabaseService _databaseService = DatabaseService();
  final PetRewardService _petRewardService = PetRewardService.instance;
  final Uuid _uuid = const Uuid();

  Timer? _dailyMissionTimer;
  Timer? _weeklyMissionTimer;

  // 미션 완료 알림 스트림
  final StreamController<MissionCompletionNotification> _missionCompletionController =
      StreamController<MissionCompletionNotification>.broadcast();
  Stream<MissionCompletionNotification> get missionCompletionStream => _missionCompletionController.stream;

  /// 서비스 초기화
  Future<void> initialize() async {
    await _databaseService.removeDuplicateMissions();
    await _generateMissionsIfNeeded();
    _schedulePeriodicMissionGeneration();
    await _cleanupExpiredMissions();
  }

  /// 현재 설정된 locale에 맞는 AppLocalizations 가져오기
  Future<AppLocalizations> _getLocalizations() async {
    final settings = await _databaseService.getSettings();
    final localeString = settings?.locale ?? 'ko';
    final locale = Locale(localeString);
    return await AppLocalizations.delegate.load(locale);
  }

  /// 활성 미션 가져오기
  Future<List<Mission>> getActiveMissions() async {
    return await _databaseService.getActiveMissions();
  }

  /// 특정 타입의 미션 가져오기
  Future<List<Mission>> getMissionsByType(String type) async {
    return await _databaseService.getMissionsByType(type);
  }

  /// 완료된 미션 가져오기
  Future<List<Mission>> getCompletedMissions() async {
    return await _databaseService.getCompletedMissions();
  }

  /// 미션 진행도 업데이트 (걸음수 기반)
  Future<List<Mission>> updateMissionProgressFromSteps(int totalSteps, int sessionSteps, int sessionDuration, double sessionDistance) async {
    final activeMissions = await getActiveMissions();
    final completedMissions = <Mission>[];

    for (final mission in activeMissions) {
      if (mission.isCompleted) continue;

      int newProgress = mission.currentProgress;
      bool shouldUpdate = false;

      // 미션 타입에 따른 진행도 계산
      if (mission.targetSteps > 0) {
        // 걸음수 미션
        if (mission.type == 'weekly') {
          // 주간 미션: 이번 주 전체 걸음수로 업데이트
          newProgress = await _getWeeklyTotalSteps();
        } else {
          // 일일 미션: 오늘 걸음수로 업데이트
          newProgress = totalSteps;
        }
        shouldUpdate = true;
      } else if (mission.targetDuration > 0) {
        // 시간 미션 (누적)
        newProgress = mission.currentProgress + sessionDuration;
        shouldUpdate = true;
      } else if (mission.targetDistance > 0) {
        // 거리 미션 (누적)
        newProgress = (mission.currentProgress + sessionDistance).round();
        shouldUpdate = true;
      }

      if (shouldUpdate) {
        await _databaseService.updateMissionProgress(mission.missionId, newProgress);

        // 미션 완료 확인
        if (newProgress >= _getMissionTargetProgress(mission) && !mission.isCompleted) {
          final completedMission = mission.copyWith(
            currentProgress: newProgress,
            isCompleted: true,
            completedAt: DateTime.now(),
          );

          completedMissions.add(completedMission);
          await _completeMission(completedMission);
        }
      }
    }

    return completedMissions;
  }

  /// 미션 완료 처리
  Future<void> _completeMission(Mission mission) async {
    // 펫에게 보상 지급
    final activePet = await _petRewardService.getActivePet();
    if (activePet != null) {
      await _petRewardService.addRewards(
        activePet.petId,
        treats: mission.treatReward,
        happiness: mission.happinessReward,
      );

      // 연결된 배지가 있으면 해제 시도
      if (mission.badgeCode != null) {
        try {
          final AchievementService achievementService = AchievementService.instance;
          await achievementService.unlockSpecialAchievement(mission.badgeCode!);
        } catch (e) {
          debugPrint('MissionService - Error unlocking badge ${mission.badgeCode}: $e');
        }
      }
    }

    // 미션 완료 알림 전송 (현재 locale에 맞는 메시지)
    final l10n = await _getLocalizations();
    final notification = MissionCompletionNotification(
      mission: mission,
      message: '${mission.title} - ${l10n.missionComplete}',
    );
    _missionCompletionController.add(notification);
  }

  /// 미션의 목표 진행도 반환
  int _getMissionTargetProgress(Mission mission) {
    if (mission.targetSteps > 0) return mission.targetSteps;
    if (mission.targetDuration > 0) return mission.targetDuration;
    if (mission.targetDistance > 0) return mission.targetDistance.round();
    return 1;
  }

  /// 필요한 경우 미션 생성
  Future<void> _generateMissionsIfNeeded() async {
    final now = DateTime.now();

    // 오늘의 일일 미션 확인
    final dailyMissions = await getMissionsByType('daily');
    final todayDailyMissions = dailyMissions.where((mission) {
      final expiresAt = mission.expiresAt;
      return expiresAt.year == now.year &&
             expiresAt.month == now.month &&
             expiresAt.day == now.day;
    }).toList();

    if (todayDailyMissions.isEmpty) {
      await _generateDailyMissions();
    }

    // 이번 주의 주간 미션 확인
    final weeklyMissions = await getMissionsByType('weekly');
    final weekStart = _getWeekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final thisWeekMissions = weeklyMissions.where((mission) {
      return mission.expiresAt.isAfter(weekStart) && mission.expiresAt.isBefore(weekEnd);
    }).toList();

    if (thisWeekMissions.isEmpty) {
      await _generateWeeklyMissions();
    }
  }

  /// 일일 미션 생성
  Future<void> _generateDailyMissions() async {
    // 설정값 및 번역 불러오기
    final settings = await _databaseService.getSettings();
    final dailyStepGoal = settings?.dailyStepGoal ?? AppConstants.dailyStepGoal;
    final l10n = await _getLocalizations();

    final missions = <Mission>[];
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // 기본 걸음수 미션
    missions.add(Mission(
      missionId: _uuid.v4(),
      type: 'daily',
      title: l10n.missionDailyStepsTitle,
      description: l10n.missionDailyStepsDescription(dailyStepGoal),
      targetSteps: dailyStepGoal,
      targetDuration: 0,
      targetDistance: 0.0,
      treatReward: 5,
      happinessReward: 20,
      isActive: true,
      isCompleted: false,
      expiresAt: endOfToday,
      currentProgress: 0,
    ));

    // 랜덤 추가 미션
    final additionalMissions = await _generateRandomDailyMissions(endOfToday, l10n);
    missions.addAll(additionalMissions);

    await _databaseService.saveMissions(missions);
  }

  /// 주간 미션 생성
  Future<void> _generateWeeklyMissions() async {
    // 설정값 및 번역 불러오기
    final settings = await _databaseService.getSettings();
    final dailyStepGoal = settings?.dailyStepGoal ?? AppConstants.dailyStepGoal;
    final l10n = await _getLocalizations();

    final now = DateTime.now();
    final weekEnd = _getWeekStart(now).add(const Duration(days: 7));
    final endOfWeek = DateTime(weekEnd.year, weekEnd.month, weekEnd.day, 23, 59, 59);

    // 기존 주간 미션 중 이번 주에 해당하는 것이 있는지 확인
    final existingWeeklyMissions = await getMissionsByType('weekly');
    debugPrint('MissionService - Found ${existingWeeklyMissions.length} existing weekly missions');

    final weekStart = _getWeekStart(now);
    final weekEndDate = weekStart.add(const Duration(days: 7));
    // weekEndDate를 하루의 끝 시간으로 설정 (23:59:59)
    final weekEndWithTime = DateTime(weekEndDate.year, weekEndDate.month, weekEndDate.day, 23, 59, 59);
    debugPrint('MissionService - This week range: $weekStart to $weekEndWithTime');

    final thisWeekMissions = existingWeeklyMissions.where((mission) {
      final isInRange = mission.expiresAt.isAfter(weekStart) && mission.expiresAt.isBefore(weekEndWithTime.add(const Duration(seconds: 1)));
      debugPrint('MissionService - Mission "${mission.title}" expires at ${mission.expiresAt}, in range: $isInRange, active: ${mission.isActive}');
      return isInRange && mission.isActive;
    }).toList();

    // 이미 이번 주 미션이 있으면 생성하지 않음
    if (thisWeekMissions.isNotEmpty) {
      debugPrint('MissionService - ✅ Weekly missions for this week already exist (${thisWeekMissions.length}), skipping generation');
      return;
    }

    debugPrint('MissionService - No weekly missions found for this week, generating new ones');

    final missions = <Mission>[];

    // 주간 걸음수 미션
    missions.add(Mission(
      missionId: _uuid.v4(),
      type: 'weekly',
      title: l10n.missionWeeklyStepsTitle,
      description: l10n.missionWeeklyStepsDescription(dailyStepGoal * 7),
      targetSteps: dailyStepGoal * 7,
      targetDuration: 0,
      targetDistance: 0.0,
      treatReward: 20,
      happinessReward: 50,
      isActive: true,
      isCompleted: false,
      expiresAt: endOfWeek,
      currentProgress: 0,
    ));

    // 주간 활동 시간 미션
    missions.add(Mission(
      missionId: _uuid.v4(),
      type: 'weekly',
      title: l10n.missionActiveWeekTitle,
      description: l10n.missionActiveWeekDescription,
      targetSteps: 0,
      targetDuration: 180 * 60, // 180분을 초로 변환
      targetDistance: 0.0,
      treatReward: 15,
      happinessReward: 30,
      isActive: true,
      isCompleted: false,
      expiresAt: endOfWeek,
      currentProgress: 0,
    ));

    await _databaseService.saveMissions(missions);
    debugPrint('MissionService - Generated ${missions.length} weekly missions');
  }

  /// 랜덤 일일 미션 생성
  Future<List<Mission>> _generateRandomDailyMissions(DateTime expiresAt, AppLocalizations l10n) async {
    final missions = <Mission>[];
    final random = Random();

    // 미션 템플릿
    final templates = [
      {
        'title': l10n.missionQuickWalkTitle,
        'description': l10n.missionQuickWalkDescription,
        'targetSteps': 0,
        'targetDuration': 30 * 60,
        'targetDistance': 0.0,
        'treatReward': 3,
        'happinessReward': 15,
      },
      {
        'title': l10n.missionDistanceChallengeTitle,
        'description': l10n.missionDistanceChallengeDescription,
        'targetSteps': 0,
        'targetDuration': 0,
        'targetDistance': 2000.0,
        'treatReward': 4,
        'happinessReward': 18,
      },
      {
        'title': l10n.missionEarlyAchievementTitle,
        'description': l10n.missionEarlyAchievementDescription,
        'targetSteps': 3000,
        'targetDuration': 0,
        'targetDistance': 0.0,
        'treatReward': 3,
        'happinessReward': 12,
      },
      {
        'title': l10n.missionConsistentExerciseTitle,
        'description': l10n.missionConsistentExerciseDescription,
        'targetSteps': 0,
        'targetDuration': 45 * 60,
        'targetDistance': 0.0,
        'treatReward': 4,
        'happinessReward': 16,
      },
    ];

    // 1-2개의 랜덤 미션 선택
    final numMissions = random.nextInt(2) + 1;
    final selectedTemplates = (templates..shuffle()).take(numMissions);

    for (final template in selectedTemplates) {
      missions.add(Mission(
        missionId: _uuid.v4(),
        type: 'daily',
        title: template['title'] as String,
        description: template['description'] as String,
        targetSteps: template['targetSteps'] as int,
        targetDuration: template['targetDuration'] as int,
        targetDistance: template['targetDistance'] as double,
        treatReward: template['treatReward'] as int,
        happinessReward: template['happinessReward'] as int,
        isActive: true,
        isCompleted: false,
        expiresAt: expiresAt,
        currentProgress: 0,
      ));
    }

    return missions;
  }

  /// 정기적인 미션 생성 스케줄링
  void _schedulePeriodicMissionGeneration() {
    // 매일 자정에 일일 미션 생성
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final timeUntilMidnight = tomorrow.difference(now);

    _dailyMissionTimer = Timer(timeUntilMidnight, () {
      _generateDailyMissions();
      // 다음 날을 위한 타이머 재설정
      _dailyMissionTimer = Timer.periodic(const Duration(days: 1), (_) {
        _generateDailyMissions();
      });
    });

    // 매주 월요일에 주간 미션 생성
    final nextMonday = _getNextMonday(now);
    final timeUntilMonday = nextMonday.difference(now);

    _weeklyMissionTimer = Timer(timeUntilMonday, () {
      _generateWeeklyMissions();
      // 다음 주를 위한 타이머 재설정
      _weeklyMissionTimer = Timer.periodic(const Duration(days: 7), (_) {
        _generateWeeklyMissions();
      });
    });
  }

  /// 만료된 미션 정리
  Future<void> _cleanupExpiredMissions() async {
    await _databaseService.removeExpiredMissions();
  }

  /// 주의 시작일 (월요일 00:00:00) 구하기
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    final daysToSubtract = weekday - 1; // 월요일이 1
    final monday = date.subtract(Duration(days: daysToSubtract));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// 다음 월요일 구하기
  DateTime _getNextMonday(DateTime date) {
    final weekday = date.weekday;
    final daysToAdd = weekday == 1 ? 7 : 8 - weekday; // 월요일이 1
    final nextMonday = date.add(Duration(days: daysToAdd));
    return DateTime(nextMonday.year, nextMonday.month, nextMonday.day);
  }

  /// 새로운 목표값으로 기존 미션 업데이트
  Future<void> updateMissionsForNewGoal(int newDailyStepGoal) async {
    try {
      final l10n = await _getLocalizations();

      // 한국어/영어 제목 모두 매칭 (미션이 어느 언어로 생성됐을지 모르므로)
      final koL10n = await AppLocalizations.delegate.load(const Locale('ko'));
      final enL10n = await AppLocalizations.delegate.load(const Locale('en'));

      final dailyTitles = [
        koL10n.missionDailyStepsTitle,
        enL10n.missionDailyStepsTitle,
      ];
      final weeklyTitles = [
        koL10n.missionWeeklyStepsTitle,
        enL10n.missionWeeklyStepsTitle,
      ];

      await _databaseService.updateDailyMissionGoal(
        newDailyStepGoal,
        matchTitles: dailyTitles,
        newDescription: l10n.missionDailyStepsDescription(newDailyStepGoal),
      );
      await _databaseService.updateWeeklyMissionGoal(
        newDailyStepGoal * 7,
        matchTitles: weeklyTitles,
        newDescription: l10n.missionWeeklyStepsDescription(newDailyStepGoal * 7),
      );

      debugPrint('MissionService - Updated missions for new goal: $newDailyStepGoal steps');
    } catch (e) {
      debugPrint('MissionService - Error updating missions for new goal: $e');
      rethrow;
    }
  }

  /// 언어 변경 시 활성 미션의 제목/설명을 새 locale로 업데이트
  Future<void> updateMissionsLocale(String newLocaleCode) async {
    try {
      final settings = await _databaseService.getSettings();
      final dailyStepGoal = settings?.dailyStepGoal ?? AppConstants.dailyStepGoal;

      // 이전 locale의 l10n (한국어/영어 모두 로드)
      final koL10n = await AppLocalizations.delegate.load(const Locale('ko'));
      final enL10n = await AppLocalizations.delegate.load(const Locale('en'));

      // 새 locale의 l10n
      final newL10n = await AppLocalizations.delegate.load(Locale(newLocaleCode));

      // old title → new (title, description) 매핑 테이블
      final Map<String, ({String title, String description})> titleMap = {
        // 일일 걸음수 목표
        koL10n.missionDailyStepsTitle: (
          title: newL10n.missionDailyStepsTitle,
          description: newL10n.missionDailyStepsDescription(dailyStepGoal),
        ),
        enL10n.missionDailyStepsTitle: (
          title: newL10n.missionDailyStepsTitle,
          description: newL10n.missionDailyStepsDescription(dailyStepGoal),
        ),
        // 주간 걸음수 챌린지
        koL10n.missionWeeklyStepsTitle: (
          title: newL10n.missionWeeklyStepsTitle,
          description: newL10n.missionWeeklyStepsDescription(dailyStepGoal * 7),
        ),
        enL10n.missionWeeklyStepsTitle: (
          title: newL10n.missionWeeklyStepsTitle,
          description: newL10n.missionWeeklyStepsDescription(dailyStepGoal * 7),
        ),
        // 활동적인 한 주
        koL10n.missionActiveWeekTitle: (
          title: newL10n.missionActiveWeekTitle,
          description: newL10n.missionActiveWeekDescription,
        ),
        enL10n.missionActiveWeekTitle: (
          title: newL10n.missionActiveWeekTitle,
          description: newL10n.missionActiveWeekDescription,
        ),
        // 빠른 산책
        koL10n.missionQuickWalkTitle: (
          title: newL10n.missionQuickWalkTitle,
          description: newL10n.missionQuickWalkDescription,
        ),
        enL10n.missionQuickWalkTitle: (
          title: newL10n.missionQuickWalkTitle,
          description: newL10n.missionQuickWalkDescription,
        ),
        // 거리 도전
        koL10n.missionDistanceChallengeTitle: (
          title: newL10n.missionDistanceChallengeTitle,
          description: newL10n.missionDistanceChallengeDescription,
        ),
        enL10n.missionDistanceChallengeTitle: (
          title: newL10n.missionDistanceChallengeTitle,
          description: newL10n.missionDistanceChallengeDescription,
        ),
        // 조기 달성
        koL10n.missionEarlyAchievementTitle: (
          title: newL10n.missionEarlyAchievementTitle,
          description: newL10n.missionEarlyAchievementDescription,
        ),
        enL10n.missionEarlyAchievementTitle: (
          title: newL10n.missionEarlyAchievementTitle,
          description: newL10n.missionEarlyAchievementDescription,
        ),
        // 꾸준한 운동
        koL10n.missionConsistentExerciseTitle: (
          title: newL10n.missionConsistentExerciseTitle,
          description: newL10n.missionConsistentExerciseDescription,
        ),
        enL10n.missionConsistentExerciseTitle: (
          title: newL10n.missionConsistentExerciseTitle,
          description: newL10n.missionConsistentExerciseDescription,
        ),
      };

      await _databaseService.updateMissionLocale(titleMap);
      debugPrint('MissionService - Updated mission titles for locale: $newLocaleCode');
    } catch (e) {
      debugPrint('MissionService - Error updating missions locale: $e');
      rethrow;
    }
  }

  /// 이번 주 총 걸음수 계산 (월요일부터 오늘까지)
  Future<int> _getWeeklyTotalSteps() async {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final mondayDate = now.subtract(Duration(days: weekday - 1));
    final monday = DateTime(mondayDate.year, mondayDate.month, mondayDate.day);

    int totalWeeklySteps = 0;

    // 월요일부터 오늘까지의 모든 Walk Session 가져오기
    for (int i = 0; i < weekday; i++) {
      final currentDay = monday.add(Duration(days: i));
      final sessions = await _databaseService.getWalkSessionsByDate(currentDay);
      final daySteps = sessions.fold<int>(0, (sum, session) => sum + session.totalSteps);
      totalWeeklySteps += daySteps;
    }

    debugPrint('MissionService - Weekly total steps calculated: $totalWeeklySteps');
    return totalWeeklySteps;
  }

  /// 서비스 해제
  void dispose() {
    _dailyMissionTimer?.cancel();
    _weeklyMissionTimer?.cancel();
    _missionCompletionController.close();
  }
}

/// 미션 완료 알림 정보
class MissionCompletionNotification {
  final Mission mission;
  final String message;

  const MissionCompletionNotification({
    required this.mission,
    required this.message,
  });
}

/// Riverpod Providers

/// 미션 서비스 Provider
final missionServiceProvider = Provider<MissionService>((ref) {
  return MissionService.instance;
});

/// 활성 미션 Provider
final activeMissionsProvider = FutureProvider<List<Mission>>((ref) async {
  final missionService = ref.read(missionServiceProvider);
  return await missionService.getActiveMissions();
});

/// 활성 미션 실시간 감시 Provider (Stream) - DB 변경 시 자동 업데이트
final activeMissionsStreamProvider = StreamProvider<List<Mission>>((ref) {
  final databaseService = DatabaseService();
  return databaseService.watchActiveMissions();
});

/// 일일 미션 Provider (Stream - 실시간 DB 감시)
final dailyMissionsProvider = StreamProvider<List<Mission>>((ref) async* {
  final databaseService = DatabaseService();
  await for (final missions in databaseService.watchActiveMissions()) {
    // 일일 미션만 필터링
    yield missions.where((m) => m.type == 'daily').toList();
  }
});

/// 주간 미션 Provider (Stream - 실시간 DB 감시)
final weeklyMissionsProvider = StreamProvider<List<Mission>>((ref) async* {
  final databaseService = DatabaseService();
  await for (final missions in databaseService.watchActiveMissions()) {
    // 주간 미션만 필터링
    yield missions.where((m) => m.type == 'weekly').toList();
  }
});

/// 완료된 미션 Provider (Stream - 실시간 DB 감시)
final completedMissionsProvider = StreamProvider<List<Mission>>((ref) async* {
  final databaseService = DatabaseService();
  final isar = await DatabaseService.instance;

  // Isar의 watch 기능을 사용하여 실시간 업데이트
  await for (final _ in isar.missionModels.watchLazy()) {
    // 완료된 미션을 DB에서 조회
    final missions = await databaseService.getCompletedMissions();
    yield missions;
  }
});

/// 미션 완료 알림 Provider (Stream)
final missionCompletionNotificationProvider = StreamProvider<MissionCompletionNotification>((ref) {
  final missionService = ref.read(missionServiceProvider);
  return missionService.missionCompletionStream;
});
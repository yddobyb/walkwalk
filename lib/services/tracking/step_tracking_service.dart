// lib/services/tracking/step_tracking_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/walk_session.dart';
import '../../data/datasources/database_service.dart';
import '../sensors/pedometer_service.dart';
import '../pet/pet_reward_service.dart';
import '../achievement/achievement_service.dart';
import '../location/location_service.dart';
import '../mission/mission_service.dart';
import '../notification/notification_service.dart';
import '../../domain/entities/mission.dart';

/// 걸음수 트래킹 및 펫 상태 업데이트 서비스
class StepTrackingService {
  static final StepTrackingService _instance = StepTrackingService._internal();
  factory StepTrackingService() => _instance;
  StepTrackingService._internal();

  final PedometerService _pedometerService = PedometerService();
  final DatabaseService _databaseService = DatabaseService();
  final PetRewardService _rewardService = PetRewardService.instance;
  final AchievementService _achievementService = AchievementService.instance;
  final LocationService _locationService = LocationService.instance;
  final MissionService _missionService = MissionService.instance;

  StreamSubscription<StepData>? _stepCountSubscription;

  final StreamController<StepTrackingState> _stateController =
      StreamController<StepTrackingState>.broadcast();

  final StreamController<int> _dailyStepsController =
      StreamController<int>.broadcast();

  final StreamController<int> _weeklyStepsController =
      StreamController<int>.broadcast();

  final StreamController<Pet?> _petUpdateController =
      StreamController<Pet?>.broadcast();

  /// 트래킹 상태 스트림
  /// 새로운 구독자는 즉시 현재 캐시된 상태를 받음
  Stream<StepTrackingState> get stateStream async* {
    if (!_isInitialized) {
      yield StepTrackingState.stopped;
      return;
    }
    yield _currentState;
    yield* _stateController.stream;
  }

  /// 일일 걸음수 스트림
  /// 새로운 구독자는 즉시 현재 캐시된 값을 받고, 이후 업데이트를 스트림으로 받음
  Stream<int> get dailyStepsStream async* {
    if (!_isInitialized) {
      return;
    }
    yield _currentDailySteps;
    yield* _dailyStepsController.stream;
  }

  /// 주간 걸음수 스트림
  /// 새로운 구독자는 즉시 현재 캐시된 값을 받고, 이후 업데이트를 스트림으로 받음
  Stream<int> get weeklyStepsStream async* {
    if (!_isInitialized) {
      return;
    }
    yield _currentWeeklySteps;
    yield* _weeklyStepsController.stream;
  }

  /// 펫 업데이트 스트림
  /// 새로운 구독자는 즉시 현재 펫 정보를 받음
  Stream<Pet?> get petUpdateStream async* {
    if (!_isInitialized) {
      return;
    }
    yield _currentPet;
    yield* _petUpdateController.stream;
  }

  // 현재 상태 변수들
  StepTrackingState _currentState = StepTrackingState.stopped;
  int _sessionStartSteps = 0;
  DateTime? _sessionStartTime;
  Pet? _currentPet;
  int _currentDailySteps = 0;
  int _currentWeeklySteps = 0;
  bool _isInitialized = false;

  // 미션 업데이트 throttling을 위한 변수들
  DateTime? _lastMissionUpdateTime;
  int _lastMissionUpdateSteps = 0;
  static const Duration _missionUpdateInterval = Duration(seconds: 10); // 10초마다 업데이트
  static const int _missionUpdateStepThreshold = 50; // 또는 50걸음마다 업데이트

  bool get isInitialized => _isInitialized;
  StepTrackingState get currentState => _currentState;
  int get currentDailySteps => _currentDailySteps;
  int get currentWeeklySteps => _currentWeeklySteps;
  DateTime? get sessionStartTime => _sessionStartTime;
  int get sessionStartSteps => _sessionStartSteps;

  /// 서비스 초기화
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('StepTrackingService - Already initialized');
      return true;
    }

    try {
      // Pedometer 서비스 초기화
      final pedometerInitialized = await _pedometerService.initialize();
      if (!pedometerInitialized) {
        debugPrint('StepTrackingService - Pedometer initialization failed');
        return false;
      }

      // 데이터베이스 초기화
      await _databaseService.initialize();

      // 현재 펫 정보 로드
      await _loadCurrentPet();

      // 걸음수 스트림 구독 (먼저 구독해서 캐시를 채움)
      _subscribeToStepCount();

      // 첫 이벤트가 올 때까지 잠시 대기 (캐시 채우기)
      await Future.delayed(const Duration(milliseconds: 500));

      // 오늘의 시작 걸음수 설정 (이제 캐시된 값 사용 가능)
      await _initializeTodaySteps();

      _isInitialized = true;
      _updateState(StepTrackingState.monitoring);

      debugPrint('StepTrackingService - Initialized successfully');
      return true;
    } catch (e) {
      debugPrint('StepTrackingService - Initialization error: $e');
      return false;
    }
  }

  /// 현재 펫 정보 로드
  Future<void> _loadCurrentPet() async {
    try {
      final pets = await _databaseService.getAllPets();
      if (pets.isNotEmpty) {
        _currentPet = pets.first; // 현재는 첫 번째 펫 사용
        _petUpdateController.add(_currentPet);
        debugPrint('StepTrackingService - Current pet loaded: ${_currentPet?.name}');
      }
    } catch (e) {
      debugPrint('StepTrackingService - Error loading current pet: $e');
    }
  }

  /// 현재 펫 정보 강제 리로드 (외부에서 펫 데이터가 변경되었을 때 사용)
  Future<void> reloadCurrentPet() async {
    await _loadCurrentPet();
    debugPrint('StepTrackingService - Pet data reloaded and stream updated');
  }

  /// 오늘의 시작 걸음수 초기화
  Future<void> _initializeTodaySteps() async {
    try {
      // Health 패키지는 자동으로 오늘의 걸음수(자정부터)를 반환하므로
      // PedometerService에서 실제 걸음수를 가져와서 사용

      final now = DateTime.now();
      final lastUpdate = _currentPet?.lastUpdate;

      debugPrint('StepTrackingService - Now: ${now.year}-${now.month}-${now.day}, Pet lastUpdate: ${lastUpdate?.year}-${lastUpdate?.month}-${lastUpdate?.day}');

      // 날짜가 바뀌었는지 체크
      bool isToday = false;
      if (lastUpdate != null) {
        isToday = lastUpdate.year == now.year &&
                  lastUpdate.month == now.month &&
                  lastUpdate.day == now.day;
      }

      // 날짜가 바뀌었으면 Pet의 stepsToday를 0으로 리셋
      if (!isToday && _currentPet != null) {
        debugPrint('StepTrackingService - Date changed, resetting Pet stepsToday to 0');

        final resetPet = _currentPet!.copyWith(
          stepsToday: 0,
          lastUpdate: now,
        );

        _currentPet = resetPet;
        await _databaseService.savePet(resetPet);
      }

      // PedometerService에서 실제 오늘의 걸음수 가져오기
      final todaySteps = await _pedometerService.getTodaySteps();
      _currentDailySteps = todaySteps ?? 0;

      // PedometerService에서 이번 주 걸음수 가져오기
      final weeklySteps = await _pedometerService.getWeeklyStepsFromHealth();
      _currentWeeklySteps = weeklySteps;

      _dailyStepsController.add(_currentDailySteps);
      _weeklyStepsController.add(_currentWeeklySteps);
      debugPrint('StepTrackingService - Initialized with actual steps from health: daily=$_currentDailySteps, weekly=$_currentWeeklySteps');
    } catch (e) {
      debugPrint('StepTrackingService - Error initializing today steps: $e');
    }
  }

  /// 걸음수 스트림 구독
  void _subscribeToStepCount() {
    _stepCountSubscription = _pedometerService.stepCountStream.listen(
      (stepCount) {
        _handleStepCount(stepCount);
      },
      onError: (error) {
        debugPrint('StepTrackingService - Step count error: $error');
        _updateState(StepTrackingState.error);
      },
    );
  }


  /// 걸음수 데이터 처리
  void _handleStepCount(StepData stepData) async {
    // Health 패키지는 이미 오늘의 걸음수(자정부터 지금까지)를 반환하므로
    // 별도의 계산 없이 바로 사용
    final todaySteps = stepData.steps;

    // 일일 걸음수 업데이트
    _currentDailySteps = todaySteps;
    _dailyStepsController.add(_currentDailySteps);

    // 주간 걸음수 업데이트 (일일 걸음수가 변경될 때마다)
    final weeklySteps = await _pedometerService.getWeeklyStepsFromHealth();
    _currentWeeklySteps = weeklySteps;
    _weeklyStepsController.add(_currentWeeklySteps);
    debugPrint('📊 StepTrackingService - Steps updated: daily=$_currentDailySteps, weekly=$_currentWeeklySteps');

    // 세션 중인 경우 세션 걸음수 계산
    if (_currentState == StepTrackingState.walking && _sessionStartSteps > 0) {
      final sessionSteps = max(0, todaySteps - _sessionStartSteps);
      debugPrint('StepTrackingService - Session steps: $sessionSteps');
    }

    // 펫 상태 업데이트
    _updatePetWithSteps(_currentDailySteps, todaySteps);

    // 미션 진행도 실시간 업데이트 (throttling 적용)
    _updateMissionsRealtime(_currentDailySteps);

    debugPrint('StepTrackingService - Today steps: $_currentDailySteps');
  }


  /// 미션 진행도 실시간 업데이트 (throttling 적용)
  void _updateMissionsRealtime(int dailySteps) {
    final now = DateTime.now();

    // Throttling 조건 확인
    // 1. 10초가 지났거나
    // 2. 50걸음 이상 차이가 나면 업데이트
    final shouldUpdate = _lastMissionUpdateTime == null ||
        now.difference(_lastMissionUpdateTime!).compareTo(_missionUpdateInterval) >= 0 ||
        (dailySteps - _lastMissionUpdateSteps).abs() >= _missionUpdateStepThreshold;

    if (!shouldUpdate) {
      return;
    }

    // 마지막 업데이트 시간 및 걸음수 저장
    _lastMissionUpdateTime = now;
    _lastMissionUpdateSteps = dailySteps;

    // 비동기로 미션 업데이트 (백그라운드에서 실행, UI 블로킹 방지)
    _updateMissionsInBackground(dailySteps);
  }

  /// 백그라운드에서 미션 업데이트 (비동기)
  Future<void> _updateMissionsInBackground(int dailySteps) async {
    try {
      // 미션 서비스를 통해 진행도 업데이트
      // 거리와 시간은 실시간으로 계산하기 어려우므로 0으로 전달
      // (실제 산책 세션 종료 시 정확한 값으로 다시 업데이트됨)
      await _missionService.updateMissionProgressFromSteps(
        dailySteps,  // 오늘 총 걸음수
        0,           // 세션 걸음수 (실시간에서는 0)
        0,           // 세션 시간 (실시간에서는 0)
        0,           // 세션 거리 (실시간에서는 0)
      );

      debugPrint('StepTrackingService - Missions updated in realtime with $dailySteps steps');
    } catch (e) {
      debugPrint('StepTrackingService - Error updating missions in realtime: $e');
    }
  }

  /// 산책 세션 시작
  Future<bool> startWalkSession({bool enableGPS = true}) async {
    if (!_isInitialized) {
      debugPrint('StepTrackingService - Not initialized');
      return false;
    }

    if (_currentState == StepTrackingState.walking) {
      debugPrint('StepTrackingService - Already walking');
      return false;
    }

    try {
      // 현재 걸음수를 세션 시작점으로 설정
      final currentStepCount = await _getCurrentStepCount();
      if (currentStepCount == null) {
        debugPrint('StepTrackingService - Could not get current step count');
        return false;
      }

      _sessionStartSteps = currentStepCount.steps;
      _sessionStartTime = DateTime.now();

      // GPS 위치 추적 시작 (선택적)
      if (enableGPS) {
        final locationStarted = await _locationService.startLocationTracking();
        if (locationStarted) {
          debugPrint('StepTrackingService - GPS tracking started');
        } else {
          debugPrint('StepTrackingService - Failed to start GPS tracking, continuing without GPS');
        }
      }

      _updateState(StepTrackingState.walking);

      debugPrint('StepTrackingService - Walk session started with $_sessionStartSteps steps');
      return true;
    } catch (e) {
      debugPrint('StepTrackingService - Error starting walk session: $e');
      return false;
    }
  }

  /// 산책 세션 종료
  Future<WalkSession?> stopWalkSession() async {
    if (_currentState != StepTrackingState.walking || _sessionStartTime == null) {
      debugPrint('StepTrackingService - No active walk session');
      return null;
    }

    try {
      // 최소 산책 시간 체크
      final endTime = DateTime.now();
      final duration = endTime.difference(_sessionStartTime!).inSeconds;

      if (duration < AppConstants.minWalkDurationSeconds) {
        debugPrint('StepTrackingService - Walk duration too short: ${duration}s (minimum: ${AppConstants.minWalkDurationSeconds}s)');
        // 최소 시간 미달 시에도 산책 종료는 허용하되 경고 표시
        // UI에서 SnackBar로 안내 메시지 표시 가능
      }

      // 첫 번째 쿼리: 즉시 걸음수 가져오기
      final currentStepCount = await _getCurrentStepCount();
      if (currentStepCount == null) {
        debugPrint('StepTrackingService - Could not get current step count');
        return null;
      }

      int sessionSteps = max(0, currentStepCount.steps - _sessionStartSteps);

      // Health Kit 동기화 대기 후 재쿼리 (짧은 산책 시 0걸음 방지)
      // 3초 대기 (iOS Health Kit이 걸음수를 배치로 처리하므로)
      debugPrint('StepTrackingService - Waiting 3 seconds for Health Kit sync...');
      await Future.delayed(const Duration(seconds: 3));

      // 두 번째 쿼리: Health Kit 동기화 후 최신 걸음수 가져오기
      final updatedStepCount = await _getCurrentStepCount();
      if (updatedStepCount != null) {
        final updatedSessionSteps = max(0, updatedStepCount.steps - _sessionStartSteps);

        // 재쿼리한 걸음수가 더 많으면 업데이트
        if (updatedSessionSteps > sessionSteps) {
          debugPrint('StepTrackingService - Step count updated after sync: $sessionSteps → $updatedSessionSteps');
          sessionSteps = updatedSessionSteps;
        }
      }

      // GPS 위치 추적 중지 및 데이터 수집
      await _locationService.stopLocationTracking();
      final locationSamples = _locationService.locationSamples;
      final validOutdoorSamples = _locationService.validOutdoorSamples;
      final outdoorRatio = _locationService.outdoorRatio;

      // 실외 여부 판정 (충분한 샘플과 높은 실외 비율이 있어야 함)
      final isOutdoor = locationSamples.isNotEmpty &&
          validOutdoorSamples >= AppConstants.minValidSamplesForOutdoor &&
          outdoorRatio >= AppConstants.minOutdoorRatioForBonus;

      // GPS 기반 거리 계산 (가능한 경우)
      final gpsDistance = _locationService.calculateTotalDistance();
      final distance = gpsDistance > 0 ? gpsDistance : _calculateDistance(sessionSteps);

      // GPS 기반 평균 속도 계산 (가능한 경우)
      final gpsSpeed = _locationService.calculateAverageSpeed();
      final avgSpeed = gpsSpeed > 0 ? gpsSpeed : _calculateAverageSpeed(sessionSteps, duration);

      // 산책 세션 객체 생성
      final walkSession = WalkSession(
        sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
        startTime: _sessionStartTime!,
        endTime: endTime,
        totalSteps: sessionSteps,
        duration: duration,
        distance: distance,
        avgSpeed: avgSpeed,
        isOutdoor: isOutdoor,
        validOutdoorSamples: validOutdoorSamples,
        locationSamples: locationSamples,
        treatsEarned: _calculateTreatsEarned(sessionSteps, isOutdoor: isOutdoor),
        happinessGained: _calculateHappinessGained(sessionSteps, isOutdoor: isOutdoor),
        missionsCompleted: [],
      );

      // 미션 진행도 업데이트 (산책 세션 생성 후 바로)
      final completedMissions = await _updateMissionProgress(walkSession);

      // 완료된 미션 정보로 산책 세션 업데이트
      final updatedWalkSession = walkSession.copyWith(
        missionsCompleted: completedMissions.map((mission) => MissionCompleted(
          missionId: mission.missionId,
          missionType: mission.type,
          rewardAmount: mission.treatReward,
          completedAt: DateTime.now(),
        )).toList(),
      );

      // 데이터베이스에 저장
      await _databaseService.saveWalkSession(updatedWalkSession);

      // 산책 완료 → 오늘 남은 산책 리마인더 취소
      await NotificationService.instance
          .cancelTodayWalkReminders();

      // 펫 상태 업데이트 (보상 적용)
      if (_currentPet != null) {
        final updatedPet = await _rewardService.applyWalkRewards(_currentPet!.petId, updatedWalkSession);
        if (updatedPet != null) {
          _currentPet = updatedPet;
          _petUpdateController.add(updatedPet);
        }
      }

      // 배지/업적 진행도 체크
      await _checkWalkAchievements(updatedWalkSession);

      _updateState(StepTrackingState.monitoring);
      _sessionStartSteps = 0;
      _sessionStartTime = null;

      debugPrint('StepTrackingService - Walk session completed: $sessionSteps steps, ${duration}s');
      return updatedWalkSession;
    } catch (e) {
      debugPrint('StepTrackingService - Error stopping walk session: $e');
      return null;
    }
  }

  /// 현재 걸음수 가져오기 (단일 요청)
  /// 즉시 Health Kit에서 최신 데이터를 가져옴 (캐시 사용 안 함)
  Future<StepData?> _getCurrentStepCount() async {
    try {
      // Health Kit에서 즉시 최신 걸음수 가져오기
      final steps = await _pedometerService.getTodaySteps();

      if (steps != null) {
        final stepData = StepData(
          steps: steps,
          timestamp: DateTime.now(),
        );
        debugPrint('StepTrackingService - Fetched fresh step data from Health Kit: $steps');
        return stepData;
      }

      // Health Kit에서 데이터를 가져오지 못한 경우 캐시된 값 사용
      final cachedStepData = _pedometerService.lastStepData;
      if (cachedStepData != null) {
        debugPrint('StepTrackingService - Health Kit failed, using cached step data: ${cachedStepData.steps}');
        return cachedStepData;
      }

      debugPrint('StepTrackingService - No step data available');
      return null;
    } catch (e) {
      debugPrint('StepTrackingService - Error getting current step count: $e');

      // 에러 발생 시 캐시된 값이라도 사용
      final cachedStepData = _pedometerService.lastStepData;
      if (cachedStepData != null) {
        debugPrint('StepTrackingService - Error occurred, using cached step data: ${cachedStepData.steps}');
        return cachedStepData;
      }

      return null;
    }
  }

  /// 펫 상태 업데이트
  void _updatePetWithSteps(int dailySteps, int totalSteps) {
    if (_currentPet == null) return;

    try {
      final updatedPet = _currentPet!.copyWith(
        stepsToday: dailySteps,
        totalSteps: totalSteps,
        lastUpdate: DateTime.now(),
        avgDailySteps: _calculateAvgDailySteps(totalSteps),
      );

      _currentPet = updatedPet;
      _petUpdateController.add(updatedPet);

      // 데이터베이스에 저장 (await 없이 fire-and-forget 방식으로 실행)
      // 중요: 데이터 손실 방지를 위해 Future를 무시하지 않고 에러 처리
      _databaseService.savePet(updatedPet).catchError((error) {
        debugPrint('StepTrackingService - Error saving pet to database: $error');
      });
    } catch (e) {
      debugPrint('StepTrackingService - Error updating pet: $e');
    }
  }


  /// 상태 업데이트
  void _updateState(StepTrackingState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  /// 거리 계산 (걸음수 기반 추정)
  double _calculateDistance(int steps) {
    // 평균 보폭 0.7m 가정
    return steps * 0.7;
  }

  /// 평균 속도 계산
  double _calculateAverageSpeed(int steps, int durationSeconds) {
    if (durationSeconds <= 0) return 0.0;
    final distanceKm = _calculateDistance(steps) / 1000;
    final durationHours = durationSeconds / 3600;
    return distanceKm / durationHours;
  }

  /// 간식 획득량 계산
  int _calculateTreatsEarned(int steps, {bool isOutdoor = false}) {
    return _rewardService.calculateTreatsFromSteps(steps, isOutdoor: isOutdoor);
  }

  /// 행복도 증가량 계산
  int _calculateHappinessGained(int steps, {bool isOutdoor = false}) {
    return _rewardService.calculateHappinessFromSteps(steps, isOutdoor: isOutdoor);
  }

  /// 평균 일일 걸음수 계산
  double _calculateAvgDailySteps(int totalSteps) {
    if (_currentPet == null) return 0.0;

    final daysSinceCreated = DateTime.now().difference(_currentPet!.createdAt).inDays + 1;
    return totalSteps / daysSinceCreated;
  }

  /// 산책 완료 시 배지/업적 체크
  Future<void> _checkWalkAchievements(WalkSession walkSession) async {
    try {
      if (_currentPet == null) return;

      // 누적 통계 계산
      final allWalkSessions = await _databaseService.getAllWalkSessions();
      final totalSteps = allWalkSessions.fold<int>(0, (sum, session) => sum + session.totalSteps);
      final totalDistance = allWalkSessions.fold<double>(0, (sum, session) => sum + session.distance);

      // 연속 산책 일수 계산 (간단한 구현 - 추후 개선 가능)
      final currentStreak = _calculateCurrentStreak(allWalkSessions);

      // 첫 번째 산책인지 확인
      final isFirstWalk = allWalkSessions.length == 1;

      // 첫 번째 실외 산책인지 확인 (추후 GPS 구현 후 실제 값 사용)
      final isFirstOutdoorWalk = walkSession.isOutdoor &&
        !allWalkSessions.any((session) => session.isOutdoor && session.sessionId != walkSession.sessionId);

      // 배지 체크 실행
      final unlockedAchievements = await _achievementService.checkWalkCompletionAchievements(
        totalSteps: totalSteps,
        totalDistanceMeters: totalDistance,
        currentStreak: currentStreak,
        isFirstWalk: isFirstWalk,
        isFirstOutdoorWalk: isFirstOutdoorWalk,
      );

      // 펫 상태 기반 배지 체크
      if (_currentPet != null) {
        await _achievementService.updateHappinessAchievements(_currentPet!.happiness);
        await _achievementService.updateTreatsAchievements(_currentPet!.treats);
      }

      debugPrint('StepTrackingService - Achievement check completed: ${unlockedAchievements.length} achievements unlocked');
    } catch (e) {
      debugPrint('StepTrackingService - Error checking achievements: $e');
    }
  }

  /// 미션 진행도 업데이트
  Future<List<Mission>> _updateMissionProgress(WalkSession walkSession) async {
    try {
      // 현재 총 걸음수 계산 (오늘 하루 총합)
      final todayWalkSessions = await _databaseService.getWalkSessionsByDate(DateTime.now());
      final totalTodaySteps = todayWalkSessions.fold<int>(0, (sum, session) => sum + session.totalSteps);

      final completedMissions = await _missionService.updateMissionProgressFromSteps(
        totalTodaySteps,
        walkSession.totalSteps,
        walkSession.duration,
        walkSession.distance,
      );

      if (completedMissions.isNotEmpty) {
        debugPrint('StepTrackingService - Missions completed: ${completedMissions.length}');
        for (final mission in completedMissions) {
          debugPrint('StepTrackingService - Completed mission: ${mission.title}');
        }
      }

      return completedMissions;
    } catch (e) {
      debugPrint('StepTrackingService - Error updating mission progress: $e');
      return [];
    }
  }

  /// 현재 연속 산책 일수 계산
  int _calculateCurrentStreak(List<dynamic> walkSessions) {
    if (walkSessions.isEmpty) return 0;

    // 날짜별로 그룹화
    final Map<String, bool> walkDays = {};
    for (final session in walkSessions) {
      final dateKey = DateTime(session.startTime.year, session.startTime.month, session.startTime.day).toIso8601String().split('T')[0];
      walkDays[dateKey] = true;
    }

    // 오늘부터 역순으로 연속 일수 계산
    int streak = 0;
    final today = DateTime.now();

    for (int i = 0; i < 30; i++) { // 최대 30일까지만 체크
      final checkDate = today.subtract(Duration(days: i));
      final dateKey = DateTime(checkDate.year, checkDate.month, checkDate.day).toIso8601String().split('T')[0];

      if (walkDays.containsKey(dateKey)) {
        streak++;
      } else {
        break; // 연속이 끊어지면 중단
      }
    }

    return streak;
  }

  /// 서비스 중지
  Future<void> stop() async {
    debugPrint('StepTrackingService - Stopping...');

    await _stepCountSubscription?.cancel();
    await _locationService.stopLocationTracking();

    _stepCountSubscription = null;

    _updateState(StepTrackingState.stopped);
    _isInitialized = false;

    debugPrint('StepTrackingService - Stopped');
  }

  /// 리소스 정리
  Future<void> dispose() async {
    await stop();
    await _stateController.close();
    await _dailyStepsController.close();
    await _petUpdateController.close();
  }
}

/// 걸음수 트래킹 상태
enum StepTrackingState {
  stopped,     // 중지됨
  monitoring,  // 모니터링 중 (기본 상태)
  walking,     // 산책 중
  error,       // 오류 상태
}

/// Step Tracking Service Provider
final stepTrackingServiceProvider = Provider<StepTrackingService>((ref) {
  final service = StepTrackingService();

  // Provider가 dispose될 때 StreamController도 정리
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// 트래킹 상태 Provider
final stepTrackingStateProvider = StreamProvider<StepTrackingState>((ref) {
  final service = ref.watch(stepTrackingServiceProvider);
  return service.stateStream;
});

/// 일일 걸음수 Provider
final dailyStepsProvider = StreamProvider<int>((ref) {
  final service = ref.watch(stepTrackingServiceProvider);
  return service.dailyStepsStream;
});

/// 주간 걸음수 Provider
/// 이번 주 월요일부터 오늘까지의 총 걸음수 계산 (HealthKit에서 실시간 조회)
final weeklyStepsProvider = StreamProvider<int>((ref) {
  final service = ref.watch(stepTrackingServiceProvider);
  return service.weeklyStepsStream;
});

/// 펫 업데이트 Provider
final petTrackingProvider = StreamProvider<Pet?>((ref) {
  final service = ref.watch(stepTrackingServiceProvider);
  return service.petUpdateStream;
});
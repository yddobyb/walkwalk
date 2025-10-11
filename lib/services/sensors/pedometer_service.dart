// lib/services/sensors/pedometer_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 걸음수 데이터를 위한 간단한 클래스 (StepCount 대체)
class StepData {
  final int steps;
  final DateTime timestamp;

  StepData({required this.steps, required this.timestamp});
}

/// Pedometer 서비스 - Health package를 사용하여 걸음수 트래킹 및 권한 관리
class PedometerService {
  static final PedometerService _instance = PedometerService._internal();
  factory PedometerService() => _instance;
  PedometerService._internal();

  final Health _health = Health();
  Timer? _stepCountTimer;

  final StreamController<StepData> _stepCountController = StreamController<StepData>.broadcast();
  final StreamController<String> _errorController = StreamController<String>.broadcast();

  /// 마지막으로 받은 걸음수 데이터 캐시
  StepData? _lastStepData;

  /// 걸음수 스트림
  Stream<StepData> get stepCountStream => _stepCountController.stream;

  /// 에러 스트림
  Stream<String> get errorStream => _errorController.stream;

  /// 마지막 걸음수 데이터 가져오기
  StepData? get lastStepData => _lastStepData;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Health 권한 확인
  Future<bool> hasPermission() async {
    try {
      await _health.configure();

      final types = [HealthDataType.STEPS];
      final permissions = [HealthDataAccess.READ];

      bool? hasPermissions = await _health.hasPermissions(types, permissions: permissions);
      return hasPermissions ?? false;
    } catch (e) {
      debugPrint('PedometerService - Permission check error: $e');
      return false;
    }
  }

  /// Health 권한 요청
  Future<bool> requestPermission() async {
    try {
      await _health.configure();

      final types = [HealthDataType.STEPS];
      final permissions = [HealthDataAccess.READ];

      bool? granted = await _health.requestAuthorization(types, permissions: permissions);

      if (granted == null || !granted) {
        _errorController.add('건강 데이터 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('PedometerService - Permission request error: $e');
      _errorController.add('권한 요청 중 오류가 발생했습니다: $e');
      return false;
    }
  }

  /// Pedometer 초기화 및 시작
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('PedometerService - Already initialized');
      return true;
    }

    try {
      // Health 설정
      await _health.configure();
      debugPrint('PedometerService - Health configured');

      // 권한 확인 및 요청
      final hasPermission = await this.hasPermission();
      if (!hasPermission) {
        debugPrint('PedometerService - No permission, requesting...');
        final granted = await requestPermission();
        if (!granted) {
          _errorController.add('걸음수 트래킹을 위해서는 건강 데이터 접근 권한이 필요합니다.');
          return false;
        }
      }

      // 정기적으로 걸음수 업데이트 (30초마다)
      await _startStepCountPolling();

      _isInitialized = true;
      debugPrint('PedometerService - Initialized successfully');
      return true;
    } catch (e) {
      debugPrint('PedometerService - Initialization error: $e');
      _errorController.add('걸음수 트래킹 초기화 중 오류가 발생했습니다: $e');
      return false;
    }
  }

  /// 오늘의 걸음수 가져오기 (자정부터 지금까지)
  Future<int?> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      debugPrint('PedometerService - Fetching steps from $midnight to $now');

      int? steps = await _health.getTotalStepsInInterval(midnight, now);

      debugPrint('PedometerService - Today\'s steps: $steps');
      return steps;
    } catch (e) {
      debugPrint('PedometerService - Error getting today steps: $e');
      _errorController.add('오늘의 걸음수를 가져오는 중 오류가 발생했습니다: $e');
      return null;
    }
  }

  /// 특정 날짜의 걸음수 가져오기 (해당 날짜 00:00 ~ 23:59)
  Future<int?> getStepsForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      debugPrint('PedometerService - Fetching steps for $date from $startOfDay to $endOfDay');

      int? steps = await _health.getTotalStepsInInterval(startOfDay, endOfDay);

      debugPrint('PedometerService - Steps for ${date.toString().split(' ')[0]}: $steps');
      return steps ?? 0;
    } catch (e) {
      debugPrint('PedometerService - Error getting steps for date: $e');
      return 0;
    }
  }

  /// 걸음수 폴링 시작 (정기적으로 걸음수 체크)
  Future<void> _startStepCountPolling() async {
    // 즉시 한 번 실행
    await _fetchAndEmitStepCount();

    // 5초마다 업데이트
    _stepCountTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fetchAndEmitStepCount();
    });
  }

  /// 걸음수 가져와서 스트림에 emit
  Future<void> _fetchAndEmitStepCount() async {
    try {
      final steps = await getTodaySteps();

      if (steps != null) {
        final stepData = StepData(
          steps: steps,
          timestamp: DateTime.now(),
        );

        _lastStepData = stepData;
        _stepCountController.add(stepData);

        debugPrint('PedometerService - Emitted step count: $steps');
      }
    } catch (e) {
      debugPrint('PedometerService - Error fetching step count: $e');
      _errorController.add('걸음수 가져오기 오류: $e');
    }
  }

  /// 서비스 중지
  Future<void> stop() async {
    debugPrint('PedometerService - Stopping...');

    _stepCountTimer?.cancel();
    _stepCountTimer = null;
    _isInitialized = false;

    debugPrint('PedometerService - Stopped');
  }

  /// 리소스 정리
  Future<void> dispose() async {
    await stop();
    await _stepCountController.close();
    await _errorController.close();
  }
}

/// Pedometer Service Provider
final pedometerServiceProvider = Provider<PedometerService>((ref) {
  return PedometerService();
});

/// 현재 걸음수 상태 Provider
final stepCountProvider = StreamProvider<StepData?>((ref) {
  final service = ref.watch(pedometerServiceProvider);
  return service.stepCountStream;
});

/// Pedometer 에러 Provider
final pedometerErrorProvider = StreamProvider<String?>((ref) {
  final service = ref.watch(pedometerServiceProvider);
  return service.errorStream;
});

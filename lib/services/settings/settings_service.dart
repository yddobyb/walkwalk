// lib/services/settings/settings_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/database_service.dart';
import '../../data/models/settings_model.dart';
import '../mission/mission_service.dart';

/// 설정 관리 서비스
class SettingsService {
  final DatabaseService _databaseService;

  SettingsService(this._databaseService);

  /// 설정 불러오기
  Future<SettingsModel> loadSettings() async {
    try {
      final settings = await _databaseService.getSettings();

      if (settings == null) {
        // 설정이 없으면 기본값 생성 후 저장
        final defaultSettings = SettingsModel.createDefault();
        await _databaseService.saveSettings(defaultSettings);
        return defaultSettings;
      }

      return settings;
    } catch (e) {
      debugPrint('SettingsService - Error loading settings: $e');
      return SettingsModel.createDefault();
    }
  }

  /// 다크 모드 설정 변경
  Future<void> updateDarkMode(bool enabled) async {
    try {
      final settings = await loadSettings();
      settings.darkModeEnabled = enabled;
      await _databaseService.saveSettings(settings);
    } catch (e) {
      debugPrint('SettingsService - Error updating dark mode: $e');
      rethrow;
    }
  }

  /// 실외 모드 설정 변경
  Future<void> updateOutdoorMode(bool enabled) async {
    try {
      final settings = await loadSettings();
      settings.isOutdoorModeEnabled = enabled;
      await _databaseService.saveSettings(settings);
    } catch (e) {
      debugPrint('SettingsService - Error updating outdoor mode: $e');
      rethrow;
    }
  }

  /// 알림 설정 변경
  Future<void> updateNotifications(bool enabled) async {
    try {
      final settings = await loadSettings();
      settings.notificationsEnabled = enabled;
      await _databaseService.saveSettings(settings);
    } catch (e) {
      debugPrint('SettingsService - Error updating notifications: $e');
      rethrow;
    }
  }

  /// 로컬 LLM 설정 변경
  Future<void> updateLocalLLM(bool enabled) async {
    try {
      final settings = await loadSettings();
      settings.localLLMEnabled = enabled;
      await _databaseService.saveSettings(settings);
    } catch (e) {
      debugPrint('SettingsService - Error updating local LLM: $e');
      rethrow;
    }
  }

  /// 클라우드 이미지 생성 설정 변경
  Future<void> updateCloudImage(bool enabled) async {
    try {
      final settings = await loadSettings();
      settings.cloudImageEnabled = enabled;
      await _databaseService.saveSettings(settings);
    } catch (e) {
      debugPrint('SettingsService - Error updating cloud image: $e');
      rethrow;
    }
  }

  /// 일일 목표 걸음수 설정 변경
  Future<void> updateDailyStepGoal(int goal) async {
    try {
      final settings = await loadSettings();
      settings.dailyStepGoal = goal;
      await _databaseService.saveSettings(settings);

      // 기존 미션들도 새로운 목표값으로 업데이트
      final missionService = MissionService.instance;
      await missionService.updateMissionsForNewGoal(goal);

      debugPrint('SettingsService - Updated daily step goal to $goal and refreshed missions');
    } catch (e) {
      debugPrint('SettingsService - Error updating daily step goal: $e');
      rethrow;
    }
  }

  /// 설정 스트림 (실시간 업데이트용)
  Stream<SettingsModel> watchSettings() async* {
    while (true) {
      yield await loadSettings();
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}

/// SettingsService Provider
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(DatabaseService());
});

/// 설정 상태 Provider (FutureProvider)
final settingsProvider = FutureProvider<SettingsModel>((ref) async {
  final service = ref.watch(settingsServiceProvider);
  return await service.loadSettings();
});

/// 설정 상태 Notifier Provider (실시간 업데이트용)
class SettingsNotifier extends StateNotifier<AsyncValue<SettingsModel>> {
  final SettingsService _service;

  SettingsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _service.loadSettings();
      state = AsyncValue.data(settings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateDarkMode(bool enabled) async {
    await _service.updateDarkMode(enabled);
    await _loadSettings();
  }

  Future<void> updateOutdoorMode(bool enabled) async {
    await _service.updateOutdoorMode(enabled);
    await _loadSettings();
  }

  Future<void> updateNotifications(bool enabled) async {
    await _service.updateNotifications(enabled);
    await _loadSettings();
  }

  Future<void> updateLocalLLM(bool enabled) async {
    await _service.updateLocalLLM(enabled);
    await _loadSettings();
  }

  Future<void> updateCloudImage(bool enabled) async {
    await _service.updateCloudImage(enabled);
    await _loadSettings();
  }

  Future<void> updateDailyStepGoal(int goal) async {
    await _service.updateDailyStepGoal(goal);
    await _loadSettings();
  }
}

/// 설정 Notifier Provider
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsModel>>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return SettingsNotifier(service);
});

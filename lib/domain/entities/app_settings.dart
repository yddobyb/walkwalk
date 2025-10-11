// lib/domain/entities/app_settings.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // 게임플레이 설정
    required bool isOutdoorModeEnabled,
    required int dailyStepGoal,
    required int stepPerTreat,
    required double outdoorBonus,
    required int dailyHappinessDecay,

    // AI 설정
    required bool localLLMEnabled,
    required bool cloudImageEnabled,
    required String llmModelPath,
    required int maxTokens,

    // 알림 설정
    required bool notificationsEnabled,
    required bool morningReminderEnabled,
    required bool eveningReminderEnabled,
    required String morningReminderTime,
    required String eveningReminderTime,

    // 프라이버시
    required bool analyticsEnabled,
    required bool crashReportingEnabled,

    // UI 설정
    required bool darkModeEnabled,
    required String locale,

    // 캐시 설정
    required int imageCacheSizeMB,
    required int llmCacheSizeMB,

    // 기타
    required DateTime lastSyncTime,
    required String appVersion,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  // 기본값 팩토리
  factory AppSettings.defaultSettings() {
    return AppSettings(
      isOutdoorModeEnabled: false,
      dailyStepGoal: 5000,
      stepPerTreat: 300,
      outdoorBonus: 1.2,
      dailyHappinessDecay: 10,
      localLLMEnabled: true,
      cloudImageEnabled: true,
      llmModelPath: '',
      maxTokens: 60,
      notificationsEnabled: true,
      morningReminderEnabled: false,
      eveningReminderEnabled: false,
      morningReminderTime: '09:00',
      eveningReminderTime: '18:00',
      analyticsEnabled: false,
      crashReportingEnabled: true,
      darkModeEnabled: false,
      locale: 'ko',
      imageCacheSizeMB: 100,
      llmCacheSizeMB: 50,
      lastSyncTime: DateTime.now(),
      appVersion: '1.0.0',
    );
  }
}
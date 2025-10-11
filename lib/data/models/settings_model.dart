// lib/data/models/settings_model.dart
import 'package:isar/isar.dart';
import '../../domain/entities/app_settings.dart';

part 'settings_model.g.dart';

@collection
class SettingsModel {
  Id id = 1; // 단일 레코드

  // 게임플레이 설정
  late bool isOutdoorModeEnabled;
  late int dailyStepGoal; // 일일 목표 걸음수
  late int stepPerTreat; // 간식당 필요 걸음수
  late double outdoorBonus; // 실외 보너스 배수
  late int dailyHappinessDecay; // 일일 행복도 감소

  // AI 설정
  late bool localLLMEnabled;
  late bool cloudImageEnabled;
  late String llmModelPath; // 로컬 모델 경로
  late int maxTokens; // 최대 응답 토큰

  // 알림 설정
  late bool notificationsEnabled;
  late bool morningReminderEnabled;
  late bool eveningReminderEnabled;
  late String morningReminderTime; // "09:00"
  late String eveningReminderTime; // "18:00"

  // 프라이버시
  late bool analyticsEnabled;
  late bool crashReportingEnabled;

  // UI 설정
  late bool darkModeEnabled;
  late String locale; // "ko", "en", etc.

  // 캐시 설정
  late int imageCacheSizeMB;
  late int llmCacheSizeMB;

  // 기타
  late DateTime lastSyncTime;
  late String appVersion;

  // 도메인 엔티티로 변환
  AppSettings toDomain() {
    return AppSettings(
      isOutdoorModeEnabled: isOutdoorModeEnabled,
      dailyStepGoal: dailyStepGoal,
      stepPerTreat: stepPerTreat,
      outdoorBonus: outdoorBonus,
      dailyHappinessDecay: dailyHappinessDecay,
      localLLMEnabled: localLLMEnabled,
      cloudImageEnabled: cloudImageEnabled,
      llmModelPath: llmModelPath,
      maxTokens: maxTokens,
      notificationsEnabled: notificationsEnabled,
      morningReminderEnabled: morningReminderEnabled,
      eveningReminderEnabled: eveningReminderEnabled,
      morningReminderTime: morningReminderTime,
      eveningReminderTime: eveningReminderTime,
      analyticsEnabled: analyticsEnabled,
      crashReportingEnabled: crashReportingEnabled,
      darkModeEnabled: darkModeEnabled,
      locale: locale,
      imageCacheSizeMB: imageCacheSizeMB,
      llmCacheSizeMB: llmCacheSizeMB,
      lastSyncTime: lastSyncTime,
      appVersion: appVersion,
    );
  }

  // 도메인 엔티티에서 생성
  static SettingsModel fromDomain(AppSettings settings) {
    return SettingsModel()
      ..isOutdoorModeEnabled = settings.isOutdoorModeEnabled
      ..dailyStepGoal = settings.dailyStepGoal
      ..stepPerTreat = settings.stepPerTreat
      ..outdoorBonus = settings.outdoorBonus
      ..dailyHappinessDecay = settings.dailyHappinessDecay
      ..localLLMEnabled = settings.localLLMEnabled
      ..cloudImageEnabled = settings.cloudImageEnabled
      ..llmModelPath = settings.llmModelPath
      ..maxTokens = settings.maxTokens
      ..notificationsEnabled = settings.notificationsEnabled
      ..morningReminderEnabled = settings.morningReminderEnabled
      ..eveningReminderEnabled = settings.eveningReminderEnabled
      ..morningReminderTime = settings.morningReminderTime
      ..eveningReminderTime = settings.eveningReminderTime
      ..analyticsEnabled = settings.analyticsEnabled
      ..crashReportingEnabled = settings.crashReportingEnabled
      ..darkModeEnabled = settings.darkModeEnabled
      ..locale = settings.locale
      ..imageCacheSizeMB = settings.imageCacheSizeMB
      ..llmCacheSizeMB = settings.llmCacheSizeMB
      ..lastSyncTime = settings.lastSyncTime
      ..appVersion = settings.appVersion;
  }

  // 기본값으로 초기화
  static SettingsModel createDefault() {
    return SettingsModel.fromDomain(AppSettings.defaultSettings());
  }
}
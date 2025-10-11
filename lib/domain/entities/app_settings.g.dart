// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      isOutdoorModeEnabled: json['isOutdoorModeEnabled'] as bool,
      dailyStepGoal: (json['dailyStepGoal'] as num).toInt(),
      stepPerTreat: (json['stepPerTreat'] as num).toInt(),
      outdoorBonus: (json['outdoorBonus'] as num).toDouble(),
      dailyHappinessDecay: (json['dailyHappinessDecay'] as num).toInt(),
      localLLMEnabled: json['localLLMEnabled'] as bool,
      cloudImageEnabled: json['cloudImageEnabled'] as bool,
      llmModelPath: json['llmModelPath'] as String,
      maxTokens: (json['maxTokens'] as num).toInt(),
      notificationsEnabled: json['notificationsEnabled'] as bool,
      morningReminderEnabled: json['morningReminderEnabled'] as bool,
      eveningReminderEnabled: json['eveningReminderEnabled'] as bool,
      morningReminderTime: json['morningReminderTime'] as String,
      eveningReminderTime: json['eveningReminderTime'] as String,
      analyticsEnabled: json['analyticsEnabled'] as bool,
      crashReportingEnabled: json['crashReportingEnabled'] as bool,
      darkModeEnabled: json['darkModeEnabled'] as bool,
      locale: json['locale'] as String,
      imageCacheSizeMB: (json['imageCacheSizeMB'] as num).toInt(),
      llmCacheSizeMB: (json['llmCacheSizeMB'] as num).toInt(),
      lastSyncTime: DateTime.parse(json['lastSyncTime'] as String),
      appVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'isOutdoorModeEnabled': instance.isOutdoorModeEnabled,
      'dailyStepGoal': instance.dailyStepGoal,
      'stepPerTreat': instance.stepPerTreat,
      'outdoorBonus': instance.outdoorBonus,
      'dailyHappinessDecay': instance.dailyHappinessDecay,
      'localLLMEnabled': instance.localLLMEnabled,
      'cloudImageEnabled': instance.cloudImageEnabled,
      'llmModelPath': instance.llmModelPath,
      'maxTokens': instance.maxTokens,
      'notificationsEnabled': instance.notificationsEnabled,
      'morningReminderEnabled': instance.morningReminderEnabled,
      'eveningReminderEnabled': instance.eveningReminderEnabled,
      'morningReminderTime': instance.morningReminderTime,
      'eveningReminderTime': instance.eveningReminderTime,
      'analyticsEnabled': instance.analyticsEnabled,
      'crashReportingEnabled': instance.crashReportingEnabled,
      'darkModeEnabled': instance.darkModeEnabled,
      'locale': instance.locale,
      'imageCacheSizeMB': instance.imageCacheSizeMB,
      'llmCacheSizeMB': instance.llmCacheSizeMB,
      'lastSyncTime': instance.lastSyncTime.toIso8601String(),
      'appVersion': instance.appVersion,
    };

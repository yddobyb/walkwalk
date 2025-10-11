// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
// 게임플레이 설정
  bool get isOutdoorModeEnabled => throw _privateConstructorUsedError;
  int get dailyStepGoal => throw _privateConstructorUsedError;
  int get stepPerTreat => throw _privateConstructorUsedError;
  double get outdoorBonus => throw _privateConstructorUsedError;
  int get dailyHappinessDecay => throw _privateConstructorUsedError; // AI 설정
  bool get localLLMEnabled => throw _privateConstructorUsedError;
  bool get cloudImageEnabled => throw _privateConstructorUsedError;
  String get llmModelPath => throw _privateConstructorUsedError;
  int get maxTokens => throw _privateConstructorUsedError; // 알림 설정
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  bool get morningReminderEnabled => throw _privateConstructorUsedError;
  bool get eveningReminderEnabled => throw _privateConstructorUsedError;
  String get morningReminderTime => throw _privateConstructorUsedError;
  String get eveningReminderTime => throw _privateConstructorUsedError; // 프라이버시
  bool get analyticsEnabled => throw _privateConstructorUsedError;
  bool get crashReportingEnabled => throw _privateConstructorUsedError; // UI 설정
  bool get darkModeEnabled => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError; // 캐시 설정
  int get imageCacheSizeMB => throw _privateConstructorUsedError;
  int get llmCacheSizeMB => throw _privateConstructorUsedError; // 기타
  DateTime get lastSyncTime => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {bool isOutdoorModeEnabled,
      int dailyStepGoal,
      int stepPerTreat,
      double outdoorBonus,
      int dailyHappinessDecay,
      bool localLLMEnabled,
      bool cloudImageEnabled,
      String llmModelPath,
      int maxTokens,
      bool notificationsEnabled,
      bool morningReminderEnabled,
      bool eveningReminderEnabled,
      String morningReminderTime,
      String eveningReminderTime,
      bool analyticsEnabled,
      bool crashReportingEnabled,
      bool darkModeEnabled,
      String locale,
      int imageCacheSizeMB,
      int llmCacheSizeMB,
      DateTime lastSyncTime,
      String appVersion});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOutdoorModeEnabled = null,
    Object? dailyStepGoal = null,
    Object? stepPerTreat = null,
    Object? outdoorBonus = null,
    Object? dailyHappinessDecay = null,
    Object? localLLMEnabled = null,
    Object? cloudImageEnabled = null,
    Object? llmModelPath = null,
    Object? maxTokens = null,
    Object? notificationsEnabled = null,
    Object? morningReminderEnabled = null,
    Object? eveningReminderEnabled = null,
    Object? morningReminderTime = null,
    Object? eveningReminderTime = null,
    Object? analyticsEnabled = null,
    Object? crashReportingEnabled = null,
    Object? darkModeEnabled = null,
    Object? locale = null,
    Object? imageCacheSizeMB = null,
    Object? llmCacheSizeMB = null,
    Object? lastSyncTime = null,
    Object? appVersion = null,
  }) {
    return _then(_value.copyWith(
      isOutdoorModeEnabled: null == isOutdoorModeEnabled
          ? _value.isOutdoorModeEnabled
          : isOutdoorModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyStepGoal: null == dailyStepGoal
          ? _value.dailyStepGoal
          : dailyStepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      stepPerTreat: null == stepPerTreat
          ? _value.stepPerTreat
          : stepPerTreat // ignore: cast_nullable_to_non_nullable
              as int,
      outdoorBonus: null == outdoorBonus
          ? _value.outdoorBonus
          : outdoorBonus // ignore: cast_nullable_to_non_nullable
              as double,
      dailyHappinessDecay: null == dailyHappinessDecay
          ? _value.dailyHappinessDecay
          : dailyHappinessDecay // ignore: cast_nullable_to_non_nullable
              as int,
      localLLMEnabled: null == localLLMEnabled
          ? _value.localLLMEnabled
          : localLLMEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudImageEnabled: null == cloudImageEnabled
          ? _value.cloudImageEnabled
          : cloudImageEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      llmModelPath: null == llmModelPath
          ? _value.llmModelPath
          : llmModelPath // ignore: cast_nullable_to_non_nullable
              as String,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      morningReminderEnabled: null == morningReminderEnabled
          ? _value.morningReminderEnabled
          : morningReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eveningReminderEnabled: null == eveningReminderEnabled
          ? _value.eveningReminderEnabled
          : eveningReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      morningReminderTime: null == morningReminderTime
          ? _value.morningReminderTime
          : morningReminderTime // ignore: cast_nullable_to_non_nullable
              as String,
      eveningReminderTime: null == eveningReminderTime
          ? _value.eveningReminderTime
          : eveningReminderTime // ignore: cast_nullable_to_non_nullable
              as String,
      analyticsEnabled: null == analyticsEnabled
          ? _value.analyticsEnabled
          : analyticsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      crashReportingEnabled: null == crashReportingEnabled
          ? _value.crashReportingEnabled
          : crashReportingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      darkModeEnabled: null == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      imageCacheSizeMB: null == imageCacheSizeMB
          ? _value.imageCacheSizeMB
          : imageCacheSizeMB // ignore: cast_nullable_to_non_nullable
              as int,
      llmCacheSizeMB: null == llmCacheSizeMB
          ? _value.llmCacheSizeMB
          : llmCacheSizeMB // ignore: cast_nullable_to_non_nullable
              as int,
      lastSyncTime: null == lastSyncTime
          ? _value.lastSyncTime
          : lastSyncTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOutdoorModeEnabled,
      int dailyStepGoal,
      int stepPerTreat,
      double outdoorBonus,
      int dailyHappinessDecay,
      bool localLLMEnabled,
      bool cloudImageEnabled,
      String llmModelPath,
      int maxTokens,
      bool notificationsEnabled,
      bool morningReminderEnabled,
      bool eveningReminderEnabled,
      String morningReminderTime,
      String eveningReminderTime,
      bool analyticsEnabled,
      bool crashReportingEnabled,
      bool darkModeEnabled,
      String locale,
      int imageCacheSizeMB,
      int llmCacheSizeMB,
      DateTime lastSyncTime,
      String appVersion});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOutdoorModeEnabled = null,
    Object? dailyStepGoal = null,
    Object? stepPerTreat = null,
    Object? outdoorBonus = null,
    Object? dailyHappinessDecay = null,
    Object? localLLMEnabled = null,
    Object? cloudImageEnabled = null,
    Object? llmModelPath = null,
    Object? maxTokens = null,
    Object? notificationsEnabled = null,
    Object? morningReminderEnabled = null,
    Object? eveningReminderEnabled = null,
    Object? morningReminderTime = null,
    Object? eveningReminderTime = null,
    Object? analyticsEnabled = null,
    Object? crashReportingEnabled = null,
    Object? darkModeEnabled = null,
    Object? locale = null,
    Object? imageCacheSizeMB = null,
    Object? llmCacheSizeMB = null,
    Object? lastSyncTime = null,
    Object? appVersion = null,
  }) {
    return _then(_$AppSettingsImpl(
      isOutdoorModeEnabled: null == isOutdoorModeEnabled
          ? _value.isOutdoorModeEnabled
          : isOutdoorModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyStepGoal: null == dailyStepGoal
          ? _value.dailyStepGoal
          : dailyStepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      stepPerTreat: null == stepPerTreat
          ? _value.stepPerTreat
          : stepPerTreat // ignore: cast_nullable_to_non_nullable
              as int,
      outdoorBonus: null == outdoorBonus
          ? _value.outdoorBonus
          : outdoorBonus // ignore: cast_nullable_to_non_nullable
              as double,
      dailyHappinessDecay: null == dailyHappinessDecay
          ? _value.dailyHappinessDecay
          : dailyHappinessDecay // ignore: cast_nullable_to_non_nullable
              as int,
      localLLMEnabled: null == localLLMEnabled
          ? _value.localLLMEnabled
          : localLLMEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudImageEnabled: null == cloudImageEnabled
          ? _value.cloudImageEnabled
          : cloudImageEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      llmModelPath: null == llmModelPath
          ? _value.llmModelPath
          : llmModelPath // ignore: cast_nullable_to_non_nullable
              as String,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      morningReminderEnabled: null == morningReminderEnabled
          ? _value.morningReminderEnabled
          : morningReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eveningReminderEnabled: null == eveningReminderEnabled
          ? _value.eveningReminderEnabled
          : eveningReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      morningReminderTime: null == morningReminderTime
          ? _value.morningReminderTime
          : morningReminderTime // ignore: cast_nullable_to_non_nullable
              as String,
      eveningReminderTime: null == eveningReminderTime
          ? _value.eveningReminderTime
          : eveningReminderTime // ignore: cast_nullable_to_non_nullable
              as String,
      analyticsEnabled: null == analyticsEnabled
          ? _value.analyticsEnabled
          : analyticsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      crashReportingEnabled: null == crashReportingEnabled
          ? _value.crashReportingEnabled
          : crashReportingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      darkModeEnabled: null == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      imageCacheSizeMB: null == imageCacheSizeMB
          ? _value.imageCacheSizeMB
          : imageCacheSizeMB // ignore: cast_nullable_to_non_nullable
              as int,
      llmCacheSizeMB: null == llmCacheSizeMB
          ? _value.llmCacheSizeMB
          : llmCacheSizeMB // ignore: cast_nullable_to_non_nullable
              as int,
      lastSyncTime: null == lastSyncTime
          ? _value.lastSyncTime
          : lastSyncTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {required this.isOutdoorModeEnabled,
      required this.dailyStepGoal,
      required this.stepPerTreat,
      required this.outdoorBonus,
      required this.dailyHappinessDecay,
      required this.localLLMEnabled,
      required this.cloudImageEnabled,
      required this.llmModelPath,
      required this.maxTokens,
      required this.notificationsEnabled,
      required this.morningReminderEnabled,
      required this.eveningReminderEnabled,
      required this.morningReminderTime,
      required this.eveningReminderTime,
      required this.analyticsEnabled,
      required this.crashReportingEnabled,
      required this.darkModeEnabled,
      required this.locale,
      required this.imageCacheSizeMB,
      required this.llmCacheSizeMB,
      required this.lastSyncTime,
      required this.appVersion});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

// 게임플레이 설정
  @override
  final bool isOutdoorModeEnabled;
  @override
  final int dailyStepGoal;
  @override
  final int stepPerTreat;
  @override
  final double outdoorBonus;
  @override
  final int dailyHappinessDecay;
// AI 설정
  @override
  final bool localLLMEnabled;
  @override
  final bool cloudImageEnabled;
  @override
  final String llmModelPath;
  @override
  final int maxTokens;
// 알림 설정
  @override
  final bool notificationsEnabled;
  @override
  final bool morningReminderEnabled;
  @override
  final bool eveningReminderEnabled;
  @override
  final String morningReminderTime;
  @override
  final String eveningReminderTime;
// 프라이버시
  @override
  final bool analyticsEnabled;
  @override
  final bool crashReportingEnabled;
// UI 설정
  @override
  final bool darkModeEnabled;
  @override
  final String locale;
// 캐시 설정
  @override
  final int imageCacheSizeMB;
  @override
  final int llmCacheSizeMB;
// 기타
  @override
  final DateTime lastSyncTime;
  @override
  final String appVersion;

  @override
  String toString() {
    return 'AppSettings(isOutdoorModeEnabled: $isOutdoorModeEnabled, dailyStepGoal: $dailyStepGoal, stepPerTreat: $stepPerTreat, outdoorBonus: $outdoorBonus, dailyHappinessDecay: $dailyHappinessDecay, localLLMEnabled: $localLLMEnabled, cloudImageEnabled: $cloudImageEnabled, llmModelPath: $llmModelPath, maxTokens: $maxTokens, notificationsEnabled: $notificationsEnabled, morningReminderEnabled: $morningReminderEnabled, eveningReminderEnabled: $eveningReminderEnabled, morningReminderTime: $morningReminderTime, eveningReminderTime: $eveningReminderTime, analyticsEnabled: $analyticsEnabled, crashReportingEnabled: $crashReportingEnabled, darkModeEnabled: $darkModeEnabled, locale: $locale, imageCacheSizeMB: $imageCacheSizeMB, llmCacheSizeMB: $llmCacheSizeMB, lastSyncTime: $lastSyncTime, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.isOutdoorModeEnabled, isOutdoorModeEnabled) ||
                other.isOutdoorModeEnabled == isOutdoorModeEnabled) &&
            (identical(other.dailyStepGoal, dailyStepGoal) ||
                other.dailyStepGoal == dailyStepGoal) &&
            (identical(other.stepPerTreat, stepPerTreat) ||
                other.stepPerTreat == stepPerTreat) &&
            (identical(other.outdoorBonus, outdoorBonus) ||
                other.outdoorBonus == outdoorBonus) &&
            (identical(other.dailyHappinessDecay, dailyHappinessDecay) ||
                other.dailyHappinessDecay == dailyHappinessDecay) &&
            (identical(other.localLLMEnabled, localLLMEnabled) ||
                other.localLLMEnabled == localLLMEnabled) &&
            (identical(other.cloudImageEnabled, cloudImageEnabled) ||
                other.cloudImageEnabled == cloudImageEnabled) &&
            (identical(other.llmModelPath, llmModelPath) ||
                other.llmModelPath == llmModelPath) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.morningReminderEnabled, morningReminderEnabled) ||
                other.morningReminderEnabled == morningReminderEnabled) &&
            (identical(other.eveningReminderEnabled, eveningReminderEnabled) ||
                other.eveningReminderEnabled == eveningReminderEnabled) &&
            (identical(other.morningReminderTime, morningReminderTime) ||
                other.morningReminderTime == morningReminderTime) &&
            (identical(other.eveningReminderTime, eveningReminderTime) ||
                other.eveningReminderTime == eveningReminderTime) &&
            (identical(other.analyticsEnabled, analyticsEnabled) ||
                other.analyticsEnabled == analyticsEnabled) &&
            (identical(other.crashReportingEnabled, crashReportingEnabled) ||
                other.crashReportingEnabled == crashReportingEnabled) &&
            (identical(other.darkModeEnabled, darkModeEnabled) ||
                other.darkModeEnabled == darkModeEnabled) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.imageCacheSizeMB, imageCacheSizeMB) ||
                other.imageCacheSizeMB == imageCacheSizeMB) &&
            (identical(other.llmCacheSizeMB, llmCacheSizeMB) ||
                other.llmCacheSizeMB == llmCacheSizeMB) &&
            (identical(other.lastSyncTime, lastSyncTime) ||
                other.lastSyncTime == lastSyncTime) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isOutdoorModeEnabled,
        dailyStepGoal,
        stepPerTreat,
        outdoorBonus,
        dailyHappinessDecay,
        localLLMEnabled,
        cloudImageEnabled,
        llmModelPath,
        maxTokens,
        notificationsEnabled,
        morningReminderEnabled,
        eveningReminderEnabled,
        morningReminderTime,
        eveningReminderTime,
        analyticsEnabled,
        crashReportingEnabled,
        darkModeEnabled,
        locale,
        imageCacheSizeMB,
        llmCacheSizeMB,
        lastSyncTime,
        appVersion
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {required final bool isOutdoorModeEnabled,
      required final int dailyStepGoal,
      required final int stepPerTreat,
      required final double outdoorBonus,
      required final int dailyHappinessDecay,
      required final bool localLLMEnabled,
      required final bool cloudImageEnabled,
      required final String llmModelPath,
      required final int maxTokens,
      required final bool notificationsEnabled,
      required final bool morningReminderEnabled,
      required final bool eveningReminderEnabled,
      required final String morningReminderTime,
      required final String eveningReminderTime,
      required final bool analyticsEnabled,
      required final bool crashReportingEnabled,
      required final bool darkModeEnabled,
      required final String locale,
      required final int imageCacheSizeMB,
      required final int llmCacheSizeMB,
      required final DateTime lastSyncTime,
      required final String appVersion}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override // 게임플레이 설정
  bool get isOutdoorModeEnabled;
  @override
  int get dailyStepGoal;
  @override
  int get stepPerTreat;
  @override
  double get outdoorBonus;
  @override
  int get dailyHappinessDecay;
  @override // AI 설정
  bool get localLLMEnabled;
  @override
  bool get cloudImageEnabled;
  @override
  String get llmModelPath;
  @override
  int get maxTokens;
  @override // 알림 설정
  bool get notificationsEnabled;
  @override
  bool get morningReminderEnabled;
  @override
  bool get eveningReminderEnabled;
  @override
  String get morningReminderTime;
  @override
  String get eveningReminderTime;
  @override // 프라이버시
  bool get analyticsEnabled;
  @override
  bool get crashReportingEnabled;
  @override // UI 설정
  bool get darkModeEnabled;
  @override
  String get locale;
  @override // 캐시 설정
  int get imageCacheSizeMB;
  @override
  int get llmCacheSizeMB;
  @override // 기타
  DateTime get lastSyncTime;
  @override
  String get appVersion;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

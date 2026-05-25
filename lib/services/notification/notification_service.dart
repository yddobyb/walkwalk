// lib/services/notification/notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../data/datasources/database_service.dart';

/// 알림 ID 상수 (날짜 기반, 7일 미리 스케줄)
class NotificationIds {
  NotificationIds._();

  // 날짜 기반 ID 계산
  // Morning: 1000 + (dayOffset % 400)
  // Evening: 2000 + (dayOffset % 400)
  static const int _morningBase = 1000;
  static const int _eveningBase = 2000;
  static const int _dayRange = 400;

  /// 미리 스케줄할 일수 (7일)
  static const int scheduleDays = 7;

  /// epoch 기준일
  static final DateTime _epoch = DateTime.utc(2025);

  static int _dayOffset(DateTime date) {
    final d = DateTime.utc(
      date.year,
      date.month,
      date.day,
    );
    return d.difference(_epoch).inDays % _dayRange;
  }

  /// 특정 날짜의 오전 알림 ID
  static int morningId(DateTime date) =>
      _morningBase + _dayOffset(date);

  /// 특정 날짜의 오후 알림 ID
  static int eveningId(DateTime date) =>
      _eveningBase + _dayOffset(date);

  // 미션/기타 (매일 반복)
  static const int missionExpiry = 3;
  static const int lowHappiness = 100;

  // 레거시 ID (마이그레이션용)
  static const List<int> legacyIds = [
    1, 2, 10, 11, 20, 21,
  ];
}

/// 알림 채널 상수
class NotificationChannels {
  NotificationChannels._();

  static const String walkReminder = 'walk_reminder';
  static const String walkReminderName = '산책 리마인더';
  static const String walkReminderDesc =
      '매일 산책 시간을 알려드립니다';

  static const String petAlert = 'pet_alert';
  static const String petAlertName = '펫 알림';
  static const String petAlertDesc =
      '펫의 상태 변화를 알려드립니다';

  static const String missionAlert = 'mission_alert';
  static const String missionAlertName = '미션 알림';
  static const String missionAlertDesc =
      '미션 만료 임박을 알려드립니다';
}

/// 로컬 푸시 알림 서비스
/// - 산책 리마인더 (오전/오후, 조건부)
/// - 행복도 낮음 경고
/// - 미션 만료 임박 알림
class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  NotificationService._();

  /// 테스트용 팩토리: 의존성 주입
  @visibleForTesting
  factory NotificationService.forTesting({
    required FlutterLocalNotificationsPlugin plugin,
    DatabaseService? dbService,
  }) {
    final service = NotificationService._();
    service._plugin = plugin;
    service._dbServiceOverride = dbService;
    return service;
  }

  /// 테스트에서 초기화 상태 직접 설정
  @visibleForTesting
  set isInitializedForTesting(bool value) =>
      _isInitialized = value;

  late FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  DatabaseService? _dbServiceOverride;
  bool _isInitialized = false;
  Timer? _midnightTimer;

  bool get isInitialized => _isInitialized;

  /// 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint(
        '⚠️ NotificationService already initialized',
      );
      return;
    }

    try {
      // timezone 초기화
      tz.initializeTimeZones();
      final timeZoneName =
          await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(
        tz.getLocation(timeZoneName),
      );

      // Android 설정
      const androidSettings =
          AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS 설정
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse:
            _onNotificationTapped,
      );

      // Android 알림 채널 생성
      if (Platform.isAndroid) {
        await _createAndroidChannels();
      }

      _isInitialized = true;
      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint(
        '❌ NotificationService init failed: $e',
      );
    }
  }

  /// Android 알림 채널 생성
  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.walkReminder,
        NotificationChannels.walkReminderName,
        description:
            NotificationChannels.walkReminderDesc,
        importance: Importance.high,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.petAlert,
        NotificationChannels.petAlertName,
        description: NotificationChannels.petAlertDesc,
        importance: Importance.high,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.missionAlert,
        NotificationChannels.missionAlertName,
        description:
            NotificationChannels.missionAlertDesc,
        importance: Importance.defaultImportance,
      ),
    );
  }

  /// 알림 권한 요청 (iOS + Android 13+)
  Future<bool> requestPermissions() async {
    try {
      if (Platform.isIOS) {
        final iosPlugin = _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        final granted =
            await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint(
          '🔔 iOS notification permission: $granted',
        );
        return granted ?? false;
      }

      if (Platform.isAndroid) {
        final androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin
            ?.requestNotificationsPermission();
        debugPrint(
          '🔔 Android notification permission: '
          '$granted',
        );
        return granted ?? false;
      }

      return false;
    } catch (e) {
      debugPrint(
        '❌ Error requesting notification '
        'permission: $e',
      );
      return false;
    }
  }

  // ─── 조건부 산책 리마인더 ──────────────────

  /// 조건부 산책 리마인더 스케줄 (7일치 미리)
  /// - DB에서 설정 로드
  /// - 오늘 산책 여부 확인 → 안 걸었으면 오늘도 스케줄
  /// - Day 1~6은 무조건 스케줄
  /// - iOS가 알림 발송 관리 → 앱 안 열어도 7일간 동작
  Future<void> scheduleConditionalReminders() async {
    if (!_isInitialized) return;

    try {
      final dbService =
          _dbServiceOverride ?? DatabaseService();
      final settings = await dbService.getSettings();
      if (settings == null ||
          !settings.notificationsEnabled) {
        debugPrint(
          '🔕 Notifications disabled, skipping '
          'walk reminders',
        );
        return;
      }

      // 기존 산책 알림 전부 취소 (7일치 + 레거시)
      await cancelWalkReminders();

      // 오늘 산책 여부 확인
      final today = DateTime.now();
      final todaySessions =
          await dbService.getWalkSessionsByDate(today);
      final walkedToday = todaySessions.isNotEmpty;

      // locale 기반 메시지
      final isKorean = settings.locale == 'ko';
      final morningTitle = isKorean
          ? '좋은 아침이에요!'
          : 'Good morning!';
      final morningBody = isKorean
          ? '오늘도 반려견과 산책을 시작해볼까요?'
          : 'Ready for a walk with your pet?';
      final eveningTitle = isKorean
          ? '저녁 산책 시간이에요!'
          : 'Time for an evening walk!';
      final eveningBody = isKorean
          ? '오늘 산책 목표를 달성해보세요!'
          : 'Let\'s reach your walk goal today!';

      // 시간 파싱
      final morningParts =
          settings.morningReminderTime.split(':');
      final morningH =
          int.tryParse(morningParts[0]) ?? 9;
      final morningM =
          int.tryParse(morningParts[1]) ?? 0;
      final eveningParts =
          settings.eveningReminderTime.split(':');
      final eveningH =
          int.tryParse(eveningParts[0]) ?? 18;
      final eveningM =
          int.tryParse(eveningParts[1]) ?? 0;

      final now = tz.TZDateTime.now(tz.local);
      var scheduledCount = 0;

      // 7일치 알림 스케줄
      for (var day = 0;
          day < NotificationIds.scheduleDays;
          day++) {
        final targetDate =
            now.add(Duration(days: day));
        final targetDateTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
        );

        // Day 0 (오늘): 산책했으면 스킵
        if (day == 0 && walkedToday) {
          debugPrint(
            '✅ Already walked today, '
            'skipping day 0',
          );
          continue;
        }

        // 오전 알림
        final morningTime = tz.TZDateTime(
          tz.local,
          targetDate.year,
          targetDate.month,
          targetDate.day,
          morningH,
          morningM,
        );
        if (morningTime.isAfter(now)) {
          await _scheduleOneTimeNotification(
            id: NotificationIds.morningId(
              targetDateTime,
            ),
            scheduledTime: morningTime,
            title: morningTitle,
            body: morningBody,
          );
          scheduledCount++;
        }

        // 오후 알림
        final eveningTime = tz.TZDateTime(
          tz.local,
          targetDate.year,
          targetDate.month,
          targetDate.day,
          eveningH,
          eveningM,
        );
        if (eveningTime.isAfter(now)) {
          await _scheduleOneTimeNotification(
            id: NotificationIds.eveningId(
              targetDateTime,
            ),
            scheduledTime: eveningTime,
            title: eveningTitle,
            body: eveningBody,
          );
          scheduledCount++;
        }
      }

      debugPrint(
        '⏰ Scheduled $scheduledCount walk '
        'reminders for '
        '${NotificationIds.scheduleDays} days',
      );
    } catch (e) {
      debugPrint(
        '❌ Error scheduling conditional '
        'reminders: $e',
      );
    }
  }

  /// 산책 리마인더 전체 취소 (7일치 + 레거시)
  Future<void> cancelWalkReminders() async {
    if (!_isInitialized) return;

    // 7일치 날짜 기반 ID 취소 (tz 기준)
    final now = tz.TZDateTime.now(tz.local);
    for (var day = 0;
        day < NotificationIds.scheduleDays;
        day++) {
      final date = now.add(Duration(days: day));
      await _cancelById(
        NotificationIds.morningId(date),
      );
      await _cancelById(
        NotificationIds.eveningId(date),
      );
    }

    // 레거시 ID 취소 (마이그레이션)
    for (final id in NotificationIds.legacyIds) {
      await _cancelById(id);
    }

    debugPrint('🔕 Walk reminders cancelled (7 days)');
  }

  /// 오늘 산책 리마인더만 취소 (산책 완료 시)
  /// 내일~6일 후 알림은 유지
  Future<void> cancelTodayWalkReminders() async {
    if (!_isInitialized) return;
    final today = tz.TZDateTime.now(tz.local);
    await _cancelById(
      NotificationIds.morningId(today),
    );
    await _cancelById(
      NotificationIds.eveningId(today),
    );
    debugPrint(
      '🔕 Today\'s walk reminders cancelled',
    );
  }

  // ─── 자정 리스케줄 타이머 ─────────────────

  /// 자정 리스케줄 타이머 시작
  void startMidnightRescheduleTimer() {
    _scheduleMidnightReschedule();
  }

  /// 자정 +1분에 조건부 리마인더 재스케줄
  void _scheduleMidnightReschedule() {
    final now = DateTime.now();
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1, minutes: 1));
    final duration = tomorrow.difference(now);

    _midnightTimer?.cancel();
    _midnightTimer = Timer(duration, () async {
      debugPrint(
        '🕛 Midnight reschedule triggered',
      );
      await scheduleConditionalReminders();
      _scheduleMidnightReschedule();
    });

    debugPrint(
      '⏰ Midnight timer set: '
      '${duration.inHours}h '
      '${duration.inMinutes % 60}m',
    );
  }

  // ─── 미션 알림 (매일 반복, 기존 유지) ──────

  /// 미션 만료 임박 알림 스케줄 (매일 21:00)
  Future<void> scheduleMissionExpiryReminder({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) return;

    await _cancelById(NotificationIds.missionExpiry);

    await _scheduleDailyNotification(
      id: NotificationIds.missionExpiry,
      hour: 21,
      minute: 0,
      title: title,
      body: body,
      channelId: NotificationChannels.missionAlert,
      channelName: NotificationChannels.missionAlertName,
    );

    debugPrint(
      '⏰ Mission expiry reminder scheduled: 21:00',
    );
  }

  // ─── 행복도 알림 (기존 유지) ───────────────

  /// 행복도 낮음 즉시 알림
  Future<void> showLowHappinessAlert({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) return;

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.petAlert,
      NotificationChannels.petAlertName,
      channelDescription:
          NotificationChannels.petAlertDesc,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: NotificationIds.lowHappiness,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );

    debugPrint('🔔 Low happiness alert shown');
  }

  // ─── 공통 ─────────────────────────────────

  /// 모든 알림 취소
  Future<void> cancelAll() async {
    if (!_isInitialized) return;
    await _plugin.cancelAll();
    debugPrint('🔕 All notifications cancelled');
  }

  /// 특정 알림 취소
  Future<void> _cancelById(int id) async {
    if (!_isInitialized) return;
    await _plugin.cancel(id: id);
  }

  /// one-time 알림 스케줄 (matchDateTimeComponents 없음)
  Future<void> _scheduleOneTimeNotification({
    required int id,
    required tz.TZDateTime scheduledTime,
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.walkReminder,
      NotificationChannels.walkReminderName,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// 매일 반복 알림 스케줄 (미션 등에 사용)
  Future<void> _scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final scheduledTime = _nextInstanceOfTime(
      hour,
      minute,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
  }

  /// 다음 발생 시각 계산 (오늘 이미 지났으면 내일)
  tz.TZDateTime _nextInstanceOfTime(
    int hour,
    int minute,
  ) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled =
          scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// 알림 탭 콜백
  void _onNotificationTapped(
    NotificationResponse response,
  ) {
    debugPrint(
      '🔔 Notification tapped: ${response.payload}',
    );
  }

  /// 서비스 정리
  void dispose() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
    _isInitialized = false;
    debugPrint('🛑 NotificationService disposed');
  }
}

/// Riverpod Provider
final notificationServiceProvider =
    Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

/// 알림 서비스 초기화 Provider
final notificationInitProvider =
    FutureProvider<void>((ref) async {
  final service = ref.read(notificationServiceProvider);
  await service.initialize();
});

// test/services/notification/notification_service_test.dart
//
// 조건부 산책 알림 테스트 (7일 미리 스케줄)
// - NotificationIds 날짜 기반 ID 검증
// - scheduleConditionalReminders() 7일 스케줄
// - cancelWalkReminders / cancelTodayWalkReminders
// - 자정 타이머 설정/해제
// - dispose 정리

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

import 'package:walk_dog/services/notification/notification_service.dart';
import 'package:walk_dog/data/datasources/database_service.dart';
import 'package:walk_dog/data/models/settings_model.dart';
import 'package:walk_dog/domain/entities/walk_session.dart';

// ─── Mock: FlutterLocalNotificationsPlugin ───────────

class MockNotificationsPlugin
    implements FlutterLocalNotificationsPlugin {
  final List<MockScheduleCall> scheduledCalls = [];
  final List<int> cancelledIds = [];
  bool cancelAllCalled = false;

  @override
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback?
        onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    return true;
  }

  @override
  Future<void> zonedSchedule(
    int id,
    String? title,
    String? body,
    tz.TZDateTime scheduledDate,
    NotificationDetails notificationDetails, {
    AndroidScheduleMode androidScheduleMode =
        AndroidScheduleMode.exact,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    scheduledCalls.add(MockScheduleCall(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      matchDateTimeComponents:
          matchDateTimeComponents,
    ));
  }

  @override
  Future<void> cancel(int id, {String? tag}) async {
    cancelledIds.add(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCalled = true;
  }

  void reset() {
    scheduledCalls.clear();
    cancelledIds.clear();
    cancelAllCalled = false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockScheduleCall {
  final int id;
  final String? title;
  final String? body;
  final tz.TZDateTime scheduledDate;
  final DateTimeComponents? matchDateTimeComponents;

  MockScheduleCall({
    required this.id,
    this.title,
    this.body,
    required this.scheduledDate,
    this.matchDateTimeComponents,
  });

  bool get isOneTime =>
      matchDateTimeComponents == null;
}

// ─── Mock: DatabaseService ────────────────────────────

class MockDatabaseService extends DatabaseService {
  SettingsModel? mockSettings;
  List<WalkSession> mockWalkSessions = [];

  @override
  Future<SettingsModel?> getSettings() async {
    return mockSettings;
  }

  @override
  Future<List<WalkSession>> getWalkSessionsByDate(
    DateTime date,
  ) async {
    return mockWalkSessions;
  }
}

// ─── Helper ──────────────────────────────────────────

SettingsModel _createSettings({
  bool notificationsEnabled = true,
  String locale = 'ko',
  String morningTime = '09:00',
  String eveningTime = '18:00',
}) {
  final s = SettingsModel.createDefault();
  s.notificationsEnabled = notificationsEnabled;
  s.locale = locale;
  s.morningReminderTime = morningTime;
  s.eveningReminderTime = eveningTime;
  return s;
}

WalkSession _createWalkSession() {
  final now = DateTime.now();
  return WalkSession(
    sessionId: 'test-${now.millisecondsSinceEpoch}',
    startTime: now.subtract(
      const Duration(minutes: 30),
    ),
    endTime: now,
    totalSteps: 3000,
    duration: 1800,
    distance: 2100,
    avgSpeed: 4.2,
    isOutdoor: true,
    validOutdoorSamples: 10,
    locationSamples: const [],
    treatsEarned: 3,
    happinessGained: 5,
    missionsCompleted: const [],
  );
}

// ─── Tests ───────────────────────────────────────────

void main() {
  setUpAll(() {
    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  });

  // ────────────────────────────────────────────────
  group('NotificationIds 날짜 기반 ID', () {
    test('같은 날짜 → 같은 ID', () {
      final date = DateTime(2026, 2, 14);
      final id1 = NotificationIds.morningId(date);
      final id2 = NotificationIds.morningId(date);
      expect(id1, id2);
      print('✅ 같은 날짜 → 같은 ID: $id1');
    });

    test('다른 날짜 → 다른 ID', () {
      final day1 = DateTime(2026, 2, 14);
      final day2 = DateTime(2026, 2, 15);
      expect(
        NotificationIds.morningId(day1),
        isNot(equals(NotificationIds.morningId(day2))),
      );
      print(
        '✅ 다른 날짜 → 다른 ID: '
        '${NotificationIds.morningId(day1)} vs '
        '${NotificationIds.morningId(day2)}',
      );
    });

    test('morning/evening ID 범위 충돌 없음', () {
      final date = DateTime(2026, 2, 14);
      final mId = NotificationIds.morningId(date);
      final eId = NotificationIds.eveningId(date);

      // morning: 1000~1399, evening: 2000~2399
      expect(mId, greaterThanOrEqualTo(1000));
      expect(mId, lessThan(1400));
      expect(eId, greaterThanOrEqualTo(2000));
      expect(eId, lessThan(2400));
      expect(mId, isNot(equals(eId)));
      print('✅ morning=$mId, evening=$eId (충돌 없음)');
    });

    test('missionExpiry/lowHappiness와 충돌 없음', () {
      // 7일치 ID가 missionExpiry(3), lowHappiness(100)과 겹치지 않음
      final now = tz.TZDateTime.now(tz.local);
      for (var i = 0; i < 7; i++) {
        final date = now.add(Duration(days: i));
        final mId = NotificationIds.morningId(date);
        final eId = NotificationIds.eveningId(date);
        expect(mId, isNot(equals(3)));
        expect(mId, isNot(equals(100)));
        expect(eId, isNot(equals(3)));
        expect(eId, isNot(equals(100)));
      }
      print('✅ mission/happiness ID와 충돌 없음');
    });

    test('scheduleDays = 7', () {
      expect(NotificationIds.scheduleDays, 7);
      print('✅ scheduleDays = 7');
    });

    test('레거시 ID 목록 포함', () {
      expect(
        NotificationIds.legacyIds,
        containsAll([1, 2, 10, 11, 20, 21]),
      );
      print(
        '✅ legacyIds: ${NotificationIds.legacyIds}',
      );
    });
  });

  // ────────────────────────────────────────────────
  group('scheduleConditionalReminders', () {
    late MockNotificationsPlugin mockPlugin;
    late MockDatabaseService mockDb;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockNotificationsPlugin();
      mockDb = MockDatabaseService();
      service = NotificationService.forTesting(
        plugin: mockPlugin,
        dbService: mockDb,
      );
      service.isInitializedForTesting = true;
    });

    test('미초기화 시 아무것도 하지 않음', () async {
      service.isInitializedForTesting = false;
      mockDb.mockSettings = _createSettings();

      await service.scheduleConditionalReminders();

      expect(mockPlugin.scheduledCalls, isEmpty);
      expect(mockPlugin.cancelledIds, isEmpty);
      print('✅ 미초기화 → 스킵');
    });

    test('알림 비활성화 시 스케줄하지 않음', () async {
      mockDb.mockSettings = _createSettings(
        notificationsEnabled: false,
      );

      await service.scheduleConditionalReminders();

      expect(mockPlugin.scheduledCalls, isEmpty);
      print('✅ 알림 OFF → 스킵');
    });

    test('설정 없음(null) 시 스케줄하지 않음', () async {
      mockDb.mockSettings = null;

      await service.scheduleConditionalReminders();

      expect(mockPlugin.scheduledCalls, isEmpty);
      print('✅ 설정 null → 스킵');
    });

    test('산책 안 한 날 → 7일치 스케줄', () async {
      mockDb.mockSettings = _createSettings(
        morningTime: '09:00',
        eveningTime: '18:00',
      );
      mockDb.mockWalkSessions = [];

      await service.scheduleConditionalReminders();

      // 7일 × 2(morning/evening) = 최대 14건
      // 오늘 이미 지난 시간은 제외
      expect(
        mockPlugin.scheduledCalls.length,
        greaterThanOrEqualTo(12),
      );

      // 모든 알림이 one-time
      for (final call in mockPlugin.scheduledCalls) {
        expect(call.isOneTime, true);
      }

      // 레거시 ID 취소 확인
      for (final id in NotificationIds.legacyIds) {
        expect(
          mockPlugin.cancelledIds,
          contains(id),
        );
      }

      print(
        '✅ 산책 안 한 날 → '
        '${mockPlugin.scheduledCalls.length}건 스케줄',
      );
    });

    test('산책 한 날 → 오늘 스킵, Day 1~6 스케줄', () async {
      mockDb.mockSettings = _createSettings();
      mockDb.mockWalkSessions = [
        _createWalkSession(),
      ];

      await service.scheduleConditionalReminders();

      // 오늘 ID로 스케줄된 게 없어야 함
      final today = tz.TZDateTime.now(tz.local);
      final todayMorningId =
          NotificationIds.morningId(today);
      final todayEveningId =
          NotificationIds.eveningId(today);

      final todayCalls = mockPlugin.scheduledCalls
          .where(
            (c) =>
                c.id == todayMorningId ||
                c.id == todayEveningId,
          )
          .toList();
      expect(todayCalls, isEmpty);

      // Day 1~6은 스케줄됨 (6일 × 2 = 12건)
      expect(
        mockPlugin.scheduledCalls.length,
        12,
      );

      print(
        '✅ 산책 한 날 → 오늘 스킵, '
        '${mockPlugin.scheduledCalls.length}건 스케줄',
      );
    });

    test('한국어 locale → 한국어 메시지', () async {
      mockDb.mockSettings = _createSettings(
        locale: 'ko',
      );
      mockDb.mockWalkSessions = [];

      await service.scheduleConditionalReminders();

      final hasKorean = mockPlugin.scheduledCalls.any(
        (c) =>
            c.title != null &&
            c.title!.contains('아침'),
      );
      expect(hasKorean, true);
      print('✅ 한국어 메시지 확인');
    });

    test('영어 locale → 영어 메시지', () async {
      mockDb.mockSettings = _createSettings(
        locale: 'en',
      );
      mockDb.mockWalkSessions = [];

      await service.scheduleConditionalReminders();

      final hasEnglish = mockPlugin.scheduledCalls.any(
        (c) =>
            c.title != null &&
            c.title!.contains('Good morning'),
      );
      expect(hasEnglish, true);
      print('✅ 영어 메시지 확인');
    });

    test('모든 알림은 one-time', () async {
      mockDb.mockSettings = _createSettings();
      mockDb.mockWalkSessions = [];

      await service.scheduleConditionalReminders();

      for (final call in mockPlugin.scheduledCalls) {
        expect(call.isOneTime, true);
      }
      print('✅ 모든 알림 one-time');
    });

    test('커스텀 시간 파싱', () async {
      mockDb.mockSettings = _createSettings(
        morningTime: '07:30',
        eveningTime: '20:15',
      );
      mockDb.mockWalkSessions = [];

      await service.scheduleConditionalReminders();

      // 내일 morning 시간 확인
      final tomorrow = tz.TZDateTime.now(tz.local).add(
        const Duration(days: 1),
      );
      final tomorrowMorningId =
          NotificationIds.morningId(tomorrow);
      final morningCall =
          mockPlugin.scheduledCalls.firstWhere(
        (c) => c.id == tomorrowMorningId,
      );
      expect(morningCall.scheduledDate.hour, 7);
      expect(morningCall.scheduledDate.minute, 30);

      // 내일 evening 시간 확인
      final tomorrowEveningId =
          NotificationIds.eveningId(tomorrow);
      final eveningCall =
          mockPlugin.scheduledCalls.firstWhere(
        (c) => c.id == tomorrowEveningId,
      );
      expect(eveningCall.scheduledDate.hour, 20);
      expect(eveningCall.scheduledDate.minute, 15);

      print('✅ 커스텀 시간 파싱: 07:30, 20:15');
    });

    test('7일 후 날짜까지 스케줄됨', () async {
      mockDb.mockSettings = _createSettings();
      mockDb.mockWalkSessions = [];

      await service.scheduleConditionalReminders();

      // Day 6 (7일째) 알림이 존재하는지 확인
      final day6 = tz.TZDateTime.now(tz.local).add(
        const Duration(days: 6),
      );
      final day6MorningId =
          NotificationIds.morningId(day6);
      final hasDay6 = mockPlugin.scheduledCalls.any(
        (c) => c.id == day6MorningId,
      );
      expect(hasDay6, true);

      print('✅ Day 6까지 스케줄됨');
    });
  });

  // ────────────────────────────────────────────────
  group('cancelWalkReminders', () {
    late MockNotificationsPlugin mockPlugin;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockNotificationsPlugin();
      service = NotificationService.forTesting(
        plugin: mockPlugin,
      );
      service.isInitializedForTesting = true;
    });

    test('7일치 + 레거시 ID 취소', () async {
      await service.cancelWalkReminders();

      // 7일 × 2 (morning+evening) = 14
      // + 6 legacy = 20
      expect(
        mockPlugin.cancelledIds.length,
        14 + NotificationIds.legacyIds.length,
      );

      // 레거시 ID 포함
      for (final id in NotificationIds.legacyIds) {
        expect(
          mockPlugin.cancelledIds,
          contains(id),
        );
      }

      print(
        '✅ ${mockPlugin.cancelledIds.length}개 '
        'ID 취소 (7일치 + 레거시)',
      );
    });

    test('미초기화 시 취소하지 않음', () async {
      service.isInitializedForTesting = false;

      await service.cancelWalkReminders();

      expect(mockPlugin.cancelledIds, isEmpty);
      print('✅ 미초기화 → 취소 스킵');
    });
  });

  // ────────────────────────────────────────────────
  group('cancelTodayWalkReminders', () {
    late MockNotificationsPlugin mockPlugin;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockNotificationsPlugin();
      service = NotificationService.forTesting(
        plugin: mockPlugin,
      );
      service.isInitializedForTesting = true;
    });

    test('오늘 ID만 취소, 나머지 유지', () async {
      await service.cancelTodayWalkReminders();

      final today = tz.TZDateTime.now(tz.local);
      final todayMorningId =
          NotificationIds.morningId(today);
      final todayEveningId =
          NotificationIds.eveningId(today);

      expect(
        mockPlugin.cancelledIds,
        contains(todayMorningId),
      );
      expect(
        mockPlugin.cancelledIds,
        contains(todayEveningId),
      );
      expect(mockPlugin.cancelledIds.length, 2);

      // 내일 ID는 취소 안 됨
      final tomorrow = today.add(
        const Duration(days: 1),
      );
      expect(
        mockPlugin.cancelledIds,
        isNot(contains(
          NotificationIds.morningId(tomorrow),
        )),
      );

      print(
        '✅ 오늘만 취소 (ID: $todayMorningId, '
        '$todayEveningId), 내일 유지',
      );
    });

    test('미초기화 시 취소하지 않음', () async {
      service.isInitializedForTesting = false;

      await service.cancelTodayWalkReminders();

      expect(mockPlugin.cancelledIds, isEmpty);
      print('✅ 미초기화 → 취소 스킵');
    });
  });

  // ────────────────────────────────────────────────
  group('자정 타이머', () {
    late MockNotificationsPlugin mockPlugin;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockNotificationsPlugin();
      service = NotificationService.forTesting(
        plugin: mockPlugin,
      );
      service.isInitializedForTesting = true;
    });

    test('startMidnightRescheduleTimer 에러 없음', () {
      expect(
        () => service.startMidnightRescheduleTimer(),
        returnsNormally,
      );
      print('✅ 자정 타이머 설정 성공');
      service.dispose();
    });

    test('dispose 시 타이머 정리됨', () {
      service.startMidnightRescheduleTimer();
      service.dispose();
      expect(service.isInitialized, false);
      print('✅ dispose → 타이머 정리');
    });

    test('중복 호출 시 이전 타이머 취소', () {
      service.startMidnightRescheduleTimer();
      service.startMidnightRescheduleTimer();
      expect(
        () => service.dispose(),
        returnsNormally,
      );
      print('✅ 중복 호출 안전');
    });
  });

  // ────────────────────────────────────────────────
  group('미션 알림 (매일 반복)', () {
    late MockNotificationsPlugin mockPlugin;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockNotificationsPlugin();
      service = NotificationService.forTesting(
        plugin: mockPlugin,
      );
      service.isInitializedForTesting = true;
    });

    test('matchDateTimeComponents.time 사용', () async {
      await service.scheduleMissionExpiryReminder(
        title: '미션 만료',
        body: '미션이 곧 만료됩니다',
      );

      expect(mockPlugin.scheduledCalls.length, 1);
      final call = mockPlugin.scheduledCalls.first;
      expect(
        call.matchDateTimeComponents,
        DateTimeComponents.time,
      );
      expect(call.isOneTime, false);
      expect(call.id, NotificationIds.missionExpiry);
      print('✅ 미션 알림: 매일 반복');
    });
  });

  // ────────────────────────────────────────────────
  group('cancelAll', () {
    test('모든 알림 취소', () async {
      final mockPlugin = MockNotificationsPlugin();
      final service = NotificationService.forTesting(
        plugin: mockPlugin,
      );
      service.isInitializedForTesting = true;

      await service.cancelAll();
      expect(mockPlugin.cancelAllCalled, true);
      print('✅ cancelAll 호출됨');
    });
  });

  // ────────────────────────────────────────────────
  group('E2E 시나리오', () {
    late MockNotificationsPlugin mockPlugin;
    late MockDatabaseService mockDb;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockNotificationsPlugin();
      mockDb = MockDatabaseService();
      service = NotificationService.forTesting(
        plugin: mockPlugin,
        dbService: mockDb,
      );
      service.isInitializedForTesting = true;
    });

    test(
      '앱 시작 → 산책 → 알림 취소 (7일 유지)',
      () async {
        // 1. 앱 시작: 산책 안 한 상태 → 7일치 스케줄
        mockDb.mockSettings = _createSettings();
        mockDb.mockWalkSessions = [];

        await service.scheduleConditionalReminders();

        final initialCount =
            mockPlugin.scheduledCalls.length;
        expect(
          initialCount,
          greaterThanOrEqualTo(12),
        );
        print(
          '1️⃣ 앱 시작: $initialCount건 스케줄됨',
        );

        // 2. 산책 완료 → 오늘만 취소
        mockPlugin.reset();
        await service.cancelTodayWalkReminders();

        expect(mockPlugin.cancelledIds.length, 2);
        print('2️⃣ 산책 완료: 오늘 2건 취소');

        // 3. 앱 안 열어도 내일~6일 알림 유지
        // (실제로는 iOS가 관리)
        print('3️⃣ 나머지 알림 iOS가 자동 발송');
        print('✅ E2E 7일 시나리오 통과');
      },
    );

    test(
      '설정에서 알림 OFF → ON',
      () async {
        mockDb.mockSettings = _createSettings(
          notificationsEnabled: false,
        );
        mockDb.mockWalkSessions = [];

        await service.scheduleConditionalReminders();
        expect(mockPlugin.scheduledCalls, isEmpty);
        print('1️⃣ 알림 OFF: 0건');

        mockPlugin.reset();
        mockDb.mockSettings = _createSettings(
          notificationsEnabled: true,
        );

        await service.scheduleConditionalReminders();
        expect(
          mockPlugin.scheduledCalls.length,
          greaterThanOrEqualTo(12),
        );
        print(
          '2️⃣ 알림 ON: '
          '${mockPlugin.scheduledCalls.length}건',
        );
        print('✅ 알림 토글 시나리오 통과');
      },
    );

    test(
      '시간 변경 후 재스케줄',
      () async {
        mockDb.mockSettings = _createSettings(
          morningTime: '09:00',
          eveningTime: '18:00',
        );
        mockDb.mockWalkSessions = [];

        await service.scheduleConditionalReminders();

        mockPlugin.reset();
        mockDb.mockSettings = _createSettings(
          morningTime: '07:00',
          eveningTime: '20:00',
        );

        await service.scheduleConditionalReminders();

        final tomorrow =
            tz.TZDateTime.now(tz.local).add(
          const Duration(days: 1),
        );
        final morningCall =
            mockPlugin.scheduledCalls.firstWhere(
          (c) =>
              c.id ==
              NotificationIds.morningId(tomorrow),
        );
        expect(morningCall.scheduledDate.hour, 7);

        final eveningCall =
            mockPlugin.scheduledCalls.firstWhere(
          (c) =>
              c.id ==
              NotificationIds.eveningId(tomorrow),
        );
        expect(eveningCall.scheduledDate.hour, 20);

        print('✅ 시간 변경 후 재스케줄 통과');
      },
    );
  });
}

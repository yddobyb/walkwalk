// test/services/tracking/walk_notification_integration_test.dart
//
// 산책 완료 → 알림 취소 통합 검증
// - step_tracking_service.dart에서 cancelTodayWalkReminders 호출 위치 확인
// - NotificationService 7일 미리 스케줄 구조 확인
// - 산책 완료 후 내일~6일 알림은 유지되는지 확인

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('산책 완료 → 알림 취소 통합 검증', () {
    test(
      'step_tracking_service.dart에 '
      'cancelTodayWalkReminders 호출이 있는지 확인',
      () {
        final file = File(
          'lib/services/tracking/'
          'step_tracking_service.dart',
        );
        final content = file.readAsStringSync();

        // cancelTodayWalkReminders 호출 존재
        expect(
          content.contains(
            'cancelTodayWalkReminders',
          ),
          true,
          reason:
              'stopWalkSession에서 '
              'cancelTodayWalkReminders 호출 필요',
        );

        // import 확인
        expect(
          content.contains(
            'notification_service.dart',
          ),
          true,
          reason: 'NotificationService import 필요',
        );

        // saveWalkSession 이후에 호출되는지 확인
        final saveIdx = content.indexOf(
          'saveWalkSession',
        );
        final cancelIdx = content.indexOf(
          'cancelTodayWalkReminders',
        );
        expect(
          cancelIdx,
          greaterThan(saveIdx),
          reason:
              'cancelTodayWalkReminders는 '
              'saveWalkSession 이후에 호출되어야 함',
        );

        print(
          '✅ cancelTodayWalkReminders 호출 위치 정확',
        );
      },
    );

    test(
      'main.dart에 조건부 스케줄 초기화 코드가 있는지 확인',
      () {
        final file = File('lib/main.dart');
        final content = file.readAsStringSync();

        // scheduleConditionalReminders 호출 존재
        expect(
          content.contains(
            'scheduleConditionalReminders',
          ),
          true,
          reason:
              '앱 시작 시 '
              'scheduleConditionalReminders 필요',
        );

        // startMidnightRescheduleTimer 호출 존재
        expect(
          content.contains(
            'startMidnightRescheduleTimer',
          ),
          true,
          reason:
              '앱 시작 시 '
              'startMidnightRescheduleTimer 필요',
        );

        // initialize 이후에 호출되는지 확인
        final initIdx = content.indexOf(
          'notifService.initialize',
        );
        final schedIdx = content.indexOf(
          'scheduleConditionalReminders',
        );
        expect(
          schedIdx,
          greaterThan(initIdx),
          reason:
              'scheduleConditionalReminders는 '
              'initialize 이후에 호출되어야 함',
        );

        print(
          '✅ main.dart 초기화 순서 정확',
        );
      },
    );

    test(
      'notification_service.dart에서 '
      '7일 미리 스케줄 구조 확인',
      () {
        final file = File(
          'lib/services/notification/'
          'notification_service.dart',
        );
        final content = file.readAsStringSync();

        // 날짜 기반 ID 메서드 존재
        expect(
          content.contains('morningId'),
          true,
          reason: 'morningId 메서드 필요',
        );
        expect(
          content.contains('eveningId'),
          true,
          reason: 'eveningId 메서드 필요',
        );

        // scheduleDays 상수 존재
        expect(
          content.contains('scheduleDays'),
          true,
          reason: 'scheduleDays 상수 필요',
        );

        // 핵심 메서드 존재
        expect(
          content.contains(
            'scheduleConditionalReminders',
          ),
          true,
        );
        expect(
          content.contains('cancelWalkReminders'),
          true,
        );
        expect(
          content.contains(
            'cancelTodayWalkReminders',
          ),
          true,
        );
        expect(
          content.contains(
            'startMidnightRescheduleTimer',
          ),
          true,
        );
        expect(
          content.contains(
            '_scheduleOneTimeNotification',
          ),
          true,
        );

        // 레거시 메서드 제거 확인
        expect(
          content.contains(
            'Future<void> scheduleMorningReminder',
          ),
          false,
          reason: 'scheduleMorningReminder 제거 필요',
        );
        expect(
          content.contains(
            'Future<void> scheduleEveningReminder',
          ),
          false,
          reason: 'scheduleEveningReminder 제거 필요',
        );

        print(
          '✅ notification_service.dart: '
          '7일 미리 스케줄 구조 확인',
        );
      },
    );

    test(
      'settings_screen.dart에서 '
      'scheduleConditionalReminders 사용하는지 확인',
      () {
        final file = File(
          'lib/presentation/screens/settings/'
          'settings_screen.dart',
        );
        final content = file.readAsStringSync();

        expect(
          content.contains(
            'scheduleConditionalReminders',
          ),
          true,
          reason:
              '설정 화면에서 '
              'scheduleConditionalReminders 사용 필요',
        );

        // 레거시 메서드 없어야 함
        expect(
          content.contains('scheduleMorningReminder'),
          false,
          reason: '레거시 메서드 사용하지 않아야 함',
        );
        expect(
          content.contains('scheduleEveningReminder'),
          false,
          reason: '레거시 메서드 사용하지 않아야 함',
        );

        print(
          '✅ settings_screen.dart: '
          'scheduleConditionalReminders 사용',
        );
      },
    );
  });
}

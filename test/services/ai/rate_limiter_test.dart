// test/services/ai/rate_limiter_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk_dog/services/ai/rate_limiter.dart';

/// Week 3 Test 2: RateLimiter 테스트
///
/// 테스트 항목:
/// 1. 일일 카운트 증가 테스트
/// 2. 시간당 카운트 증가 테스트
/// 3. 자동 일일 리셋 테스트
/// 4. 자동 시간당 리셋 테스트
/// 5. canMakeRequest() 통합 테스트
/// 6. 남은 할당량 조회 테스트
/// 7. 다음 리셋까지 시간 계산 테스트
/// 8. 상태 조회 테스트
/// 9. 수동 리셋 테스트
/// 10. 엣지 케이스 (첫 실행, 제한 경계값)
void main() {
  late RateLimiter rateLimiter;

  setUp(() async {
    // SharedPreferences mock 초기화
    SharedPreferences.setMockInitialValues({});
    rateLimiter = RateLimiter();
  });

  tearDown(() async {
    // 각 테스트 후 리셋
    await rateLimiter.reset();
  });

  group('RateLimiter Tests', () {
    // ==========================================================================
    // 1. 일일 카운트 증가 테스트
    // ==========================================================================
    test('incrementDailyCount - 첫 호출 성공', () async {
      // Given: 빈 SharedPreferences

      // When: 일일 카운트 증가
      final success = await rateLimiter.incrementDailyCount();

      // Then: 성공 (제한 내)
      expect(success, true);

      print('✅ incrementDailyCount 첫 호출 성공 확인 완료');
    });

    test('incrementDailyCount - 80회 제한 도달', () async {
      // Given: 79회 호출 완료
      for (int i = 0; i < 79; i++) {
        await rateLimiter.incrementDailyCount();
      }

      // When: 80번째 호출
      final success80 = await rateLimiter.incrementDailyCount();

      // Then: 80번째 성공
      expect(success80, true);

      // When: 81번째 호출
      final success81 = await rateLimiter.incrementDailyCount();

      // Then: 81번째 실패 (제한 초과)
      expect(success81, false);

      print('✅ incrementDailyCount 80회 제한 확인 완료');
      print('   - 80번째: 성공');
      print('   - 81번째: 실패 (제한 초과)');
    });

    test('incrementDailyCount - 연속 호출 카운트 증가', () async {
      // Given: 빈 상태

      // When: 5회 연속 호출
      for (int i = 0; i < 5; i++) {
        await rateLimiter.incrementDailyCount();
      }

      // Then: 남은 할당량 확인 (80 - 5 = 75)
      final remaining = await rateLimiter.getRemainingDailyQuota();
      expect(remaining, 75);

      print('✅ incrementDailyCount 연속 호출 카운트 증가 확인 완료');
      print('   - 5회 호출 후 남은 할당량: $remaining');
    });

    // ==========================================================================
    // 2. 시간당 카운트 증가 테스트
    // ==========================================================================
    test('incrementHourlyCount - 첫 호출 성공', () async {
      // Given: 빈 SharedPreferences

      // When: 시간당 카운트 증가
      final success = await rateLimiter.incrementHourlyCount();

      // Then: 성공 (제한 내)
      expect(success, true);

      print('✅ incrementHourlyCount 첫 호출 성공 확인 완료');
    });

    test('incrementHourlyCount - 20회 제한 도달', () async {
      // Given: 19회 호출 완료
      for (int i = 0; i < 19; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // When: 20번째 호출
      final success20 = await rateLimiter.incrementHourlyCount();

      // Then: 20번째 성공
      expect(success20, true);

      // When: 21번째 호출
      final success21 = await rateLimiter.incrementHourlyCount();

      // Then: 21번째 실패 (제한 초과)
      expect(success21, false);

      print('✅ incrementHourlyCount 20회 제한 확인 완료');
      print('   - 20번째: 성공');
      print('   - 21번째: 실패 (제한 초과)');
    });

    test('incrementHourlyCount - 연속 호출 카운트 증가', () async {
      // Given: 빈 상태

      // When: 3회 연속 호출
      for (int i = 0; i < 3; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // Then: 남은 할당량 확인 (20 - 3 = 17)
      final remaining = await rateLimiter.getRemainingHourlyQuota();
      expect(remaining, 17);

      print('✅ incrementHourlyCount 연속 호출 카운트 증가 확인 완료');
      print('   - 3회 호출 후 남은 할당량: $remaining');
    });

    // ==========================================================================
    // 3. 자동 일일 리셋 테스트 (날짜 변경 시뮬레이션)
    // ==========================================================================
    test('일일 카운트 자동 리셋 - 날짜 변경 시뮬레이션', () async {
      // Given: 오늘 10회 호출
      for (int i = 0; i < 10; i++) {
        await rateLimiter.incrementDailyCount();
      }

      // Then: 남은 할당량 확인 (70)
      var remaining = await rateLimiter.getRemainingDailyQuota();
      expect(remaining, 70);

      // When: SharedPreferences의 날짜 키를 수동으로 어제로 변경 (리셋 시뮬레이션)
      final prefs = await SharedPreferences.getInstance();
      final yesterday =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
      await prefs.setString('llm_daily_reset_date', yesterday);

      // When: 새로운 날짜에 incrementDailyCount 호출
      final success = await rateLimiter.incrementDailyCount();

      // Then: 성공 (자동 리셋됨)
      expect(success, true);

      // Then: 남은 할당량 확인 (80 - 1 = 79)
      remaining = await rateLimiter.getRemainingDailyQuota();
      expect(remaining, 79);

      print('✅ 일일 카운트 자동 리셋 확인 완료');
      print('   - 어제 10회 호출 → 오늘 자동 리셋 → 79/80 남음');
    });

    // ==========================================================================
    // 4. 자동 시간당 리셋 테스트 (시간 변경 시뮬레이션)
    // ==========================================================================
    test('시간당 카운트 자동 리셋 - 시간 변경 시뮬레이션', () async {
      // Given: 현재 시간에 5회 호출
      for (int i = 0; i < 5; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // Then: 남은 할당량 확인 (15)
      var remaining = await rateLimiter.getRemainingHourlyQuota();
      expect(remaining, 15);

      // When: SharedPreferences의 시간 키를 수동으로 이전 시간으로 변경 (리셋 시뮬레이션)
      final prefs = await SharedPreferences.getInstance();
      final lastHour =
          DateTime.now().subtract(const Duration(hours: 1)).toIso8601String().substring(0, 13);
      await prefs.setString('llm_hourly_reset_time', lastHour);

      // When: 새로운 시간에 incrementHourlyCount 호출
      final success = await rateLimiter.incrementHourlyCount();

      // Then: 성공 (자동 리셋됨)
      expect(success, true);

      // Then: 남은 할당량 확인 (20 - 1 = 19)
      remaining = await rateLimiter.getRemainingHourlyQuota();
      expect(remaining, 19);

      print('✅ 시간당 카운트 자동 리셋 확인 완료');
      print('   - 이전 시간 5회 호출 → 현재 시간 자동 리셋 → 19/20 남음');
    });

    // ==========================================================================
    // 5. canMakeRequest() 통합 테스트
    // ==========================================================================
    test('canMakeRequest - 일일 + 시간당 제한 모두 확인', () async {
      // Given: 빈 상태

      // When: 첫 호출
      var canMake = await rateLimiter.canMakeRequest();

      // Then: 가능
      expect(canMake, true);

      // When: 일일 80회 도달
      for (int i = 0; i < 80; i++) {
        await rateLimiter.incrementDailyCount();
      }

      // Then: 일일 제한 초과 → 불가능
      canMake = await rateLimiter.canMakeRequest();
      expect(canMake, false);

      print('✅ canMakeRequest 일일 제한 확인 완료');
      print('   - 80회 도달 후: 호출 불가능');
    });

    test('canMakeRequest - 시간당 제한 우선 확인', () async {
      // Given: 시간당 20회 도달
      for (int i = 0; i < 20; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // When: canMakeRequest 확인
      final canMake = await rateLimiter.canMakeRequest();

      // Then: 시간당 제한 초과 → 불가능
      expect(canMake, false);

      print('✅ canMakeRequest 시간당 제한 확인 완료');
      print('   - 20회 도달 후: 호출 불가능');
    });

    // ==========================================================================
    // 6. 남은 할당량 조회 테스트
    // ==========================================================================
    test('getRemainingDailyQuota - 정확한 남은 할당량', () async {
      // Given: 25회 호출
      for (int i = 0; i < 25; i++) {
        await rateLimiter.incrementDailyCount();
      }

      // When: 남은 할당량 조회
      final remaining = await rateLimiter.getRemainingDailyQuota();

      // Then: 55 (80 - 25)
      expect(remaining, 55);

      print('✅ getRemainingDailyQuota 정확성 확인 완료');
      print('   - 25회 호출 후 남은 할당량: $remaining');
    });

    test('getRemainingHourlyQuota - 정확한 남은 할당량', () async {
      // Given: 7회 호출
      for (int i = 0; i < 7; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // When: 남은 할당량 조회
      final remaining = await rateLimiter.getRemainingHourlyQuota();

      // Then: 13 (20 - 7)
      expect(remaining, 13);

      print('✅ getRemainingHourlyQuota 정확성 확인 완료');
      print('   - 7회 호출 후 남은 할당량: $remaining');
    });

    // ==========================================================================
    // 7. 다음 리셋까지 시간 계산 테스트
    // ==========================================================================
    test('getSecondsUntilDailyReset - 남은 시간 계산', () {
      // When: 다음 일일 리셋까지 시간 계산
      final seconds = rateLimiter.getSecondsUntilDailyReset();

      // Then: 0 < seconds <= 86400 (24시간)
      expect(seconds, greaterThan(0));
      expect(seconds, lessThanOrEqualTo(86400));

      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();

      print('✅ getSecondsUntilDailyReset 계산 확인 완료');
      print('   - 다음 리셋까지: ${hours}시간 ${minutes}분');
    });

    test('getSecondsUntilHourlyReset - 남은 시간 계산', () {
      // When: 다음 시간당 리셋까지 시간 계산
      final seconds = rateLimiter.getSecondsUntilHourlyReset();

      // Then: 0 < seconds <= 3600 (1시간)
      expect(seconds, greaterThan(0));
      expect(seconds, lessThanOrEqualTo(3600));

      final minutes = (seconds / 60).floor();

      print('✅ getSecondsUntilHourlyReset 계산 확인 완료');
      print('   - 다음 리셋까지: ${minutes}분');
    });

    // ==========================================================================
    // 8. 상태 조회 테스트
    // ==========================================================================
    test('getStatus - 전체 상태 조회', () async {
      // Given: 10회 일일 호출, 3회 시간당 호출
      for (int i = 0; i < 10; i++) {
        await rateLimiter.incrementDailyCount();
      }
      for (int i = 0; i < 3; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // When: 상태 조회
      final status = await rateLimiter.getStatus();

      // Then: 올바른 구조 및 값
      expect(status['dailyRemaining'], 70);
      expect(status['dailyLimit'], 80);
      expect(status['hourlyRemaining'], 17);
      expect(status['hourlyLimit'], 20);
      expect(status['secondsUntilDailyReset'], greaterThan(0));
      expect(status['secondsUntilHourlyReset'], greaterThan(0));

      print('✅ getStatus 전체 상태 조회 확인 완료');
      print('   - dailyRemaining: ${status['dailyRemaining']}');
      print('   - hourlyRemaining: ${status['hourlyRemaining']}');
      print('   - secondsUntilDailyReset: ${status['secondsUntilDailyReset']}');
      print('   - secondsUntilHourlyReset: ${status['secondsUntilHourlyReset']}');
    });

    // ==========================================================================
    // 9. 수동 리셋 테스트
    // ==========================================================================
    test('reset - 수동 리셋 후 모든 카운트 초기화', () async {
      // Given: 50회 일일 호출, 10회 시간당 호출
      for (int i = 0; i < 50; i++) {
        await rateLimiter.incrementDailyCount();
      }
      for (int i = 0; i < 10; i++) {
        await rateLimiter.incrementHourlyCount();
      }

      // When: 수동 리셋
      await rateLimiter.reset();

      // Then: 모든 할당량 전체로 복구
      final dailyRemaining = await rateLimiter.getRemainingDailyQuota();
      final hourlyRemaining = await rateLimiter.getRemainingHourlyQuota();

      expect(dailyRemaining, 80);
      expect(hourlyRemaining, 20);

      print('✅ reset 수동 리셋 확인 완료');
      print('   - 리셋 후 dailyRemaining: $dailyRemaining');
      print('   - 리셋 후 hourlyRemaining: $hourlyRemaining');
    });

    // ==========================================================================
    // 10. 엣지 케이스 - 첫 실행 시 (데이터 없음)
    // ==========================================================================
    test('첫 실행 시 - 데이터 없음, 정상 동작', () async {
      // Given: 빈 SharedPreferences (setUp에서 이미 설정됨)

      // When: canMakeRequest 확인
      final canMake = await rateLimiter.canMakeRequest();

      // Then: 가능
      expect(canMake, true);

      // When: 할당량 조회
      final dailyRemaining = await rateLimiter.getRemainingDailyQuota();
      final hourlyRemaining = await rateLimiter.getRemainingHourlyQuota();

      // Then: 전체 할당량
      expect(dailyRemaining, 80);
      expect(hourlyRemaining, 20);

      print('✅ 첫 실행 시 정상 동작 확인 완료');
      print('   - canMakeRequest: $canMake');
      print('   - dailyRemaining: $dailyRemaining');
      print('   - hourlyRemaining: $hourlyRemaining');
    });

    // ==========================================================================
    // 11. 엣지 케이스 - 제한 경계값 (79, 80, 81)
    // ==========================================================================
    test('제한 경계값 - 79, 80, 81회 테스트', () async {
      // Given: 79회 호출
      for (int i = 0; i < 79; i++) {
        await rateLimiter.incrementDailyCount();
      }

      // When: 79회 후 상태 확인
      var canMake = await rateLimiter.canMakeRequest();
      var remaining = await rateLimiter.getRemainingDailyQuota();

      // Then: 아직 가능, 1개 남음
      expect(canMake, true);
      expect(remaining, 1);

      // When: 80번째 호출
      await rateLimiter.incrementDailyCount();

      // When: 80회 후 상태 확인
      canMake = await rateLimiter.canMakeRequest();
      remaining = await rateLimiter.getRemainingDailyQuota();

      // Then: 불가능, 0개 남음
      expect(canMake, false);
      expect(remaining, 0);

      // When: 81번째 호출 시도
      final success = await rateLimiter.incrementDailyCount();

      // Then: 실패
      expect(success, false);

      print('✅ 제한 경계값 테스트 확인 완료');
      print('   - 79회: canMake=true, remaining=1');
      print('   - 80회: canMake=false, remaining=0');
      print('   - 81회: 증가 실패');
    });
  });
}

// lib/services/ai/rate_limiter.dart

import 'package:shared_preferences/shared_preferences.dart';

/// API 레이트 리밋 관리 서비스
///
/// Week 3 Phase 5: OpenRouter API 무료 tier 제한 관리
/// - 일일 제한: 80회 (100회 중 20% 여유)
/// - 시간당 제한: 20회
/// - SharedPreferences로 영구 저장
/// - 매일 자정 자동 리셋
class RateLimiter {
  static const String _dailyCountKey = 'llm_daily_count';
  static const String _dailyResetDateKey = 'llm_daily_reset_date';
  static const String _hourlyCountKey = 'llm_hourly_count';
  static const String _hourlyResetTimeKey = 'llm_hourly_reset_time';

  static const int dailyLimit = 80; // 일일 80회 제한 (100회 중 80% 사용)
  static const int hourlyLimit = 20; // 시간당 20회 제한

  /// 일일 카운트 증가
  ///
  /// Returns: true = 제한 내, false = 제한 초과
  Future<bool> incrementDailyCount() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. 날짜 확인 및 리셋
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    final lastResetDate = prefs.getString(_dailyResetDateKey);

    if (lastResetDate != today) {
      // 날짜가 바뀌었으면 카운트 리셋
      await prefs.setInt(_dailyCountKey, 0);
      await prefs.setString(_dailyResetDateKey, today);
    }

    // 2. 현재 카운트 확인
    final currentCount = prefs.getInt(_dailyCountKey) ?? 0;

    if (currentCount >= dailyLimit) {
      return false; // 제한 초과
    }

    // 3. 카운트 증가
    await prefs.setInt(_dailyCountKey, currentCount + 1);
    return true; // 제한 내
  }

  /// 시간당 카운트 증가
  ///
  /// Returns: true = 제한 내, false = 제한 초과
  Future<bool> incrementHourlyCount() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. 시간 확인 및 리셋
    final now = DateTime.now();
    final currentHour = now.toIso8601String().substring(0, 13); // YYYY-MM-DDTHH
    final lastResetHour = prefs.getString(_hourlyResetTimeKey);

    if (lastResetHour != currentHour) {
      // 시간이 바뀌었으면 카운트 리셋
      await prefs.setInt(_hourlyCountKey, 0);
      await prefs.setString(_hourlyResetTimeKey, currentHour);
    }

    // 2. 현재 카운트 확인
    final currentCount = prefs.getInt(_hourlyCountKey) ?? 0;

    if (currentCount >= hourlyLimit) {
      return false; // 제한 초과
    }

    // 3. 카운트 증가
    await prefs.setInt(_hourlyCountKey, currentCount + 1);
    return true; // 제한 내
  }

  /// API 호출 가능 여부 확인 (일일 + 시간당)
  ///
  /// Returns: true = 호출 가능, false = 제한 초과
  Future<bool> canMakeRequest() async {
    final dailyOk = await _checkDailyLimit();
    final hourlyOk = await _checkHourlyLimit();

    return dailyOk && hourlyOk;
  }

  /// 일일 제한 확인 (카운트 증가 없이)
  Future<bool> _checkDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();

    // 날짜 확인
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastResetDate = prefs.getString(_dailyResetDateKey);

    if (lastResetDate != today) {
      // 날짜가 바뀌었으면 제한 내
      return true;
    }

    // 현재 카운트 확인
    final currentCount = prefs.getInt(_dailyCountKey) ?? 0;
    return currentCount < dailyLimit;
  }

  /// 시간당 제한 확인 (카운트 증가 없이)
  Future<bool> _checkHourlyLimit() async {
    final prefs = await SharedPreferences.getInstance();

    // 시간 확인
    final currentHour = DateTime.now().toIso8601String().substring(0, 13);
    final lastResetHour = prefs.getString(_hourlyResetTimeKey);

    if (lastResetHour != currentHour) {
      // 시간이 바뀌었으면 제한 내
      return true;
    }

    // 현재 카운트 확인
    final currentCount = prefs.getInt(_hourlyCountKey) ?? 0;
    return currentCount < hourlyLimit;
  }

  /// 남은 일일 할당량 조회
  Future<int> getRemainingDailyQuota() async {
    final prefs = await SharedPreferences.getInstance();

    // 날짜 확인
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastResetDate = prefs.getString(_dailyResetDateKey);

    if (lastResetDate != today) {
      // 날짜가 바뀌었으면 전체 할당량 반환
      return dailyLimit;
    }

    // 현재 카운트 확인
    final currentCount = prefs.getInt(_dailyCountKey) ?? 0;
    return dailyLimit - currentCount;
  }

  /// 남은 시간당 할당량 조회
  Future<int> getRemainingHourlyQuota() async {
    final prefs = await SharedPreferences.getInstance();

    // 시간 확인
    final currentHour = DateTime.now().toIso8601String().substring(0, 13);
    final lastResetHour = prefs.getString(_hourlyResetTimeKey);

    if (lastResetHour != currentHour) {
      // 시간이 바뀌었으면 전체 할당량 반환
      return hourlyLimit;
    }

    // 현재 카운트 확인
    final currentCount = prefs.getInt(_hourlyCountKey) ?? 0;
    return hourlyLimit - currentCount;
  }

  /// 다음 일일 리셋까지 남은 시간 (초)
  int getSecondsUntilDailyReset() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now).inSeconds;
  }

  /// 다음 시간당 리셋까지 남은 시간 (초)
  int getSecondsUntilHourlyReset() {
    final now = DateTime.now();
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    return nextHour.difference(now).inSeconds;
  }

  /// 레이트 리밋 상태 조회 (디버깅용)
  Future<Map<String, dynamic>> getStatus() async {
    final remainingDaily = await getRemainingDailyQuota();
    final remainingHourly = await getRemainingHourlyQuota();

    return {
      'dailyRemaining': remainingDaily,
      'dailyLimit': dailyLimit,
      'hourlyRemaining': remainingHourly,
      'hourlyLimit': hourlyLimit,
      'secondsUntilDailyReset': getSecondsUntilDailyReset(),
      'secondsUntilHourlyReset': getSecondsUntilHourlyReset(),
    };
  }

  /// 수동 리셋 (테스트 및 디버깅용)
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyCountKey);
    await prefs.remove(_dailyResetDateKey);
    await prefs.remove(_hourlyCountKey);
    await prefs.remove(_hourlyResetTimeKey);
  }
}

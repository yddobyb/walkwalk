// test/services/ai/api_config_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:walk_dog/core/config/api_config.dart';

/// API 설정 테스트
///
/// 테스트 항목:
/// 1. 공통 설정 상수 확인
/// 2. LLM 파라미터 확인
void main() {
  group('ApiConfig Tests', () {
    test('공통 설정 상수가 올바른지 확인', () {
      final timeout = ApiConfig.requestTimeout;
      final dailyLimit = ApiConfig.maxDailyRequests;
      final hourlyLimit = ApiConfig.maxHourlyRequests;

      expect(timeout, 15);
      expect(dailyLimit, 40);
      expect(hourlyLimit, 15);

      debugPrint('✅ 공통 설정 상수 확인 완료');
      debugPrint('   - Timeout: ${timeout}s');
      debugPrint('   - Daily Limit: $dailyLimit');
      debugPrint('   - Hourly Limit: $hourlyLimit');
    });

    test('maxTokens 및 temperature 설정 확인', () {
      final maxTokens = ApiConfig.maxTokens;
      final temperature = ApiConfig.temperature;

      expect(maxTokens, 100);
      expect(temperature, 0.7);

      debugPrint('✅ LLM 파라미터 설정 확인 완료');
      debugPrint('   - Max Tokens: $maxTokens');
      debugPrint('   - Temperature: $temperature');
    });

    test('환경 감지 확인', () {
      // debug 모드에서 테스트 실행 시
      expect(ApiConfig.enableDebugLogs, kDebugMode);
      expect(ApiConfig.isProduction, kReleaseMode);

      debugPrint('✅ 환경 감지 확인 완료');
    });
  });
}

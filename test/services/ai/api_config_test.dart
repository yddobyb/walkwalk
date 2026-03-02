// test/services/ai/api_config_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/core/config/api_config.dart';

/// Week 3 Test 1: API 설정 테스트
///
/// 테스트 항목:
/// 1. OpenRouter 설정 상수 확인
/// 2. API 키 유효성 검증
/// 3. HTTP 헤더 생성
void main() {
  group('ApiConfig Tests', () {
    test('OpenRouter 설정 상수가 올바른지 확인', () {
      // Given: ApiConfig 클래스

      // When: 상수 확인
      final baseUrl = ApiConfig.openRouterBaseUrl;
      final model = ApiConfig.model;
      final timeout = ApiConfig.requestTimeout;
      final dailyLimit = ApiConfig.maxDailyRequests;
      final hourlyLimit = ApiConfig.maxHourlyRequests;

      // Then: 예상값과 일치 (4-tier fallback 아키텍처로 업데이트됨)
      expect(baseUrl, 'https://openrouter.ai/api/v1');
      expect(model, 'openrouter/free');
      expect(timeout, 15);
      expect(dailyLimit, 40);
      expect(hourlyLimit, 15);

      print('✅ OpenRouter 설정 상수 확인 완료');
      print('   - Base URL: $baseUrl');
      print('   - Model: $model');
      print('   - Timeout: ${timeout}s');
      print('   - Daily Limit: $dailyLimit');
      print('   - Hourly Limit: $hourlyLimit');
    });

    test('API 키 유효성 검증 - 유효한 키', () {
      // Given: 유효한 API 키 형식
      final validKey = '***REDACTED_OPENROUTER_KEY***';

      // When: 유효성 검증
      final isValid = ApiConfig.isValidApiKey(validKey);

      // Then: true 반환
      expect(isValid, true);
      print('✅ 유효한 API 키 검증 성공: ${validKey.substring(0, 20)}...');
    });

    test('API 키 유효성 검증 - 빈 문자열', () {
      // Given: 빈 문자열
      final emptyKey = '';

      // When: 유효성 검증
      final isValid = ApiConfig.isValidApiKey(emptyKey);

      // Then: false 반환
      expect(isValid, false);
      print('✅ 빈 API 키 검증 실패 확인');
    });

    test('API 키 유효성 검증 - null', () {
      // Given: null 값
      String? nullKey;

      // When: 유효성 검증
      final isValid = ApiConfig.isValidApiKey(nullKey);

      // Then: false 반환
      expect(isValid, false);
      print('✅ null API 키 검증 실패 확인');
    });

    test('HTTP 헤더 생성 확인', () {
      // Given: API 키
      final apiKey = 'test-api-key-12345';

      // When: 헤더 생성
      final headers = ApiConfig.getHeaders(apiKey);

      // Then: 필수 헤더 포함
      expect(headers['Authorization'], 'Bearer $apiKey');
      expect(headers['HTTP-Referer'], 'com.walkdog.app');
      expect(headers['X-Title'], 'WalkDog');
      expect(headers['Content-Type'], 'application/json');

      print('✅ HTTP 헤더 생성 확인 완료');
      print('   - Authorization: ${headers['Authorization']?.substring(0, 20)}...');
      print('   - HTTP-Referer: ${headers['HTTP-Referer']}');
      print('   - X-Title: ${headers['X-Title']}');
      print('   - Content-Type: ${headers['Content-Type']}');
    });

    test('maxTokens 및 temperature 설정 확인', () {
      // Given: ApiConfig 클래스

      // When: 설정값 확인
      final maxTokens = ApiConfig.maxTokens;
      final temperature = ApiConfig.temperature;

      // Then: 예상값과 일치
      expect(maxTokens, 100);
      expect(temperature, 0.7);

      print('✅ LLM 파라미터 설정 확인 완료');
      print('   - Max Tokens: $maxTokens');
      print('   - Temperature: $temperature');
    });
  });
}

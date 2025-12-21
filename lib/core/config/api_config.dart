// lib/core/config/api_config.dart

import 'package:flutter/foundation.dart';

import '../../services/config/remote_config_service.dart';

/// OpenRouter API 설정
///
/// Week 3: 클라우드 AI 대화 시스템
/// - Mistral Devstral 2512 모델 (무료, 코딩 전문)
/// - HTTP 기반 API 호출
/// - 15초 타임아웃
class ApiConfig {
  // OpenRouter API 기본 설정
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String model = 'mistralai/devstral-2512:free';
  static const int requestTimeout = 15; // 초

  // 레이트 리밋 (안전 마진 포함)
  static const int maxDailyRequests = 80; // OpenRouter 무료: 100회/일
  static const int maxHourlyRequests = 20; // 시간당 제한

  // 응답 생성 설정
  static const int maxTokens = 100; // 짧은 대화 유지
  static const double temperature = 0.7; // 창의성과 일관성 균형

  /// Firebase Remote Config에서 API 키 가져오기
  ///
  /// Week 3: Remote Config 우선, 환경 변수 폴백
  ///
  /// 우선순위:
  /// 1. Firebase Remote Config (openrouter_api_key)
  /// 2. 환경 변수 (--dart-define=OPENROUTER_API_KEY)
  /// 3. 에러 발생
  static Future<String> getOpenRouterApiKey() async {
    try {
      // 1. Firebase Remote Config에서 가져오기 시도
      if (RemoteConfigService.isInitialized) {
        final remoteKey = RemoteConfigService.getOpenRouterApiKey();
        if (remoteKey.isNotEmpty && isValidApiKey(remoteKey)) {
          debugPrint('✅ ApiConfig - Using API key from Firebase Remote Config');
          return remoteKey;
        } else if (remoteKey.isNotEmpty) {
          debugPrint('⚠️ ApiConfig - Invalid API key from Remote Config');
        }
      } else {
        debugPrint('⚠️ ApiConfig - RemoteConfigService not initialized');
      }

      // 2. 환경 변수로 폴백
      const envKey = String.fromEnvironment(
        'OPENROUTER_API_KEY',
        defaultValue: '',
      );

      if (envKey.isNotEmpty && isValidApiKey(envKey)) {
        debugPrint('✅ ApiConfig - Using API key from environment variable');
        return envKey;
      } else if (envKey.isNotEmpty) {
        debugPrint('⚠️ ApiConfig - Invalid API key from environment variable');
      }

      // 3. API 키가 설정되지 않았으면 에러
      debugPrint('❌ ApiConfig - OPENROUTER_API_KEY not configured');
      debugPrint('   Set it via:');
      debugPrint('   - Firebase Remote Config (openrouter_api_key)');
      debugPrint('   - Environment variable: flutter run --dart-define=OPENROUTER_API_KEY=your_key');
      throw Exception('OpenRouter API key not configured');
    } catch (e) {
      debugPrint('❌ ApiConfig - Failed to get API key: $e');
      rethrow;
    }
  }

  /// API 키 유효성 검증
  static bool isValidApiKey(String? key) {
    if (key == null || key.isEmpty) return false;
    // OpenRouter API 키는 보통 "sk-or-" 로 시작
    return key.startsWith('sk-or-');
  }

  /// 개발/프로덕션 환경별 설정
  static bool get isProduction => kReleaseMode;
  static bool get enableDebugLogs => kDebugMode;

  /// API 요청 헤더 생성
  static Map<String, String> getHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'HTTP-Referer': 'com.walkdog.app',
      'X-Title': 'WalkDog',
      'Content-Type': 'application/json',
    };
  }
}

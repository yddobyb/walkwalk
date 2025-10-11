// lib/core/config/api_config.dart

import 'package:flutter/foundation.dart';

/// OpenRouter API 설정
///
/// Week 3: 클라우드 AI 대화 시스템
/// - DeepSeek R1 모델 (무료, 100회/일)
/// - HTTP 기반 API 호출
/// - 15초 타임아웃
class ApiConfig {
  // OpenRouter API 기본 설정
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String model = 'deepseek/deepseek-r1:free';
  static const int requestTimeout = 15; // 초

  // 레이트 리밋 (안전 마진 포함)
  static const int maxDailyRequests = 80; // OpenRouter 무료: 100회/일
  static const int maxHourlyRequests = 20; // 시간당 제한

  // 응답 생성 설정
  static const int maxTokens = 100; // 짧은 대화 유지
  static const double temperature = 0.7; // 창의성과 일관성 균형

  /// Firebase Remote Config에서 API 키 가져오기
  ///
  /// 현재는 하드코딩 (테스트용), 나중에 Firebase Remote Config로 대체
  ///
  /// TODO: Firebase Remote Config 연동
  /// ```dart
  /// final remoteConfig = FirebaseRemoteConfig.instance;
  /// await remoteConfig.fetchAndActivate();
  /// return remoteConfig.getString('openrouter_api_key');
  /// ```
  static Future<String> getOpenRouterApiKey() async {
    // ⚠️ 임시 하드코딩 - 테스트 후 Firebase Remote Config로 이동 필수!
    // 실제 API 키는 절대 소스코드에 포함하지 말 것
    const apiKey = String.fromEnvironment(
      'OPENROUTER_API_KEY',
      defaultValue: '', // 환경 변수가 없으면 빈 문자열
    );

    if (apiKey.isEmpty) {
      debugPrint('⚠️ ApiConfig - OPENROUTER_API_KEY not set');
      debugPrint('Set it via: flutter run --dart-define=OPENROUTER_API_KEY=your_key');
      throw Exception('OpenRouter API key not configured');
    }

    return apiKey;
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

// lib/core/config/api_config.dart

import 'package:flutter/foundation.dart';

import '../../services/config/remote_config_service.dart';

/// API 설정
///
/// LLM 4-tier fallback chain:
/// 1. OpenRouter Free (자동 라우터)
/// 2. Groq Free (Llama 3.3 70B, 초고속)
/// 3. Gemini Flash-Lite (Google 직접)
/// 4. 규칙 기반 폴백 (오프라인)
class ApiConfig {
  // ==========================================================
  // OpenRouter
  // ==========================================================
  static const String openRouterBaseUrl =
      'https://openrouter.ai/api/v1';
  static const String openRouterModel = 'openrouter/free';
  static const int openRouterTimeout = 8; // 초

  // ==========================================================
  // Groq
  // ==========================================================
  static const String groqBaseUrl =
      'https://api.groq.com/openai/v1';
  static const String groqModel = 'llama-3.3-70b-versatile';
  static const int groqTimeout = 5; // Groq는 초고속

  // ==========================================================
  // Gemini
  // ==========================================================
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-2.0-flash-lite';
  static const int geminiTimeout = 8; // 초

  // ==========================================================
  // 공통 설정
  // ==========================================================
  static const int requestTimeout = 15; // 레거시 (하위호환)

  // 레이트 리밋 (안전 마진 포함)
  static const int maxDailyRequests = 40;
  static const int maxHourlyRequests = 15;

  // 응답 생성 설정
  static const int maxTokens = 100;
  static const double temperature = 0.7;

  // 레거시 별칭
  static const String model = openRouterModel;

  // ==========================================================
  // OpenRouter API 키
  // ==========================================================
  static Future<String> getOpenRouterApiKey() async {
    try {
      if (RemoteConfigService.isInitialized) {
        final remoteKey =
            RemoteConfigService.getOpenRouterApiKey();
        if (remoteKey.isNotEmpty && isValidApiKey(remoteKey)) {
          debugPrint(
            '✅ ApiConfig - OpenRouter key from Remote Config',
          );
          return remoteKey;
        }
      }
      const envKey = String.fromEnvironment(
        'OPENROUTER_API_KEY',
        defaultValue: '',
      );
      if (envKey.isNotEmpty && isValidApiKey(envKey)) {
        debugPrint(
          '✅ ApiConfig - OpenRouter key from env variable',
        );
        return envKey;
      }
      throw Exception('OpenRouter API key not configured');
    } catch (e) {
      debugPrint('❌ ApiConfig - OpenRouter key failed: $e');
      rethrow;
    }
  }

  // ==========================================================
  // Groq API 키
  // ==========================================================
  static Future<String> getGroqApiKey() async {
    try {
      if (RemoteConfigService.isInitialized) {
        final remoteKey = RemoteConfigService.getGroqApiKey();
        if (remoteKey.isNotEmpty &&
            isValidGroqApiKey(remoteKey)) {
          debugPrint(
            '✅ ApiConfig - Groq key from Remote Config',
          );
          return remoteKey;
        }
      }
      const envKey = String.fromEnvironment(
        'GROQ_API_KEY',
        defaultValue: '',
      );
      if (envKey.isNotEmpty && isValidGroqApiKey(envKey)) {
        debugPrint('✅ ApiConfig - Groq key from env variable');
        return envKey;
      }
      throw Exception('Groq API key not configured');
    } catch (e) {
      debugPrint('❌ ApiConfig - Groq key failed: $e');
      rethrow;
    }
  }

  // ==========================================================
  // Gemini API 키
  // ==========================================================
  static Future<String> getGeminiApiKey() async {
    try {
      if (RemoteConfigService.isInitialized) {
        final remoteKey =
            RemoteConfigService.getGeminiApiKey();
        if (remoteKey.isNotEmpty &&
            isValidGeminiApiKey(remoteKey)) {
          debugPrint(
            '✅ ApiConfig - Gemini key from Remote Config',
          );
          return remoteKey;
        }
      }
      const envKey = String.fromEnvironment(
        'GEMINI_API_KEY',
        defaultValue: '',
      );
      if (envKey.isNotEmpty && isValidGeminiApiKey(envKey)) {
        debugPrint(
          '✅ ApiConfig - Gemini key from env variable',
        );
        return envKey;
      }
      throw Exception('Gemini API key not configured');
    } catch (e) {
      debugPrint('❌ ApiConfig - Gemini key failed: $e');
      rethrow;
    }
  }

  // ==========================================================
  // API 키 유효성 검증
  // ==========================================================

  /// OpenRouter API 키 검증 (sk-or- prefix)
  static bool isValidApiKey(String? key) {
    if (key == null || key.isEmpty) return false;
    return key.startsWith('sk-or-');
  }

  /// Groq API 키 검증 (gsk_ prefix)
  static bool isValidGroqApiKey(String? key) {
    if (key == null || key.isEmpty) return false;
    return key.startsWith('gsk_');
  }

  /// Gemini API 키 검증 (AIza prefix)
  static bool isValidGeminiApiKey(String? key) {
    if (key == null || key.isEmpty) return false;
    return key.startsWith('AIza');
  }

  // ==========================================================
  // 헤더 생성
  // ==========================================================

  /// OpenRouter 요청 헤더
  static Map<String, String> getHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'HTTP-Referer': 'com.walkdog.app',
      'X-Title': 'WalkDog',
      'Content-Type': 'application/json',
    };
  }

  /// Groq 요청 헤더
  static Map<String, String> getGroqHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  /// Gemini 요청 헤더 (API 키는 URL 파라미터로)
  static Map<String, String> getGeminiHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  // ==========================================================
  // 환경
  // ==========================================================
  static bool get isProduction => kReleaseMode;
  static bool get enableDebugLogs => kDebugMode;
}

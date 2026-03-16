// lib/core/config/api_config.dart

import 'package:flutter/foundation.dart';

/// API 설정 (클라이언트 공통)
///
/// LLM API 호출은 모두 chatWithPet Cloud Function을 통해 서버에서 수행.
/// 클라이언트에는 API 키를 전달하지 않음 (보안).
///
/// 서버 내부 폴백: OpenRouter → Groq → Gemini → 에러
/// 클라이언트 폴백: Cloud Function 실패 시 → 규칙 기반 오프라인 응답
class ApiConfig {
  // ==========================================================
  // 공통 설정 (클라이언트 레이트 리밋 + LLM 파라미터)
  // ==========================================================
  static const int requestTimeout = 15; // Cloud Function 타임아웃 (초)

  // 클라이언트 레이트 리밋 (안전 마진 포함)
  static const int maxDailyRequests = 40;
  static const int maxHourlyRequests = 15;

  // 응답 생성 설정
  static const int maxTokens = 100;
  static const double temperature = 0.7;

  // ==========================================================
  // 환경
  // ==========================================================
  static bool get isProduction => kReleaseMode;
  static bool get enableDebugLogs => kDebugMode;
}

// lib/services/analytics/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Analytics 서비스
///
/// Week 3: AI 대화 시스템 성능 모니터링
///
/// 기능:
/// - LLM 요청 이벤트 추적
/// - 응답 시간 측정
/// - 폴백 사용 추적
/// - 에러 로깅
///
/// Usage:
/// ```dart
/// await AnalyticsService.initialize();
///
/// // LLM 요청 시작
/// AnalyticsService.logLlmRequestStarted(
///   context: 'walk_complete',
///   dogName: 'Max',
/// );
///
/// // LLM 요청 완료
/// AnalyticsService.logLlmRequestCompleted(
///   context: 'walk_complete',
///   responseTimeMs: 1234,
///   usedFallback: false,
/// );
/// ```
class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static bool _isInitialized = false;

  // ==========================================================================
  // 초기화
  // ==========================================================================

  /// Analytics 초기화
  ///
  /// Firebase가 초기화된 후 호출
  ///
  /// Returns: true if 성공, false if 실패
  static Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ Analytics - Already initialized');
      return true;
    }

    try {
      _analytics = FirebaseAnalytics.instance;
      _isInitialized = true;

      debugPrint('✅ Analytics - Initialized successfully');

      // 앱 시작 이벤트 기록
      await logAppStarted();

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Analytics - Initialization failed: $e');
      debugPrint('   Stack trace: $stackTrace');
      _isInitialized = false;
      return false;
    }
  }

  /// Analytics 인스턴스 가져오기
  static FirebaseAnalytics? get instance => _analytics;

  /// 초기화 상태 확인
  static bool get isInitialized => _isInitialized;

  // ==========================================================================
  // 앱 생명주기 이벤트
  // ==========================================================================

  /// 앱 시작 이벤트
  static Future<void> logAppStarted() async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.logEvent(
        name: 'app_started',
        parameters: {
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - App started');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log app_started: $e');
    }
  }

  // ==========================================================================
  // LLM 요청 이벤트
  // ==========================================================================

  /// LLM 요청 시작 이벤트
  ///
  /// Parameters:
  /// - context: 대화 컨텍스트 (walk_complete, mission_complete, etc.)
  /// - dogName: 반려견 이름
  /// - dogBreed: 반려견 품종
  /// - happinessLevel: 행복도 (0-100)
  static Future<void> logLlmRequestStarted({
    required String context,
    String? dogName,
    String? dogBreed,
    int? happinessLevel,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      final parameters = <String, Object>{
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (dogName != null) parameters['dog_name'] = dogName;
      if (dogBreed != null) parameters['dog_breed'] = dogBreed;
      if (happinessLevel != null) parameters['happiness_level'] = happinessLevel;

      await _analytics!.logEvent(
        name: 'llm_request_started',
        parameters: parameters,
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - LLM request started: $context');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log llm_request_started: $e');
    }
  }

  /// LLM 요청 완료 이벤트
  ///
  /// Parameters:
  /// - context: 대화 컨텍스트
  /// - responseTimeMs: 응답 시간 (밀리초)
  /// - usedFallback: 폴백 사용 여부
  /// - responseLength: 응답 길이 (글자 수)
  static Future<void> logLlmRequestCompleted({
    required String context,
    required int responseTimeMs,
    required bool usedFallback,
    int? responseLength,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      final parameters = <String, Object>{
        'context': context,
        'response_time_ms': responseTimeMs,
        'used_fallback': usedFallback ? 'true' : 'false', // Convert bool to string
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (responseLength != null) {
        parameters['response_length'] = responseLength;
      }

      await _analytics!.logEvent(
        name: 'llm_request_completed',
        parameters: parameters,
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - LLM request completed: $context '
            '(${responseTimeMs}ms, fallback: $usedFallback)');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log llm_request_completed: $e');
    }
  }

  /// LLM 요청 실패 이벤트
  ///
  /// Parameters:
  /// - context: 대화 컨텍스트
  /// - errorType: 에러 타입 (network, timeout, api_error, etc.)
  /// - errorMessage: 에러 메시지
  /// - usedFallback: 폴백 사용 여부
  static Future<void> logLlmRequestFailed({
    required String context,
    required String errorType,
    String? errorMessage,
    required bool usedFallback,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      final parameters = <String, Object>{
        'context': context,
        'error_type': errorType,
        'used_fallback': usedFallback ? 'true' : 'false', // Convert bool to string
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (errorMessage != null) {
        // 에러 메시지는 최대 100자로 제한
        parameters['error_message'] = errorMessage.length > 100
            ? '${errorMessage.substring(0, 97)}...'
            : errorMessage;
      }

      await _analytics!.logEvent(
        name: 'llm_request_failed',
        parameters: parameters,
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - LLM request failed: $context '
            '(type: $errorType, fallback: $usedFallback)');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log llm_request_failed: $e');
    }
  }

  // ==========================================================================
  // 폴백 사용 이벤트
  // ==========================================================================

  /// 폴백 응답 사용 이벤트
  ///
  /// Parameters:
  /// - context: 대화 컨텍스트
  /// - reason: 폴백 사용 이유 (network_error, timeout, api_error, etc.)
  static Future<void> logFallbackUsed({
    required String context,
    required String reason,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.logEvent(
        name: 'fallback_used',
        parameters: {
          'context': context,
          'reason': reason,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - Fallback used: $context (reason: $reason)');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log fallback_used: $e');
    }
  }

  // ==========================================================================
  // 사용자 속성 설정
  // ==========================================================================

  /// 사용자 속성 설정
  ///
  /// Parameters:
  /// - dogName: 반려견 이름
  /// - dogBreed: 반려견 품종
  /// - userLevel: 사용자 레벨
  static Future<void> setUserProperties({
    String? dogName,
    String? dogBreed,
    int? userLevel,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      if (dogName != null) {
        await _analytics!.setUserProperty(
          name: 'dog_name',
          value: dogName,
        );
      }

      if (dogBreed != null) {
        await _analytics!.setUserProperty(
          name: 'dog_breed',
          value: dogBreed,
        );
      }

      if (userLevel != null) {
        await _analytics!.setUserProperty(
          name: 'user_level',
          value: userLevel.toString(),
        );
      }

      if (kDebugMode) {
        debugPrint('📊 Analytics - User properties set');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to set user properties: $e');
    }
  }

  // ==========================================================================
  // 화면 조회 이벤트
  // ==========================================================================

  /// 화면 조회 이벤트
  ///
  /// Parameters:
  /// - screenName: 화면 이름
  /// - screenClass: 화면 클래스 이름
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - Screen view: $screenName');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log screen view: $e');
    }
  }

  // ==========================================================================
  // 커스텀 이벤트
  // ==========================================================================

  /// 커스텀 이벤트 로깅
  ///
  /// Parameters:
  /// - eventName: 이벤트 이름
  /// - parameters: 이벤트 파라미터
  static Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.logEvent(
        name: eventName,
        parameters: parameters,
      );

      if (kDebugMode) {
        debugPrint('📊 Analytics - Custom event: $eventName');
      }
    } catch (e) {
      debugPrint('❌ Analytics - Failed to log custom event: $e');
    }
  }
}

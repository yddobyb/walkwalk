// lib/services/config/remote_config_service.dart

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Firebase Remote Config 서비스
///
/// Week 3: 클라우드 기반 앱 설정 관리
///
/// 기능:
/// - OpenRouter API 키 원격 관리
/// - 레이트 리밋 설정 동적 변경
/// - 디버그 로그 원격 제어
///
/// Usage:
/// ```dart
/// await RemoteConfigService.initialize();
/// final apiKey = RemoteConfigService.getOpenRouterApiKey();
/// ```
class RemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _isInitialized = false;

  // ==========================================================================
  // 기본값 (Default Values)
  // ==========================================================================

  static const Map<String, dynamic> _defaults = {
    'openrouter_api_key': '',
    'rate_limit_daily': 80,
    'rate_limit_hourly': 20,
    'enable_debug_logs': false,
  };

  // ==========================================================================
  // 초기화
  // ==========================================================================

  /// Remote Config 초기화
  ///
  /// 앱 시작 시 Firebase 초기화 후 호출
  ///
  /// Returns: true if 성공, false if 실패
  static Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ RemoteConfig - Already initialized');
      return true;
    }

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // 설정 지정 (Fetch 간격)
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // 기본값 설정
      await _remoteConfig!.setDefaults(_defaults);

      // Remote Config 데이터 가져오기 및 활성화
      await _remoteConfig!.fetchAndActivate();

      _isInitialized = true;

      debugPrint('✅ RemoteConfig - Initialized successfully');
      debugPrint('   - API Key: ${_maskApiKey(getOpenRouterApiKey())}');
      debugPrint('   - Daily Limit: ${getRateLimitDaily()}');
      debugPrint('   - Hourly Limit: ${getRateLimitHourly()}');
      debugPrint('   - Debug Logs: ${isDebugLogsEnabled()}');

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ RemoteConfig - Initialization failed: $e');
      debugPrint('   Stack trace: $stackTrace');
      debugPrint('   Using default values');
      _isInitialized = false;
      return false;
    }
  }

  /// Remote Config 강제 새로고침
  ///
  /// 최신 설정값을 서버에서 가져옴
  static Future<bool> refresh() async {
    if (!_isInitialized || _remoteConfig == null) {
      debugPrint('⚠️ RemoteConfig - Not initialized');
      return false;
    }

    try {
      await _remoteConfig!.fetchAndActivate();
      debugPrint('✅ RemoteConfig - Refreshed successfully');
      return true;
    } catch (e) {
      debugPrint('❌ RemoteConfig - Refresh failed: $e');
      return false;
    }
  }

  // ==========================================================================
  // Getters (설정값 가져오기)
  // ==========================================================================

  /// OpenRouter API 키 가져오기
  ///
  /// Returns: API 키 문자열 (설정되지 않았으면 빈 문자열)
  static String getOpenRouterApiKey() {
    if (!_isInitialized || _remoteConfig == null) {
      return _defaults['openrouter_api_key'] as String;
    }

    try {
      final value = _remoteConfig!.getString('openrouter_api_key');
      return value.isEmpty ? _defaults['openrouter_api_key'] as String : value;
    } catch (e) {
      debugPrint('⚠️ RemoteConfig - Failed to get API key: $e');
      return _defaults['openrouter_api_key'] as String;
    }
  }

  /// 일일 레이트 리밋 가져오기
  ///
  /// Returns: 일일 최대 요청 수 (기본: 80)
  static int getRateLimitDaily() {
    if (!_isInitialized || _remoteConfig == null) {
      return _defaults['rate_limit_daily'] as int;
    }

    try {
      return _remoteConfig!.getInt('rate_limit_daily');
    } catch (e) {
      debugPrint('⚠️ RemoteConfig - Failed to get daily limit: $e');
      return _defaults['rate_limit_daily'] as int;
    }
  }

  /// 시간당 레이트 리밋 가져오기
  ///
  /// Returns: 시간당 최대 요청 수 (기본: 20)
  static int getRateLimitHourly() {
    if (!_isInitialized || _remoteConfig == null) {
      return _defaults['rate_limit_hourly'] as int;
    }

    try {
      return _remoteConfig!.getInt('rate_limit_hourly');
    } catch (e) {
      debugPrint('⚠️ RemoteConfig - Failed to get hourly limit: $e');
      return _defaults['rate_limit_hourly'] as int;
    }
  }

  /// 디버그 로그 활성화 여부
  ///
  /// Returns: true if 디버그 로그 활성화
  static bool isDebugLogsEnabled() {
    if (!_isInitialized || _remoteConfig == null) {
      return _defaults['enable_debug_logs'] as bool;
    }

    try {
      return _remoteConfig!.getBool('enable_debug_logs');
    } catch (e) {
      debugPrint('⚠️ RemoteConfig - Failed to get debug logs flag: $e');
      return _defaults['enable_debug_logs'] as bool;
    }
  }

  // ==========================================================================
  // 유틸리티
  // ==========================================================================

  /// API 키 마스킹 (보안)
  ///
  /// 예: sk-or-v1-abc...xyz → sk-or-***xyz
  static String _maskApiKey(String apiKey) {
    if (apiKey.isEmpty || apiKey.length < 10) {
      return '***';
    }

    final prefix = apiKey.substring(0, 6);
    final suffix = apiKey.substring(apiKey.length - 3);
    return '$prefix***$suffix';
  }

  /// 초기화 상태 확인
  static bool get isInitialized => _isInitialized;

  /// Remote Config 인스턴스 가져오기
  static FirebaseRemoteConfig? get instance => _remoteConfig;
}

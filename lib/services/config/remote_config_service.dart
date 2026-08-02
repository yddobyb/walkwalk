// lib/services/config/remote_config_service.dart

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Firebase Remote Config 서비스
///
/// 클라우드 기반 앱 설정 관리
///
/// 기능:
/// - 레이트 리밋 설정 동적 변경
/// - 디버그 로그 원격 제어
///
/// 참고: API 키는 서버(Cloud Functions)에서만 관리.
/// 클라이언트에는 API 키를 전달하지 않음.
class RemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _isInitialized = false;

  // ==========================================================================
  // 기본값 (Default Values)
  // ==========================================================================

  static const Map<String, dynamic> _defaults = {
    // API 키는 서버(Cloud Functions)에서만 관리 — 클라이언트에 전달하지 않음
    'rate_limit_daily': 80,
    'rate_limit_hourly': 20,
    'enable_debug_logs': false,
    // 위치(실외모드) 기능 제공 여부 — Phase 27-8.
    // Firebase Console에서 "Country/Region = South Korea" 조건으로 false를 내려
    // 한국 이용자에게는 위치 기능을 제공하지 않는다(위치정보법 신고 회피).
    // 조건은 **디바이스 IP 기준**으로 판정된다.
    'location_features_enabled': true,
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
      // 디버그 빌드는 스로틀 없이 매번 가져온다 — 지역 게이트 같은 설정을
      // 콘솔에서 바꾸고 바로 실기기로 확인하려면 1시간 캐시가 방해된다.
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // 기본값 설정
      await _remoteConfig!.setDefaults(_defaults);

      // Remote Config 데이터 가져오기 및 활성화
      await _remoteConfig!.fetchAndActivate();

      _isInitialized = true;

      debugPrint('✅ RemoteConfig - Initialized successfully');
      debugPrint('   - Daily Limit: ${getRateLimitDaily()}');
      debugPrint('   - Hourly Limit: ${getRateLimitHourly()}');

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

  /// 위치(실외모드) 기능 제공 여부 (Phase 27-8)
  ///
  /// Firebase Console의 Country/Region 조건으로 한국(KR) IP에는 false를 내린다.
  /// 초기화 실패/오프라인이면 기본값 true → 클라이언트의 디바이스 지역 체크
  /// ([LocationAvailabilityService])가 2차 방어선 역할을 한다.
  static bool isLocationFeaturesEnabled() {
    if (!_isInitialized || _remoteConfig == null) {
      return _defaults['location_features_enabled'] as bool;
    }

    try {
      return _remoteConfig!.getBool('location_features_enabled');
    } catch (e) {
      debugPrint('⚠️ RemoteConfig - Failed to get location flag: $e');
      return _defaults['location_features_enabled'] as bool;
    }
  }

  // ==========================================================================
  // 유틸리티
  // ==========================================================================

  /// 초기화 상태 확인
  static bool get isInitialized => _isInitialized;

  /// Remote Config 인스턴스 가져오기
  static FirebaseRemoteConfig? get instance => _remoteConfig;
}

// lib/services/network/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// 네트워크 연결 상태 관리 서비스
///
/// Week 3: 네트워크 최적화
/// - 인터넷 연결 상태 확인
/// - WiFi vs 모바일 데이터 감지
/// - 연결 상태 변경 스트림 제공
/// - LLM API 호출 전 네트워크 체크
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// 현재 연결 상태 확인
  ///
  /// Returns: 현재 활성화된 연결 타입 리스트
  Future<List<ConnectivityResult>> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (kDebugMode) {
        debugPrint('📡 ConnectivityService - Current: $result');
      }
      return result;
    } catch (e) {
      debugPrint('❌ ConnectivityService - Check failed: $e');
      return [ConnectivityResult.none];
    }
  }

  /// 인터넷 연결 여부 확인
  ///
  /// Returns: true if 인터넷 연결됨
  Future<bool> isConnected() async {
    final result = await checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// WiFi 연결 여부 확인
  ///
  /// Returns: true if WiFi 연결됨
  Future<bool> isWifi() async {
    final result = await checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// 모바일 데이터 연결 여부 확인
  ///
  /// Returns: true if 모바일 데이터 연결됨
  Future<bool> isMobile() async {
    final result = await checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  /// 연결 타입 문자열 반환 (로그/디버그용, UI에는 l10n 사용)
  ///
  /// Returns: "WiFi", "Mobile Data", "Ethernet", "No Connection" 등
  Future<String> getConnectionTypeString() async {
    final result = await checkConnectivity();

    if (result.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (result.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (result.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    } else if (result.contains(ConnectivityResult.other)) {
      return 'Other Network';
    } else {
      return 'No Connection';
    }
  }

  /// 연결 상태 변경 스트림
  ///
  /// 네트워크 연결 상태가 변경될 때마다 이벤트 발생
  ///
  /// Example:
  /// ```dart
  /// final subscription = connectivityService.onConnectivityChanged.listen((result) {
  ///   if (result.contains(ConnectivityResult.none)) {
  ///     // 오프라인 처리
  ///   }
  /// });
  /// ```
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// 연결 상태 변경 리스닝 시작
  ///
  /// [onChanged]: 연결 상태 변경 시 호출되는 콜백
  ///
  /// Returns: StreamSubscription (dispose 시 cancel 필요)
  StreamSubscription<List<ConnectivityResult>> listenToConnectivity({
    required Function(List<ConnectivityResult>) onChanged,
  }) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (kDebugMode) {
        debugPrint('📡 ConnectivityService - Changed to: $result');
      }
      onChanged(result);
    });

    return _subscription!;
  }

  /// 서비스 정리
  ///
  /// StreamSubscription을 취소하여 메모리 누수 방지
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    debugPrint('🗑️ ConnectivityService - Disposed');
  }
}

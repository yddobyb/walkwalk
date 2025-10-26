// lib/services/network/network_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectivity_service.dart';

/// Week 3: 네트워크 Riverpod Providers
///
/// Provider 계층:
/// 1. connectivityServiceProvider - 연결 상태 관리 서비스
/// 2. connectivityStatusProvider - 연결 상태 변경 스트림
/// 3. isConnectedProvider - 현재 연결 여부 확인
/// 4. isWifiProvider - WiFi 연결 여부 확인
/// 5. connectionTypeProvider - 연결 타입 문자열

// ==========================================================================
// 1. ConnectivityService Provider
// ==========================================================================

/// 네트워크 연결 상태 관리 서비스 Provider
///
/// 싱글톤 인스턴스
///
/// Usage:
/// ```dart
/// final service = ref.watch(connectivityServiceProvider);
/// final isConnected = await service.isConnected();
/// ```
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();

  // Provider가 dispose될 때 서비스도 정리
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// ==========================================================================
// 2. Connectivity Status Stream Provider
// ==========================================================================

/// 연결 상태 변경 스트림 Provider
///
/// 네트워크 연결 상태가 변경될 때마다 이벤트 발생
///
/// Usage:
/// ```dart
/// final statusAsync = ref.watch(connectivityStatusProvider);
/// statusAsync.when(
///   data: (result) {
///     if (result.contains(ConnectivityResult.none)) {
///       // 오프라인 처리
///     }
///   },
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error: $e'),
/// );
/// ```
final connectivityStatusProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

// ==========================================================================
// 3. Is Connected Provider
// ==========================================================================

/// 현재 인터넷 연결 여부 Provider
///
/// Returns: true if 인터넷 연결됨, false if 오프라인
///
/// Usage:
/// ```dart
/// final isConnectedAsync = ref.watch(isConnectedProvider);
/// isConnectedAsync.when(
///   data: (connected) => Text(connected ? 'Online' : 'Offline'),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error'),
/// );
/// ```
final isConnectedProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(connectivityServiceProvider);
  return await service.isConnected();
});

// ==========================================================================
// 4. Is WiFi Provider
// ==========================================================================

/// 현재 WiFi 연결 여부 Provider
///
/// Returns: true if WiFi 연결됨
///
/// Usage:
/// ```dart
/// final isWifiAsync = ref.watch(isWifiProvider);
/// isWifiAsync.when(
///   data: (wifi) => Text(wifi ? 'WiFi' : 'Mobile'),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error'),
/// );
/// ```
final isWifiProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(connectivityServiceProvider);
  return await service.isWifi();
});

// ==========================================================================
// 5. Connection Type Provider
// ==========================================================================

/// 현재 연결 타입 문자열 Provider
///
/// Returns: "WiFi", "모바일 데이터", "이더넷", "연결 없음" 등
///
/// Usage:
/// ```dart
/// final connectionTypeAsync = ref.watch(connectionTypeProvider);
/// connectionTypeAsync.when(
///   data: (type) => Text('연결: $type'),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error'),
/// );
/// ```
final connectionTypeProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(connectivityServiceProvider);
  return await service.getConnectionTypeString();
});

// lib/services/location/location_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/walk_session.dart';

/// GPS 위치 기반 실외 감지 서비스
/// - 위치 권한 관리
/// - 실외/실내 자동 판정
/// - 위치 데이터 수집 및 분석
class LocationService {
  static LocationService? _instance;
  static LocationService get instance {
    _instance ??= LocationService._();
    return _instance!;
  }

  LocationService._();

  StreamSubscription<Position>? _positionSubscription;
  final List<LocationSample> _locationSamples = [];
  final StreamController<LocationSample> _locationController = StreamController<LocationSample>.broadcast();
  final StreamController<bool> _outdoorStatusController = StreamController<bool>.broadcast();

  // 위치 스트림
  Stream<LocationSample> get locationStream => _locationController.stream;
  Stream<bool> get outdoorStatusStream => _outdoorStatusController.stream;

  // 현재 상태
  bool _isTracking = false;
  bool _isOutdoor = false;
  LocationPermission? _currentPermission;

  /// 위치 권한 확인
  Future<LocationPermission> checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      _currentPermission = permission;
      debugPrint('LocationService - Current permission: $permission');
      return permission;
    } catch (e) {
      debugPrint('LocationService - Error checking permission: $e');
      return LocationPermission.denied;
    }
  }

  /// 위치 권한 요청
  Future<LocationPermission> requestLocationPermission() async {
    try {
      // 위치 서비스 활성화 확인
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        debugPrint('LocationService - Location services are disabled');
        return LocationPermission.denied;
      }

      // 현재 권한 상태 확인
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // 권한 요청
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('LocationService - Location permissions are denied');
          return permission;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('LocationService - Location permissions are permanently denied');
        return permission;
      }

      _currentPermission = permission;
      debugPrint('LocationService - Permission granted: $permission');
      return permission;
    } catch (e) {
      debugPrint('LocationService - Error requesting permission: $e');
      return LocationPermission.denied;
    }
  }

  /// 위치 추적 시작
  Future<bool> startLocationTracking() async {
    if (_isTracking) {
      debugPrint('LocationService - Already tracking location');
      return true;
    }

    try {
      // 권한 확인
      final permission = await requestLocationPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        debugPrint('LocationService - Insufficient permission to start tracking');
        return false;
      }

      // 위치 설정 구성
      final locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: AppConstants.locationDistanceFilter,
        timeLimit: null, // 시간 제한 없음
      );

      // 위치 스트림 시작
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        _handlePositionUpdate,
        onError: _handleLocationError,
      );

      _isTracking = true;
      _locationSamples.clear();
      debugPrint('LocationService - Location tracking started');
      return true;
    } catch (e) {
      debugPrint('LocationService - Error starting location tracking: $e');
      return false;
    }
  }

  /// 위치 추적 중지
  Future<void> stopLocationTracking() async {
    if (!_isTracking) return;

    try {
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      _isTracking = false;
      debugPrint('LocationService - Location tracking stopped');
    } catch (e) {
      debugPrint('LocationService - Error stopping location tracking: $e');
    }
  }

  /// 위치 업데이트 처리
  void _handlePositionUpdate(Position position) {
    try {
      final sample = LocationSample(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
        speed: max(0.0, position.speed), // 음수 속도 방지
      );

      _locationSamples.add(sample);
      _locationController.add(sample);

      // 실외 상태 업데이트
      _updateOutdoorStatus(sample);

      // 오래된 샘플 정리 (10분 이상)
      _cleanupOldSamples();

      debugPrint('LocationService - Position updated: ${position.latitude}, ${position.longitude}, accuracy: ${position.accuracy}m');
    } catch (e) {
      debugPrint('LocationService - Error handling position update: $e');
    }
  }

  /// 위치 오류 처리
  void _handleLocationError(error) {
    debugPrint('LocationService - Location error: $error');
  }

  /// 실외 상태 업데이트
  void _updateOutdoorStatus(LocationSample sample) {
    try {
      // GPS 정확도 기반 실외 판정
      final isCurrentlyOutdoor = _isLocationOutdoor(sample);

      if (isCurrentlyOutdoor != _isOutdoor) {
        _isOutdoor = isCurrentlyOutdoor;
        _outdoorStatusController.add(_isOutdoor);
        debugPrint('LocationService - Outdoor status changed: $_isOutdoor');
      }
    } catch (e) {
      debugPrint('LocationService - Error updating outdoor status: $e');
    }
  }

  /// 위치가 실외인지 판정
  bool _isLocationOutdoor(LocationSample sample) {
    // GPS 정확도를 기반으로 실외 판정
    // 정확도가 높을수록 (값이 낮을수록) 실외일 가능성이 높음
    if (sample.accuracy <= AppConstants.outdoorAccuracyThreshold) {
      return true;
    }

    // 속도 기반 보조 판정
    if (sample.speed > AppConstants.outdoorSpeedThreshold) {
      return true;
    }

    return false;
  }

  /// 오래된 위치 샘플 정리
  void _cleanupOldSamples() {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 10));
    _locationSamples.removeWhere((sample) => sample.timestamp.isBefore(cutoff));
  }

  /// 현재 실외 상태 반환
  bool get isOutdoor => _isOutdoor;

  /// 현재 추적 상태 반환
  bool get isTracking => _isTracking;

  /// 현재 권한 상태 반환
  LocationPermission? get currentPermission => _currentPermission;

  /// 수집된 위치 샘플들 반환
  List<LocationSample> get locationSamples => List.unmodifiable(_locationSamples);

  /// 유효한 실외 샘플 수 계산
  int get validOutdoorSamples {
    return _locationSamples.where((sample) => _isLocationOutdoor(sample)).length;
  }

  /// 실외 비율 계산 (0.0 ~ 1.0)
  double get outdoorRatio {
    if (_locationSamples.isEmpty) return 0.0;
    return validOutdoorSamples / _locationSamples.length;
  }

  /// 총 이동 거리 계산 (미터)
  double calculateTotalDistance() {
    if (_locationSamples.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 1; i < _locationSamples.length; i++) {
      final prev = _locationSamples[i - 1];
      final curr = _locationSamples[i];

      try {
        final distance = Geolocator.distanceBetween(
          prev.latitude,
          prev.longitude,
          curr.latitude,
          curr.longitude,
        );

        // 비현실적인 거리는 무시 (순간이동 방지)
        if (distance <= AppConstants.maxReasonableDistancePerSample) {
          totalDistance += distance;
        }
      } catch (e) {
        debugPrint('LocationService - Error calculating distance: $e');
      }
    }

    return totalDistance;
  }

  /// 평균 속도 계산 (km/h)
  double calculateAverageSpeed() {
    if (_locationSamples.length < 2) return 0.0;

    final validSpeeds = _locationSamples
        .where((sample) => sample.speed >= 0 && sample.speed <= AppConstants.maxReasonableSpeed)
        .map((sample) => sample.speed)
        .toList();

    if (validSpeeds.isEmpty) return 0.0;

    final avgSpeedMs = validSpeeds.reduce((a, b) => a + b) / validSpeeds.length;
    return avgSpeedMs * 3.6; // m/s to km/h
  }

  /// 앱 설정 열기
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('LocationService - Error opening app settings: $e');
      return false;
    }
  }

  /// 위치 설정 열기
  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('LocationService - Error opening location settings: $e');
      return false;
    }
  }

  /// 서비스 정리
  void dispose() {
    _positionSubscription?.cancel();
    _locationController.close();
    _outdoorStatusController.close();
    _locationSamples.clear();
    debugPrint('LocationService - Disposed');
  }
}

/// Riverpod Provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService.instance;
});

/// 위치 권한 상태 Provider
final locationPermissionProvider = FutureProvider<LocationPermission>((ref) async {
  final service = ref.read(locationServiceProvider);
  return await service.checkLocationPermission();
});

/// 실외 상태 스트림 Provider
final outdoorStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.read(locationServiceProvider);
  return service.outdoorStatusStream;
});

/// 위치 샘플 스트림 Provider
final locationSampleProvider = StreamProvider<LocationSample>((ref) {
  final service = ref.read(locationServiceProvider);
  return service.locationStream;
});
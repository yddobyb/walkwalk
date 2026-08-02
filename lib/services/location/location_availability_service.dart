// lib/services/location/location_availability_service.dart

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/remote_config_service.dart';

/// 위치(실외모드) 기능 제공 여부 판정 서비스.
///
/// Phase 27-8: 한국에서는 위치 기능을 제공하지 않는다.
/// 「위치정보의 보호 및 이용 등에 관한 법률」상 위치기반서비스사업 신고 대상이
/// 되지 않도록, 한국 이용자에게는 위치 수집 자체를 하지 않는 것이 목적이다.
///
/// 판정 순서 (fallback 구조):
/// 1. **Remote Config를 받았으면 그 값을 신뢰한다.** Firebase Console의
///    Country/Region 조건은 **디바이스 IP 기준**이라 "지금 어느 나라에 있는가"를
///    가장 잘 반영한다. 위치정보법은 소재지 기준이므로 이게 옳은 신호다.
/// 2. **Remote Config를 못 받았으면**(오프라인·첫 실행) 기기 지역 설정으로
///    보수적으로 판정한다. 기기 지역이 KR이면 차단.
///
/// ⚠️ 기기 지역을 1순위로 쓰면 안 된다: **해외 거주 한국어 사용자**(기기 지역
/// ko-KR + 해외 IP)가 통째로 막힌다. 그분들은 한국에 있지 않으므로 위치정보법
/// 대상이 아니고, 한국 개발자의 앱 특성상 이 층이 두껍다. 실제 검증 기기가
/// 정확히 이 경우였다(밴쿠버 소재, 기기 지역 ko-KR).
///
/// ⚠️ 남는 위험: RC를 받은 상태에서 VPN 등으로 IP가 한국이 아니게 보이는
/// 한국 내 이용자. IP 지오로케이션의 한계로, 합리적 노력의 범위를 넘는다.
class LocationAvailabilityService {
  LocationAvailabilityService({
    bool Function()? remoteFlag,
    bool Function()? remoteConfigReady,
    String? Function()? deviceCountryCode,
  })  : _remoteFlag = remoteFlag ?? RemoteConfigService.isLocationFeaturesEnabled,
        _remoteConfigReady =
            remoteConfigReady ?? (() => RemoteConfigService.isInitialized),
        _deviceCountryCode = deviceCountryCode ?? _platformCountryCode;

  final bool Function() _remoteFlag;
  final bool Function() _remoteConfigReady;
  final String? Function() _deviceCountryCode;

  /// 위치 기능을 제공하지 않는 국가 코드.
  static const Set<String> blockedCountryCodes = {'KR'};

  static String? _platformCountryCode() =>
      ui.PlatformDispatcher.instance.locale.countryCode;

  /// 위치(실외모드) 기능을 제공해도 되는지.
  bool isEnabled() {
    // 1순위: Remote Config(IP 기반 국가 조건). 받았으면 이게 가장 정확하다.
    if (_remoteConfigReady()) {
      final allowed = _remoteFlag();
      if (!allowed) {
        debugPrint('📍 LocationAvailability - disabled by Remote Config (IP region)');
      }
      return allowed;
    }

    // 2순위: RC 미수신(오프라인·첫 실행) → 기기 지역으로 보수적 판정
    final country = _deviceCountryCode()?.toUpperCase();
    if (country != null && blockedCountryCodes.contains(country)) {
      debugPrint(
        '📍 LocationAvailability - Remote Config unavailable, '
        'disabled by device region ($country)',
      );
      return false;
    }

    return true;
  }
}

final locationAvailabilityServiceProvider =
    Provider<LocationAvailabilityService>(
  (ref) => LocationAvailabilityService(),
);

/// 위치 기능 제공 여부 (UI 구독용).
final locationFeatureEnabledProvider = Provider<bool>((ref) {
  return ref.watch(locationAvailabilityServiceProvider).isEnabled();
});

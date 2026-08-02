// test/services/location/location_availability_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/location/location_availability_service.dart';

/// Phase 27-8: 위치 기능 지역 게이트 테스트.
///
/// 한국 이용자에게 위치 기능을 제공하지 않는 것이 위치정보법상 신고 대상이
/// 되지 않기 위한 전제다. 다만 **해외 거주 한국어 사용자를 막으면 안 되므로**,
/// Remote Config(IP 기준)를 받았을 때는 기기 지역이 KR이어도 허용해야 한다.
void main() {
  LocationAvailabilityService build({
    required bool remoteFlag,
    bool remoteReady = true,
    String? country,
  }) {
    return LocationAvailabilityService(
      remoteFlag: () => remoteFlag,
      remoteConfigReady: () => remoteReady,
      deviceCountryCode: () => country,
    );
  }

  group('Remote Config를 받은 경우 — IP 기준 판정을 신뢰', () {
    test('한국 IP면 차단', () {
      expect(build(remoteFlag: false, country: 'KR').isEnabled(), isFalse);
      expect(build(remoteFlag: false, country: 'CA').isEnabled(), isFalse);
    });

    test('한국 IP가 아니면 허용', () {
      expect(build(remoteFlag: true, country: 'CA').isEnabled(), isTrue);
      expect(build(remoteFlag: true, country: 'US').isEnabled(), isTrue);
    });

    test('해외 거주 한국어 사용자(기기 ko-KR + 해외 IP)는 허용된다', () {
      // 회귀 방지: 기기 지역만 보고 막으면 이 층이 통째로 차단된다.
      // 실제 검증 기기가 이 경우였다(밴쿠버 소재, 기기 지역 ko-KR).
      expect(build(remoteFlag: true, country: 'KR').isEnabled(), isTrue);
    });
  });

  group('Remote Config를 못 받은 경우 — 기기 지역으로 보수적 판정', () {
    test('기기 지역이 KR이면 차단', () {
      expect(
        build(remoteFlag: true, remoteReady: false, country: 'KR').isEnabled(),
        isFalse,
      );
    });

    test('국가 코드는 대소문자를 가리지 않는다', () {
      expect(
        build(remoteFlag: true, remoteReady: false, country: 'kr').isEnabled(),
        isFalse,
      );
    });

    test('기기 지역이 KR이 아니면 허용', () {
      expect(
        build(remoteFlag: true, remoteReady: false, country: 'CA').isEnabled(),
        isTrue,
      );
    });

    test('국가 코드를 알 수 없으면 허용(주력 시장 UX 우선)', () {
      expect(
        build(remoteFlag: true, remoteReady: false, country: null).isEnabled(),
        isTrue,
      );
    });
  });

  test('차단 대상 국가 목록에 KR이 포함되어 있다', () {
    expect(LocationAvailabilityService.blockedCountryCodes, contains('KR'));
  });
}

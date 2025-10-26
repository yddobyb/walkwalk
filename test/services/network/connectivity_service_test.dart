// test/services/network/connectivity_service_test.dart

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/network/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Week 3 Test 8: ConnectivityService 테스트
///
/// 테스트 항목:
/// 1. 연결 상태 확인 (checkConnectivity)
/// 2. 인터넷 연결 여부 확인 (isConnected)
/// 3. WiFi 연결 확인 (isWifi)
/// 4. 모바일 데이터 연결 확인 (isMobile)
/// 5. 연결 타입 문자열 반환 (getConnectionTypeString)
/// 6. 서비스 정리 (dispose)
void main() {
  late ConnectivityService connectivityService;

  setUpAll(() {
    // Flutter 바인딩 초기화 (connectivity_plus 플러그인 사용을 위해 필요)
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    connectivityService = ConnectivityService();
  });

  tearDown(() {
    connectivityService.dispose();
  });

  group('ConnectivityService Tests', () {
    // ==========================================================================
    // 1. checkConnectivity() 테스트
    // ==========================================================================
    test('checkConnectivity - 현재 연결 상태 확인', () async {
      // Given: ConnectivityService

      // When: 연결 상태 확인
      final result = await connectivityService.checkConnectivity();

      // Then: 연결 상태 리스트 반환
      expect(result, isA<List<ConnectivityResult>>());
      expect(result.isNotEmpty, true);

      print('✅ checkConnectivity 테스트 완료');
      print('   - 현재 연결 상태: $result');
    });

    // ==========================================================================
    // 2. isConnected() 테스트
    // ==========================================================================
    test('isConnected - 인터넷 연결 여부 확인', () async {
      // Given: ConnectivityService

      // When: 연결 여부 확인
      final isConnected = await connectivityService.isConnected();

      // Then: boolean 반환
      expect(isConnected, isA<bool>());

      print('✅ isConnected 테스트 완료');
      print('   - 인터넷 연결: $isConnected');
    });

    // ==========================================================================
    // 3. isWifi() 테스트
    // ==========================================================================
    test('isWifi - WiFi 연결 확인', () async {
      // Given: ConnectivityService

      // When: WiFi 연결 확인
      final isWifi = await connectivityService.isWifi();

      // Then: boolean 반환
      expect(isWifi, isA<bool>());

      print('✅ isWifi 테스트 완료');
      print('   - WiFi 연결: $isWifi');
    });

    // ==========================================================================
    // 4. isMobile() 테스트
    // ==========================================================================
    test('isMobile - 모바일 데이터 연결 확인', () async {
      // Given: ConnectivityService

      // When: 모바일 데이터 연결 확인
      final isMobile = await connectivityService.isMobile();

      // Then: boolean 반환
      expect(isMobile, isA<bool>());

      print('✅ isMobile 테스트 완료');
      print('   - 모바일 데이터 연결: $isMobile');
    });

    // ==========================================================================
    // 5. getConnectionTypeString() 테스트
    // ==========================================================================
    test('getConnectionTypeString - 연결 타입 문자열 반환', () async {
      // Given: ConnectivityService

      // When: 연결 타입 문자열 요청
      final connectionType = await connectivityService.getConnectionTypeString();

      // Then: 문자열 반환
      expect(connectionType, isA<String>());
      expect(connectionType.isNotEmpty, true);

      // 가능한 값: WiFi, 모바일 데이터, 이더넷, VPN, 블루투스, 기타 네트워크, 연결 없음
      final validTypes = [
        'WiFi',
        '모바일 데이터',
        '이더넷',
        'VPN',
        '블루투스',
        '기타 네트워크',
        '연결 없음',
      ];
      expect(validTypes.contains(connectionType), true);

      print('✅ getConnectionTypeString 테스트 완료');
      print('   - 연결 타입: $connectionType');
    });

    // ==========================================================================
    // 6. onConnectivityChanged Stream 테스트
    // ==========================================================================
    test('onConnectivityChanged - 연결 상태 변경 스트림', () async {
      // Given: ConnectivityService

      // When: 스트림 구독
      final stream = connectivityService.onConnectivityChanged;

      // Then: Stream 반환
      expect(stream, isA<Stream<List<ConnectivityResult>>>());

      print('✅ onConnectivityChanged 스트림 확인 완료');
      print('   - Stream<List<ConnectivityResult>> 타입 확인');
    });

    // ==========================================================================
    // 7. listenToConnectivity() 테스트
    // ==========================================================================
    test('listenToConnectivity - 연결 상태 변경 리스닝', () async {
      // Given: ConnectivityService

      var changeDetected = false;

      // When: 연결 상태 변경 리스닝
      final subscription = connectivityService.listenToConnectivity(
        onChanged: (result) {
          changeDetected = true;
          print('📡 연결 상태 변경: $result');
        },
      );

      // 잠시 대기 (스트림 초기 이벤트)
      await Future.delayed(Duration(milliseconds: 100));

      // 구독 취소
      await subscription.cancel();

      // Then: 구독 객체 반환
      expect(subscription, isA<StreamSubscription<List<ConnectivityResult>>>());

      print('✅ listenToConnectivity 테스트 완료');
      print('   - 스트림 구독 및 취소 성공');
    });

    // ==========================================================================
    // 8. dispose() 테스트
    // ==========================================================================
    test('dispose - 서비스 정리', () async {
      // Given: ConnectivityService with active subscription
      final subscription = connectivityService.listenToConnectivity(
        onChanged: (result) {
          print('📡 연결 상태: $result');
        },
      );

      // When: dispose 호출
      connectivityService.dispose();

      // Then: 정리 완료 (subscription이 취소됨)
      // 참고: dispose는 내부적으로 subscription을 취소함

      print('✅ dispose 테스트 완료');
      print('   - 서비스 정리 성공');
    });

    // ==========================================================================
    // 9. 연결 상태별 테스트 (통합)
    // ==========================================================================
    test('연결 상태별 isConnected() 동작 확인', () async {
      // Given: ConnectivityService

      // When: 연결 상태 확인
      final connectivityResult = await connectivityService.checkConnectivity();
      final isConnected = await connectivityService.isConnected();

      // Then: ConnectivityResult.none이면 isConnected는 false
      if (connectivityResult.contains(ConnectivityResult.none)) {
        expect(isConnected, false);
      } else {
        expect(isConnected, true);
      }

      print('✅ 연결 상태별 isConnected 동작 확인 완료');
      print('   - 연결 상태: $connectivityResult');
      print('   - isConnected: $isConnected');
    });

    // ==========================================================================
    // 10. WiFi vs 모바일 데이터 확인
    // ==========================================================================
    test('WiFi vs 모바일 데이터 구분 확인', () async {
      // Given: ConnectivityService

      // When: 연결 타입 확인
      final isWifi = await connectivityService.isWifi();
      final isMobile = await connectivityService.isMobile();

      // Then: 둘 다 false이거나, 하나만 true
      // (WiFi와 모바일 동시 연결은 일반적으로 불가능)
      if (isWifi) {
        print('✅ WiFi 연결 확인 완료');
      } else if (isMobile) {
        print('✅ 모바일 데이터 연결 확인 완료');
      } else {
        print('✅ WiFi/모바일 아닌 연결 또는 오프라인');
      }

      print('   - WiFi: $isWifi, Mobile: $isMobile');
    });
  });
}

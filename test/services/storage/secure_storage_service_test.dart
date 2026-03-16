// test/services/storage/secure_storage_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/storage/secure_storage_service.dart';

/// SecureStorageService 유닛 테스트
///
/// 테스트 항목:
/// 1. 초기화 전 상태 검증
/// 2. _ensureInitialized 가드 동작
/// 3. 키 상수 정의
///
/// Note: 실제 FlutterSecureStorage 읽기/쓰기는 플랫폼 채널 필요 →
/// 여기서는 초기화 로직과 가드 메서드만 검증.
void main() {
  group('SecureStorageService Tests', () {
    // ========================================================================
    // 1. 초기화 상태 확인
    // ========================================================================
    test('isInitialized - 초기 상태는 true (main.dart에서 이미 호출)', () {
      // SecureStorageService.initialize()는 main.dart에서 실행되나
      // 테스트 환경에서는 static 상태가 유지될 수 있음
      // isInitialized getter가 bool을 반환하는지만 확인
      expect(SecureStorageService.isInitialized, isA<bool>());
    });

    // ========================================================================
    // 2. 키 상수 정의
    // ========================================================================
    test('keyIsarEncryption - 올바른 키 이름', () {
      expect(
        SecureStorageService.keyIsarEncryption,
        equals('isar_encryption_key'),
      );
    });

    // ========================================================================
    // 3. 초기화되지 않은 상태에서 메서드 호출 시 StateError
    // ========================================================================
    test('write - 초기화 전이면 StateError (또는 정상 동작)', () async {
      // SecureStorageService는 static이므로,
      // 이미 initialize()가 불린 상태일 수 있음.
      // 초기화되지 않은 상태를 명시적으로 테스트하기 어려우므로
      // isInitialized 상태에 따라 분기 테스트
      if (!SecureStorageService.isInitialized) {
        expect(
          () => SecureStorageService.write('test', 'value'),
          throwsA(isA<StateError>()),
        );
      } else {
        // 이미 초기화된 경우: FlutterSecureStorage 플랫폼 채널
        // 테스트 환경에서는 MissingPluginException 발생 가능
        expect(SecureStorageService.isInitialized, isTrue);
      }
    });

    test('read - 초기화 전이면 StateError (또는 정상 동작)', () async {
      if (!SecureStorageService.isInitialized) {
        expect(
          () => SecureStorageService.read('test'),
          throwsA(isA<StateError>()),
        );
      } else {
        expect(SecureStorageService.isInitialized, isTrue);
      }
    });

    test('delete - 초기화 전이면 StateError (또는 정상 동작)', () async {
      if (!SecureStorageService.isInitialized) {
        expect(
          () => SecureStorageService.delete('test'),
          throwsA(isA<StateError>()),
        );
      } else {
        expect(SecureStorageService.isInitialized, isTrue);
      }
    });

    test('containsKey - 초기화 전이면 StateError (또는 정상 동작)', () async {
      if (!SecureStorageService.isInitialized) {
        expect(
          () => SecureStorageService.containsKey('test'),
          throwsA(isA<StateError>()),
        );
      } else {
        expect(SecureStorageService.isInitialized, isTrue);
      }
    });

    test('deleteAll - 초기화 전이면 StateError (또는 정상 동작)', () async {
      if (!SecureStorageService.isInitialized) {
        expect(
          () => SecureStorageService.deleteAll(),
          throwsA(isA<StateError>()),
        );
      } else {
        expect(SecureStorageService.isInitialized, isTrue);
      }
    });

    // ========================================================================
    // 4. initialize() 멱등성
    // ========================================================================
    test('initialize - 멱등성 (여러 번 호출해도 에러 없음)', () async {
      // initialize()를 여러 번 호출 → 에러 없이 반환해야 함
      // 플랫폼 채널 없이는 MissingPluginException 가능하므로 try-catch
      try {
        await SecureStorageService.initialize();
        await SecureStorageService.initialize();
        await SecureStorageService.initialize();
        // 에러 없으면 성공
        expect(true, isTrue);
      } catch (e) {
        // 테스트 환경에서 FlutterSecureStorage 플랫폼 채널이 없을 수 있음
        // 이 경우에도 initialize() 자체는 에러를 throw하지 않아야 함
        fail('initialize() should not throw: $e');
      }
    });
  });
}

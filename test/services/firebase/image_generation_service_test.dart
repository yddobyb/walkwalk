// test/services/firebase/image_generation_service_test.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/firebase/image_generation_service.dart';

void main() {
  group('ImageGenerationService Tests', () {
    // Note: ImageGenerationService는 Firebase Functions에 의존하므로
    // 실제 생성 로직은 통합 테스트 또는 수동 테스트로 진행합니다.
    // 여기서는 유틸리티 메서드와 예외 클래스만 단위 테스트합니다.

    group('Base64 유틸리티 테스트', () {
      test('Base64 인코딩/디코딩 동작 확인', () {
        // Given
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final base64String = base64Encode(testBytes);

        // When
        final decoded = base64Decode(base64String);

        // Then
        expect(decoded, equals(testBytes));
      });

      test('잘못된 Base64 문자열 디코딩 시 FormatException', () {
        // Given
        const invalidBase64 = 'this-is-not-valid-base64!!!';

        // Then
        expect(
          () => base64Decode(invalidBase64),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });

  group('ImageGenerationException', () {
    test('코드와 메시지로 생성', () {
      // Given
      const code = 'test-error';
      const message = 'Test error message';

      // When
      final exception = ImageGenerationException(code: code, message: message);

      // Then
      expect(exception.code, code);
      expect(exception.message, message);
      expect(exception.details, isNull);
      expect(exception.toString(), contains(code));
      expect(exception.toString(), contains(message));
    });

    test('details 포함하여 생성', () {
      // Given
      const code = 'test-error';
      const message = 'Test error message';
      const details = {'key': 'value'};

      // When
      final exception = ImageGenerationException(
        code: code,
        message: message,
        details: details,
      );

      // Then
      expect(exception.code, code);
      expect(exception.message, message);
      expect(exception.details, details);
    });

    test('사용자 친화적 메시지 반환', () {
      // Given
      final exception = ImageGenerationException(
        code: 'offline',
        message: 'Network error',
      );

      // When
      final userMessage = exception.userMessage;

      // Then
      expect(userMessage, contains('인터넷 연결'));
    });
  });
}

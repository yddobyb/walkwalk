// test/services/firebase/quota_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/firebase/quota_service.dart';

void main() {
  group('QuotaService Tests', () {
    // Note: QuotaService는 Firebase Functions에 의존하므로
    // 실제 API 테스트는 통합 테스트 또는 수동 테스트로 진행합니다.
    // 여기서는 예외 클래스만 단위 테스트합니다.

    group('QuotaException', () {
      test('코드와 메시지로 생성', () {
        // Given
        const code = 'test-error';
        const message = 'Test error message';

        // When
        final exception = QuotaException(code: code, message: message);

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
        final exception = QuotaException(
          code: code,
          message: message,
          details: details,
        );

        // Then
        expect(exception.code, code);
        expect(exception.message, message);
        expect(exception.details, details);
      });

      test('사용자 친화적 메시지 반환 - unauthenticated', () {
        // Given
        final exception = QuotaException(
          code: 'unauthenticated',
          message: 'Auth error',
        );

        // When
        final userMessage = exception.userMessage;

        // Then
        expect(userMessage, contains('로그인'));
      });

      test('사용자 친화적 메시지 반환 - internal', () {
        // Given
        final exception = QuotaException(
          code: 'internal',
          message: 'Server error',
        );

        // When
        final userMessage = exception.userMessage;

        // Then
        expect(userMessage, contains('할당량 조회'));
        expect(userMessage, contains('실패'));
      });

      test('사용자 친화적 메시지 반환 - 알 수 없는 에러', () {
        // Given
        final exception = QuotaException(
          code: 'unknown-code',
          message: 'Unknown error',
        );

        // When
        final userMessage = exception.userMessage;

        // Then
        expect(userMessage, contains('알 수 없는 오류'));
      });
    });
  });
}

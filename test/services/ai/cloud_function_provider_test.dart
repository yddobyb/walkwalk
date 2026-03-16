// test/services/ai/cloud_function_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/ai/providers/cloud_function_provider.dart';
import 'package:walk_dog/services/ai/providers/llm_provider.dart';

/// CloudFunctionProvider 유닛 테스트
///
/// 테스트 항목:
/// 1. Provider 속성 (type, displayName)
/// 2. 초기화 전 상태 검증
/// 3. generateResponse 미초기화 시 예외
/// 4. dispose 동작
///
/// Note: 실제 FirebaseFunctions 호출은 Firebase 초기화 필요 →
/// 여기서는 순수 로직만 검증.
void main() {
  group('CloudFunctionProvider Tests', () {
    late CloudFunctionProvider provider;

    setUp(() {
      provider = CloudFunctionProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    // ========================================================================
    // 1. Provider 속성
    // ========================================================================
    test('type - LlmProviderType.cloudFunction', () {
      expect(provider.type, equals(LlmProviderType.cloudFunction));
    });

    test('displayName - Cloud Function (server-side)', () {
      expect(
        provider.displayName,
        equals('Cloud Function (server-side)'),
      );
    });

    // ========================================================================
    // 2. 초기화 전 상태
    // ========================================================================
    test('isInitialized - 초기 상태 false', () {
      expect(provider.isInitialized, isFalse);
    });

    // ========================================================================
    // 3. generateResponse - 미초기화 시 예외
    // ========================================================================
    test('generateResponse - 초기화 전 호출 시 Exception', () async {
      expect(
        () => provider.generateResponse(
          systemPrompt: 'test',
          userMessage: 'hello',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('generateResponse - 초기화 전 호출 시 올바른 에러 메시지', () async {
      try {
        await provider.generateResponse(
          systemPrompt: 'test',
          userMessage: 'hello',
        );
        fail('Should have thrown');
      } catch (e) {
        expect(
          e.toString(),
          contains('CloudFunctionProvider not initialized'),
        );
      }
    });

    // ========================================================================
    // 4. dispose
    // ========================================================================
    test('dispose - isInitialized가 false로 리셋', () {
      // dispose 호출 후 isInitialized가 false인지 확인
      provider.dispose();
      expect(provider.isInitialized, isFalse);
    });

    test('dispose 후 generateResponse - Exception', () async {
      provider.dispose();
      expect(
        () => provider.generateResponse(
          systemPrompt: 'test',
          userMessage: 'hello',
        ),
        throwsA(isA<Exception>()),
      );
    });

    // ========================================================================
    // 5. LlmProvider 인터페이스 준수
    // ========================================================================
    test('LlmProvider 추상 클래스 구현', () {
      expect(provider, isA<LlmProvider>());
    });

    // ========================================================================
    // 6. 새 인스턴스는 독립적
    // ========================================================================
    test('별도 인스턴스는 상태 공유 안함', () {
      final provider2 = CloudFunctionProvider();

      expect(provider.isInitialized, isFalse);
      expect(provider2.isInitialized, isFalse);

      provider2.dispose();
    });

    // ========================================================================
    // 7. generateResponse 파라미터 기본값
    // ========================================================================
    test('generateResponse - maxTokens, temperature 기본값 처리', () async {
      // 초기화 안 된 상태에서 기본값 파라미터 전달 → 에러 확인
      // (초기화 체크가 파라미터 처리보다 먼저)
      expect(
        () => provider.generateResponse(
          systemPrompt: 'system',
          userMessage: 'user',
          maxTokens: null,
          temperature: null,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}

// test/services/ai/cloud_function_chain_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walk_dog/services/ai/ai_providers.dart';
import 'package:walk_dog/services/ai/providers/cloud_function_provider.dart';
import 'package:walk_dog/services/ai/providers/llm_provider.dart';

/// CloudFunction이 Provider 체인에 올바르게 통합되었는지 검증
///
/// 보안 강화: 클라이언트 직접 호출 제거 후 CloudFunction만 사용
///
/// 테스트 항목:
/// 1. CloudFunctionProvider가 유일한 Provider
/// 2. 서버에서 OpenRouter → Groq → Gemini 폴백 처리
/// 3. Provider가 LlmProvider 인터페이스 준수
void main() {
  group('LLM Provider Chain - CloudFunction Only (Server-Side)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    // ========================================================================
    // 1. 체인 구성
    // ========================================================================
    test('Provider 체인 - CloudFunctionProvider만 존재', () {
      final chain = container.read(llmProviderChainProvider);
      expect(chain.length, equals(1));
      expect(chain[0], isA<CloudFunctionProvider>());
    });

    test('Provider 체인 - CloudFunction 타입 확인', () {
      final chain = container.read(llmProviderChainProvider);
      expect(chain[0].type, equals(LlmProviderType.cloudFunction));
    });

    // ========================================================================
    // 2. Provider가 LlmProvider 인터페이스 준수
    // ========================================================================
    test('CloudFunctionProvider - LlmProvider 인터페이스 준수', () {
      final chain = container.read(llmProviderChainProvider);
      final provider = chain[0];

      expect(provider, isA<LlmProvider>());
      expect(provider.type, isA<LlmProviderType>());
      expect(provider.displayName, isA<String>());
      expect(provider.displayName.isNotEmpty, isTrue);
      expect(provider.isInitialized, isA<bool>());
    });

    // ========================================================================
    // 3. CloudFunctionProvider 속성
    // ========================================================================
    test('CloudFunctionProvider - displayName 확인', () {
      final chain = container.read(llmProviderChainProvider);
      final cfProvider = chain[0];
      expect(
        cfProvider.displayName,
        equals('Cloud Function (server-side)'),
      );
    });

    test('CloudFunctionProvider - 초기 상태 미초기화', () {
      final chain = container.read(llmProviderChainProvider);
      final cfProvider = chain[0];
      expect(cfProvider.isInitialized, isFalse);
    });
  });
}

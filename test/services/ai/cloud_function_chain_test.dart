// test/services/ai/cloud_function_chain_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walk_dog/services/ai/ai_providers.dart';
import 'package:walk_dog/services/ai/providers/cloud_function_provider.dart';
import 'package:walk_dog/services/ai/providers/llm_provider.dart';

/// CloudFunction이 Provider 체인에 올바르게 통합되었는지 검증
///
/// 테스트 항목:
/// 1. CloudFunctionProvider가 체인 첫 번째
/// 2. 총 4개 Provider (CF → OpenRouter → Groq → Gemini)
/// 3. 모든 Provider가 LlmProvider 인터페이스 준수
void main() {
  group('LLM Provider Chain - CloudFunction Integration', () {
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
    test('Provider 체인 - 4개 Provider 존재', () {
      final chain = container.read(llmProviderChainProvider);
      expect(chain.length, equals(4));
    });

    test('Provider 체인 - CloudFunctionProvider가 첫 번째', () {
      final chain = container.read(llmProviderChainProvider);
      expect(chain[0], isA<CloudFunctionProvider>());
      expect(chain[0].type, equals(LlmProviderType.cloudFunction));
    });

    test('Provider 체인 - 순서: CF → OpenRouter → Groq → Gemini', () {
      final chain = container.read(llmProviderChainProvider);

      expect(chain[0].type, equals(LlmProviderType.cloudFunction));
      expect(chain[1].type, equals(LlmProviderType.openRouter));
      expect(chain[2].type, equals(LlmProviderType.groq));
      expect(chain[3].type, equals(LlmProviderType.gemini));
    });

    // ========================================================================
    // 2. 모든 Provider가 LlmProvider 인터페이스 준수
    // ========================================================================
    test('모든 Provider - LlmProvider 인터페이스 준수', () {
      final chain = container.read(llmProviderChainProvider);

      for (final provider in chain) {
        expect(provider, isA<LlmProvider>());
        expect(provider.type, isA<LlmProviderType>());
        expect(provider.displayName, isA<String>());
        expect(provider.displayName.isNotEmpty, isTrue);
        expect(provider.isInitialized, isA<bool>());
      }
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

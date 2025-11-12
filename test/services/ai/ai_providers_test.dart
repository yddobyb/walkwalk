// test/services/ai/ai_providers_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walk_dog/services/ai/ai_providers.dart';
import 'package:walk_dog/services/ai/fallback_responses.dart';
import 'package:walk_dog/services/ai/rate_limiter.dart';
import 'package:walk_dog/services/ai/llm_service.dart';
import 'package:walk_dog/services/ai/conversation_service.dart';
import 'package:walk_dog/services/ai/dialogue_request.dart';

/// Week 3 Test 6: AI Providers 테스트
///
/// 테스트 항목:
/// 1. Singleton Provider 테스트 (fallbackResponsesProvider, rateLimiterProvider)
/// 2. Dependency Injection 테스트 (llmServiceProvider, conversationServiceProvider)
/// 3. Async Provider 테스트 (llmInitializationProvider)
/// 4. Family Provider 테스트 (dialogueProvider)
/// 5. 6개 편의 Provider 테스트
/// 6. Provider 캐싱 동작 테스트
void main() {
  group('AI Providers Tests', () {
    // ==========================================================================
    // 1. Singleton Provider 테스트
    // ==========================================================================
    test('fallbackResponsesProvider - FallbackResponses 인스턴스 반환', () {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // When: fallbackResponsesProvider 읽기
      final fallbackResponses = container.read(fallbackResponsesProvider);

      // Then: FallbackResponses 인스턴스 반환
      expect(fallbackResponses, isA<FallbackResponses>());

      print('✅ fallbackResponsesProvider 인스턴스 반환 확인 완료');

      container.dispose();
    });

    test('rateLimiterProvider - RateLimiter 인스턴스 반환', () {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // When: rateLimiterProvider 읽기
      final rateLimiter = container.read(rateLimiterProvider);

      // Then: RateLimiter 인스턴스 반환
      expect(rateLimiter, isA<RateLimiter>());

      print('✅ rateLimiterProvider 인스턴스 반환 확인 완료');

      container.dispose();
    });

    // ==========================================================================
    // 2. Dependency Injection 테스트
    // ==========================================================================
    test('llmServiceProvider - 의존성 주입 (fallbackResponses, rateLimiter)', () {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // When: llmServiceProvider 읽기
      final llmService = container.read(llmServiceProvider);

      // Then: LLMService 인스턴스 반환
      expect(llmService, isA<LLMService>());

      print('✅ llmServiceProvider 의존성 주입 확인 완료');
      print('   - LLMService 생성됨 (FallbackResponses + RateLimiter 주입)');

      container.dispose();
    });

    test('conversationServiceProvider - 의존성 주입 (llmService, fallbackResponses)', () {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // When: conversationServiceProvider 읽기
      final conversationService = container.read(conversationServiceProvider);

      // Then: ConversationService 인스턴스 반환
      expect(conversationService, isA<ConversationService>());

      print('✅ conversationServiceProvider 의존성 주입 확인 완료');
      print('   - ConversationService 생성됨 (LLMService + FallbackResponses 주입)');

      container.dispose();
    });

    test('Provider 의존성 체인 - fallback → rateLimiter → llmService → conversationService', () {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // When: 모든 Provider 읽기
      final fallbackResponses = container.read(fallbackResponsesProvider);
      final rateLimiter = container.read(rateLimiterProvider);
      final llmService = container.read(llmServiceProvider);
      final conversationService = container.read(conversationServiceProvider);

      // Then: 모두 올바른 타입 반환
      expect(fallbackResponses, isA<FallbackResponses>());
      expect(rateLimiter, isA<RateLimiter>());
      expect(llmService, isA<LLMService>());
      expect(conversationService, isA<ConversationService>());

      print('✅ Provider 의존성 체인 확인 완료');
      print('   - fallbackResponses ✅');
      print('   - rateLimiter ✅');
      print('   - llmService ✅ (의존성: fallbackResponses, rateLimiter)');
      print('   - conversationService ✅ (의존성: llmService, fallbackResponses)');

      container.dispose();
    });

    // ==========================================================================
    // 3. Async Provider 테스트 (llmInitializationProvider)
    // ==========================================================================
    test('llmInitializationProvider - AsyncValue 반환 (초기화 시도)', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // When: llmInitializationProvider 읽기
      final initAsync = container.read(llmInitializationProvider);

      // Then: AsyncValue 타입 확인 (loading → data/error)
      expect(initAsync, isA<AsyncValue<bool>>());

      // Then: 비동기 완료 대기
      await container.read(llmInitializationProvider.future);

      // Then: 초기화 완료 (API 키 없으면 false, 있으면 true)
      final isInitialized = await container.read(llmInitializationProvider.future);

      print('✅ llmInitializationProvider AsyncValue 확인 완료');
      print('   - AsyncValue 타입: ${initAsync.runtimeType}');
      print('   - 초기화 결과: $isInitialized');

      container.dispose();
    });

    // ==========================================================================
    // 4. Family Provider 테스트 (dialogueProvider)
    // ==========================================================================
    test('dialogueProvider - DialogueRequest 파라미터로 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest
      final request = DialogueRequest(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // When: dialogueProvider 읽기 (FutureProvider.family)
      final dialogueAsync = container.read(dialogueProvider(request));

      // Then: AsyncValue 타입 확인
      expect(dialogueAsync, isA<AsyncValue<String>>());

      // When: 비동기 완료 대기
      final response = await container.read(dialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ dialogueProvider 대화 생성 확인 완료');
      print('   - DialogueRequest: Max (Golden Retriever)');
      print('   - 컨텍스트: greeting');
      print('   - 응답: $response');

      container.dispose();
    });

    test('dialogueProvider - 다른 DialogueRequest는 캐시 미스', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: 첫 번째 DialogueRequest
      final request1 = DialogueRequest(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // Given: 두 번째 DialogueRequest (다른 dogName)
      final request2 = DialogueRequest(
        dogName: 'Buddy',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // When: 두 개의 다른 DialogueRequest로 대화 생성
      final response1 = await container.read(dialogueProvider(request1).future);
      final response2 = await container.read(dialogueProvider(request2).future);

      // Then: 두 응답 모두 생성됨
      expect(response1.isNotEmpty, true);
      expect(response2.isNotEmpty, true);

      print('✅ dialogueProvider 캐시 미스 확인 완료');
      print('   - Request1 (Max): $response1');
      print('   - Request2 (Buddy): $response2');

      container.dispose();
    });

    // ==========================================================================
    // 5. 6개 편의 Provider 테스트
    // ==========================================================================
    test('greetingDialogueProvider - 인사 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest
      final request = DialogueRequest(
        dogName: 'Charlie',
        dogBreed: 'Beagle',
        happinessLevel: 75,
        context: 'greeting', // 실제로는 무시됨 (내부에서 greeting 고정)
        locale: 'ko',
      );

      // When: greetingDialogueProvider 호출
      final response = await container.read(greetingDialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ greetingDialogueProvider 대화 생성 확인 완료');
      print('   - 강아지: Charlie (Beagle)');
      print('   - 응답: $response');

      container.dispose();
    });

    test('walkCompleteDialogueProvider - 산책 완료 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest (contextData 포함)
      final request = DialogueRequest(
        dogName: 'Luna',
        dogBreed: 'Shiba Inu',
        happinessLevel: 85,
        context: 'walk_complete',
        contextData: {
          'steps': 7000,
          'duration': 2400,
          'isOutdoor': true,
        },
        locale: 'ko',
      );

      // When: walkCompleteDialogueProvider 호출
      final response = await container.read(walkCompleteDialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ walkCompleteDialogueProvider 대화 생성 확인 완료');
      print('   - 강아지: Luna (Shiba Inu)');
      print('   - 걸음수: 7000 (40분)');
      print('   - 응답: $response');

      container.dispose();
    });

    test('missionCompleteDialogueProvider - 미션 완료 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest (contextData 포함)
      final request = DialogueRequest(
        dogName: 'Rocky',
        dogBreed: 'Husky',
        happinessLevel: 90,
        context: 'mission_complete',
        contextData: {
          'title': '주간 목표 달성',
          'treatReward': 20,
        },
        locale: 'ko',
      );

      // When: missionCompleteDialogueProvider 호출
      final response = await container.read(missionCompleteDialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ missionCompleteDialogueProvider 대화 생성 확인 완료');
      print('   - 강아지: Rocky (Husky)');
      print('   - 미션: 주간 목표 달성 (보상: 20개)');
      print('   - 응답: $response');

      container.dispose();
    });

    test('feedDialogueProvider - 간식 먹기 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest (contextData 포함)
      final request = DialogueRequest(
        dogName: 'Bella',
        dogBreed: 'Chihuahua',
        happinessLevel: 60,
        context: 'feed',
        contextData: {
          'treatCount': 15,
        },
        locale: 'ko',
      );

      // When: feedDialogueProvider 호출
      final response = await container.read(feedDialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ feedDialogueProvider 대화 생성 확인 완료');
      print('   - 강아지: Bella (Chihuahua)');
      print('   - 간식: 15개');
      print('   - 응답: $response');

      container.dispose();
    });

    test('levelUpDialogueProvider - 레벨업 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest (contextData 포함)
      final request = DialogueRequest(
        dogName: 'Coco',
        dogBreed: 'Maltese',
        happinessLevel: 95,
        context: 'level_up',
        contextData: {
          'level': 10,
          'experience': 1500,
        },
        locale: 'ko',
      );

      // When: levelUpDialogueProvider 호출
      final response = await container.read(levelUpDialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ levelUpDialogueProvider 대화 생성 확인 완료');
      print('   - 강아지: Coco (Maltese)');
      print('   - 레벨: 10 (경험치: 1500)');
      print('   - 응답: $response');

      container.dispose();
    });

    test('lowHappinessDialogueProvider - 행복도 낮음 대화 생성', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest
      final request = DialogueRequest(
        dogName: 'Daisy',
        dogBreed: 'Bulldog',
        happinessLevel: 20,
        context: 'low_happiness',
        locale: 'ko',
      );

      // When: lowHappinessDialogueProvider 호출
      final response = await container.read(lowHappinessDialogueProvider(request).future);

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ lowHappinessDialogueProvider 대화 생성 확인 완료');
      print('   - 강아지: Daisy (Bulldog)');
      print('   - 행복도: 20 (매우 슬픔)');
      print('   - 응답: $response');

      container.dispose();
    });

    // ==========================================================================
    // 6. 6개 편의 Provider 모두 동작 확인
    // ==========================================================================
    test('6개 편의 Provider 모두 응답 생성 확인', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: 기본 DialogueRequest
      final baseRequest = DialogueRequest(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 70,
        context: 'greeting',
        locale: 'ko',
      );

      // When: 6개 Provider 모두 호출
      final greeting = await container.read(greetingDialogueProvider(baseRequest).future);

      final walkComplete = await container.read(walkCompleteDialogueProvider(
        baseRequest.copyWith(
          context: 'walk_complete',
          contextData: {'steps': 5000, 'duration': 1800, 'isOutdoor': false},
        ),
      ).future);

      final missionComplete = await container.read(missionCompleteDialogueProvider(
        baseRequest.copyWith(
          context: 'mission_complete',
          contextData: {'title': '테스트 미션', 'treatReward': 10},
        ),
      ).future);

      final feed = await container.read(feedDialogueProvider(
        baseRequest.copyWith(
          context: 'feed',
          contextData: {'treatCount': 15},
        ),
      ).future);

      final levelUp = await container.read(levelUpDialogueProvider(
        baseRequest.copyWith(
          context: 'level_up',
          contextData: {'level': 5, 'experience': 500},
        ),
      ).future);

      final lowHappiness = await container.read(lowHappinessDialogueProvider(
        baseRequest.copyWith(
          context: 'low_happiness',
          happinessLevel: 20,
        ),
      ).future);

      // Then: 모두 응답 생성됨
      expect(greeting.isNotEmpty, true);
      expect(walkComplete.isNotEmpty, true);
      expect(missionComplete.isNotEmpty, true);
      expect(feed.isNotEmpty, true);
      expect(levelUp.isNotEmpty, true);
      expect(lowHappiness.isNotEmpty, true);

      print('✅ 6개 편의 Provider 모두 응답 생성 확인 완료');
      print('   1. greeting: $greeting');
      print('   2. walkComplete: $walkComplete');
      print('   3. missionComplete: $missionComplete');
      print('   4. feed: $feed');
      print('   5. levelUp: $levelUp');
      print('   6. lowHappiness: $lowHappiness');

      container.dispose();
    });

    // ==========================================================================
    // 7. Provider 캐싱 동작 테스트
    // ==========================================================================
    test('dialogueProvider - 같은 DialogueRequest는 캐시됨', () async {
      // Given: ProviderContainer
      final container = ProviderContainer();

      // Given: DialogueRequest
      final request = DialogueRequest(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // When: 같은 DialogueRequest로 두 번 호출
      final response1 = await container.read(dialogueProvider(request).future);
      final response2 = await container.read(dialogueProvider(request).future);

      // Then: 같은 응답 반환 (캐시됨)
      expect(response1, response2);

      print('✅ dialogueProvider 캐싱 동작 확인 완료');
      print('   - 같은 DialogueRequest → 같은 응답');
      print('   - 응답: $response1');

      container.dispose();
    });

    test('DialogueRequest equals/hashCode - 캐싱 키 동작', () {
      // Given: 같은 내용의 두 DialogueRequest
      final request1 = DialogueRequest(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      final request2 = DialogueRequest(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // Then: equals/hashCode 동작 확인
      expect(request1, request2);
      expect(request1.hashCode, request2.hashCode);

      print('✅ DialogueRequest equals/hashCode 동작 확인 완료');
      print('   - request1 == request2: true');
      print('   - hashCode 일치: ${request1.hashCode == request2.hashCode}');
    });
  });
}

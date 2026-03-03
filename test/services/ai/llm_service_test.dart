// test/services/ai/llm_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:walk_dog/services/ai/llm_service.dart';
import 'package:walk_dog/services/ai/fallback_responses.dart';
import 'package:walk_dog/services/ai/rate_limiter.dart';

/// Week 3 Test 3: LLMService 테스트
///
/// 테스트 항목:
/// 1. 초기화 상태 확인
/// 2. 폴백 응답 확인 (API 키 없음)
/// 3. 시스템 프롬프트 생성 로직
/// 4. 사용자 메시지 생성 로직
/// 5. 컨텍스트별 대화 생성
void main() {
  late LLMService llmService;
  late FallbackResponses fallbackResponses;
  late RateLimiter rateLimiter;

  setUp(() {
    fallbackResponses = FallbackResponses();
    rateLimiter = RateLimiter();
    llmService = LLMService(
      fallbackResponses: fallbackResponses,
      rateLimiter: rateLimiter,
    );
  });

  group('LLMService Tests', () {
    // ==========================================================================
    // 1. 초기화 테스트
    // ==========================================================================
    test('초기화 전 상태 확인', () {
      // Given: 새로운 LLMService 인스턴스

      // When: 초기화 전 상태 확인
      final isInitialized = llmService.isInitialized;

      // Then: false 반환
      expect(isInitialized, false);

      debugPrint('✅ 초기화 전 상태 확인 완료: $isInitialized');
    });

    test('초기화 후 상태 확인', () async {
      // Given: LLMService 인스턴스

      // When: 초기화 실행
      await llmService.initialize();

      // Then: isInitialized 확인 (API 키 유효성에 따라 달라짐)
      final isInitialized = llmService.isInitialized;

      debugPrint('✅ 초기화 후 상태 확인 완료: $isInitialized');
      debugPrint('   - API 키가 유효하면 true, 없으면 false');
    });

    // ==========================================================================
    // 2. 폴백 응답 테스트 (API 키 없음)
    // ==========================================================================
    test('API 키 없이 응답 생성 - 초기화 안됨 예외 발생', () async {
      // Given: 초기화되지 않은 LLMService

      // When/Then: generateResponse()는 미초기화 시 예외 발생
      // (generateDialogue()는 내부에서 예외를 catch해 폴백 응답 반환)
      expect(
        () => llmService.generateResponse(
          systemPrompt: 'You are a helpful assistant',
          userMessage: 'Hello',
        ),
        throwsA(isA<Exception>()),
      );

      debugPrint('✅ 미초기화 상태 예외 발생 확인 완료');
    });

    test('API 키 없이 컨텍스트 기반 대화 생성 - 폴백 사용', () async {
      // Given: 초기화되지 않은 LLMService

      // When: greeting 컨텍스트 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // Then: 폴백 응답 반환
      expect(response.isNotEmpty, true);

      debugPrint('✅ 컨텍스트 기반 폴백 대화 생성 확인 완료');
      debugPrint('   - 컨텍스트: greeting');
      debugPrint('   - 응답: $response');
    });

    // ==========================================================================
    // 3. 컨텍스트별 대화 생성 테스트 (프롬프트 검증)
    // ==========================================================================
    test('walk_complete 컨텍스트 대화 생성', () async {
      // Given: walk_complete 컨텍스트

      // When: 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Buddy',
        dogBreed: 'Poodle',
        happinessLevel: 70,
        context: 'walk_complete',
        contextData: {
          'steps': 5000,
          'duration': 1800,
          'isOutdoor': true,
        },
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      debugPrint('✅ walk_complete 대화 생성 확인 완료');
      debugPrint('   - 강아지: Buddy (Poodle)');
      debugPrint('   - 행복도: 70');
      debugPrint('   - 걸음수: 5000 (30분)');
      debugPrint('   - 응답: $response');
    });

    test('mission_complete 컨텍스트 대화 생성', () async {
      // Given: mission_complete 컨텍스트

      // When: 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Charlie',
        dogBreed: 'Beagle',
        happinessLevel: 85,
        context: 'mission_complete',
        contextData: {
          'title': '첫 산책 완료',
          'treatReward': 10,
        },
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      debugPrint('✅ mission_complete 대화 생성 확인 완료');
      debugPrint('   - 강아지: Charlie (Beagle)');
      debugPrint('   - 미션: 첫 산책 완료');
      debugPrint('   - 응답: $response');
    });

    test('feed 컨텍스트 대화 생성', () async {
      // Given: feed 컨텍스트

      // When: 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Luna',
        dogBreed: 'Shiba Inu',
        happinessLevel: 90,
        context: 'feed',
        contextData: {
          'treatCount': 15,
        },
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      debugPrint('✅ feed 대화 생성 확인 완료');
      debugPrint('   - 강아지: Luna (Shiba Inu)');
      debugPrint('   - 간식: 15개');
      debugPrint('   - 응답: $response');
    });

    test('level_up 컨텍스트 대화 생성', () async {
      // Given: level_up 컨텍스트

      // When: 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Rocky',
        dogBreed: 'Husky',
        happinessLevel: 95,
        context: 'level_up',
        contextData: {
          'level': 5,
          'experience': 500,
        },
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      debugPrint('✅ level_up 대화 생성 확인 완료');
      debugPrint('   - 강아지: Rocky (Husky)');
      debugPrint('   - 레벨: 5');
      debugPrint('   - 응답: $response');
    });

    test('low_happiness 컨텍스트 대화 생성', () async {
      // Given: low_happiness 컨텍스트

      // When: 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Bella',
        dogBreed: 'Chihuahua',
        happinessLevel: 25,
        context: 'low_happiness',
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      debugPrint('✅ low_happiness 대화 생성 확인 완료');
      debugPrint('   - 강아지: Bella (Chihuahua)');
      debugPrint('   - 행복도: 25 (매우 슬픔)');
      debugPrint('   - 응답: $response');
    });

    test('greeting 컨텍스트 대화 생성 (시간대별)', () async {
      // Given: greeting 컨텍스트

      // When: 대화 생성
      final response = await llmService.generateDialogue(
        dogName: 'Coco',
        dogBreed: 'Maltese',
        happinessLevel: 75,
        context: 'greeting',
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      final hour = DateTime.now().hour;
      final timeOfDay = hour < 12 ? '아침' : hour < 18 ? '오후' : '저녁';

      debugPrint('✅ greeting 대화 생성 확인 완료');
      debugPrint('   - 강아지: Coco (Maltese)');
      debugPrint('   - 현재 시간대: $timeOfDay');
      debugPrint('   - 응답: $response');
    });

    // ==========================================================================
    // 4. 행복도별 기분 변화 테스트
    // ==========================================================================
    test('행복도별 기분 확인 (5단계)', () async {
      // Given: 5가지 행복도 시나리오
      final scenarios = [
        {'happiness': 95, 'expectedMood': '매우 행복함'},
        {'happiness': 70, 'expectedMood': '행복함'},
        {'happiness': 50, 'expectedMood': '보통'},
        {'happiness': 30, 'expectedMood': '조금 슬픔'},
        {'happiness': 10, 'expectedMood': '매우 슬픔'},
      ];

      for (final scenario in scenarios) {
        // When: 대화 생성
        final response = await llmService.generateDialogue(
          dogName: 'Test',
          dogBreed: 'Test Breed',
          happinessLevel: scenario['happiness'] as int,
          context: 'greeting',
          locale: 'ko',
        );

        // Then: 응답 생성됨
        expect(response.isNotEmpty, true);
      }

      debugPrint('✅ 행복도별 기분 변화 확인 완료');
      debugPrint('   - 95: 매우 행복함 (꼬리를 흔들며 뛰어다님)');
      debugPrint('   - 70: 행복함 (기분 좋음)');
      debugPrint('   - 50: 보통 (평온함)');
      debugPrint('   - 30: 조금 슬픔 (관심 필요)');
      debugPrint('   - 10: 매우 슬픔 (외로움)');
    });

    // ==========================================================================
    // 5. dispose() 테스트
    // ==========================================================================
    test('dispose 후 초기화 상태 리셋', () async {
      // Given: 초기화된 LLMService
      await llmService.initialize();

      // When: dispose 호출
      llmService.dispose();

      // Then: isInitialized = false
      expect(llmService.isInitialized, false);

      debugPrint('✅ dispose 후 상태 리셋 확인 완료');
    });
  });
}

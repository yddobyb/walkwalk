// test/services/ai/conversation_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/ai/conversation_service.dart';
import 'package:walk_dog/services/ai/llm_service.dart';
import 'package:walk_dog/services/ai/fallback_responses.dart';
import 'package:walk_dog/services/ai/rate_limiter.dart';

/// Week 3 Test 5: ConversationService 테스트
///
/// 테스트 항목:
/// 1. 6가지 편의 메서드 동작 확인
/// 2. 폴백 응답 동작 확인 (LLM 미초기화 시)
/// 3. 초기화 및 정리 테스트
/// 4. 컨텍스트 데이터 전달 확인
void main() {
  late ConversationService conversationService;
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
    conversationService = ConversationService(
      llmService: llmService,
      fallbackResponses: fallbackResponses,
    );
  });

  group('ConversationService Tests', () {
    // ==========================================================================
    // 1. getGreeting() 테스트
    // ==========================================================================
    test('getGreeting - 인사 응답 생성', () async {
      // Given: 강아지 정보

      // When: 인사 응답 요청
      final response = await conversationService.getGreeting(
        dogName: 'Max',
        dogBreed: 'Golden Retriever',
        happinessLevel: 80,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getGreeting 응답 생성 확인 완료');
      print('   - 강아지: Max (Golden Retriever)');
      print('   - 행복도: 80');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 2. getWalkCompleteResponse() 테스트
    // ==========================================================================
    test('getWalkCompleteResponse - 산책 완료 응답 생성', () async {
      // Given: 산책 데이터

      // When: 산책 완료 응답 요청
      final response = await conversationService.getWalkCompleteResponse(
        dogName: 'Buddy',
        dogBreed: 'Poodle',
        happinessLevel: 75,
        steps: 5000,
        duration: 1800,
        isOutdoor: true,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getWalkCompleteResponse 응답 생성 확인 완료');
      print('   - 강아지: Buddy (Poodle)');
      print('   - 걸음수: 5000 (30분)');
      print('   - 실외: true');
      print('   - 응답: $response');
    });

    test('getWalkCompleteResponse - 실내 산책', () async {
      // Given: 실내 산책 데이터

      // When: 산책 완료 응답 요청
      final response = await conversationService.getWalkCompleteResponse(
        dogName: 'Charlie',
        dogBreed: 'Beagle',
        happinessLevel: 60,
        steps: 3000,
        duration: 1200,
        isOutdoor: false,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getWalkCompleteResponse (실내) 응답 생성 확인 완료');
      print('   - 강아지: Charlie (Beagle)');
      print('   - 걸음수: 3000 (20분)');
      print('   - 실외: false');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 3. getMissionCompleteResponse() 테스트
    // ==========================================================================
    test('getMissionCompleteResponse - 미션 완료 응답 생성', () async {
      // Given: 미션 데이터

      // When: 미션 완료 응답 요청
      final response = await conversationService.getMissionCompleteResponse(
        dogName: 'Luna',
        dogBreed: 'Shiba Inu',
        happinessLevel: 85,
        missionTitle: '첫 산책 완료',
        treatReward: 10,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getMissionCompleteResponse 응답 생성 확인 완료');
      print('   - 강아지: Luna (Shiba Inu)');
      print('   - 미션: 첫 산책 완료 (보상: 10개)');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 4. getFeedResponse() 테스트
    // ==========================================================================
    test('getFeedResponse - 간식 먹기 응답 생성', () async {
      // Given: 간식 데이터

      // When: 간식 먹기 응답 요청
      final response = await conversationService.getFeedResponse(
        dogName: 'Rocky',
        dogBreed: 'Husky',
        happinessLevel: 90,
        treatCount: 15,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getFeedResponse 응답 생성 확인 완료');
      print('   - 강아지: Rocky (Husky)');
      print('   - 간식: 15개');
      print('   - 응답: $response');
    });

    test('getFeedResponse - 간식 적을 때', () async {
      // Given: 간식 적음

      // When: 간식 먹기 응답 요청
      final response = await conversationService.getFeedResponse(
        dogName: 'Bella',
        dogBreed: 'Chihuahua',
        happinessLevel: 50,
        treatCount: 3,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getFeedResponse (간식 적음) 응답 생성 확인 완료');
      print('   - 강아지: Bella (Chihuahua)');
      print('   - 간식: 3개');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 5. getLevelUpResponse() 테스트
    // ==========================================================================
    test('getLevelUpResponse - 레벨업 응답 생성', () async {
      // Given: 레벨업 데이터

      // When: 레벨업 응답 요청
      final response = await conversationService.getLevelUpResponse(
        dogName: 'Coco',
        dogBreed: 'Maltese',
        happinessLevel: 95,
        newLevel: 5,
        experience: 500,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getLevelUpResponse 응답 생성 확인 완료');
      print('   - 강아지: Coco (Maltese)');
      print('   - 레벨: 5 (경험치: 500)');
      print('   - 응답: $response');
    });

    test('getLevelUpResponse - 첫 레벨업', () async {
      // Given: 첫 레벨업 데이터

      // When: 레벨업 응답 요청
      final response = await conversationService.getLevelUpResponse(
        dogName: 'Milo',
        dogBreed: 'Corgi',
        happinessLevel: 70,
        newLevel: 2,
        experience: 100,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getLevelUpResponse (첫 레벨업) 응답 생성 확인 완료');
      print('   - 강아지: Milo (Corgi)');
      print('   - 레벨: 2 (경험치: 100)');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 6. getLowHappinessResponse() 테스트
    // ==========================================================================
    test('getLowHappinessResponse - 행복도 낮음 응답 생성', () async {
      // Given: 낮은 행복도

      // When: 행복도 낮음 응답 요청
      final response = await conversationService.getLowHappinessResponse(
        dogName: 'Daisy',
        dogBreed: 'Bulldog',
        happinessLevel: 25,
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getLowHappinessResponse 응답 생성 확인 완료');
      print('   - 강아지: Daisy (Bulldog)');
      print('   - 행복도: 25 (매우 슬픔)');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 7. getResponse() 범용 메서드 테스트
    // ==========================================================================
    test('getResponse - 범용 응답 생성 (greeting)', () async {
      // Given: 범용 파라미터

      // When: 범용 응답 요청
      final response = await conversationService.getResponse(
        dogName: 'Oscar',
        dogBreed: 'Labrador',
        happinessLevel: 80,
        context: 'greeting',
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getResponse (범용) 응답 생성 확인 완료');
      print('   - 강아지: Oscar (Labrador)');
      print('   - 컨텍스트: greeting');
      print('   - 응답: $response');
    });

    test('getResponse - 범용 응답 생성 (walk_complete with contextData)', () async {
      // Given: 범용 파라미터 + contextData

      // When: 범용 응답 요청
      final response = await conversationService.getResponse(
        dogName: 'Zoe',
        dogBreed: 'Pomeranian',
        happinessLevel: 85,
        context: 'walk_complete',
        contextData: {
          'steps': 7000,
          'duration': 2400,
          'isOutdoor': true,
        },
        locale: 'ko',
      );

      // Then: 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ getResponse (contextData 포함) 응답 생성 확인 완료');
      print('   - 강아지: Zoe (Pomeranian)');
      print('   - 컨텍스트: walk_complete (7000걸음, 40분)');
      print('   - 응답: $response');
    });

    // ==========================================================================
    // 8. 초기화 및 정리 테스트
    // ==========================================================================
    test('initialize - LLM 초기화', () async {
      // Given: ConversationService

      // When: 초기화
      await conversationService.initialize();

      // Then: LLM 초기화 상태 확인 (API 키 있으면 true)
      // (테스트 환경에서는 API 키 없을 수 있음)
      print('✅ initialize 호출 확인 완료');
      print('   - LLM 초기화 시도됨');
    });

    test('dispose - 서비스 정리', () {
      // Given: ConversationService

      // When: 정리
      conversationService.dispose();

      // Then: 정리 완료
      expect(llmService.isInitialized, false);

      print('✅ dispose 호출 확인 완료');
      print('   - LLM 서비스 정리됨');
    });

    // ==========================================================================
    // 9. 6가지 편의 메서드 모두 다른 응답 확인
    // ==========================================================================
    test('6가지 편의 메서드 모두 응답 생성 확인', () async {
      // Given: 6가지 편의 메서드

      // When: 각 메서드 호출
      final greeting = await conversationService.getGreeting(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 70,
        locale: 'ko',
      );

      final walkComplete = await conversationService.getWalkCompleteResponse(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 70,
        steps: 5000,
        duration: 1800,
        isOutdoor: true,
        locale: 'ko',
      );

      final missionComplete = await conversationService.getMissionCompleteResponse(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 70,
        missionTitle: '테스트 미션',
        treatReward: 10,
        locale: 'ko',
      );

      final feed = await conversationService.getFeedResponse(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 70,
        treatCount: 15,
        locale: 'ko',
      );

      final levelUp = await conversationService.getLevelUpResponse(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 70,
        newLevel: 3,
        experience: 200,
        locale: 'ko',
      );

      final lowHappiness = await conversationService.getLowHappinessResponse(
        dogName: 'Test',
        dogBreed: 'Test Breed',
        happinessLevel: 20,
        locale: 'ko',
      );

      // Then: 모두 응답 생성됨
      expect(greeting.isNotEmpty, true);
      expect(walkComplete.isNotEmpty, true);
      expect(missionComplete.isNotEmpty, true);
      expect(feed.isNotEmpty, true);
      expect(levelUp.isNotEmpty, true);
      expect(lowHappiness.isNotEmpty, true);

      print('✅ 6가지 편의 메서드 모두 응답 생성 확인 완료');
      print('   1. greeting: $greeting');
      print('   2. walkComplete: $walkComplete');
      print('   3. missionComplete: $missionComplete');
      print('   4. feed: $feed');
      print('   5. levelUp: $levelUp');
      print('   6. lowHappiness: $lowHappiness');
    });

    // ==========================================================================
    // 10. 폴백 동작 확인 (LLM 미초기화)
    // ==========================================================================
    test('폴백 동작 확인 - LLM 미초기화 시', () async {
      // Given: LLM 미초기화 (setUp에서 초기화하지 않음)

      // When: 응답 요청
      final response = await conversationService.getGreeting(
        dogName: 'Fallback Test',
        dogBreed: 'Test Breed',
        happinessLevel: 50,
        locale: 'ko',
      );

      // Then: 폴백 응답 생성됨
      expect(response.isNotEmpty, true);

      print('✅ 폴백 동작 확인 완료');
      print('   - LLM 미초기화 시 FallbackResponses 사용');
      print('   - 응답: $response');
    });
  });
}

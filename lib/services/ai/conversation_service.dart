// lib/services/ai/conversation_service.dart

import 'package:flutter/foundation.dart';

import '../../core/config/api_config.dart';
import 'llm_service.dart';
import 'fallback_responses.dart';

/// 대화 관리 서비스
///
/// Week 3: LLM + Fallback 통합 레이어
/// - LLMService 우선 시도
/// - 실패 시 FallbackResponses 자동 사용
/// - 컨텍스트 기반 대화 생성
class ConversationService {
  final LLMService _llmService;
  final FallbackResponses _fallbackResponses;

  ConversationService({
    required LLMService llmService,
    required FallbackResponses fallbackResponses,
  })  : _llmService = llmService,
        _fallbackResponses = fallbackResponses;

  /// 대화 응답 생성
  ///
  /// [dogName]: 강아지 이름
  /// [dogBreed]: 강아지 품종
  /// [happinessLevel]: 행복도 (0-100)
  /// [context]: 대화 컨텍스트 (walk_complete, mission_complete, feed, level_up, low_happiness, greeting)
  /// [contextData]: 컨텍스트별 추가 데이터
  /// [userMessage]: 사용자 정의 메시지 (선택)
  ///
  /// Returns: 강아지의 응답 문자열
  Future<String> getResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String context,
    Map<String, dynamic>? contextData,
    String? userMessage,
  }) async {
    try {
      // 1. LLM 서비스가 초기화되어 있으면 API 호출 시도
      if (_llmService.isInitialized) {
        if (ApiConfig.enableDebugLogs) {
          debugPrint('💬 ConversationService - Trying LLM API...');
        }

        final response = await _llmService.generateDialogue(
          dogName: dogName,
          dogBreed: dogBreed,
          happinessLevel: happinessLevel,
          context: context,
          contextData: contextData,
        );

        // 응답이 있으면 반환
        if (response.isNotEmpty) {
          if (ApiConfig.enableDebugLogs) {
            debugPrint('✅ ConversationService - LLM response received');
          }
          return response;
        }
      }

      // 2. LLM이 실패하거나 초기화되지 않았으면 폴백 사용
      if (ApiConfig.enableDebugLogs) {
        debugPrint('⚠️ ConversationService - Using fallback response');
      }

      return _fallbackResponses.getResponse(context, contextData);
    } catch (e) {
      // 3. 예외 발생 시에도 폴백 사용
      debugPrint('❌ ConversationService - Error: $e, using fallback');
      return _fallbackResponses.getResponse(context, contextData);
    }
  }

  /// 간단한 인사 응답
  ///
  /// 앱 시작 시 또는 펫 화면 진입 시 사용 (랜덤)
  Future<String> getGreeting({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'greeting',
    );
  }

  /// 정적 인사 응답
  ///
  /// 홈 화면 접속 시 사용 (시간대별)
  Future<String> getGreetingStatic({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'greeting_static',
    );
  }

  /// 산책 완료 응답
  Future<String> getWalkCompleteResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required int steps,
    required int duration,
    required bool isOutdoor,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'walk_complete',
      contextData: {
        'steps': steps,
        'duration': duration,
        'isOutdoor': isOutdoor,
      },
    );
  }

  /// 미션 완료 응답
  Future<String> getMissionCompleteResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String missionTitle,
    required int treatReward,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'mission_complete',
      contextData: {
        'title': missionTitle,
        'treatReward': treatReward,
      },
    );
  }

  /// 간식 먹기 응답
  Future<String> getFeedResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required int treatCount,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'feed',
      contextData: {
        'treatCount': treatCount,
      },
    );
  }

  /// 레벨업 응답
  Future<String> getLevelUpResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required int newLevel,
    required int experience,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'level_up',
      contextData: {
        'level': newLevel,
        'experience': experience,
      },
    );
  }

  /// 행복도 낮음 응답
  Future<String> getLowHappinessResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
  }) async {
    return await getResponse(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
      context: 'low_happiness',
    );
  }

  /// 서비스 초기화 (LLM API 키 로드)
  Future<void> initialize() async {
    await _llmService.initialize();
  }

  /// 서비스 정리
  void dispose() {
    _llmService.dispose();
  }
}

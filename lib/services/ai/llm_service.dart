// lib/services/ai/llm_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../core/config/api_config.dart';
import 'fallback_responses.dart';

/// OpenRouter API 기반 LLM 서비스
///
/// Week 3: 클라우드 AI 대화 시스템
/// - DeepSeek R1 모델 사용
/// - HTTP POST 요청으로 OpenRouter API 호출
/// - 15초 타임아웃
/// - 자동 폴백 (에러 시 FallbackResponses 사용)
class LLMService {
  final FallbackResponses _fallbackResponses;
  String? _apiKey;
  bool _isInitialized = false;

  LLMService({required FallbackResponses fallbackResponses})
      : _fallbackResponses = fallbackResponses;

  /// 서비스 초기화 (API 키 로드)
  ///
  /// 앱 시작 시 또는 첫 사용 전 호출 필요
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _apiKey = await ApiConfig.getOpenRouterApiKey();

      // API 키 유효성 검증
      if (!ApiConfig.isValidApiKey(_apiKey)) {
        debugPrint('⚠️ LLMService - Invalid API key format');
        _isInitialized = false;
        return;
      }

      _isInitialized = true;
      debugPrint('✅ LLMService - Initialized with OpenRouter API');
    } catch (e) {
      debugPrint('❌ LLMService - Initialization failed: $e');
      _isInitialized = false;
    }
  }

  /// 초기화 상태 확인
  bool get isInitialized => _isInitialized;

  /// AI 응답 생성
  ///
  /// [systemPrompt]: 시스템 메시지 (강아지 성격, 역할 정의)
  /// [userMessage]: 사용자 메시지 (컨텍스트 기반)
  /// [maxTokens]: 최대 토큰 수 (기본: 100)
  /// [temperature]: 창의성 (0.0~1.0, 기본: 0.7)
  ///
  /// Returns: AI 응답 문자열
  ///
  /// 에러 발생 시 자동으로 FallbackResponses 사용
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int? maxTokens,
    double? temperature,
  }) async {
    // API 키가 없으면 폴백
    if (!_isInitialized || _apiKey == null) {
      debugPrint('⚠️ LLMService - Not initialized, using fallback');
      return _fallbackResponses.getRandomResponse();
    }

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.openRouterBaseUrl}/chat/completions'),
            headers: ApiConfig.getHeaders(_apiKey!),
            body: jsonEncode({
              'model': ApiConfig.model,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': userMessage},
              ],
              'max_tokens': maxTokens ?? ApiConfig.maxTokens,
              'temperature': temperature ?? ApiConfig.temperature,
            }),
          )
          .timeout(
            Duration(seconds: ApiConfig.requestTimeout),
            onTimeout: () {
              debugPrint('⏱️ LLMService - Request timeout');
              throw Exception('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        if (ApiConfig.enableDebugLogs) {
          debugPrint('✅ LLMService - Generated: ${content.substring(0, content.length > 50 ? 50 : content.length)}...');
        }

        return content.trim();
      } else {
        debugPrint('❌ LLMService - API Error ${response.statusCode}: ${response.body}');
        return _fallbackResponses.getRandomResponse();
      }
    } catch (e) {
      debugPrint('❌ LLMService - Exception: $e');
      return _fallbackResponses.getRandomResponse();
    }
  }

  /// 컨텍스트 기반 대화 생성
  ///
  /// [dogName]: 강아지 이름
  /// [dogBreed]: 강아지 품종
  /// [happinessLevel]: 행복도 (0-100)
  /// [context]: 대화 컨텍스트
  /// [contextData]: 컨텍스트별 추가 데이터
  ///
  /// Returns: 강아지의 응답
  Future<String> generateDialogue({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String context,
    Map<String, dynamic>? contextData,
  }) async {
    // 시스템 프롬프트 생성
    final systemPrompt = _buildSystemPrompt(
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
    );

    // 사용자 메시지 생성
    final userMessage = _buildUserMessage(
      context: context,
      contextData: contextData,
    );

    // API 호출 (실패 시 자동 폴백)
    return await generateResponse(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
    );
  }

  /// 시스템 프롬프트 생성
  ///
  /// 강아지의 성격, 역할, 말투를 정의
  String _buildSystemPrompt({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
  }) {
    final mood = _getMood(happinessLevel);

    return '''
당신은 $dogName이라는 이름의 $dogBreed 강아지입니다.
당신의 성격: 활발하고 친근하며 주인을 매우 사랑합니다.
현재 기분: $mood

규칙:
1. 항상 강아지 말투로 대답하세요 ("멍멍!", "왈왈!" 사용)
2. 짧고 친근한 한 문장으로 대답하세요 (최대 2문장)
3. 이모지는 사용하지 마세요
4. 주인에게 감사와 애정을 표현하세요
5. 산책과 간식을 좋아하는 강아지답게 행동하세요
''';
  }

  /// 사용자 메시지 생성
  ///
  /// 컨텍스트에 맞는 질문/상황 설명
  String _buildUserMessage({
    required String context,
    Map<String, dynamic>? contextData,
  }) {
    switch (context) {
      case 'walk_complete':
        final steps = contextData?['steps'] ?? 0;
        final duration = contextData?['duration'] ?? 0;
        return '방금 산책을 마쳤어요! $steps걸음을 ${duration ~/ 60}분 동안 걸었어요. 어땠어요?';

      case 'mission_complete':
        final title = contextData?['title'] ?? '미션';
        return '$title을(를) 완료했어요! 기분이 어때요?';

      case 'feed':
        final treatCount = contextData?['treatCount'] ?? 0;
        return '간식을 줬어요! 지금 총 $treatCount개의 간식이 있어요. 어때요?';

      case 'level_up':
        final level = contextData?['level'] ?? 1;
        return '레벨업! 이제 레벨 $level이 됐어요! 축하해요!';

      case 'low_happiness':
        return '요즘 기분이 좀 안 좋아 보여요. 무슨 일이에요?';

      case 'greeting':
        final hour = DateTime.now().hour;
        if (hour < 12) {
          return '좋은 아침이에요! 오늘 기분이 어때요?';
        } else if (hour < 18) {
          return '좋은 오후예요! 뭐 하고 있어요?';
        } else {
          return '좋은 저녁이에요! 오늘 하루 어땠어요?';
        }

      default:
        return '안녕! 무슨 일이에요?';
    }
  }

  /// 행복도 기반 기분 계산
  String _getMood(int happinessLevel) {
    if (happinessLevel >= 80) {
      return '매우 행복함 (꼬리를 흔들며 뛰어다님)';
    } else if (happinessLevel >= 60) {
      return '행복함 (기분 좋음)';
    } else if (happinessLevel >= 40) {
      return '보통 (평온함)';
    } else if (happinessLevel >= 20) {
      return '조금 슬픔 (관심 필요)';
    } else {
      return '매우 슬픔 (외로움)';
    }
  }

  /// 서비스 정리
  void dispose() {
    _apiKey = null;
    _isInitialized = false;
    debugPrint('🗑️ LLMService - Disposed');
  }
}

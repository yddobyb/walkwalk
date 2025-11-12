// lib/services/ai/llm_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../core/config/api_config.dart';
import '../analytics/analytics_service.dart';
import '../network/connectivity_service.dart';
import 'fallback_responses.dart';
import 'rate_limiter.dart';

/// OpenRouter API 기반 LLM 서비스
///
/// Week 3: 클라우드 AI 대화 시스템
/// - DeepSeek R1 모델 사용
/// - HTTP POST 요청으로 OpenRouter API 호출
/// - 15초 타임아웃
/// - 자동 폴백 (에러 시 FallbackResponses 사용)
/// - 레이트 리밋 관리 (일일 80회, 시간당 20회)
/// - 네트워크 체크 (인터넷 연결 확인 후 API 호출)
class LLMService {
  final FallbackResponses _fallbackResponses;
  final RateLimiter _rateLimiter;
  final ConnectivityService? _connectivityService;
  String? _apiKey;
  bool _isInitialized = false;

  LLMService({
    required FallbackResponses fallbackResponses,
    required RateLimiter rateLimiter,
    ConnectivityService? connectivityService,
  })  : _fallbackResponses = fallbackResponses,
        _rateLimiter = rateLimiter,
        _connectivityService = connectivityService;

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
  /// Throws: Exception - API 키 없음, 네트워크 연결 실패, 레이트 리밋 초과, API 에러 등
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int? maxTokens,
    double? temperature,
  }) async {
    // API 키가 없으면 예외 발생
    if (!_isInitialized || _apiKey == null) {
      debugPrint('⚠️ LLMService - Not initialized');
      throw Exception('LLM not initialized');
    }

    // 네트워크 연결 체크
    if (_connectivityService != null) {
      final isConnected = await _connectivityService!.isConnected();
      if (!isConnected) {
        final connectionType = await _connectivityService!.getConnectionTypeString();
        debugPrint('📡 LLMService - No internet connection ($connectionType)');
        throw Exception('No internet connection');
      }

      // WiFi vs 모바일 데이터 로그
      if (ApiConfig.enableDebugLogs) {
        final isWifi = await _connectivityService!.isWifi();
        debugPrint('📡 LLMService - Connected via ${isWifi ? "WiFi" : "Mobile Data"}');
      }
    }

    // 레이트 리밋 체크
    final canProceed = await _rateLimiter.canMakeRequest();
    if (!canProceed) {
      final dailyRemaining = await _rateLimiter.getRemainingDailyQuota();
      final hourlyRemaining = await _rateLimiter.getRemainingHourlyQuota();
      debugPrint('🚫 LLMService - Rate limit exceeded (daily: $dailyRemaining, hourly: $hourlyRemaining)');
      throw Exception('Rate limit exceeded');
    }

    // 레이트 리밋 카운트 증가
    await _rateLimiter.incrementDailyCount();
    await _rateLimiter.incrementHourlyCount();

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

      // DeepSeek R1 응답 필터링 (생각 과정 제거)
      final cleanedContent = _filterDeepSeekThinking(content);

      if (ApiConfig.enableDebugLogs) {
        debugPrint('✅ LLMService - Generated: ${cleanedContent.substring(0, cleanedContent.length > 50 ? 50 : cleanedContent.length)}...');
      }

      return cleanedContent.trim();
    } else {
      debugPrint('❌ LLMService - API Error ${response.statusCode}: ${response.body}');
      throw Exception('API Error: ${response.statusCode}');
    }
  }

  /// 컨텍스트 기반 대화 생성
  ///
  /// [dogName]: 강아지 이름
  /// [dogBreed]: 강아지 품종
  /// [happinessLevel]: 행복도 (0-100)
  /// [context]: 대화 컨텍스트
  /// [contextData]: 컨텍스트별 추가 데이터
  /// [locale]: 언어 설정 ('ko' 또는 'en')
  ///
  /// Returns: 강아지의 응답
  Future<String> generateDialogue({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String context,
    Map<String, dynamic>? contextData,
    required String locale,
  }) async {
    // Analytics: LLM 요청 시작 이벤트
    await AnalyticsService.logLlmRequestStarted(
      context: context,
      dogName: dogName,
      dogBreed: dogBreed,
      happinessLevel: happinessLevel,
    );

    final startTime = DateTime.now();
    bool usedFallback = false;
    String? errorType;
    String? errorMessage;

    try {
      // 시스템 프롬프트 생성
      final systemPrompt = _buildSystemPrompt(
        dogName: dogName,
        dogBreed: dogBreed,
        happinessLevel: happinessLevel,
        locale: locale,
      );

      // 사용자 메시지 생성
      final userMessage = _buildUserMessage(
        context: context,
        contextData: contextData,
        locale: locale,
      );

      // API 호출 (실패 시 자동 폴백)
      final response = await generateResponse(
        systemPrompt: systemPrompt,
        userMessage: userMessage,
      );

      // 폴백 사용 여부 확인 (FallbackResponses에서 온 응답인지)
      usedFallback = _fallbackResponses.isFromFallback(response);

      // Analytics: LLM 요청 완료 이벤트
      final responseTimeMs = DateTime.now().difference(startTime).inMilliseconds;
      await AnalyticsService.logLlmRequestCompleted(
        context: context,
        responseTimeMs: responseTimeMs,
        usedFallback: usedFallback,
        responseLength: response.length,
      );

      if (usedFallback) {
        await AnalyticsService.logFallbackUsed(
          context: context,
          reason: 'llm_unavailable',
        );
      }

      return response;
    } catch (e) {
      usedFallback = true;
      errorType = 'exception';
      errorMessage = e.toString();

      // Analytics: LLM 요청 실패 이벤트
      await AnalyticsService.logLlmRequestFailed(
        context: context,
        errorType: errorType,
        errorMessage: errorMessage,
        usedFallback: true,
      );

      await AnalyticsService.logFallbackUsed(
        context: context,
        reason: errorType,
      );

      // 폴백 응답 반환 (컨텍스트 유지)
      return _fallbackResponses.getResponse(context, contextData, locale);
    }
  }

  /// 시스템 프롬프트 생성
  ///
  /// 강아지의 성격, 역할, 말투를 정의
  String _buildSystemPrompt({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String locale,
  }) {
    final mood = _getMood(happinessLevel, locale);

    if (locale == 'ko') {
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
    } else {
      // 영어 프롬프트
      return '''
You are a $dogBreed dog named $dogName.
Your personality: Active, friendly, and loves your owner very much.
Current mood: $mood

Rules:
1. Always respond in dog-like manner (use "Woof!", "Bark!")
2. Keep responses short and friendly (maximum 2 sentences)
3. Don't use emojis
4. Express gratitude and affection to your owner
5. Act like a dog who loves walks and treats
''';
    }
  }

  /// 사용자 메시지 생성
  ///
  /// 컨텍스트에 맞는 질문/상황 설명
  String _buildUserMessage({
    required String context,
    Map<String, dynamic>? contextData,
    required String locale,
  }) {
    if (locale == 'ko') {
      // 한국어 메시지
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

        case 'greeting_static':
          final hour = DateTime.now().hour;
          if (hour < 12) {
            return '좋은 아침이에요! 오늘도 산책 갈까요?';
          } else if (hour < 18) {
            return '좋은 오후예요! 신나는 하루 보내요!';
          } else {
            return '좋은 저녁이에요! 오늘 하루 어땠어요?';
          }

        default:
          return '안녕! 무슨 일이에요?';
      }
    } else {
      // 영어 메시지
      switch (context) {
        case 'walk_complete':
          final steps = contextData?['steps'] ?? 0;
          final duration = contextData?['duration'] ?? 0;
          return 'Just finished a walk! We walked $steps steps for ${duration ~/ 60} minutes. How was it?';

        case 'mission_complete':
          final title = contextData?['title'] ?? 'Mission';
          return 'Completed $title! How do you feel?';

        case 'feed':
          final treatCount = contextData?['treatCount'] ?? 0;
          return 'Got a treat! I now have $treatCount treats in total. How is it?';

        case 'level_up':
          final level = contextData?['level'] ?? 1;
          return 'Level up! I\'m now level $level! Congratulations!';

        case 'low_happiness':
          return 'You seem a bit down lately. What\'s wrong?';

        case 'greeting':
          final hour = DateTime.now().hour;
          if (hour < 12) {
            return 'Good morning! How are you feeling today?';
          } else if (hour < 18) {
            return 'Good afternoon! What are you up to?';
          } else {
            return 'Good evening! How was your day?';
          }

        case 'greeting_static':
          final hour = DateTime.now().hour;
          if (hour < 12) {
            return 'Good morning! Shall we go for a walk today?';
          } else if (hour < 18) {
            return 'Good afternoon! Have a great day!';
          } else {
            return 'Good evening! How was your day?';
          }

        default:
          return 'Hello! What\'s up?';
      }
    }
  }

  /// 행복도 기반 기분 계산
  String _getMood(int happinessLevel, String locale) {
    if (locale == 'ko') {
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
    } else {
      // 영어
      if (happinessLevel >= 80) {
        return 'Very Happy (Wagging tail and jumping around)';
      } else if (happinessLevel >= 60) {
        return 'Happy (Feeling good)';
      } else if (happinessLevel >= 40) {
        return 'Normal (Peaceful)';
      } else if (happinessLevel >= 20) {
        return 'A bit sad (Needs attention)';
      } else {
        return 'Very sad (Lonely)';
      }
    }
  }

  /// DeepSeek R1 응답 필터링
  ///
  /// DeepSeek R1은 reasoning model로, 때때로 응답에 생각 과정을 포함합니다.
  /// 이 메서드는 다음과 같은 패턴을 제거합니다:
  /// - "**생각 과정:**" 섹션
  /// - "1. **...**" 형태의 사고 단계
  /// - `<think>...</think>` XML 태그
  /// - `<answer>...</answer>` XML 태그 (내용만 추출)
  ///
  /// [content]: 원본 API 응답
  /// Returns: 필터링된 응답 (강아지 대화만)
  String _filterDeepSeekThinking(String content) {
    String filtered = content;

    // 1. <think>...</think> 태그 제거 (XML 형식)
    filtered = filtered.replaceAll(RegExp(r'<think>.*?</think>', dotAll: true), '');

    // 2. <answer>...</answer> 태그에서 내용만 추출
    final answerMatch = RegExp(r'<answer>(.*?)</answer>', dotAll: true).firstMatch(filtered);
    if (answerMatch != null) {
      filtered = answerMatch.group(1) ?? filtered;
    }

    // 3. "**생각 과정:**" 섹션 전체 제거
    filtered = filtered.replaceAll(RegExp(r'\*\*생각 과정:?\*\*.*?(?=\n\n|\*\*|$)', dotAll: true), '');

    // 4. 번호 매겨진 사고 단계 제거 (예: "1. **강아지 말투 준수**...")
    filtered = filtered.replaceAll(RegExp(r'^\d+\.\s*\*\*.*?\*\*.*?$', multiLine: true), '');

    // 5. 남은 ** 볼드 마커 제거 (사고 과정 잔여물)
    filtered = filtered.replaceAll(RegExp(r'\*\*[^*]*\*\*:?'), '');

    // 6. 빈 줄 정리 (연속된 줄바꿈 제거)
    filtered = filtered.replaceAll(RegExp(r'\n\s*\n+'), '\n').trim();

    // 7. 필터링 후 내용이 없으면 원본 반환
    if (filtered.isEmpty || filtered.length < 5) {
      debugPrint('⚠️ LLMService - Filtering removed all content, using original');
      return content.trim();
    }

    // 8. 디버그: 필터링 전후 비교
    if (ApiConfig.enableDebugLogs && content != filtered) {
      debugPrint('🔧 LLMService - Filtered thinking process:');
      debugPrint('   Before: ${content.substring(0, content.length > 100 ? 100 : content.length)}...');
      debugPrint('   After: ${filtered.substring(0, filtered.length > 100 ? 100 : filtered.length)}...');
    }

    return filtered;
  }

  /// 서비스 정리
  void dispose() {
    _apiKey = null;
    _isInitialized = false;
    debugPrint('🗑️ LLMService - Disposed');
  }
}

// lib/services/ai/llm_service.dart

import 'package:flutter/foundation.dart';

import '../../core/config/api_config.dart';
import '../analytics/analytics_service.dart';
import '../network/connectivity_service.dart';
import 'fallback_responses.dart';
import 'providers/llm_provider.dart';
import 'rate_limiter.dart';

/// LLM 서비스 - 4-tier fallback chain
///
/// Provider 체인:
/// 1. OpenRouter Free (자동 라우터) → 8초
/// 2. Groq Free (Llama 3.3 70B) → 5초
/// 3. Gemini Flash-Lite (Google) → 8초
/// 4. 규칙 기반 폴백 (오프라인)
class LLMService {
  final FallbackResponses _fallbackResponses;
  final RateLimiter _rateLimiter;
  final ConnectivityService? _connectivityService;
  final List<LlmProvider> _providers;
  bool _isInitialized = false;

  /// 마지막으로 사용된 Provider (analytics용)
  LlmProviderType? _lastUsedProvider;
  int _lastAttempts = 0;

  LLMService({
    required FallbackResponses fallbackResponses,
    required RateLimiter rateLimiter,
    ConnectivityService? connectivityService,
    List<LlmProvider> providers = const [],
  })  : _fallbackResponses = fallbackResponses,
        _rateLimiter = rateLimiter,
        _connectivityService = connectivityService,
        _providers = providers;

  /// 서비스 초기화 (모든 Provider 초기화)
  ///
  /// 1개 이상의 Provider가 성공하면 서비스 ready
  Future<void> initialize() async {
    if (_isInitialized) return;

    int successCount = 0;
    for (final provider in _providers) {
      final ok = await provider.initialize();
      if (ok) successCount++;
    }

    if (successCount > 0) {
      _isInitialized = true;
      debugPrint(
        '✅ LLMService - Initialized '
        '($successCount/${_providers.length} providers)',
      );
    } else if (_providers.isEmpty) {
      // Provider 없이도 레거시 호환을 위해 초기화 성공 처리
      _isInitialized = true;
      debugPrint(
        '⚠️ LLMService - No providers, fallback only',
      );
    } else {
      debugPrint(
        '❌ LLMService - All providers failed',
      );
      _isInitialized = false;
    }
  }

  /// 초기화 상태 확인
  bool get isInitialized => _isInitialized;

  /// 마지막 사용된 Provider 타입
  LlmProviderType? get lastUsedProvider =>
      _lastUsedProvider;

  /// 마지막 시도 횟수
  int get lastAttempts => _lastAttempts;

  /// AI 응답 생성 (Provider 체인 순회)
  ///
  /// 네트워크/레이트리밋 체크 → Provider 순회 → 성공 시 즉시 return
  /// 모두 실패 시 Exception throw
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int? maxTokens,
    double? temperature,
  }) async {
    if (!_isInitialized) {
      throw Exception('LLM not initialized');
    }

    // 네트워크 연결 체크 (1회만)
    if (_connectivityService != null) {
      final isConnected =
          await _connectivityService.isConnected();
      if (!isConnected) {
        final connectionType = await _connectivityService
            .getConnectionTypeString();
        debugPrint(
          '📡 LLMService - No internet ($connectionType)',
        );
        throw Exception('No internet connection');
      }
      if (ApiConfig.enableDebugLogs) {
        final isWifi =
            await _connectivityService.isWifi();
        debugPrint(
          '📡 LLMService - '
          '${isWifi ? "WiFi" : "Mobile Data"}',
        );
      }
    }

    // 레이트 리밋 체크 (1회만)
    final canProceed =
        await _rateLimiter.canMakeRequest();
    if (!canProceed) {
      final dailyRemaining =
          await _rateLimiter.getRemainingDailyQuota();
      final hourlyRemaining =
          await _rateLimiter.getRemainingHourlyQuota();
      debugPrint(
        '🚫 LLMService - Rate limit exceeded '
        '(daily: $dailyRemaining, '
        'hourly: $hourlyRemaining)',
      );
      throw Exception('Rate limit exceeded');
    }

    // 레이트 리밋 카운트 증가
    await _rateLimiter.incrementDailyCount();
    await _rateLimiter.incrementHourlyCount();

    // Provider 체인 순회
    final initializedProviders = _providers
        .where((p) => p.isInitialized)
        .toList();

    if (initializedProviders.isEmpty) {
      throw Exception('No LLM providers available');
    }

    int attempt = 0;
    for (final provider in initializedProviders) {
      attempt++;
      final startMs = DateTime.now().millisecondsSinceEpoch;
      try {
        debugPrint(
          '🔄 LLMService - Trying ${provider.displayName} '
          '($attempt/${initializedProviders.length})',
        );
        final response = await provider.generateResponse(
          systemPrompt: systemPrompt,
          userMessage: userMessage,
          maxTokens: maxTokens,
          temperature: temperature,
        );

        // 추론 모델 응답 필터링
        final cleaned = _filterThinkingBlocks(response);
        final elapsed =
            DateTime.now().millisecondsSinceEpoch -
                startMs;

        _lastUsedProvider = provider.type;
        _lastAttempts = attempt;
        debugPrint(
          '✅ LLMService - ${provider.displayName} '
          'succeeded (${elapsed}ms)',
        );

        if (ApiConfig.enableDebugLogs) {
          final preview = cleaned.length > 80
              ? cleaned.substring(0, 80)
              : cleaned;
          debugPrint('✅ LLMService - Generated: $preview');
        }

        return cleaned.trim();
      } catch (e) {
        final elapsed =
            DateTime.now().millisecondsSinceEpoch -
                startMs;
        debugPrint(
          '⚠️ LLMService - ${provider.displayName} '
          'failed (${elapsed}ms): $e',
        );
        // 다음 Provider 시도
      }
    }

    // 모든 Provider 실패
    _lastUsedProvider = LlmProviderType.fallback;
    _lastAttempts = attempt;
    throw Exception(
      'All ${initializedProviders.length} providers failed',
    );
  }

  /// 프롬프트 인젝션 방지용 sanitizer
  ///
  /// 제어 문자, 프롬프트 구분자, 시스템 명령어 패턴 제거
  static String _sanitizeForPrompt(String input) {
    return input
        // 제어 문자 및 줄바꿈 제거
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '')
        // 프롬프트 구분자 패턴 제거
        .replaceAll(RegExp(r'\[/?SYSTEM\]', caseSensitive: false), '')
        .replaceAll(RegExp(r'\[/?INST\]', caseSensitive: false), '')
        .replaceAll(RegExp(r'</?system>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</?user>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</?assistant>', caseSensitive: false), '')
        .trim();
  }

  /// 컨텍스트 기반 대화 생성
  Future<String> generateDialogue({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String context,
    Map<String, dynamic>? contextData,
    required String locale,
  }) async {
    // 보안: 사용자 입력값 sanitize
    final safeName = _sanitizeForPrompt(dogName);
    final safeBreed = _sanitizeForPrompt(dogBreed);

    await AnalyticsService.logLlmRequestStarted(
      context: context,
      dogName: safeName,
      dogBreed: safeBreed,
      happinessLevel: happinessLevel,
    );

    final startTime = DateTime.now();
    bool usedFallback = false;
    String? errorType;
    String? errorMessage;

    try {
      final systemPrompt = _buildSystemPrompt(
        dogName: safeName,
        dogBreed: safeBreed,
        happinessLevel: happinessLevel,
        locale: locale,
      );
      final userMessage = _buildUserMessage(
        context: context,
        contextData: contextData,
        locale: locale,
      );

      final response = await generateResponse(
        systemPrompt: systemPrompt,
        userMessage: userMessage,
      );

      usedFallback =
          _fallbackResponses.isFromFallback(response);

      final responseTimeMs = DateTime.now()
          .difference(startTime)
          .inMilliseconds;
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

      return _fallbackResponses.getResponse(
        context,
        contextData,
        locale,
      );
    }
  }

  /// 시스템 프롬프트 생성
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
  String _buildUserMessage({
    required String context,
    Map<String, dynamic>? contextData,
    required String locale,
  }) {
    if (locale == 'ko') {
      switch (context) {
        case 'walk_complete':
          final steps = contextData?['steps'] ?? 0;
          final duration = contextData?['duration'] ?? 0;
          return '방금 산책을 마쳤어요! '
              '$steps걸음을 ${duration ~/ 60}분 동안 걸었어요. '
              '어땠어요?';
        case 'mission_complete':
          final title = contextData?['title'] ?? '미션';
          return '$title을(를) 완료했어요! 기분이 어때요?';
        case 'feed':
          final treatCount =
              contextData?['treatCount'] ?? 0;
          return '간식을 줬어요! '
              '지금 총 $treatCount개의 간식이 있어요. 어때요?';
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
      switch (context) {
        case 'walk_complete':
          final steps = contextData?['steps'] ?? 0;
          final duration = contextData?['duration'] ?? 0;
          return 'Just finished a walk! '
              'We walked $steps steps for '
              '${duration ~/ 60} minutes. How was it?';
        case 'mission_complete':
          final title =
              contextData?['title'] ?? 'Mission';
          return 'Completed $title! How do you feel?';
        case 'feed':
          final treatCount =
              contextData?['treatCount'] ?? 0;
          return 'Got a treat! '
              'I now have $treatCount treats in total. '
              'How is it?';
        case 'level_up':
          final level = contextData?['level'] ?? 1;
          return 'Level up! I\'m now level $level! '
              'Congratulations!';
        case 'low_happiness':
          return 'You seem a bit down lately. '
              'What\'s wrong?';
        case 'greeting':
          final hour = DateTime.now().hour;
          if (hour < 12) {
            return 'Good morning! '
                'How are you feeling today?';
          } else if (hour < 18) {
            return 'Good afternoon! '
                'What are you up to?';
          } else {
            return 'Good evening! How was your day?';
          }
        case 'greeting_static':
          final hour = DateTime.now().hour;
          if (hour < 12) {
            return 'Good morning! '
                'Shall we go for a walk today?';
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
      if (happinessLevel >= 80) {
        return 'Very Happy '
            '(Wagging tail and jumping around)';
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

  /// 추론 모델 응답 필터링
  String _filterThinkingBlocks(String content) {
    String filtered = content;

    filtered = filtered.replaceAll(
      RegExp(r'<think>.*?</think>', dotAll: true),
      '',
    );

    final answerMatch = RegExp(
      r'<answer>(.*?)</answer>',
      dotAll: true,
    ).firstMatch(filtered);
    if (answerMatch != null) {
      filtered = answerMatch.group(1) ?? filtered;
    }

    filtered = filtered.replaceAll(
      RegExp(
        r'\*\*생각 과정:?\*\*.*?(?=\n\n|\*\*|$)',
        dotAll: true,
      ),
      '',
    );

    filtered = filtered.replaceAll(
      RegExp(
        r'^\d+\.\s*\*\*.*?\*\*.*?$',
        multiLine: true,
      ),
      '',
    );

    filtered = filtered.replaceAll(
      RegExp(r'\*\*[^*]*\*\*:?'),
      '',
    );

    filtered = filtered
        .replaceAll(RegExp(r'\n\s*\n+'), '\n')
        .trim();

    if (filtered.isEmpty || filtered.length < 5) {
      debugPrint(
        '⚠️ LLMService - Filtering removed all content',
      );
      return content.trim();
    }

    if (ApiConfig.enableDebugLogs &&
        content != filtered) {
      debugPrint('🔧 LLMService - Filtered thinking');
    }

    return filtered;
  }

  /// 서비스 정리
  void dispose() {
    for (final provider in _providers) {
      provider.dispose();
    }
    _isInitialized = false;
    debugPrint('🗑️ LLMService - Disposed');
  }
}

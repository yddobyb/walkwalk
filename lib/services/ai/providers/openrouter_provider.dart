// lib/services/ai/providers/openrouter_provider.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../core/config/api_config.dart';
import 'llm_provider.dart';

/// OpenRouter Free Provider
///
/// 1차 LLM: openrouter/free 자동 라우터
/// 타임아웃: 8초
class OpenRouterProvider extends LlmProvider {
  String? _apiKey;
  bool _isInitialized = false;

  @override
  LlmProviderType get type => LlmProviderType.openRouter;

  @override
  String get displayName => 'OpenRouter Free';

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    try {
      _apiKey = await ApiConfig.getOpenRouterApiKey();
      if (!ApiConfig.isValidApiKey(_apiKey)) {
        debugPrint(
          '⚠️ OpenRouterProvider - Invalid API key',
        );
        _isInitialized = false;
        return false;
      }
      _isInitialized = true;
      debugPrint('✅ OpenRouterProvider - Initialized');
      return true;
    } catch (e) {
      debugPrint('⚠️ OpenRouterProvider - Skip: $e');
      _isInitialized = false;
      return false;
    }
  }

  @override
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int? maxTokens,
    double? temperature,
  }) async {
    if (!_isInitialized || _apiKey == null) {
      throw Exception('OpenRouter not initialized');
    }

    final response = await http
        .post(
          Uri.parse(
            '${ApiConfig.openRouterBaseUrl}/chat/completions',
          ),
          headers: ApiConfig.getHeaders(_apiKey!),
          body: jsonEncode({
            'model': ApiConfig.openRouterModel,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userMessage},
            ],
            'max_tokens': maxTokens ?? ApiConfig.maxTokens,
            'temperature':
                temperature ?? ApiConfig.temperature,
          }),
        )
        .timeout(
          Duration(seconds: ApiConfig.openRouterTimeout),
          onTimeout: () {
            throw Exception('OpenRouter timeout');
          },
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content =
          data['choices']?[0]?['message']?['content']
              as String?;
      if (content == null || content.trim().isEmpty) {
        throw Exception('OpenRouter empty response');
      }
      debugPrint(
        '✅ OpenRouterProvider - Response: '
        '${content.length} chars',
      );
      return content;
    } else {
      throw Exception(
        'OpenRouter API error: ${response.statusCode}',
      );
    }
  }

  @override
  void dispose() {
    _apiKey = null;
    _isInitialized = false;
  }
}

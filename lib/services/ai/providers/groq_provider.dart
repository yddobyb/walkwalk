// lib/services/ai/providers/groq_provider.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../core/config/api_config.dart';
import 'llm_provider.dart';

/// Groq Free Provider
///
/// 2차 LLM: Llama 3.3 70B Versatile (초고속)
/// 타임아웃: 5초
class GroqProvider extends LlmProvider {
  String? _apiKey;
  bool _isInitialized = false;

  @override
  LlmProviderType get type => LlmProviderType.groq;

  @override
  String get displayName => 'Groq (Llama 3.3 70B)';

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    try {
      _apiKey = await ApiConfig.getGroqApiKey();
      if (!ApiConfig.isValidGroqApiKey(_apiKey)) {
        debugPrint('⚠️ GroqProvider - Invalid API key');
        _isInitialized = false;
        return false;
      }
      _isInitialized = true;
      debugPrint('✅ GroqProvider - Initialized');
      return true;
    } catch (e) {
      debugPrint('⚠️ GroqProvider - Skip: $e');
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
      throw Exception('Groq not initialized');
    }

    final response = await http
        .post(
          Uri.parse(
            '${ApiConfig.groqBaseUrl}/chat/completions',
          ),
          headers: ApiConfig.getGroqHeaders(_apiKey!),
          body: jsonEncode({
            'model': ApiConfig.groqModel,
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
          Duration(seconds: ApiConfig.groqTimeout),
          onTimeout: () {
            throw Exception('Groq timeout');
          },
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content =
          data['choices']?[0]?['message']?['content']
              as String?;
      if (content == null || content.trim().isEmpty) {
        throw Exception('Groq empty response');
      }
      debugPrint(
        '✅ GroqProvider - Response: '
        '${content.length} chars',
      );
      return content;
    } else {
      throw Exception(
        'Groq API error: ${response.statusCode}',
      );
    }
  }

  @override
  void dispose() {
    _apiKey = null;
    _isInitialized = false;
  }
}

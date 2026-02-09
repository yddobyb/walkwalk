// lib/services/ai/providers/gemini_provider.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../core/config/api_config.dart';
import 'llm_provider.dart';

/// Gemini Flash-Lite Provider
///
/// 3차 LLM: Google Gemini 2.0 Flash-Lite
/// Google generateContent API 형식 (OpenAI와 다름)
/// 타임아웃: 8초
class GeminiProvider extends LlmProvider {
  String? _apiKey;
  bool _isInitialized = false;

  @override
  LlmProviderType get type => LlmProviderType.gemini;

  @override
  String get displayName => 'Gemini Flash-Lite';

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    try {
      _apiKey = await ApiConfig.getGeminiApiKey();
      if (!ApiConfig.isValidGeminiApiKey(_apiKey)) {
        debugPrint('⚠️ GeminiProvider - Invalid API key');
        _isInitialized = false;
        return false;
      }
      _isInitialized = true;
      debugPrint('✅ GeminiProvider - Initialized');
      return true;
    } catch (e) {
      debugPrint('⚠️ GeminiProvider - Skip: $e');
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
      throw Exception('Gemini not initialized');
    }

    // Gemini generateContent API 형식
    final url = '${ApiConfig.geminiBaseUrl}/models/'
        '${ApiConfig.geminiModel}:generateContent'
        '?key=$_apiKey';

    final response = await http
        .post(
          Uri.parse(url),
          headers: ApiConfig.getGeminiHeaders(),
          body: jsonEncode({
            'systemInstruction': {
              'parts': [
                {'text': systemPrompt},
              ],
            },
            'contents': [
              {
                'parts': [
                  {'text': userMessage},
                ],
              },
            ],
            'generationConfig': {
              'maxOutputTokens':
                  maxTokens ?? ApiConfig.maxTokens,
              'temperature':
                  temperature ?? ApiConfig.temperature,
            },
          }),
        )
        .timeout(
          Duration(seconds: ApiConfig.geminiTimeout),
          onTimeout: () {
            throw Exception('Gemini timeout');
          },
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('Gemini no candidates');
      }
      final parts =
          candidates[0]['content']?['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        throw Exception('Gemini no parts');
      }
      final content = parts[0]['text'] as String?;
      if (content == null || content.trim().isEmpty) {
        throw Exception('Gemini empty response');
      }
      debugPrint(
        '✅ GeminiProvider - Response: '
        '${content.length} chars',
      );
      return content;
    } else {
      throw Exception(
        'Gemini API error: ${response.statusCode}',
      );
    }
  }

  @override
  void dispose() {
    _apiKey = null;
    _isInitialized = false;
  }
}

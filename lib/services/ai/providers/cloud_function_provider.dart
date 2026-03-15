// lib/services/ai/providers/cloud_function_provider.dart

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import 'llm_provider.dart';

/// Cloud Function 기반 LLM Provider
///
/// API 키를 서버 사이드에서만 관리하여 클라이언트 노출을 방지한다.
/// `chatWithPet` Cloud Function을 호출하여 서버에서 LLM API 호출 수행.
class CloudFunctionProvider extends LlmProvider {
  bool _isInitialized = false;
  HttpsCallable? _callable;

  @override
  LlmProviderType get type => LlmProviderType.cloudFunction;

  @override
  String get displayName => 'Cloud Function (server-side)';

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    try {
      _callable = FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable(
        'chatWithPet',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
      );
      _isInitialized = true;
      debugPrint('✅ CloudFunctionProvider - Initialized');
      return true;
    } catch (e) {
      debugPrint('⚠️ CloudFunctionProvider - Init failed: $e');
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
    if (!_isInitialized || _callable == null) {
      throw Exception('CloudFunctionProvider not initialized');
    }

    final result = await _callable!.call<Map<String, dynamic>>({
      'systemPrompt': systemPrompt,
      'userMessage': userMessage,
      'maxTokens': maxTokens ?? 100,
      'temperature': temperature ?? 0.7,
    });

    final data = result.data;
    if (data['success'] == true && data['text'] != null) {
      debugPrint(
        '✅ CloudFunctionProvider - '
        'Provider: ${data['provider']}, '
        '${data['durationMs']}ms',
      );
      return data['text'] as String;
    }

    throw Exception('Cloud Function returned unsuccessful response');
  }

  @override
  void dispose() {
    _callable = null;
    _isInitialized = false;
  }
}

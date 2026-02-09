// lib/services/ai/providers/llm_provider.dart

/// LLM Provider 타입
enum LlmProviderType {
  openRouter,
  groq,
  gemini,
  fallback,
}

/// LLM Provider 응답 결과
class LlmProviderResult {
  final bool success;
  final String? response;
  final LlmProviderType provider;
  final String? error;
  final int durationMs;

  const LlmProviderResult({
    required this.success,
    this.response,
    required this.provider,
    this.error,
    required this.durationMs,
  });
}

/// LLM Provider 추상 클래스
///
/// 각 LLM API를 동일한 인터페이스로 추상화
abstract class LlmProvider {
  /// Provider 타입
  LlmProviderType get type;

  /// 표시 이름
  String get displayName;

  /// 초기화 완료 여부
  bool get isInitialized;

  /// Provider 초기화 (API 키 로드 등)
  ///
  /// 키가 없으면 gracefully false 반환 (에러 아님)
  Future<bool> initialize();

  /// AI 응답 생성
  ///
  /// 실패 시 Exception throw → 다음 Provider로 전환
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int? maxTokens,
    double? temperature,
  });

  /// 리소스 정리
  void dispose();
}

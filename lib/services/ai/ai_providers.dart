// lib/services/ai/ai_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/network_providers.dart';
import 'ai_consent_service.dart';
import 'fallback_responses.dart';
import 'llm_service.dart';
import 'conversation_service.dart';
import 'dialogue_request.dart';
import 'providers/llm_provider.dart';
import 'providers/cloud_function_provider.dart';
import 'rate_limiter.dart';

/// Week 3: AI 서비스 Riverpod Providers
///
/// Provider 계층:
/// 1. fallbackResponsesProvider - 기본 응답 시스템
/// 2. rateLimiterProvider - API 레이트 리밋 관리
/// 3. llmServiceProvider - LLM API 호출
/// 4. llmInitializationProvider - LLM 초기화 상태
/// 5. conversationServiceProvider - 대화 통합 서비스
/// 6. dialogueProvider - 대화 생성 (FutureProvider.family)

// ==========================================================================
// 1. FallbackResponses Provider
// ==========================================================================

/// 오프라인 폴백 응답 Provider
///
/// 싱글톤 인스턴스
final fallbackResponsesProvider = Provider<FallbackResponses>((ref) {
  return FallbackResponses();
});

// ==========================================================================
// 2. RateLimiter Provider
// ==========================================================================

/// API 레이트 리밋 관리 Provider
///
/// 일일 80회, 시간당 20회 제한
final rateLimiterProvider = Provider<RateLimiter>((ref) {
  return RateLimiter();
});

// ==========================================================================
// 3. LLM Provider Chain
// ==========================================================================

/// LLM Provider 체인 (서버 전용)
///
/// CloudFunction만 사용: API 키가 서버에만 존재하여 보안 강화
/// chatWithPet Cloud Function 내부에서 Groq → OpenRouter → Gemini 폴백 처리
/// 모든 provider 실패 시 → 클라이언트의 규칙 기반 폴백 (오프라인)
final llmProviderChainProvider = Provider<List<LlmProvider>>((ref) {
  return [
    CloudFunctionProvider(),
  ];
});

// ==========================================================================
// 4. LLMService Provider
// ==========================================================================

/// LLM 서비스 Provider
///
/// Provider 체인 + FallbackResponses + RateLimiter + Connectivity 주입
final llmServiceProvider = Provider<LLMService>((ref) {
  final fallbackResponses = ref.watch(fallbackResponsesProvider);
  final rateLimiter = ref.watch(rateLimiterProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  final providers = ref.watch(llmProviderChainProvider);

  return LLMService(
    fallbackResponses: fallbackResponses,
    rateLimiter: rateLimiter,
    connectivityService: connectivityService,
    providers: providers,
  );
});

// ==========================================================================
// 3. LLM Initialization Provider
// ==========================================================================

/// LLM 초기화 상태 Provider
///
/// 앱 시작 시 LLM API 키 로드
///
/// Usage:
/// ```dart
/// final initAsync = ref.watch(llmInitializationProvider);
/// initAsync.when(
///   data: (_) => Text('Initialized'),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error: $e'),
/// );
/// ```
final llmInitializationProvider = FutureProvider<bool>((ref) async {
  final llmService = ref.watch(llmServiceProvider);
  await llmService.initialize();
  return llmService.isInitialized;
});

// ==========================================================================
// 4. ConversationService Provider
// ==========================================================================

/// 대화 서비스 Provider
///
/// LLMService + FallbackResponses 통합
final conversationServiceProvider = Provider<ConversationService>((ref) {
  final llmService = ref.watch(llmServiceProvider);
  final fallbackResponses = ref.watch(fallbackResponsesProvider);
  final consentService = ref.watch(aiConsentServiceProvider);

  return ConversationService(
    llmService: llmService,
    fallbackResponses: fallbackResponses,
    // Phase 27: 제3자 AI 전송 동의가 없으면 로컬 폴백만 사용한다.
    // 매 호출마다 조회하므로 설정에서 철회하면 즉시 반영된다.
    consentGate: consentService.hasConsent,
  );
});

// ==========================================================================
// 5. Dialogue Provider (FutureProvider.family)
// ==========================================================================

/// 대화 생성 Provider (FutureProvider.family)
///
/// [DialogueRequest]를 파라미터로 받아 대화 생성
///
/// Usage:
/// ```dart
/// final dialogueAsync = ref.watch(dialogueProvider(DialogueRequest(
///   dogName: 'Max',
///   dogBreed: 'Golden Retriever',
///   happinessLevel: 80,
///   context: 'walk_complete',
///   contextData: {'steps': 5000, 'duration': 1800},
/// )));
///
/// dialogueAsync.when(
///   data: (response) => Text(response),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error'),
/// );
/// ```
final dialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getResponse(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    context: request.context,
    contextData: request.contextData,
    userMessage: request.userMessage,
    locale: request.locale,
  );
});

// ==========================================================================
// 6. Convenience Providers (컨텍스트별 대화)
// ==========================================================================

/// 인사 Provider
///
/// Usage:
/// ```dart
/// final greetingAsync = ref.watch(greetingDialogueProvider(DialogueRequest(...)));
/// ```
final greetingDialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getGreeting(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    locale: request.locale,
  );
});

/// 산책 완료 Provider
final walkCompleteDialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getWalkCompleteResponse(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    steps: request.contextData?['steps'] ?? 0,
    duration: request.contextData?['duration'] ?? 0,
    isOutdoor: request.contextData?['isOutdoor'] ?? false,
    locale: request.locale,
  );
});

/// 미션 완료 Provider
final missionCompleteDialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getMissionCompleteResponse(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    missionTitle: request.contextData?['title'] ?? 'Mission',
    treatReward: request.contextData?['treatReward'] ?? 0,
    locale: request.locale,
  );
});

/// 간식 먹기 Provider
final feedDialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getFeedResponse(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    treatCount: request.contextData?['treatCount'] ?? 0,
    locale: request.locale,
  );
});

/// 레벨업 Provider
final levelUpDialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getLevelUpResponse(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    newLevel: request.contextData?['level'] ?? 1,
    experience: request.contextData?['experience'] ?? 0,
    locale: request.locale,
  );
});

/// 행복도 낮음 Provider
final lowHappinessDialogueProvider =
    FutureProvider.family<String, DialogueRequest>((ref, request) async {
  final conversationService = ref.watch(conversationServiceProvider);

  return await conversationService.getLowHappinessResponse(
    dogName: request.dogName,
    dogBreed: request.dogBreed,
    happinessLevel: request.happinessLevel,
    locale: request.locale,
  );
});

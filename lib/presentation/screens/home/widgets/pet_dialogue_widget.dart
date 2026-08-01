// lib/presentation/screens/home/widgets/pet_dialogue_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../presentation/widgets/ai_generated_badge.dart';
import '../../../../services/ai/ai_providers.dart';
import '../../../../services/ai/dialogue_request.dart';
import '../../../../services/settings/settings_service.dart';
import '../../../../services/tracking/step_tracking_service.dart';

/// 펫 대화 위젯
///
/// Week 3 Phase 4: AI 대화 UI 통합
/// - LLM/Fallback 응답을 말풍선 형태로 표시
/// - 컨텍스트별 대화 (greeting, walk_complete, mission_complete, feed, level_up, low_happiness)
/// - AsyncValue 3-state 처리 (loading/data/error)
class PetDialogueWidget extends ConsumerWidget {
  final String context;
  final Map<String, dynamic>? contextData;

  const PetDialogueWidget({
    super.key,
    required this.context,
    this.contextData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Pet 정보 가져오기 (petTrackingProvider 사용)
    final petAsync = ref.watch(petTrackingProvider);

    // 설정 정보 가져오기 (언어 설정)
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return petAsync.when(
      data: (pet) {
        // Pet이 null이면 빈 상태 표시
        if (pet == null) {
          return _buildEmptyState(context, theme);
        }

        // 설정에서 locale 추출 (기본값: 'ko')
        final locale = settingsAsync.when(
          data: (settings) => settings.locale,
          loading: () => 'ko', // 로딩 중에는 한국어 기본값
          error: (_, __) => 'ko', // 오류 시에도 한국어 기본값
        );

        // 대화 요청 생성
        final request = DialogueRequest(
          dogName: pet.name,
          dogBreed: pet.breed,
          happinessLevel: pet.happiness,
          context: this.context,
          contextData: contextData,
          locale: locale,
        );

        // 대화 생성
        final dialogueAsync = ref.watch(dialogueProvider(request));

        return _buildDialogueBubble(context, theme, dialogueAsync);
      },
      loading: () => _buildLoadingState(theme),
      error: (_, __) => _buildEmptyState(context, theme),
    );
  }

  /// 대화 말풍선 위젯
  Widget _buildDialogueBubble(
    BuildContext context,
    ThemeData theme,
    AsyncValue<String> dialogueAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: dialogueAsync.when(
        // ✅ 대화 생성 성공
        data: (text) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 강아지 아이콘
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.pets,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // 대화 텍스트 + AI 생성 표시(AI기본법 제31조 ②항)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const AiGeneratedTextTag(),
                ],
              ),
            ),
          ],
        ),
        // ⏳ 대화 생성 중 (Shimmer 로딩)
        loading: () => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.pets,
                color: Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: ShimmerLoading(width: 200, height: 20),
            ),
          ],
        ),
        // ❌ 대화 생성 실패 (폴백 응답)
        error: (error, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.pets,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context).dogBark,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 빈 상태 (Pet 없음)
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        AppLocalizations.of(context).loadingDogInfo,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  /// 로딩 상태
  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Shimmer 로딩 위젯
///
/// 대화 생성 중 표시되는 로딩 애니메이션
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// lib/presentation/screens/home/widgets/walk_button_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/tracking/step_tracking_service.dart';
import '../../../../services/ads/ad_service.dart';
import '../../../../services/user/user_tier_providers.dart';
import '../../../widgets/step_permission_button.dart';
import 'pet_dialogue_widget.dart';

class WalkButtonWidget extends ConsumerWidget {
  const WalkButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stepTrackingStateAsync = ref.watch(stepTrackingStateProvider);

    return stepTrackingStateAsync.when(
      data: (state) => _buildWalkButton(context, ref, theme, state),
      loading: () => _buildLoadingButton(context, theme),
      error: (error, stack) => _buildErrorButton(context, theme),
    );
  }

  Widget _buildWalkButton(BuildContext context, WidgetRef ref, ThemeData theme, StepTrackingState state) {
    final isWalking = state == StepTrackingState.walking;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isWalking
              ? [
                  Colors.red.shade400,
                  Colors.red.shade600,
                ]
              : [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  isWalking ? Icons.stop : Icons.directions_walk,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWalking ? AppLocalizations.of(context).walkEndWalk : AppLocalizations.of(context).walkStartWalk,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isWalking
                          ? AppLocalizations.of(context).walkEndWalkDescription
                          : AppLocalizations.of(context).walkStartWalkDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 산책 버튼들
          if (isWalking)
            // 산책 종료 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _stopWalk(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stop),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).walkEndButton),
                  ],
                ),
              ),
            )
          else
            // 산책 시작 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _startWalk(context, ref, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.home),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context).walkIndoor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _startWalk(context, ref, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context).walkOutdoor),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // 팁 메시지
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isWalking ? Icons.timer : Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isWalking
                        ? AppLocalizations.of(context).walkingNow
                        : AppLocalizations.of(context).walkOutdoorBonus,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).walkSensorInitializing,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorButton(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).walkSensorUnavailable,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).walkPermissionRequired,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const StepPermissionButton(onDark: true),
        ],
      ),
    );
  }

  Future<void> _startWalk(BuildContext context, WidgetRef ref, bool isOutdoor) async {
    final service = ref.read(stepTrackingServiceProvider);

    try {
      // 실외 산책일 때만 GPS 활성화
      final success = await service.startWalkSession(enableGPS: isOutdoor);
      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isOutdoor
                  ? AppLocalizations.of(context).walkStartedOutdoor
                  : AppLocalizations.of(context).walkStartedIndoor,
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: AppLocalizations.of(context).confirm,
              onPressed: () {},
            ),
          ),
        );
      } else {
        _showErrorSnackBar(context, AppLocalizations.of(context).walkStartFailed);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, AppLocalizations.of(context).errorOccurred(e.toString()));
      }
    }
  }

  Future<void> _stopWalk(BuildContext context, WidgetRef ref) async {
    final service = ref.read(stepTrackingServiceProvider);

    try {
      // 산책 종료 안내 메시지 (걸음수 동기화 대기 중)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(AppLocalizations.of(context).walkEndingMessage),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade700,
          duration: const Duration(seconds: 4),
        ),
      );

      // 산책 시작 전 펫 레벨 저장
      final petBefore = await ref.read(stepTrackingServiceProvider).petUpdateStream.first;
      final levelBefore = petBefore?.level ?? 1;

      // 산책 종료 (3초 동기화 대기 포함)
      final walkSession = await service.stopWalkSession();
      if (walkSession != null) {
        // 산책 종료 후 펫 레벨 확인 (약간의 지연 후 최신 상태 가져오기)
        await Future.delayed(const Duration(milliseconds: 300));
        final petAfter = await ref.read(stepTrackingServiceProvider).petUpdateStream.first;
        final levelAfter = petAfter?.level ?? 1;

        // 레벨업 여부 확인
        final levelsGained = levelAfter - levelBefore;
        final didLevelUp = levelsGained > 0;

        // 메시지 구성
        if (!context.mounted) return;
        final l10n = AppLocalizations.of(context);
        String message = l10n.walkCompleted(
          walkSession.totalSteps,
          walkSession.treatsEarned,
          walkSession.happinessGained,
        );

        if (didLevelUp) {
          message += '\n\n${l10n.walkLevelUp(levelBefore, levelAfter)}';
          if (levelsGained > 1) {
            message += ' ${l10n.walkLevelUpMultiple(levelsGained)}';
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: didLevelUp ? Colors.amber.shade700 : Colors.green,
            duration: Duration(seconds: didLevelUp ? 6 : 4),
            action: SnackBarAction(
              label: l10n.confirm,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );

        // AI 대화 Bottom Sheet (walk_complete)
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 드래그 핸들
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // AI 대화
                  PetDialogueWidget(
                    context: 'walk_complete',
                    contextData: {
                      'steps': walkSession.totalSteps,
                      'duration': walkSession.duration,
                      'isOutdoor': walkSession.isOutdoor,
                    },
                  ),
                  const SizedBox(height: 16),
                  // 닫기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context).close),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );

          // 산책 완료 시트가 닫힌 뒤 전면광고 (레벨업 시 생략 — 축하 흐름 방해 X).
          // 프리미엄 제외/빈도 제한은 AdService가 처리.
          if (!didLevelUp && context.mounted) {
            // .future로 await — valueOrNull은 autoDispose 미해결 시 null→false라
            // 프리미엄인데도 광고가 뜨던 버그 방지
            final isPremium = await ref.read(isPremiumUserProvider.future);
            ref
                .read(adServiceProvider)
                .maybeShowWalkInterstitial(isPremium: isPremium);
          }

          // 레벨업 발생 시 추가 AI 대화 Bottom Sheet (level_up)
          if (didLevelUp) {
            // walk_complete Bottom Sheet가 닫힐 때까지 대기
            await Future.delayed(const Duration(milliseconds: 800));
            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                            ]
                          : [
                              Colors.amber.shade100,
                              Colors.amber.shade50,
                            ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 드래그 핸들
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // 레벨업 축하 아이콘
                      Icon(
                        Icons.celebration,
                        size: 64,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(height: 16),
                      // AI 대화 (level_up)
                      PetDialogueWidget(
                        context: 'level_up',
                        contextData: {
                          'level': levelAfter,
                        },
                      ),
                      const SizedBox(height: 16),
                      // 닫기 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context).congratulations),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          _showErrorSnackBar(context, AppLocalizations.of(context).walkEndError);
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, AppLocalizations.of(context).errorOccurred(e.toString()));
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: AppLocalizations.of(context).confirm,
          onPressed: () {},
        ),
      ),
    );
  }
}
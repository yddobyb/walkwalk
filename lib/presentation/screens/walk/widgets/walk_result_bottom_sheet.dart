// lib/presentation/screens/walk/widgets/walk_result_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../../../../domain/entities/walk_session.dart';
import '../../../../l10n/app_localizations.dart';
import '../../home/widgets/pet_dialogue_widget.dart';

/// 산책 완료 결과 BottomSheet
class WalkResultBottomSheet {
  WalkResultBottomSheet._();

  /// 산책 완료 BottomSheet 표시
  static Future<void> show(
    BuildContext context, {
    required WalkSession walkSession,
    required int levelBefore,
    required int levelAfter,
  }) async {
    final didLevelUp = levelAfter > levelBefore;
    final levelsGained = levelAfter - levelBefore;

    // 완료 메시지 SnackBar
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
        backgroundColor:
            didLevelUp ? Colors.amber.shade700 : Colors.green,
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
    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
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
                color: Theme.of(ctx).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(ctx).close),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    // 레벨업 Bottom Sheet
    if (didLevelUp) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!context.mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(ctx).brightness == Brightness.dark
                  ? [
                      Theme.of(ctx).colorScheme.surface,
                      Theme.of(ctx).colorScheme.surfaceContainerHighest,
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
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Icon(
                Icons.celebration,
                size: 64,
                color: Colors.amber.shade700,
              ),
              const SizedBox(height: 16),
              PetDialogueWidget(
                context: 'level_up',
                contextData: {
                  'level': levelAfter,
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                      AppLocalizations.of(ctx).congratulations),
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

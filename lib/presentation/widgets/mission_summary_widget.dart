// lib/presentation/widgets/mission_summary_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mission.dart';
import '../../l10n/app_localizations.dart';
import '../../services/mission/mission_service.dart';
import '../../services/tracking/step_tracking_service.dart';
import 'mission_list_widget.dart';

/// 미션 요약 위젯
/// 홈 화면이나 대시보드에서 간단한 미션 정보를 표시
class MissionSummaryWidget extends ConsumerWidget {
  final bool showViewAllButton;

  const MissionSummaryWidget({
    super.key,
    this.showViewAllButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // StreamProvider를 사용하여 실시간 DB 변경 감지
    final activeMissionsAsync = ref.watch(activeMissionsStreamProvider);

    // 실시간 걸음수 가져오기
    final dailyStepsAsync = ref.watch(dailyStepsProvider);

    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.flag,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context).todaysMissions,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (showViewAllButton)
                  TextButton(
                    onPressed: () => _navigateToMissionList(context),
                    child: Text(AppLocalizations.of(context).viewAll),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // 미션 목록
            activeMissionsAsync.when(
              data: (missions) => _buildMissionContent(context, theme, missions, dailyStepsAsync),
              loading: () => _buildLoadingContent(),
              error: (error, stackTrace) => _buildErrorContent(context, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionContent(BuildContext context, ThemeData theme, List<Mission> missions, AsyncValue<int> dailyStepsAsync) {
    if (missions.isEmpty) {
      return _buildEmptyContent(context, theme);
    }

    // 일일 미션만 표시 (최대 3개)
    final dailyMissions = missions
        .where((mission) => mission.type == 'daily')
        .take(3)
        .toList();

    if (dailyMissions.isEmpty) {
      return _buildEmptyContent(context, theme);
    }

    return Column(
      children: [
        ...dailyMissions.map((mission) => _buildMissionItem(context, theme, mission, dailyStepsAsync)),

        if (missions.length > 3) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.more_horiz,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).moreAvailable(missions.length - 3),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMissionItem(BuildContext context, ThemeData theme, Mission mission, AsyncValue<int> dailyStepsAsync) {
    // 실시간 진행도 계산
    final currentProgress = _getCurrentProgress(mission, dailyStepsAsync);
    final progress = _calculateProgress(mission, currentProgress);
    final isCompleted = mission.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.05)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: isCompleted
            ? Border.all(color: Colors.green.withValues(alpha: 0.2))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mission.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.green : null,
                  ),
                ),
              ),
              if (isCompleted)
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // 진행도 바
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? Colors.green : theme.colorScheme.primary,
            ),
            minHeight: 4,
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatProgress(context, mission, currentProgress),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pets,
                    color: Colors.orange,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${mission.treatReward}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '+${mission.happinessReward}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      children: [
        for (int i = 0; i < 2; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).cannotLoadMissions,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).newMissionsComingSoon,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMissionList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).missions),
            elevation: 0,
          ),
          body: const MissionListWidget(),
        ),
      ),
    );
  }

  /// 현재 진행도 가져오기 (실시간 또는 DB 값)
  int _getCurrentProgress(Mission mission, AsyncValue<int> dailyStepsAsync) {
    // 걸음수 미션이면 실시간 값 사용
    if (mission.targetSteps > 0) {
      return dailyStepsAsync.when(
        data: (steps) => steps,
        loading: () => mission.currentProgress, // 로딩 중에는 DB 값 사용
        error: (_, __) => mission.currentProgress, // 에러 시에는 DB 값 사용
      );
    }

    // 걸음수 미션이 아니면 DB 값 사용
    return mission.currentProgress;
  }

  double _calculateProgress(Mission mission, int currentProgress) {
    final target = _getTargetProgress(mission);
    if (target == 0) return 0.0;
    return (currentProgress / target).clamp(0.0, 1.0);
  }

  int _getTargetProgress(Mission mission) {
    if (mission.targetSteps > 0) return mission.targetSteps;
    if (mission.targetDuration > 0) return mission.targetDuration;
    if (mission.targetDistance > 0) return mission.targetDistance.round();
    return 1;
  }

  String _formatProgress(BuildContext context, Mission mission, int currentProgress) {
    final target = _getTargetProgress(mission);

    if (mission.targetSteps > 0) {
      return '$currentProgress / ${mission.targetSteps} ${AppLocalizations.of(context).stepsUnitLabel}';
    } else if (mission.targetDuration > 0) {
      final currentMinutes = currentProgress ~/ 60;
      final targetMinutes = mission.targetDuration ~/ 60;
      return '$currentMinutes / $targetMinutes ${AppLocalizations.of(context).minutesUnitLabel}';
    } else if (mission.targetDistance > 0) {
      final currentKm = currentProgress / 1000;
      final targetKm = mission.targetDistance / 1000;
      return '${currentKm.toStringAsFixed(1)} / ${targetKm.toStringAsFixed(1)} km';
    }
    return '$currentProgress / $target';
  }
}
// lib/presentation/widgets/mission_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mission.dart';
import '../../l10n/app_localizations.dart';
import '../../services/tracking/step_tracking_service.dart';

/// 미션 카드 위젯
/// 개별 미션의 정보와 진행도를 표시
class MissionCardWidget extends ConsumerWidget {
  final Mission mission;
  final VoidCallback? onTap;

  const MissionCardWidget({
    super.key,
    required this.mission,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 걸음수 기반 미션인 경우 실시간 걸음수 가져오기
    // 일일 미션: dailyStepsProvider, 주간 미션: weeklyStepsProvider
    final stepsAsync = mission.targetSteps > 0
        ? (mission.type == 'weekly'
            ? ref.watch(weeklyStepsProvider)
            : ref.watch(dailyStepsProvider))
        : null;

    // 실시간 진행도 계산 (걸음수 미션이면 실시간 값, 아니면 DB 값 사용)
    final currentProgress = _getCurrentProgress(stepsAsync);
    final progress = _calculateProgress(currentProgress);
    final isCompleted = mission.isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isCompleted
                ? Border.all(color: Colors.green.withValues(alpha: 0.3), width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMissionTypeIcon(theme),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                            color: isCompleted ? Colors.green : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mission.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context).missionCompleted,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // 진행도 바
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).missionProgress,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_formatProgress(context, currentProgress)} / ${_formatTargetProgress(context)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isCompleted ? Colors.green : theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : theme.colorScheme.primary,
                    ),
                    minHeight: 6,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 보상 정보
              Row(
                children: [
                  _buildRewardItem(
                    context: context,
                    icon: Icons.pets,
                    value: AppLocalizations.of(context).missionTreatsCount(mission.treatReward),
                    label: AppLocalizations.of(context).missionTreatsLabel,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildRewardItem(
                    context: context,
                    icon: Icons.favorite,
                    value: '+${mission.happinessReward}',
                    label: AppLocalizations.of(context).missionHappinessLabel,
                    color: Colors.red,
                  ),
                  const Spacer(),
                  _buildMissionExpiryInfo(context, theme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionTypeIcon(ThemeData theme) {
    IconData icon;
    Color color;

    switch (mission.type) {
      case 'daily':
        icon = Icons.today;
        color = Colors.blue;
        break;
      case 'weekly':
        icon = Icons.date_range;
        color = Colors.purple;
        break;
      case 'special':
        icon = Icons.star;
        color = Colors.amber;
        break;
      default:
        icon = Icons.flag;
        color = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildRewardItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionExpiryInfo(BuildContext context, ThemeData theme) {
    final now = DateTime.now();
    final timeRemaining = mission.expiresAt.difference(now);
    final isExpired = timeRemaining.isNegative;

    if (isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          AppLocalizations.of(context).missionExpired,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.red,
            fontSize: 10,
          ),
        ),
      );
    }

    String timeText;
    if (timeRemaining.inDays > 0) {
      timeText = AppLocalizations.of(context).missionDaysRemaining(timeRemaining.inDays);
    } else if (timeRemaining.inHours > 0) {
      timeText = AppLocalizations.of(context).missionHoursRemaining(timeRemaining.inHours);
    } else {
      timeText = AppLocalizations.of(context).missionMinutesRemaining(timeRemaining.inMinutes);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        timeText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 10,
        ),
      ),
    );
  }

  /// 현재 진행도 가져오기 (실시간 또는 DB 값)
  int _getCurrentProgress(AsyncValue<int>? stepsAsync) {
    // 걸음수 미션이고 실시간 데이터가 있으면 실시간 값 사용
    if (mission.targetSteps > 0 && stepsAsync != null) {
      return stepsAsync.when(
        data: (steps) => steps,
        loading: () => mission.currentProgress, // 로딩 중에는 DB 값 사용
        error: (_, __) => mission.currentProgress, // 에러 시에는 DB 값 사용
      );
    }

    // 걸음수 미션이 아니면 DB 값 사용
    return mission.currentProgress;
  }

  double _calculateProgress(int currentProgress) {
    final target = _getTargetProgress();
    if (target == 0) return 0.0;
    return (currentProgress / target).clamp(0.0, 1.0);
  }

  int _getTargetProgress() {
    if (mission.targetSteps > 0) return mission.targetSteps;
    if (mission.targetDuration > 0) return mission.targetDuration;
    if (mission.targetDistance > 0) return mission.targetDistance.round();
    return 1;
  }

  String _formatProgress(BuildContext context, int progress) {
    if (mission.targetSteps > 0) {
      return AppLocalizations.of(context).missionStepsUnit(progress);
    } else if (mission.targetDuration > 0) {
      final minutes = progress ~/ 60;
      return AppLocalizations.of(context).missionMinutesUnit(minutes);
    } else if (mission.targetDistance > 0) {
      final km = progress / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
    return '$progress';
  }

  String _formatTargetProgress(BuildContext context) {
    if (mission.targetSteps > 0) {
      return AppLocalizations.of(context).missionStepsUnit(mission.targetSteps);
    } else if (mission.targetDuration > 0) {
      final minutes = mission.targetDuration ~/ 60;
      return AppLocalizations.of(context).missionMinutesUnit(minutes);
    } else if (mission.targetDistance > 0) {
      final km = mission.targetDistance / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
    return '${_getTargetProgress()}';
  }
}
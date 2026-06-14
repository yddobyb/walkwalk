// lib/presentation/screens/home/widgets/daily_stats_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/tracking/step_tracking_service.dart';
import '../../../../services/statistics/statistics_service.dart';
import '../../../../services/settings/settings_service.dart';
import '../../../../services/sensors/pedometer_service.dart';
import '../../../widgets/step_permission_button.dart';

class DailyStatsWidget extends ConsumerWidget {
  const DailyStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 걸음수 권한이 없으면(온보딩에서 "나중에" 스킵 등) 무엇보다 먼저 "권한 켜기" 안내
    final permissionMissing = ref
        .watch(healthPermissionProvider)
        .maybeWhen(data: (granted) => !granted, orElse: () => false);
    if (permissionMissing) {
      return _buildPermissionState(context, theme);
    }

    // 실시간 걸음수 데이터 가져오기
    final dailyStepsAsync = ref.watch(dailyStepsProvider);
    final stepTrackingStateAsync = ref.watch(stepTrackingStateProvider);
    final streakDataAsync = ref.watch(streakDataProvider);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return dailyStepsAsync.when(
      data: (todaySteps) {
        // 설정에서 목표 걸음수 가져오기 (기본값: 8000)
        final int goalSteps = settingsAsync.when(
          data: (settings) => settings.dailyStepGoal,
          loading: () => AppConstants.dailyStepGoal,
          error: (_, __) => AppConstants.dailyStepGoal,
        );

        final double distance = (todaySteps * 0.7) / 1000; // km (평균 보폭 0.7m)
        // 평균 걷기 속도: 100걸음/분 가정
        final int activeMinutes = (todaySteps / 100).round(); // 추정 활동 시간

        final stepProgress = todaySteps / goalSteps;

        return _buildStatsContent(
          context,
          theme,
          todaySteps,
          goalSteps,
          distance,
          activeMinutes,
          stepProgress,
          stepTrackingStateAsync,
          streakDataAsync,
        );
      },
      loading: () => _buildLoadingState(context, theme),
      error: (error, stack) => _buildErrorState(context, theme, error.toString()),
    );
  }

  Widget _buildStatsContent(
    BuildContext context,
    ThemeData theme,
    int todaySteps,
    int goalSteps,
    double distance,
    int activeMinutes,
    double stepProgress,
    AsyncValue<StepTrackingState> stepTrackingStateAsync,
    AsyncValue<StreakData> streakDataAsync,
  ) {

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).todaysActivity,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  // 트래킹 상태 표시
                  stepTrackingStateAsync.when(
                    data: (state) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStateColor(state).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStateIcon(state),
                            size: 12,
                            color: _getStateColor(state),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getStateText(context, state),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getStateColor(state),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${DateTime.now().month}/${DateTime.now().day}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 걸음수 메인 표시
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: stepProgress > 1.0 ? 1.0 : stepProgress,
                        strokeWidth: 8,
                        backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          stepProgress >= 1.0
                              ? Colors.green
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          todaySteps.toString(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: stepProgress >= 1.0 ? Colors.green : null,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).stepsUnitLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stepProgress >= 1.0
                      ? AppLocalizations.of(context).goalAchieved
                      : AppLocalizations.of(context).stepsToGoal(goalSteps - todaySteps),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: stepProgress >= 1.0
                        ? Colors.green
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 추가 통계
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.straighten,
                  label: AppLocalizations.of(context).distance,
                  value: '${distance.toStringAsFixed(1)}km',
                  color: theme.colorScheme.secondary,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.timer,
                  label: AppLocalizations.of(context).activeTime,
                  value: '$activeMinutes${AppLocalizations.of(context).minutesUnitLabel}',
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 연속 산책 일수 표시
          streakDataAsync.when(
            data: (streakData) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: _getStreakColor(streakData.currentStreak),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getStreakMessage(context, streakData),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ThemeData theme) {
    return Container(
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
              AppLocalizations.of(context).loadingSteps,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error) {
    return Container(
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
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).cannotLoadSteps,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).checkActivityPermissions,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 걸음수 권한이 없을 때: "권한 켜기" CTA 카드 (온보딩 스킵 사용자 복구 경로)
  Widget _buildPermissionState(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);
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
      child: Column(
        children: [
          const Text('👟', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            l10n.cannotLoadSteps,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.stepPermissionOffDesc,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const StepPermissionButton(),
        ],
      ),
    );
  }

  Color _getStateColor(StepTrackingState state) {
    switch (state) {
      case StepTrackingState.monitoring:
        return Colors.green;
      case StepTrackingState.walking:
        return Colors.blue;
      case StepTrackingState.stopped:
        return Colors.grey;
      case StepTrackingState.error:
        return Colors.red;
    }
  }

  IconData _getStateIcon(StepTrackingState state) {
    switch (state) {
      case StepTrackingState.monitoring:
        return Icons.visibility;
      case StepTrackingState.walking:
        return Icons.directions_walk;
      case StepTrackingState.stopped:
        return Icons.stop;
      case StepTrackingState.error:
        return Icons.error;
    }
  }

  String _getStateText(BuildContext context, StepTrackingState state) {
    switch (state) {
      case StepTrackingState.monitoring:
        return AppLocalizations.of(context).trackingStateMonitoring;
      case StepTrackingState.walking:
        return AppLocalizations.of(context).trackingStateWalking;
      case StepTrackingState.stopped:
        return AppLocalizations.of(context).trackingStateStopped;
      case StepTrackingState.error:
        return AppLocalizations.of(context).trackingStateError;
    }
  }

  Color _getStreakColor(int streak) {
    if (streak == 0) return Colors.grey;
    if (streak >= 7) return Colors.orange;
    return Colors.green;
  }

  String _getStreakMessage(BuildContext context, StreakData streakData) {
    if (streakData.currentStreak == 0) {
      return AppLocalizations.of(context).streakMessageZero;
    } else if (streakData.currentStreak == 1) {
      return AppLocalizations.of(context).streakMessageOne;
    } else if (streakData.currentStreak < 7) {
      return AppLocalizations.of(context).streakMessageActive(
        streakData.currentStreak,
        7 - streakData.currentStreak,
      );
    } else {
      return AppLocalizations.of(context).streakMessageLong(streakData.currentStreak);
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
// lib/presentation/screens/home/widgets/daily_stats_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/tracking/step_tracking_service.dart';
import '../../../../services/statistics/statistics_service.dart';
import '../../../../services/settings/settings_service.dart';

class DailyStatsWidget extends ConsumerWidget {
  const DailyStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
            color: Colors.black.withOpacity(0.05),
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
                '오늘의 활동',
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
                        color: _getStateColor(state).withOpacity(0.2),
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
                            _getStateText(state),
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
                        backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
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
                          '걸음',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stepProgress >= 1.0
                      ? '목표 달성! 🎉'
                      : '목표까지 ${goalSteps - todaySteps}걸음',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: stepProgress >= 1.0
                        ? Colors.green
                        : theme.colorScheme.onSurface.withOpacity(0.7),
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
                  label: '거리',
                  value: '${distance.toStringAsFixed(1)}km',
                  color: theme.colorScheme.secondary,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.timer,
                  label: '활동 시간',
                  value: '${activeMinutes}분',
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
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
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
                      _getStreakMessage(streakData),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
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
            color: Colors.black.withOpacity(0.05),
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
              '걸음수 데이터를 불러오는 중...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
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
            color: Colors.black.withOpacity(0.05),
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
              '걸음수 데이터를 불러올 수 없습니다',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '설정에서 활동 권한을 확인해주세요',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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

  String _getStateText(StepTrackingState state) {
    switch (state) {
      case StepTrackingState.monitoring:
        return '모니터링';
      case StepTrackingState.walking:
        return '산책 중';
      case StepTrackingState.stopped:
        return '중지됨';
      case StepTrackingState.error:
        return '오류';
    }
  }

  Color _getStreakColor(int streak) {
    if (streak == 0) return Colors.grey;
    if (streak >= 7) return Colors.orange;
    return Colors.green;
  }

  String _getStreakMessage(StreakData streakData) {
    if (streakData.currentStreak == 0) {
      return '오늘 산책을 시작하고 연속 기록을 세워보세요!';
    } else if (streakData.currentStreak == 1) {
      return '좋은 시작! 내일도 계속해보세요!';
    } else if (streakData.currentStreak < 7) {
      return '${streakData.currentStreak}일 연속 달성 중! 일주일까지 ${7 - streakData.currentStreak}일 남았어요!';
    } else {
      return '${streakData.currentStreak}일 연속 달성 중! 계속 화이팅!';
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
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
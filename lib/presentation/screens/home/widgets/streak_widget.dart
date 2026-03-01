// lib/presentation/screens/home/widgets/streak_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/statistics/statistics_service.dart';

/// 연속 산책 일수 위젯
class StreakWidget extends ConsumerWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final streakDataAsync = ref.watch(streakDataProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: streakDataAsync.when(
        data: (streakData) => _buildContent(context, theme, streakData),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(context, theme),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, StreakData streakData) {
    return Column(
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getStreakColor(streakData.currentStreak).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_fire_department,
                color: _getStreakColor(streakData.currentStreak),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context).streakTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 현재 연속 일수 (대형 표시)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${streakData.currentStreak}',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getStreakColor(streakData.currentStreak),
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                AppLocalizations.of(context).daysInARow,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 격려 메시지
        Text(
          _getEncouragementMessage(context, streakData.currentStreak),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // 구분선
        Divider(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          thickness: 1,
        ),

        const SizedBox(height: 16),

        // 추가 정보
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                context,
                theme,
                AppLocalizations.of(context).longestStreak,
                AppLocalizations.of(context).streakDays(streakData.longestStreak),
                Icons.emoji_events,
                Colors.amber,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            Expanded(
              child: _buildStatItem(
                context,
                theme,
                AppLocalizations.of(context).lastWalk,
                streakData.lastWalkDate != null
                    ? _formatLastWalkDate(context, streakData.lastWalkDate!)
                    : AppLocalizations.of(context).noRecord,
                Icons.calendar_today,
                theme.colorScheme.secondary,
              ),
            ),
          ],
        ),

        // 다음 목표까지
        if (streakData.currentStreak > 0) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _getNextGoalMessage(context, streakData.currentStreak),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, ThemeData theme, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 150,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(
          AppLocalizations.of(context).dataLoadError,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }

  Color _getStreakColor(int streak) {
    if (streak == 0) return Colors.grey;
    if (streak >= 30) return Colors.purple;
    if (streak >= 14) return Colors.orange;
    if (streak >= 7) return Colors.green;
    return Colors.blue;
  }

  String _getEncouragementMessage(BuildContext context, int streak) {
    final l10n = AppLocalizations.of(context);
    if (streak == 0) {
      return l10n.streakEncouragement0;
    } else if (streak == 1) {
      return l10n.streakEncouragement1;
    } else if (streak < 7) {
      return l10n.streakEncouragementUnder7;
    } else if (streak == 7) {
      return l10n.streakEncouragement7;
    } else if (streak < 30) {
      return l10n.streakEncouragementUnder30(30 - streak);
    } else {
      return l10n.streakEncouragement30Plus;
    }
  }

  String _getNextGoalMessage(BuildContext context, int streak) {
    final l10n = AppLocalizations.of(context);
    if (streak < 3) {
      return l10n.nextGoal3Days(3 - streak);
    } else if (streak < 7) {
      return l10n.nextGoalWeek(7 - streak);
    } else if (streak < 14) {
      return l10n.nextGoalTwoWeeks(14 - streak);
    } else if (streak < 30) {
      return l10n.nextGoalMonth(30 - streak);
    } else {
      return l10n.keepGoingMessage;
    }
  }

  String _formatLastWalkDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return l10n.today;
    } else if (difference == 1) {
      return l10n.yesterday;
    } else if (difference < 7) {
      return l10n.daysAgo(difference);
    } else {
      return DateFormat('M/d').format(date);
    }
  }
}

// lib/presentation/screens/home/widgets/streak_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
            theme.colorScheme.primaryContainer.withOpacity(0.5),
            theme.colorScheme.secondaryContainer.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: streakDataAsync.when(
        data: (streakData) => _buildContent(context, theme, streakData),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(theme),
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
                color: _getStreakColor(streakData.currentStreak).withOpacity(0.2),
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
                '연속 산책 기록',
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
                '일 연속',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 격려 메시지
        Text(
          _getEncouragementMessage(streakData.currentStreak),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // 구분선
        Divider(
          color: theme.colorScheme.outline.withOpacity(0.2),
          thickness: 1,
        ),

        const SizedBox(height: 16),

        // 추가 정보
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                theme,
                '최장 기록',
                '${streakData.longestStreak}일',
                Icons.emoji_events,
                Colors.amber,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            Expanded(
              child: _buildStatItem(
                theme,
                '마지막 산책',
                streakData.lastWalkDate != null
                    ? _formatLastWalkDate(streakData.lastWalkDate!)
                    : '기록 없음',
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
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
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
                  _getNextGoalMessage(streakData.currentStreak),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
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

  Widget _buildStatItem(ThemeData theme, String label, String value, IconData icon, Color color) {
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
            color: theme.colorScheme.onSurface.withOpacity(0.6),
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

  Widget _buildErrorState(ThemeData theme) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(
          '데이터를 불러올 수 없습니다',
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

  String _getEncouragementMessage(int streak) {
    if (streak == 0) {
      return '오늘 산책을 시작하고 연속 기록을 세워보세요!';
    } else if (streak == 1) {
      return '좋은 시작이에요! 내일도 계속해보세요! 💪';
    } else if (streak < 7) {
      return '멋져요! 일주일 연속을 향해 달려가고 있어요! 🔥';
    } else if (streak == 7) {
      return '와! 일주일 연속 달성! 정말 대단해요! 🎉';
    } else if (streak < 30) {
      return '놀라워요! 한 달 연속까지 ${30 - streak}일 남았어요! 🌟';
    } else {
      return '전설이에요! 한 달 이상 연속 산책 중! 👑';
    }
  }

  String _getNextGoalMessage(int streak) {
    if (streak < 3) {
      return '3일 연속까지 ${3 - streak}일 남았어요!';
    } else if (streak < 7) {
      return '일주일 연속까지 ${7 - streak}일 남았어요!';
    } else if (streak < 14) {
      return '2주 연속까지 ${14 - streak}일 남았어요!';
    } else if (streak < 30) {
      return '한 달 연속까지 ${30 - streak}일 남았어요!';
    } else {
      return '계속 이 기록을 유지해보세요!';
    }
  }

  String _formatLastWalkDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return '오늘';
    } else if (difference == 1) {
      return '어제';
    } else if (difference < 7) {
      return '$difference일 전';
    } else {
      return DateFormat('M/d').format(date);
    }
  }
}

// lib/presentation/screens/home/widgets/achievements_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/achievement.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/achievement/achievement_service.dart';
import '../../achievements/achievements_screen.dart';

class AchievementsWidget extends ConsumerWidget {
  const AchievementsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unlockedAchievementsAsync = ref.watch(unlockedAchievementsProvider);

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
              Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).achievementsTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _navigateToAchievements(context),
                child: Text(AppLocalizations.of(context).viewAll),
              ),
            ],
          ),
          const SizedBox(height: 16),
          unlockedAchievementsAsync.when(
            data: (achievements) => _buildAchievementsList(context, theme, achievements),
            loading: () => _buildLoadingState(context, theme),
            error: (error, stack) => _buildErrorState(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context, ThemeData theme, List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // 최근 해제된 배지 순으로 정렬 (최대 3개만 표시)
    final recentAchievements = achievements
        .where((a) => a.unlockedAt != null)
        .toList()
      ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));

    final displayAchievements = recentAchievements.take(3).toList();

    return Column(
      children: [
        // 최근 해제된 배지들
        if (displayAchievements.isNotEmpty) ...[
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayAchievements.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index < displayAchievements.length - 1 ? 12 : 0),
                  child: _buildAchievementBadge(context, theme, displayAchievements[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 통계 요약
        _buildAchievementSummary(context, theme, achievements),
      ],
    );
  }

  Widget _buildAchievementBadge(BuildContext context, ThemeData theme, Achievement achievement) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _getTierColor(achievement.tier).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getTierColor(achievement.tier),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getAchievementEmoji(achievement.code),
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 2),
          Text(
            _getAchievementTitle(achievement.code, AppLocalizations.of(context)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getTierColor(achievement.tier),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSummary(BuildContext context, ThemeData theme, List<Achievement> unlockedAchievements) {
    // 티어별 개수 계산
    final bronzeCount = unlockedAchievements.where((a) => a.tier == AchievementTier.bronze).length;
    final silverCount = unlockedAchievements.where((a) => a.tier == AchievementTier.silver).length;
    final goldCount = unlockedAchievements.where((a) => a.tier == AchievementTier.gold).length;
    final platinumCount = unlockedAchievements.where((a) => a.tier == AchievementTier.platinum).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTierCount(theme, '🥉', bronzeCount, const Color(0xFFCD7F32)),
          _buildTierCount(theme, '🥈', silverCount, const Color(0xFFC0C0C0)),
          _buildTierCount(theme, '🥇', goldCount, const Color(0xFFFFD700)),
          _buildTierCount(theme, '💎', platinumCount, const Color(0xFF00D4AA)),
        ],
      ),
    );
  }

  Widget _buildTierCount(ThemeData theme, String emoji, int count, Color color) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 32,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).firstBadgePrompt,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).badgesWalkHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ThemeData theme) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 32,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).badgesLoadError,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAchievements(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AchievementsScreen(),
      ),
    );
  }

  Color _getTierColor(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFF00D4AA);
    }
  }

  String _getAchievementEmoji(String code) {
    switch (code) {
      case 'FIRST_WALK':
        return '🚶';
      case 'STEPS_1K':
        return '👟';
      case 'STEPS_5K':
        return '🏃';
      case 'STEPS_10K':
        return '🏃‍♂️';
      case 'STREAK_3':
        return '🔥';
      case 'STREAK_7':
        return '⚡';
      case 'OUTDOOR_FIRST':
        return '🌳';
      case 'HAPPY_100':
        return '😆';
      case 'TREATS_100':
        return '🦴';
      case 'DISTANCE_1KM':
        return '📏';
      default:
        return '🏆';
    }
  }

  String _getAchievementTitle(String code, AppLocalizations l10n) {
    switch (code) {
      case 'FIRST_WALK':
        return l10n.achievementFirstWalkTitle;
      case 'STEPS_1K':
        return l10n.achievementSteps1kTitle;
      case 'STEPS_5K':
        return l10n.achievementSteps5kTitle;
      case 'STEPS_10K':
        return l10n.achievementSteps10kTitle;
      case 'STREAK_3':
        return l10n.achievementStreak3Title;
      case 'STREAK_7':
        return l10n.achievementStreak7Title;
      case 'OUTDOOR_FIRST':
        return l10n.achievementOutdoorFirstTitle;
      case 'HAPPY_100':
        return l10n.achievementHappy100Title;
      case 'TREATS_100':
        return l10n.achievementTreats100Title;
      case 'DISTANCE_1KM':
        return l10n.achievementDistance1kmTitle;
      default:
        return '';
    }
  }

  String _getAchievementDescription(String code, AppLocalizations l10n) {
    switch (code) {
      case 'FIRST_WALK':
        return l10n.achievementFirstWalkDescription;
      case 'STEPS_1K':
        return l10n.achievementSteps1kDescription;
      case 'STEPS_5K':
        return l10n.achievementSteps5kDescription;
      case 'STEPS_10K':
        return l10n.achievementSteps10kDescription;
      case 'STREAK_3':
        return l10n.achievementStreak3Description;
      case 'STREAK_7':
        return l10n.achievementStreak7Description;
      case 'OUTDOOR_FIRST':
        return l10n.achievementOutdoorFirstDescription;
      case 'HAPPY_100':
        return l10n.achievementHappy100Description;
      case 'TREATS_100':
        return l10n.achievementTreats100Description;
      case 'DISTANCE_1KM':
        return l10n.achievementDistance1kmDescription;
      default:
        return '';
    }
  }
}
// lib/presentation/screens/achievements/achievements_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/achievement.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/achievement/achievement_service.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final achievementsAsync = ref.watch(allAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).badgesCollectionTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: achievementsAsync.when(
        data: (achievements) => _buildAchievementsList(context, theme, achievements),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, theme, error),
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context, ThemeData theme, List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // 티어별로 그룹화
    final groupedAchievements = _groupAchievementsByTier(achievements);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(context, theme, achievements),
          const SizedBox(height: 20),
          ...groupedAchievements.entries.map((entry) =>
              _buildTierSection(context, theme, entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, ThemeData theme, List<Achievement> achievements) {
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    final totalCount = achievements.length;
    final progressPercentage = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).badgesCollectionStatus,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).badgesAchieved(unlockedCount, totalCount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progressPercentage * 100).toInt()}%',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierSection(BuildContext context, ThemeData theme, AchievementTier tier, List<Achievement> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(
                _getTierIcon(tier),
                color: _getTierColor(tier),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _getTierName(tier, context),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getTierColor(tier),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _buildAchievementCard(context, theme, achievements[index]);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAchievementCard(BuildContext context, ThemeData theme, Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final progress = achievement.currentProgress / achievement.targetProgress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? theme.colorScheme.surface : theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? _getTierColor(achievement.tier) : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked ? [
          BoxShadow(
            color: _getTierColor(achievement.tier).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isUnlocked ? _getTierColor(achievement.tier).withValues(alpha: 0.1) : theme.colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    _getAchievementEmoji(achievement.code),
                    style: TextStyle(
                      fontSize: 18,
                      color: isUnlocked ? null : theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isUnlocked)
                Icon(
                  Icons.check_circle,
                  color: _getTierColor(achievement.tier),
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getAchievementTitle(achievement.code, AppLocalizations.of(context)),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isUnlocked ? null : theme.colorScheme.outline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              _getAchievementDescription(achievement.code, AppLocalizations.of(context)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isUnlocked ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isUnlocked) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getTierColor(achievement.tier).withValues(alpha: 0.7),
                ),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${achievement.currentProgress} / ${achievement.targetProgress}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
                fontSize: 10,
              ),
            ),
          ] else if (achievement.unlockedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).achievementUnlockedDate(_formatDate(achievement.unlockedAt!)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getTierColor(achievement.tier),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noBadgesYet,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).startWalkingForFirstBadge,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).badgesLoadError,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).tryAgainLater,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Map<AchievementTier, List<Achievement>> _groupAchievementsByTier(List<Achievement> achievements) {
    final grouped = <AchievementTier, List<Achievement>>{};
    for (final achievement in achievements) {
      grouped.putIfAbsent(achievement.tier, () => []).add(achievement);
    }
    return grouped;
  }

  String _getTierName(AchievementTier tier, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (tier) {
      case AchievementTier.bronze:
        return l10n.tierBronze;
      case AchievementTier.silver:
        return l10n.tierSilver;
      case AchievementTier.gold:
        return l10n.tierGold;
      case AchievementTier.platinum:
        return l10n.tierPlatinum;
    }
  }

  IconData _getTierIcon(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return Icons.military_tech;
      case AchievementTier.silver:
        return Icons.workspace_premium;
      case AchievementTier.gold:
        return Icons.emoji_events;
      case AchievementTier.platinum:
        return Icons.diamond;
    }
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

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
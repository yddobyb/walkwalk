// lib/presentation/widgets/achievement_notification_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/achievement.dart';
import '../../l10n/app_localizations.dart';
import '../../services/achievement/achievement_service.dart';

/// 새로 해제된 배지 알림을 표시하는 위젯
/// 홈 화면에 오버레이로 표시됨
class AchievementNotificationWidget extends ConsumerStatefulWidget {
  const AchievementNotificationWidget({super.key});

  @override
  ConsumerState<AchievementNotificationWidget> createState() => _AchievementNotificationWidgetState();
}

class _AchievementNotificationWidgetState extends ConsumerState<AchievementNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  Achievement? _currentAchievement;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 새로 해제된 배지 스트림 감시
    ref.listen<AsyncValue<Achievement>>(newUnlockedAchievementProvider, (previous, next) {
      next.whenData((achievement) {
        _showNotification(achievement);
      });
    });

    if (!_isVisible || _currentAchievement == null) {
      return const SizedBox.shrink();
    }

    return _buildNotification(context);
  }

  Widget _buildNotification(BuildContext context) {
    final theme = Theme.of(context);
    final achievement = _currentAchievement!;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTierColor(achievement.tier),
                      _getTierColor(achievement.tier).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _getTierColor(achievement.tier).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
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
                          child: Center(
                            child: Text(
                              _getAchievementEmoji(achievement.code),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context).badgeAchieved,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _getAchievementTitle(achievement.code, AppLocalizations.of(context)),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _hideNotification,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getAchievementDescription(achievement.code, AppLocalizations.of(context)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    if (achievement.treatReward > 0 || achievement.happinessReward > 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (achievement.treatReward > 0) ...[
                              const Text('🦴', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '+${achievement.treatReward}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            if (achievement.treatReward > 0 && achievement.happinessReward > 0)
                              const SizedBox(width: 12),
                            if (achievement.happinessReward > 0) ...[
                              const Text('😊', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '+${achievement.happinessReward}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotification(Achievement achievement) {
    setState(() {
      _currentAchievement = achievement;
      _isVisible = true;
    });

    _animationController.forward();

    // 5초 후 자동으로 숨김
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _hideNotification();
      }
    });
  }

  void _hideNotification() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
          _currentAchievement = null;
        });
      }
    });
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
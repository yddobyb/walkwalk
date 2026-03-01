// lib/presentation/widgets/mission_completion_notification.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mission.dart';
import '../../l10n/app_localizations.dart';

/// 미션 완료 알림 위젯
/// 미션 완료 시 애니메이션과 함께 보상 정보를 표시
class MissionCompletionNotification extends ConsumerStatefulWidget {
  final Mission mission;
  final VoidCallback? onDismiss;

  const MissionCompletionNotification({
    super.key,
    required this.mission,
    this.onDismiss,
  });

  @override
  ConsumerState<MissionCompletionNotification> createState() =>
      _MissionCompletionNotificationState();
}

class _MissionCompletionNotificationState
    extends ConsumerState<MissionCompletionNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _sparkleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.bounceOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    // 애니메이션 시작
    _startAnimations();

    // 자동 해제 타이머
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismissNotification();
      }
    });
  }

  void _startAnimations() async {
    await _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _scaleController.forward();
    _sparkleController.repeat();
  }

  void _dismissNotification() async {
    _sparkleController.stop();
    await _slideController.reverse();
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.withValues(alpha: 0.9),
                  Colors.greenAccent.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: Stack(
              children: [
                // 반짝이는 효과
                _buildSparkleEffects(),

                // 메인 콘텐츠
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 헤더
                      Row(
                        children: [
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).missionComplete,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.mission.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _dismissNotification,
                            icon: Icon(
                              Icons.close,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 보상 정보
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context).rewardsEarned,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildRewardItem(
                                    context: context,
                                    icon: Icons.pets,
                                    value: AppLocalizations.of(context).missionTreatsCount(widget.mission.treatReward),
                                    label: AppLocalizations.of(context).missionTreatsLabel,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                Expanded(
                                  child: _buildRewardItem(
                                    context: context,
                                    icon: Icons.favorite,
                                    value: '+${widget.mission.happinessReward}',
                                    label: AppLocalizations.of(context).missionHappinessLabel,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 축하 메시지
                      Text(
                        AppLocalizations.of(context).congratulations,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkleEffects() {
    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // 반짝이는 점들
            for (int i = 0; i < 5; i++)
              Positioned(
                top: 20 + (i * 30) + (_sparkleAnimation.value * 10),
                right: 20 + (i * 25) + (_sparkleAnimation.value * 5),
                child: Opacity(
                  opacity: (1 - _sparkleAnimation.value).clamp(0.0, 1.0),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            for (int i = 0; i < 3; i++)
              Positioned(
                bottom: 30 + (i * 25) + (_sparkleAnimation.value * 8),
                left: 30 + (i * 35) + (_sparkleAnimation.value * 6),
                child: Opacity(
                  opacity: (1 - _sparkleAnimation.value).clamp(0.0, 1.0),
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// 미션 완료 알림을 표시하는 오버레이 위젯
class MissionCompletionOverlay extends StatefulWidget {
  final Mission mission;

  const MissionCompletionOverlay({
    super.key,
    required this.mission,
  });

  @override
  State<MissionCompletionOverlay> createState() =>
      _MissionCompletionOverlayState();

  static void show(BuildContext context, Mission mission) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => MissionCompletionOverlay(mission: mission),
    );

    overlay.insert(overlayEntry);

    // 5초 후 자동 제거
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _MissionCompletionOverlayState extends State<MissionCompletionOverlay> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: MissionCompletionNotification(
        mission: widget.mission,
        onDismiss: () {
          // 오버레이 제거는 부모에서 처리됨
        },
      ),
    );
  }
}
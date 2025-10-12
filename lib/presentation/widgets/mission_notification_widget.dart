// lib/presentation/widgets/mission_notification_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/mission/mission_service.dart';
import '../screens/home/widgets/pet_dialogue_widget.dart';

/// 미션 완료 알림을 표시하는 위젯
/// 홈 화면에 오버레이로 표시됨
class MissionNotificationWidget extends ConsumerStatefulWidget {
  const MissionNotificationWidget({super.key});

  @override
  ConsumerState<MissionNotificationWidget> createState() => _MissionNotificationWidgetState();
}

class _MissionNotificationWidgetState extends ConsumerState<MissionNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  MissionCompletionNotification? _currentNotification;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 미션 완료 스트림 감시
    ref.listen<AsyncValue<MissionCompletionNotification>>(
      missionCompletionNotificationProvider,
      (previous, next) {
        next.whenData((notification) {
          _showNotification(notification);
        });
      },
    );

    if (!_isVisible || _currentNotification == null) {
      return const SizedBox.shrink();
    }

    return _buildNotification(context);
  }

  Widget _buildNotification(BuildContext context) {
    final theme = Theme.of(context);
    final notification = _currentNotification!;
    final mission = notification.mission;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
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
                      _getMissionTypeColor(mission.type),
                      _getMissionTypeColor(mission.type).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getMissionTypeColor(mission.type).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(
                          _getMissionTypeIcon(mission.type),
                          color: Colors.white,
                          size: 20,
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
                                Icons.check_circle,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '미션 완료!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            mission.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (mission.treatReward > 0 || mission.happinessReward > 0) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (mission.treatReward > 0) ...[
                                  const Text('🦴', style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${mission.treatReward}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                                if (mission.treatReward > 0 && mission.happinessReward > 0)
                                  const SizedBox(width: 12),
                                if (mission.happinessReward > 0) ...[
                                  const Text('😊', style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${mission.happinessReward}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
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
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotification(MissionCompletionNotification notification) {
    setState(() {
      _currentNotification = notification;
      _isVisible = true;
    });

    _animationController.forward();

    // 4초 후 자동으로 숨김 → 그 후 AI 대화 Bottom Sheet 표시
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _hideNotification();

        // 알림 애니메이션 완료 후 Bottom Sheet 표시
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            _showMissionCompleteDialog(notification);
          }
        });
      }
    });
  }

  void _hideNotification() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
          _currentNotification = null;
        });
      }
    });
  }

  void _showMissionCompleteDialog(MissionCompletionNotification notification) {
    final mission = notification.mission;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 드래그 핸들
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // AI 대화 (mission_complete)
            PetDialogueWidget(
              context: 'mission_complete',
              contextData: {
                'missionTitle': mission.title,
              },
            ),
            const SizedBox(height: 16),
            // 닫기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('닫기'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Color _getMissionTypeColor(String type) {
    switch (type) {
      case 'daily':
        return const Color(0xFF4CAF50); // Green
      case 'weekly':
        return const Color(0xFF2196F3); // Blue
      default:
        return const Color(0xFF9C27B0); // Purple
    }
  }

  IconData _getMissionTypeIcon(String type) {
    switch (type) {
      case 'daily':
        return Icons.today;
      case 'weekly':
        return Icons.date_range;
      default:
        return Icons.star;
    }
  }
}

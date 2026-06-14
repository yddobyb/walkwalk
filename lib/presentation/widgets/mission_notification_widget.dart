// lib/presentation/widgets/mission_notification_widget.dart
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mission.dart';
import '../../l10n/app_localizations.dart';
import '../../services/mission/mission_service.dart';
import '../screens/home/widgets/pet_dialogue_widget.dart';

/// 미션 완료 축하 토스트
///
/// 홈 화면 상단 오버레이로 표시된다. 완료 알림이 발생할 때(라이브) 뿐 아니라,
/// 홈 진입 전 자동완료된 미션(설치/권한 허용 직후)도 MissionService 버퍼에서
/// 꺼내 재생한다. 여러 개가 쌓이면 큐로 하나씩 보여준다.
class MissionNotificationWidget extends ConsumerStatefulWidget {
  const MissionNotificationWidget({super.key});

  @override
  ConsumerState<MissionNotificationWidget> createState() =>
      _MissionNotificationWidgetState();
}

/// 큐 항목: 알림 + 재생 여부(재생본은 후속 대화 시트를 띄우지 않음)
class _QueuedCelebration {
  final MissionCompletionNotification notification;
  final bool replayed;
  const _QueuedCelebration(this.notification, {required this.replayed});
}

class _MissionNotificationWidgetState
    extends ConsumerState<MissionNotificationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _slide;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  final Queue<_QueuedCelebration> _queue = Queue();
  _QueuedCelebration? _current;
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 520),
      reverseDuration: const Duration(milliseconds: 320),
      vsync: this,
    );
    _slide = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    ));
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    ));
    _fade = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    // 홈 마운트 시점에 버퍼된(놓친) 축하 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final pending = ref.read(missionServiceProvider).takePendingCelebrations();
      for (final n in pending) {
        _enqueue(n, replayed: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _enqueue(MissionCompletionNotification n, {required bool replayed}) {
    _queue.add(_QueuedCelebration(n, replayed: replayed));
    if (!_isShowing) _showNext();
  }

  void _showNext() {
    if (_queue.isEmpty) {
      setState(() {
        _isShowing = false;
        _current = null;
      });
      return;
    }
    setState(() {
      _current = _queue.removeFirst();
      _isShowing = true;
    });
    _animationController.forward(from: 0);

    // 4.2초 후 자동 닫기
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted && _current != null) _dismiss();
    });
  }

  void _dismiss() {
    final dismissed = _current;
    _animationController.reverse().then((_) {
      if (!mounted) return;
      setState(() => _current = null);
      // 라이브 완료는 펫 대화 시트로 마무리(재생본은 온보딩 과밀 방지로 생략)
      if (dismissed != null && !dismissed.replayed) {
        _showMissionCompleteDialog(dismissed.notification);
      }
      // 다음 큐 처리(시트와 안 겹치게 약간 지연)
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) _showNext();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 라이브 완료 알림 감시: 버퍼에서 제거 후 큐에 추가(중복 표시 방지)
    ref.listen<AsyncValue<MissionCompletionNotification>>(
      missionCompletionNotificationProvider,
      (previous, next) {
        next.whenData((notification) {
          ref.read(missionServiceProvider).clearPendingCelebration(notification);
          _enqueue(notification, replayed: false);
        });
      },
    );

    final current = _current;
    if (current == null) return const SizedBox.shrink();
    return _buildToast(context, current.notification);
  }

  Widget _buildToast(
      BuildContext context, MissionCompletionNotification notification) {
    final theme = Theme.of(context);
    final mission = notification.mission;
    final accent = _missionTypeColor(mission.type);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fade.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, _slide.value * 80),
              child: Transform.scale(scale: _scale.value, child: child),
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: _dismiss,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, Color.lerp(accent, Colors.black, 0.18)!],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 헤더: 타입 배지 + "🎉 미션 완료!" + 닫기
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_missionTypeIcon(mission.type),
                            color: Colors.white, size: 19),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).missionCompleteCelebration,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _dismiss,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close,
                              color: Colors.white70, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 미션 제목
                  Text(
                    mission.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // 달성 라인 (걸음수 미션이면 실제 수치, 아니면 설명)
                  Text(
                    _achievementLine(context, mission),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 보상 칩
                  Row(
                    children: [
                      if (mission.treatReward > 0)
                        _RewardChip(
                            emoji: '🦴', value: '+${mission.treatReward}'),
                      if (mission.treatReward > 0 && mission.happinessReward > 0)
                        const SizedBox(width: 8),
                      if (mission.happinessReward > 0)
                        _RewardChip(
                            emoji: '❤️', value: '+${mission.happinessReward}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _achievementLine(BuildContext context, Mission mission) {
    if (mission.targetSteps > 0) {
      return AppLocalizations.of(context)
          .missionAchievedSteps(_formatNumber(mission.currentProgress));
    }
    return mission.description;
  }

  /// 천 단위 콤마 (예: 47253 → 47,253)
  String _formatNumber(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            PetDialogueWidget(
              context: 'mission_complete',
              contextData: {'title': mission.title},
            ),
            const SizedBox(height: 16),
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
                child: Text(AppLocalizations.of(context).close),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Color _missionTypeColor(String type) {
    switch (type) {
      case 'daily':
        return const Color(0xFF4CAF50); // Green
      case 'weekly':
        return const Color(0xFF2196F3); // Blue
      default:
        return const Color(0xFF9C27B0); // Purple
    }
  }

  IconData _missionTypeIcon(String type) {
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

/// 보상 칩 (반투명 흰 배경 + 이모지 + 값)
class _RewardChip extends StatelessWidget {
  final String emoji;
  final String value;

  const _RewardChip({required this.emoji, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

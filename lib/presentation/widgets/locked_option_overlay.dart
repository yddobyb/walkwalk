// lib/presentation/widgets/locked_option_overlay.dart
import 'package:flutter/material.dart';

/// 프리미엄 전용 옵션 위에 겹치는 자물쇠 표시 (Phase 29-3).
///
/// **잠긴 항목을 숨기지 않고 보여주는 게 핵심이다.** 목록에서 빼버리면 무료
/// 이용자는 그런 게 있는 줄도 모르고, 그러면 구독할 이유도 안 보인다.
/// 자물쇠가 달린 채로 눈에 띄어야 "저걸 쓰려면 결제"가 성립한다.
///
/// 잠긴 칸도 **탭은 받는다** — 막힌 느낌 대신 업그레이드 안내로 이어준다.
class LockedOptionOverlay extends StatelessWidget {
  const LockedOptionOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // 잠긴 건 흐리게 — 쓸 수 없다는 게 한눈에 보여야 한다
        Opacity(opacity: 0.45, child: child),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(Icons.lock, size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

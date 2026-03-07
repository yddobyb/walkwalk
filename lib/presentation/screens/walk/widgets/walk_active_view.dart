// lib/presentation/screens/walk/widgets/walk_active_view.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/location/location_service.dart';
import '../../../../services/tracking/step_tracking_service.dart';

/// 산책 중 실시간 추적 뷰
class WalkActiveView extends ConsumerWidget {
  final int elapsedSeconds;
  final int stepsAtWalkStart;
  final VoidCallback onStopWalk;
  final bool isStopping;

  const WalkActiveView({
    super.key,
    required this.elapsedSeconds,
    required this.stepsAtWalkStart,
    required this.onStopWalk,
    this.isStopping = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dailyStepsAsync = ref.watch(dailyStepsProvider);
    final outdoorAsync = ref.watch(outdoorStatusProvider);

    final sessionSteps = dailyStepsAsync.when(
      data: (daily) => max(0, daily - stepsAtWalkStart),
      loading: () => 0,
      error: (_, __) => 0,
    );
    final distanceKm = (sessionSteps * 0.7) / 1000;
    final isOutdoor = outdoorAsync.valueOrNull ?? false;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 1. 타이머 카드
                _TimerCard(
                  elapsedSeconds: elapsedSeconds,
                  theme: theme,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),

                // 2. 세션 걸음수 카드
                _SessionStepsCard(
                  sessionSteps: sessionSteps,
                  theme: theme,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),

                // 3. 라이브 통계 행
                _LiveStatsRow(
                  distanceKm: distanceKm,
                  isOutdoor: isOutdoor,
                  theme: theme,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),

                // 4. 응원 메시지
                _MotivationalTip(theme: theme, l10n: l10n),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),

        // 5. 하단 고정 정지 버튼
        _StopWalkButton(
          onStopWalk: onStopWalk,
          isStopping: isStopping,
          theme: theme,
          l10n: l10n,
        ),
      ],
    );
  }
}

/// 1. 대형 타이머 카드
class _TimerCard extends StatelessWidget {
  final int elapsedSeconds;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _TimerCard({
    required this.elapsedSeconds,
    required this.theme,
    required this.l10n,
  });

  String _formatTime(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:'
      '${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:'
      '${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.walkScreenElapsedTime,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(elapsedSeconds),
            style: theme.textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFeatures: [
                const FontFeature.tabularFigures(),
              ],
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. 세션 걸음수 카드
class _SessionStepsCard extends StatelessWidget {
  final int sessionSteps;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _SessionStepsCard({
    required this.sessionSteps,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.walkScreenSessionSteps,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$sessionSteps',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontFeatures: [
                const FontFeature.tabularFigures(),
              ],
            ),
          ),
          Text(
            l10n.stepsUnitLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. 라이브 통계 행 (추정 거리 | 실내/실외 배지)
class _LiveStatsRow extends StatelessWidget {
  final double distanceKm;
  final bool isOutdoor;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _LiveStatsRow({
    required this.distanceKm,
    required this.isOutdoor,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(Icons.straighten,
                  color: theme.colorScheme.secondary,
                  size: 22),
              const SizedBox(height: 4),
              Text(
                '${distanceKm.toStringAsFixed(2)}km',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
              Text(
                l10n.distance,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color:
                theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Column(
            children: [
              Icon(
                isOutdoor
                    ? Icons.wb_sunny
                    : Icons.home,
                color: isOutdoor
                    ? Colors.orange
                    : Colors.blueGrey,
                size: 22,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (isOutdoor
                          ? Colors.orange
                          : Colors.blueGrey)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOutdoor
                      ? l10n.walkScreenOutdoorBadge
                      : l10n.walkScreenIndoorBadge,
                  style:
                      theme.textTheme.bodySmall?.copyWith(
                    color: isOutdoor
                        ? Colors.orange.shade700
                        : Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 4. 응원 메시지
class _MotivationalTip extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _MotivationalTip({
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.directions_walk,
            size: 20,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.walkScreenMotivation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 5. 하단 고정 정지 버튼
class _StopWalkButton extends StatelessWidget {
  final VoidCallback onStopWalk;
  final bool isStopping;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _StopWalkButton({
    required this.onStopWalk,
    required this.isStopping,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isStopping ? null : onStopWalk,
            style: ElevatedButton.styleFrom(
              backgroundColor: isStopping
                  ? Colors.grey
                  : Colors.red.shade600,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor:
                  Colors.white.withValues(alpha: 0.7),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isStopping)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.stop, size: 24),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isStopping
                        ? l10n.walkEndingMessage
                        : l10n.walkEndButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

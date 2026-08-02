// lib/presentation/screens/walk/widgets/walk_idle_view.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/mission.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/location/location_availability_service.dart';
import '../../../../services/mission/mission_service.dart';
import '../../../../services/settings/settings_service.dart';
import '../../../../services/statistics/statistics_service.dart';
import '../../../../services/tracking/step_tracking_service.dart';

/// 산책 전 대시보드 뷰
class WalkIdleView extends ConsumerWidget {
  final void Function(bool isOutdoor) onStartWalk;

  const WalkIdleView({super.key, required this.onStartWalk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dailyStepsAsync = ref.watch(dailyStepsProvider);
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final streakAsync = ref.watch(streakDataProvider);
    final missionsAsync = ref.watch(activeMissionsStreamProvider);
    final locationEnabled = ref.watch(locationFeatureEnabledProvider);

    final int goalSteps = settingsAsync.when(
      data: (settings) => settings.dailyStepGoal,
      loading: () => AppConstants.dailyStepGoal,
      error: (_, __) => AppConstants.dailyStepGoal,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. 원형 진행도 카드
          _HeroProgressCard(
            dailyStepsAsync: dailyStepsAsync,
            goalSteps: goalSteps,
            theme: theme,
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 2. 빠른 통계 행
          _QuickStatsRow(
            dailyStepsAsync: dailyStepsAsync,
            streakAsync: streakAsync,
            theme: theme,
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 3. 활성 미션 카드
          _ActiveMissionsCard(
            missionsAsync: missionsAsync,
            dailyStepsAsync: dailyStepsAsync,
            theme: theme,
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 4. 산책 시작 섹션
          // Phase 27-8: 위치 미제공 지역에서는 실외 선택지를 아예 노출하지 않는다.
          _WalkStartSection(
            onStartWalk: onStartWalk,
            locationEnabled: locationEnabled,
            theme: theme,
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 5. 팁 카드
          _WalkTipsCard(
            locationEnabled: locationEnabled,
            theme: theme,
            l10n: l10n,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 1. 원형 진행도 히어로 카드
class _HeroProgressCard extends StatelessWidget {
  final AsyncValue<int> dailyStepsAsync;
  final int goalSteps;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _HeroProgressCard({
    required this.dailyStepsAsync,
    required this.goalSteps,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: dailyStepsAsync.when(
        data: (steps) {
          final progress = (steps / goalSteps).clamp(0.0, 1.0);
          final achieved = steps >= goalSteps;

          return Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        achieved
                            ? Colors.greenAccent
                            : Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$steps',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/ $goalSteps ${l10n.stepsUnitLabel}',
                        style:
                            theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                achieved
                    ? l10n.goalAchieved
                    : l10n.stepsToGoal(goalSteps - steps),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 140,
          child: Center(
            child:
                CircularProgressIndicator(color: Colors.white),
          ),
        ),
        error: (_, __) => SizedBox(
          height: 140,
          child: Center(
            child: Text(
              l10n.cannotLoadSteps,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// 2. 빠른 통계 행 (거리 | 활동시간 | 연속일수)
class _QuickStatsRow extends StatelessWidget {
  final AsyncValue<int> dailyStepsAsync;
  final AsyncValue<StreakData> streakAsync;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _QuickStatsRow({
    required this.dailyStepsAsync,
    required this.streakAsync,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final steps = dailyStepsAsync.valueOrNull ?? 0;
    final distanceKm = (steps * 0.7) / 1000;
    final activeMinutes = (steps / 100).round();
    final streak = streakAsync.valueOrNull?.currentStreak ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 8),
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
        children: [
          Expanded(
            child: _QuickStatItem(
              icon: Icons.straighten,
              value: '${distanceKm.toStringAsFixed(1)}km',
              label: l10n.distance,
              color: theme.colorScheme.secondary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _QuickStatItem(
              icon: Icons.timer,
              value:
                  '$activeMinutes${l10n.minutesUnitLabel}',
              label: l10n.activeTime,
              color: theme.colorScheme.tertiary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _QuickStatItem(
              icon: Icons.local_fire_department,
              value: '$streak${l10n.daysUnit}',
              label: l10n.streakTitle,
              color: streak > 0 ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _QuickStatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

/// 3. 활성 미션 카드 (진행 중인 1~2개)
class _ActiveMissionsCard extends StatelessWidget {
  final AsyncValue<List<Mission>> missionsAsync;
  final AsyncValue<int> dailyStepsAsync;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _ActiveMissionsCard({
    required this.missionsAsync,
    required this.dailyStepsAsync,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return missionsAsync.when(
      data: (missions) {
        final active = missions
            .where(
                (m) => m.type == 'daily' && !m.isCompleted)
            .take(2)
            .toList();

        if (active.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
              children: [
                Icon(Icons.emoji_events,
                    color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.walkScreenAllMissionsDone,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag,
                      color: theme.colorScheme.primary,
                      size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.todaysMissions,
                    style:
                        theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...active.map((mission) =>
                  _MissionProgressItem(
                    mission: mission,
                    dailyStepsAsync: dailyStepsAsync,
                    theme: theme,
                  )),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _MissionProgressItem extends StatelessWidget {
  final Mission mission;
  final AsyncValue<int> dailyStepsAsync;
  final ThemeData theme;

  const _MissionProgressItem({
    required this.mission,
    required this.dailyStepsAsync,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final currentSteps = dailyStepsAsync.valueOrNull ?? 0;
    final current = mission.targetSteps > 0
        ? currentSteps
        : mission.currentProgress;
    final target = mission.targetSteps > 0
        ? mission.targetSteps
        : (mission.targetDuration > 0
            ? mission.targetDuration
            : max(1, mission.targetDistance.round()));
    final progress = (current / target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mission.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor:
                theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary),
            minHeight: 4,
          ),
        ],
      ),
    );
  }
}

/// 4. 산책 시작 섹션 (실내/실외 버튼)
class _WalkStartSection extends StatelessWidget {
  final void Function(bool isOutdoor) onStartWalk;

  /// false면 실외 버튼을 숨기고 실내 산책 단일 버튼만 보여준다(Phase 27-8).
  final bool locationEnabled;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _WalkStartSection({
    required this.onStartWalk,
    required this.locationEnabled,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.walkScreenStartPrompt,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (locationEnabled)
            Row(
              children: [
                Expanded(child: _indoorButton()),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onStartWalk(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 8),
                        Text(l10n.walkOutdoor),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            // 위치 미제공 지역: 실내/실외 구분 없이 단일 시작 버튼
            SizedBox(
              width: double.infinity,
              child: _indoorButton(label: l10n.walkStartWalk),
            ),
        ],
      ),
    );
  }

  Widget _indoorButton({String? label}) {
    return ElevatedButton(
      onPressed: () => onStartWalk(false),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(label == null ? Icons.home : Icons.directions_walk),
          const SizedBox(width: 8),
          Text(label ?? l10n.walkIndoor),
        ],
      ),
    );
  }
}

/// 5. 팁 카드
class _WalkTipsCard extends StatelessWidget {
  /// false면 실외 보너스 대신 걸음수 기반 안내를 보여준다(Phase 27-8).
  final bool locationEnabled;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _WalkTipsCard({
    required this.locationEnabled,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              locationEnabled
                  ? l10n.walkOutdoorBonus
                  : l10n.walkStepsOnlyTip,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

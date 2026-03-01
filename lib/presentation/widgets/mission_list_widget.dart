// lib/presentation/widgets/mission_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mission.dart';
import '../../l10n/app_localizations.dart';
import '../../services/mission/mission_service.dart';
import '../../services/tracking/step_tracking_service.dart';
import 'mission_card_widget.dart';

/// 미션 목록 위젯
/// 일일/주간 미션을 탭으로 구분하여 표시
class MissionListWidget extends ConsumerStatefulWidget {
  const MissionListWidget({super.key});

  @override
  ConsumerState<MissionListWidget> createState() => _MissionListWidgetState();
}

class _MissionListWidgetState extends ConsumerState<MissionListWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 탭 바
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.primary,
            ),
            labelColor: theme.colorScheme.onPrimary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.today, size: 16),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).daily),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range, size: 16),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).weekly),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).missionCompleted),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 탭 뷰
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDailyMissions(),
              _buildWeeklyMissions(),
              _buildCompletedMissions(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyMissions() {
    final dailyMissionsAsync = ref.watch(dailyMissionsProvider);

    return dailyMissionsAsync.when(
      data: (missions) {
        if (missions.isEmpty) {
          return _buildEmptyState(
            icon: Icons.today,
            title: AppLocalizations.of(context).noDailyMissions,
            subtitle: AppLocalizations.of(context).newMissionsComingSoon,
          );
        }

        return _buildMissionList(missions);
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(AppLocalizations.of(context).errorLoadingDailyMissions),
    );
  }

  Widget _buildWeeklyMissions() {
    final weeklyMissionsAsync = ref.watch(weeklyMissionsProvider);

    return weeklyMissionsAsync.when(
      data: (missions) {
        if (missions.isEmpty) {
          return _buildEmptyState(
            icon: Icons.date_range,
            title: AppLocalizations.of(context).noWeeklyMissions,
            subtitle: AppLocalizations.of(context).newWeeklyMissionsComingSoon,
          );
        }

        return _buildMissionList(missions);
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(AppLocalizations.of(context).errorLoadingWeeklyMissions),
    );
  }

  Widget _buildCompletedMissions() {
    final completedMissionsAsync = ref.watch(completedMissionsProvider);

    return completedMissionsAsync.when(
      data: (missions) {
        if (missions.isEmpty) {
          return _buildEmptyState(
            icon: Icons.emoji_events,
            title: AppLocalizations.of(context).noCompletedMissions,
            subtitle: AppLocalizations.of(context).completeToGetRewards,
          );
        }

        // 완료된 미션을 최신순으로 정렬
        final sortedMissions = List<Mission>.from(missions);
        sortedMissions.sort((a, b) {
          if (a.completedAt == null && b.completedAt == null) return 0;
          if (a.completedAt == null) return 1;
          if (b.completedAt == null) return -1;
          return b.completedAt!.compareTo(a.completedAt!);
        });

        return _buildMissionList(sortedMissions);
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(AppLocalizations.of(context).errorLoadingCompletedMissions),
    );
  }

  Widget _buildMissionList(List<Mission> missions) {
    return RefreshIndicator(
      onRefresh: () async {
        // Provider들을 새로고침
        ref.invalidate(dailyMissionsProvider);
        ref.invalidate(weeklyMissionsProvider);
        ref.invalidate(completedMissionsProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          return MissionCardWidget(
            mission: mission,
            onTap: () => _showMissionDetails(context, mission),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).loadingMissions),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(dailyMissionsProvider);
              ref.invalidate(weeklyMissionsProvider);
              ref.invalidate(completedMissionsProvider);
            },
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showMissionDetails(BuildContext context, Mission mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MissionDetailsBottomSheet(mission: mission),
    );
  }
}

/// 미션 상세 정보를 보여주는 바텀 시트
class _MissionDetailsBottomSheet extends ConsumerWidget {
  final Mission mission;

  const _MissionDetailsBottomSheet({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 걸음수 기반 미션인 경우 실시간 걸음수 가져오기
    // 일일 미션: dailyStepsProvider, 주간 미션: weeklyStepsProvider
    final stepsAsync = mission.targetSteps > 0
        ? (mission.type == 'weekly'
            ? ref.watch(weeklyStepsProvider)
            : ref.watch(dailyStepsProvider))
        : null;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 미션 타이틀과 상태
          Row(
            children: [
              _buildMissionTypeIcon(context, theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mission.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (mission.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context).missionCompleted,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // 진행도 상세
          _buildProgressSection(context, theme, stepsAsync),

          const SizedBox(height: 24),

          // 보상 정보
          _buildRewardSection(context, theme),

          const SizedBox(height: 24),

          // 미션 정보
          _buildMissionInfoSection(context, theme),

          const SizedBox(height: 24),

          // 닫기 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).close),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionTypeIcon(BuildContext context, ThemeData theme) {
    IconData icon;
    Color color;
    String typeText;

    switch (mission.type) {
      case 'daily':
        icon = Icons.today;
        color = Colors.blue;
        typeText = AppLocalizations.of(context).dailyMissionType;
        break;
      case 'weekly':
        icon = Icons.date_range;
        color = Colors.purple;
        typeText = AppLocalizations.of(context).weeklyMissionType;
        break;
      case 'special':
        icon = Icons.star;
        color = Colors.amber;
        typeText = AppLocalizations.of(context).specialMissionType;
        break;
      default:
        icon = Icons.flag;
        color = theme.colorScheme.primary;
        typeText = AppLocalizations.of(context).missions;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          typeText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, ThemeData theme, AsyncValue<int>? stepsAsync) {
    // 실시간 진행도 계산
    final currentProgress = _getCurrentProgress(stepsAsync);
    final progress = _calculateProgress(currentProgress);
    final isCompleted = mission.isCompleted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).missionProgress,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatProgress(currentProgress, context),
              style: theme.textTheme.titleLarge?.copyWith(
                color: isCompleted ? Colors.green : theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${AppLocalizations.of(context).targetLabel}: ${_formatTargetProgress(context)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(
            isCompleted ? Colors.green : theme.colorScheme.primary,
          ),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).percentComplete((progress * 100).toInt()),
          style: theme.textTheme.bodySmall?.copyWith(
            color: isCompleted ? Colors.green : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).rewardsLabel,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.pets,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${mission.treatReward}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).missionTreatsLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+${mission.happinessReward}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).missionHappinessLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.red.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionInfoSection(BuildContext context, ThemeData theme) {
    final now = DateTime.now();
    final timeRemaining = mission.expiresAt.difference(now);
    final isExpired = timeRemaining.isNegative;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).missionInfoTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.schedule,
          label: AppLocalizations.of(context).expiryTime,
          value: _formatDate(mission.expiresAt),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          icon: isExpired ? Icons.error : Icons.timer,
          label: AppLocalizations.of(context).remainingTime,
          value: isExpired ? AppLocalizations.of(context).missionExpired : _formatTimeRemaining(timeRemaining, context),
          valueColor: isExpired ? Colors.red : null,
        ),
        if (mission.completedAt != null) ...[
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.check_circle,
            label: AppLocalizations.of(context).completionTime,
            value: _formatDate(mission.completedAt!),
            valueColor: Colors.green,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: valueColor ?? Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  /// 현재 진행도 가져오기 (실시간 또는 DB 값)
  int _getCurrentProgress(AsyncValue<int>? stepsAsync) {
    // 걸음수 미션이고 실시간 데이터가 있으면 실시간 값 사용
    if (mission.targetSteps > 0 && stepsAsync != null) {
      return stepsAsync.when(
        data: (steps) => steps,
        loading: () => mission.currentProgress, // 로딩 중에는 DB 값 사용
        error: (_, __) => mission.currentProgress, // 에러 시에는 DB 값 사용
      );
    }

    // 걸음수 미션이 아니면 DB 값 사용
    return mission.currentProgress;
  }

  double _calculateProgress(int currentProgress) {
    final target = _getTargetProgress();
    if (target == 0) return 0.0;
    return (currentProgress / target).clamp(0.0, 1.0);
  }

  int _getTargetProgress() {
    if (mission.targetSteps > 0) return mission.targetSteps;
    if (mission.targetDuration > 0) return mission.targetDuration;
    if (mission.targetDistance > 0) return mission.targetDistance.round();
    return 1;
  }

  String _formatProgress(int progress, BuildContext context) {
    if (mission.targetSteps > 0) {
      return '$progress ${AppLocalizations.of(context).stepsUnitLabel}';
    } else if (mission.targetDuration > 0) {
      final minutes = progress ~/ 60;
      return '$minutes ${AppLocalizations.of(context).minutesUnitLabel}';
    } else if (mission.targetDistance > 0) {
      final km = progress / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
    return '$progress';
  }

  String _formatTargetProgress(BuildContext context) {
    if (mission.targetSteps > 0) {
      return '${mission.targetSteps} ${AppLocalizations.of(context).stepsUnitLabel}';
    } else if (mission.targetDuration > 0) {
      final minutes = mission.targetDuration ~/ 60;
      return '$minutes ${AppLocalizations.of(context).minutesUnitLabel}';
    } else if (mission.targetDistance > 0) {
      final km = mission.targetDistance / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
    return '${_getTargetProgress()}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeRemaining(Duration duration, BuildContext context) {
    if (duration.inDays > 0) {
      return '${duration.inDays} ${AppLocalizations.of(context).daysUnit} ${duration.inHours % 24} ${AppLocalizations.of(context).hoursUnit}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ${AppLocalizations.of(context).hoursUnit} ${duration.inMinutes % 60} ${AppLocalizations.of(context).minutesUnitLabel}';
    } else {
      return '${duration.inMinutes} ${AppLocalizations.of(context).minutesUnitLabel}';
    }
  }
}
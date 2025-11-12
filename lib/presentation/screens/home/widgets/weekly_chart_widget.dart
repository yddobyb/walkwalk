// lib/presentation/screens/home/widgets/weekly_chart_widget.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/statistics/statistics_service.dart';

/// 주간 걸음수 차트 위젯
class WeeklyChartWidget extends ConsumerWidget {
  const WeeklyChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyStatsAsync = ref.watch(weeklyStatisticsProvider);

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
              Text(
                AppLocalizations.of(context).weeklyActivity,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context).last7Days,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          weeklyStatsAsync.when(
            data: (stats) => _buildChart(context, theme, stats),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, ThemeData theme, List<DailyStatistics> stats) {
    if (stats.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // HealthKit 전체 걸음수 기준으로 차트 생성
    final maxSteps = stats.map((s) => s.steps).reduce((a, b) => a > b ? a : b);
    final averageSteps = stats.map((s) => s.steps).reduce((a, b) => a + b) / stats.length;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxSteps > 0 ? maxSteps * 1.2 : 10000,
              minY: 0,
              barGroups: _buildBarGroups(stats, theme),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxSteps > 0 ? maxSteps / 5 : 2000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max || value == 0) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          _formatNumber(value.toInt()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= stats.length) {
                        return const SizedBox.shrink();
                      }
                      final date = stats[index].date;
                      final dayName = _getWeekdayName(context, date.weekday);

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          dayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => theme.colorScheme.inverseSurface,
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final stat = stats[groupIndex];
                    final date = stat.date;
                    final totalSteps = stat.steps;
                    final appSteps = stat.appSessionSteps;

                    // 앱 세션이 있으면 구분하여 표시
                    String tooltipText = '${DateFormat('M/d').format(date)}\n${AppLocalizations.of(context).chartTooltipTotal(totalSteps)}';
                    if (appSteps > 0) {
                      tooltipText += '\n${AppLocalizations.of(context).chartTooltipAppWalk(appSteps)}';
                    }

                    return BarTooltipItem(
                      tooltipText,
                      TextStyle(
                        color: theme.colorScheme.onInverseSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              theme,
              AppLocalizations.of(context).average,
              '${averageSteps.round()}',
              Icons.trending_up,
              theme.colorScheme.primary,
            ),
            Container(
              width: 1,
              height: 30,
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            _buildStatItem(
              theme,
              AppLocalizations.of(context).maximum,
              '$maxSteps',
              Icons.military_tech,
              Colors.amber,
            ),
          ],
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<DailyStatistics> stats, ThemeData theme) {
    return List.generate(stats.length, (index) {
      final stat = stats[index];
      final isToday = _isToday(stat.date);
      final hasAppSession = stat.appSessionSteps > 0; // 앱으로 산책한 날인지 확인

      // 색상 결정: 오늘 > 앱 세션 있는 날 > 일반 날
      Color barColor;
      if (isToday) {
        barColor = theme.colorScheme.primary;
      } else if (hasAppSession) {
        barColor = Colors.green; // 앱 세션이 있는 날은 초록색
      } else {
        barColor = theme.colorScheme.primary.withOpacity(0.3);
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stat.steps.toDouble(),
            color: barColor,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Widget _buildStatItem(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          AppLocalizations.of(context).cannotLoadData,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).noRecordsYet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  /// 요일 번호를 현지화된 요일명으로 변환
  String _getWeekdayName(BuildContext context, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return AppLocalizations.of(context).mondayShort;
      case DateTime.tuesday:
        return AppLocalizations.of(context).tuesdayShort;
      case DateTime.wednesday:
        return AppLocalizations.of(context).wednesdayShort;
      case DateTime.thursday:
        return AppLocalizations.of(context).thursdayShort;
      case DateTime.friday:
        return AppLocalizations.of(context).fridayShort;
      case DateTime.saturday:
        return AppLocalizations.of(context).saturdayShort;
      case DateTime.sunday:
        return AppLocalizations.of(context).sundayShort;
      default:
        return '';
    }
  }
}

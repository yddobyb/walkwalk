// lib/services/statistics/statistics_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/database_service.dart';
import '../sensors/pedometer_service.dart';

/// 통계 데이터 모델
class DailyStatistics {
  final DateTime date;
  final int steps; // HealthKit에서 가져온 전체 걸음수
  final int appSessionSteps; // 앱으로 산책한 걸음수
  final double distance; // meters
  final int duration; // seconds
  final int walkCount;

  DailyStatistics({
    required this.date,
    required this.steps,
    required this.appSessionSteps,
    required this.distance,
    required this.duration,
    required this.walkCount,
  });

  factory DailyStatistics.empty(DateTime date) {
    return DailyStatistics(
      date: date,
      steps: 0,
      appSessionSteps: 0,
      distance: 0,
      duration: 0,
      walkCount: 0,
    );
  }
}

/// 연속 산책 기록
class StreakData {
  final int currentStreak; // 현재 연속 일수
  final int longestStreak; // 최장 연속 일수
  final DateTime? lastWalkDate; // 마지막 산책 날짜

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastWalkDate,
  });
}

/// 통계 서비스
class StatisticsService {
  final DatabaseService _databaseService;
  final PedometerService _pedometerService;

  StatisticsService(this._databaseService, this._pedometerService);

  /// 특정 날짜의 통계 가져오기
  Future<DailyStatistics> getDailyStatistics(DateTime date) async {
    try {
      // 앱 세션 데이터 가져오기
      final sessions = await _databaseService.getWalkSessionsByDate(date);

      int appSessionSteps = 0;
      double totalDistance = 0;
      int totalDuration = 0;

      for (var session in sessions) {
        appSessionSteps += session.totalSteps;
        totalDistance += session.distance;
        totalDuration += session.duration;
      }

      // HealthKit에서 전체 걸음수 가져오기
      final healthKitSteps = await _pedometerService.getStepsForDate(date) ?? 0;

      return DailyStatistics(
        date: date,
        steps: healthKitSteps,
        appSessionSteps: appSessionSteps,
        distance: totalDistance,
        duration: totalDuration,
        walkCount: sessions.length,
      );
    } catch (e) {
      debugPrint('StatisticsService - Error getting daily statistics: $e');
      return DailyStatistics.empty(date);
    }
  }

  /// 주간 통계 가져오기 (지난 7일)
  Future<List<DailyStatistics>> getWeeklyStatistics() async {
    try {
      final List<DailyStatistics> weeklyStats = [];
      final now = DateTime.now();

      for (int i = AppConstants.weeklyStatisticsDays - 1; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final stats = await getDailyStatistics(date);
        weeklyStats.add(stats);
      }

      return weeklyStats;
    } catch (e) {
      debugPrint('StatisticsService - Error getting weekly statistics: $e');
      return [];
    }
  }

  /// 월간 통계 가져오기 (지난 30일)
  Future<List<DailyStatistics>> getMonthlyStatistics() async {
    try {
      final List<DailyStatistics> monthlyStats = [];
      final now = DateTime.now();

      for (int i = AppConstants.monthlyStatisticsDays - 1; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final stats = await getDailyStatistics(date);
        monthlyStats.add(stats);
      }

      return monthlyStats;
    } catch (e) {
      debugPrint('StatisticsService - Error getting monthly statistics: $e');
      return [];
    }
  }

  /// 연속 산책 일수 계산
  Future<StreakData> getStreakData() async {
    try {
      final now = DateTime.now();
      int currentStreak = 0;
      int longestStreak = 0;
      int tempStreak = 0;
      DateTime? lastWalkDate;

      // 최근 90일간의 데이터를 조회
      for (int i = 0; i < AppConstants.streakMaxDays; i++) {
        final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final sessions = await _databaseService.getWalkSessionsByDate(date);

        if (sessions.isNotEmpty) {
          lastWalkDate ??= date;

          // 현재 연속 기록 계산 (오늘 또는 어제까지만)
          if (i <= 1) {
            if (currentStreak == 0 || i == currentStreak) {
              currentStreak++;
            } else {
              break; // 연속 끊김
            }
          }

          tempStreak++;
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
        } else {
          tempStreak = 0;
        }
      }

      return StreakData(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        lastWalkDate: lastWalkDate,
      );
    } catch (e) {
      debugPrint('StatisticsService - Error calculating streak: $e');
      return StreakData(
        currentStreak: 0,
        longestStreak: 0,
      );
    }
  }

  /// 전체 누적 통계
  Future<Map<String, dynamic>> getTotalStatistics() async {
    try {
      final allSessions = await _databaseService.getAllWalkSessions();

      int totalSteps = 0;
      double totalDistance = 0;
      int totalDuration = 0;
      int totalWalks = allSessions.length;

      for (var session in allSessions) {
        totalSteps += session.totalSteps;
        totalDistance += session.distance;
        totalDuration += session.duration;
      }

      return {
        'totalSteps': totalSteps,
        'totalDistance': totalDistance,
        'totalDuration': totalDuration,
        'totalWalks': totalWalks,
        'averageStepsPerWalk': totalWalks > 0 ? (totalSteps / totalWalks).round() : 0,
        'averageDistancePerWalk': totalWalks > 0 ? totalDistance / totalWalks : 0.0,
      };
    } catch (e) {
      debugPrint('StatisticsService - Error getting total statistics: $e');
      return {
        'totalSteps': 0,
        'totalDistance': 0.0,
        'totalDuration': 0,
        'totalWalks': 0,
        'averageStepsPerWalk': 0,
        'averageDistancePerWalk': 0.0,
      };
    }
  }
}

/// Providers
final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  final pedometerService = ref.watch(pedometerServiceProvider);
  return StatisticsService(DatabaseService(), pedometerService);
});

/// 주간 통계 Provider
final weeklyStatisticsProvider = FutureProvider<List<DailyStatistics>>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getWeeklyStatistics();
});

/// 월간 통계 Provider
final monthlyStatisticsProvider = FutureProvider<List<DailyStatistics>>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getMonthlyStatistics();
});

/// 연속 산책 일수 Provider
final streakDataProvider = FutureProvider<StreakData>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getStreakData();
});

/// 전체 누적 통계 Provider
final totalStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getTotalStatistics();
});

// lib/services/pet/happiness_scheduler_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/database_service.dart';
import '../notification/notification_service.dart';
import 'pet_reward_service.dart';

/// 펫의 행복도 일일 감소 스케줄러
/// - 매일 자정에 행복도 자연 감소 적용
/// - 백그라운드에서 실행되며 앱 시작 시 체크
class HappinessSchedulerService {
  static HappinessSchedulerService? _instance;
  static HappinessSchedulerService get instance {
    _instance ??= HappinessSchedulerService._();
    return _instance!;
  }

  HappinessSchedulerService._();

  final PetRewardService _rewardService = PetRewardService.instance;
  Timer? _dailyDecayTimer;
  bool _isInitialized = false;

  /// 스케줄러 초기화
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ HappinessSchedulerService already initialized');
      return;
    }

    try {
      // 앱 시작 시 누락된 일일 감소 적용
      await _applyMissedDailyDecay();

      // 다음 자정까지의 시간 계산하여 타이머 설정
      _scheduleNextDecay();

      _isInitialized = true;
      debugPrint('✅ HappinessSchedulerService initialized');
    } catch (e) {
      debugPrint('❌ HappinessSchedulerService initialization failed: $e');
      rethrow;
    }
  }

  /// 누락된 일일 감소 적용 (앱이 오래 꺼져 있었을 경우)
  Future<void> _applyMissedDailyDecay() async {
    try {
      final activePet = await _rewardService.getActivePet();
      if (activePet == null) {
        debugPrint('⚠️ No active pet found');
        return;
      }

      await _rewardService.applyDailyHappinessDecay(activePet.petId);
    } catch (e) {
      debugPrint('❌ Error applying missed decay: $e');
      rethrow;
    }
  }

  /// 다음 자정까지의 시간 계산하여 타이머 설정
  void _scheduleNextDecay() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final timeUntilMidnight = tomorrow.difference(now);

    _dailyDecayTimer?.cancel();
    _dailyDecayTimer = Timer(timeUntilMidnight, () {
      _applyDailyDecay();
      _scheduleNextDecay();
    });

    debugPrint('⏰ Next happiness decay in ${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m');
  }

  /// 일일 행복도 감소 적용
  Future<void> _applyDailyDecay() async {
    try {
      final activePet = await _rewardService.getActivePet();
      if (activePet == null) return;

      final updatedPet = await _rewardService
          .applyDailyHappinessDecay(activePet.petId);
      if (updatedPet != null &&
          updatedPet.happiness <= 30) {
        debugPrint(
          '⚠️ Pet happiness is low: '
          '${updatedPet.happiness}',
        );
        // 알림 설정이 켜져있으면 푸시 알림 발송
        await _sendLowHappinessNotification(
          updatedPet.name,
          updatedPet.happiness,
        );
      }
    } catch (e) {
      debugPrint('❌ Error applying daily decay: $e');
    }
  }

  /// 행복도 낮음 푸시 알림 발송
  Future<void> _sendLowHappinessNotification(
    String petName,
    int happiness,
  ) async {
    try {
      // 알림 설정 확인
      final dbService = DatabaseService();
      final settings = await dbService.getSettings();
      if (settings == null ||
          !settings.notificationsEnabled) {
        return;
      }

      final notifService = NotificationService.instance;
      if (!notifService.isInitialized) return;

      // locale에 따라 메시지 결정
      final isKorean = settings.locale == 'ko';
      final title = isKorean
          ? '$petName이(가) 슬퍼하고 있어요 😢'
          : '$petName is feeling sad 😢';
      final body = isKorean
          ? '행복도가 $happiness%로 낮아졌어요. '
              '산책이나 간식으로 기운을 내주세요!'
          : 'Happiness dropped to $happiness%. '
              'Go for a walk or give treats!';

      await notifService.showLowHappinessAlert(
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint(
        '❌ Error sending low happiness notification: $e',
      );
    }
  }

  /// 수동으로 행복도 감소 체크 (테스트용)
  Future<void> manualDecayCheck() async {
    await _applyMissedDailyDecay();
  }

  /// 스케줄러 중지
  void dispose() {
    _dailyDecayTimer?.cancel();
    _dailyDecayTimer = null;
    _isInitialized = false;
    debugPrint('🛑 HappinessSchedulerService disposed');
  }
}

/// Riverpod Provider
final happinessSchedulerServiceProvider = Provider<HappinessSchedulerService>((ref) {
  return HappinessSchedulerService.instance;
});

/// 스케줄러 초기화 Provider
final happinessSchedulerInitProvider = FutureProvider<void>((ref) async {
  final scheduler = ref.read(happinessSchedulerServiceProvider);
  await scheduler.initialize();
});
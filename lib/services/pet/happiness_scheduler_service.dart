// lib/services/pet/happiness_scheduler_service.dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
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
    // 강제로 로그 출력 (release 모드에서도 보이도록) - developer.log 사용!
    developer.log('═══════════════════════════════════════════════════');
    developer.log('HappinessSchedulerService.initialize() CALLED');
    developer.log('  _isInitialized: $_isInitialized');
    developer.log('═══════════════════════════════════════════════════');

    if (_isInitialized) {
      developer.log('⚠️ HappinessSchedulerService - Already initialized, skipping');
      return;
    }

    try {
      developer.log('🔄 HappinessSchedulerService - Starting initialization...');

      // 앱 시작 시 누락된 일일 감소 적용
      await _applyMissedDailyDecay();

      // 다음 자정까지의 시간 계산하여 타이머 설정
      _scheduleNextDecay();

      _isInitialized = true;
      developer.log('✅ HappinessSchedulerService - Initialized successfully');
    } catch (e, stackTrace) {
      developer.log('❌ HappinessSchedulerService - Initialization failed: $e');
      developer.log('   Stack trace: $stackTrace');
      // 실패해도 앱은 계속 실행 (일일 감소만 동작하지 않음)
      rethrow; // 에러를 다시 던져서 main.dart의 catchError에서 잡히도록
    }
  }

  /// 누락된 일일 감소 적용 (앱이 오래 꺼져 있었을 경우)
  Future<void> _applyMissedDailyDecay() async {
    try {
      final activePet = await _rewardService.getActivePet();
      if (activePet == null) {
        developer.log('⚠️ HappinessSchedulerService - No active pet found, skipping decay');
        return;
      }

      developer.log('✅ HappinessSchedulerService - Found active pet: ${activePet.name} (ID: ${activePet.petId})');
      await _rewardService.applyDailyHappinessDecay(activePet.petId);
      developer.log('✅ HappinessSchedulerService - Applied missed daily decay check');
    } catch (e) {
      developer.log('❌ HappinessSchedulerService - Error applying missed decay: $e');
      rethrow; // 에러를 다시 던져서 initialize()의 catch에서 처리
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
      // 다음 날 타이머 설정
      _scheduleNextDecay();
    });

    developer.log('⏰ HappinessSchedulerService - Next decay scheduled in ${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m');
  }

  /// 일일 행복도 감소 적용
  Future<void> _applyDailyDecay() async {
    try {
      final activePet = await _rewardService.getActivePet();
      if (activePet == null) return;

      final updatedPet = await _rewardService.applyDailyHappinessDecay(activePet.petId);
      if (updatedPet != null) {
        developer.log('✅ HappinessSchedulerService - Daily decay applied. Happiness: ${updatedPet.happiness}');

        // 행복도가 낮아졌다는 알림을 보낼 수 있음 (추후 구현)
        if (updatedPet.happiness <= AppConstants.minHappiness + 10) {
          developer.log('⚠️ HappinessSchedulerService - Pet happiness is getting low!');
        }
      }
    } catch (e) {
      developer.log('❌ HappinessSchedulerService - Error applying daily decay: $e');
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
    developer.log('🛑 HappinessSchedulerService - Disposed');
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
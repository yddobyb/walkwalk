// lib/presentation/screens/walk/walk_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/tracking/step_tracking_service.dart';
import '../../../services/ads/ad_service.dart';
import '../../../services/user/user_tier_providers.dart';
import 'widgets/walk_active_view.dart';
import 'widgets/walk_idle_view.dart';
import 'widgets/walk_result_bottom_sheet.dart';

/// 산책 화면 - 상태별 뷰 전환 (산책 전/중/후)
class WalkScreen extends ConsumerStatefulWidget {
  const WalkScreen({super.key});

  @override
  ConsumerState<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends ConsumerState<WalkScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _stepsAtWalkStart = 0;
  bool _isStopping = false;
  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreTimerIfWalking();
    });
  }

  /// 이미 산책 중이면 타이머 복구
  void _restoreTimerIfWalking() {
    final service = ref.read(stepTrackingServiceProvider);
    if (service.currentState == StepTrackingState.walking &&
        service.sessionStartTime != null) {
      setState(() {
        _stepsAtWalkStart = service.sessionStartSteps;
        _elapsedSeconds = DateTime.now()
            .difference(service.sessionStartTime!)
            .inSeconds;
      });
      _startTimer();
    }
  }

  /// 크로스탭 상태 변화 감지 (Home 탭에서 시작/종료 시)
  void _onTrackingStateChanged(
    StepTrackingState? prev,
    StepTrackingState next,
  ) {
    if (prev == next) return;

    if (next == StepTrackingState.walking &&
        _timer == null) {
      // 외부(Home 탭)에서 산책이 시작됨 → 타이머 복구
      _restoreTimerIfWalking();
    } else if (prev == StepTrackingState.walking &&
        next != StepTrackingState.walking) {
      // 외부(Home 탭)에서 산책이 종료됨 → 타이머 정리
      _timer?.cancel();
      _timer = null;
      if (mounted) {
        setState(() {
          _elapsedSeconds = 0;
          _stepsAtWalkStart = 0;
          _isStopping = false;
        });
      }
    }
  }

  /// 산책 시작
  Future<void> _startWalk(bool isOutdoor) async {
    if (_isStarting) return;
    _isStarting = true;

    final service = ref.read(stepTrackingServiceProvider);
    final l10n = AppLocalizations.of(context);

    // 이미 산책 중이면 무시
    if (service.currentState == StepTrackingState.walking) {
      _isStarting = false;
      return;
    }

    try {
      final success = await service.startWalkSession(
          enableGPS: isOutdoor);

      if (success) {
        // 서비스에서 확정된 값 사용 (Bug 5 fix)
        setState(() {
          _stepsAtWalkStart = service.sessionStartSteps;
          _elapsedSeconds = 0;
        });
        _startTimer();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isOutdoor
                    ? l10n.walkStartedOutdoor
                    : l10n.walkStartedIndoor,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.walkStartFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOccurred(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isStarting = false;
    }
  }

  /// 산책 종료
  Future<void> _stopWalk() async {
    if (_isStopping) return;
    setState(() {
      _isStopping = true;
    });

    final service = ref.read(stepTrackingServiceProvider);
    final l10n = AppLocalizations.of(context);

    _timer?.cancel();
    _timer = null;

    try {
      // 종료 중 로딩 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.walkEndingMessage)),
              ],
            ),
            backgroundColor: Colors.blue.shade700,
            duration: const Duration(seconds: 4),
          ),
        );
      }

      // 종료 전 펫 레벨 저장
      final petBefore = await service.petUpdateStream.first;
      final levelBefore = petBefore?.level ?? 1;

      // 산책 종료 (3초 동기화 대기 포함)
      final walkSession = await service.stopWalkSession();

      if (walkSession != null) {
        // 종료 후 펫 레벨 확인
        await Future.delayed(
            const Duration(milliseconds: 300));
        final petAfter =
            await service.petUpdateStream.first;
        final levelAfter = petAfter?.level ?? 1;

        // 로컬 상태 리셋
        if (mounted) {
          setState(() {
            _elapsedSeconds = 0;
            _stepsAtWalkStart = 0;
            _isStopping = false;
          });
        }

        // 결과 BottomSheet 표시
        if (mounted) {
          await WalkResultBottomSheet.show(
            context,
            walkSession: walkSession,
            levelBefore: levelBefore,
            levelAfter: levelAfter,
          );
        }
        // 산책 완료 시트가 닫힌 뒤 전면광고 (레벨업 시 생략 — 축하 흐름 방해 X).
        // 프리미엄 제외/빈도 제한은 AdService가 처리.
        if (mounted && levelAfter <= levelBefore) {
          final isPremium =
              ref.read(isPremiumUserProvider).valueOrNull ?? false;
          ref
              .read(adServiceProvider)
              .maybeShowWalkInterstitial(isPremium: isPremium);
        }
      } else {
        if (mounted) {
          setState(() {
            _isStopping = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.walkEndError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isStopping = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(l10n.errorOccurred(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 타이머 시작
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {
            _elapsedSeconds++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 크로스탭 상태 변화 리스너 (Bug 1+2 fix)
    ref.listen<AsyncValue<StepTrackingState>>(
      stepTrackingStateProvider,
      (prev, next) {
        final prevState = prev?.valueOrNull;
        final nextState = next.valueOrNull;
        if (nextState != null) {
          _onTrackingStateChanged(prevState, nextState);
        }
      },
    );

    final stepTrackingStateAsync =
        ref.watch(stepTrackingStateProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walkTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: stepTrackingStateAsync.when(
          data: (state) {
            switch (state) {
              case StepTrackingState.walking:
                return WalkActiveView(
                  elapsedSeconds: _elapsedSeconds,
                  stepsAtWalkStart: _stepsAtWalkStart,
                  onStopWalk: _stopWalk,
                  isStopping: _isStopping,
                );
              case StepTrackingState.stopped:
              case StepTrackingState.monitoring:
                return WalkIdleView(
                  onStartWalk: _startWalk,
                );
              case StepTrackingState.error:
                return _buildErrorView(context);
            }
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => _buildErrorView(context),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.walkSensorUnavailable,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.walkPermissionRequired,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

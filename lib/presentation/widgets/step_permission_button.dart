// lib/presentation/widgets/step_permission_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import '../../services/sensors/pedometer_service.dart';
import '../../services/statistics/statistics_service.dart';
import '../../services/tracking/step_tracking_service.dart';

/// 걸음수(Health) 권한을 다시 요청하는 공용 플로우.
///
/// 1) 인앱 요청 — Android Health Connect / iOS HealthKit 시트를 띄운다.
///    온보딩에서 "나중에"로 스킵해 아직 OS에 한 번도 묻지 않은 사용자는 여기서 바로 해결된다.
/// 2) 허용되면 트래킹을 (재)초기화하고 관련 Provider를 invalidate 해 UI를 즉시 갱신한다.
/// 3) 여전히 거부 상태면(이미 OS에서 거부했거나 iOS에서 한 번 결정한 경우) 인앱 시트가
///    더는 안 뜨므로 OS 설정으로 유도한다.
Future<void> requestStepPermission(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final pedometer = ref.read(pedometerServiceProvider);

  bool granted = false;
  try {
    await pedometer.requestPermission();
    granted = await pedometer.hasPermission();
  } catch (_) {
    granted = false;
  }

  if (granted) {
    // startup에서 미뤄둔 트래킹 초기화 + 화면 갱신
    await StepTrackingService().initialize();
    ref.invalidate(healthPermissionProvider);
    ref.invalidate(dailyStepsProvider);
    ref.invalidate(weeklyStepsProvider);
    ref.invalidate(stepTrackingStateProvider);
    // 펫 스트림도 새로 구독 → 보상 반영된 펫(간식/행복도)과 채팅 즉시 갱신
    ref.invalidate(petTrackingProvider);
    // Health 직접 조회 통계(주간/월간 차트·스트릭·합계)도 갱신.
    // 권한 전 홈 마운트 시 빈 결과로 캐시되므로, 허용 후 재계산해야 데이터가 채워진다.
    ref.invalidate(weeklyStatisticsProvider);
    ref.invalidate(monthlyStatisticsProvider);
    ref.invalidate(streakDataProvider);
    ref.invalidate(totalStatisticsProvider);
    messenger.showSnackBar(SnackBar(
      content: Text(l10n.stepPermissionGranted),
      backgroundColor: Colors.green,
    ));
  } else {
    messenger.showSnackBar(SnackBar(
      content: Text(l10n.stepPermissionDeniedHint),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(
        label: l10n.openSettings,
        onPressed: openAppSettings,
      ),
    ));
  }
}

/// "권한 켜기" 버튼 (요청 중 스피너 표시).
///
/// 홈 걸음수 카드와 산책 버튼 에러 카드에서 공용으로 쓴다.
class StepPermissionButton extends ConsumerStatefulWidget {
  /// 어두운/컬러 배경(errorContainer 등) 위에 올릴 때 true → 흰 버튼 + 컬러 글자.
  final bool onDark;

  const StepPermissionButton({super.key, this.onDark = false});

  @override
  ConsumerState<StepPermissionButton> createState() =>
      _StepPermissionButtonState();
}

class _StepPermissionButtonState extends ConsumerState<StepPermissionButton> {
  bool _loading = false;

  Future<void> _onTap() async {
    if (_loading) return;
    setState(() => _loading = true);
    await requestStepPermission(context, ref);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ElevatedButton.icon(
      onPressed: _loading ? null : _onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            widget.onDark ? Colors.white : theme.colorScheme.primary,
        foregroundColor:
            widget.onDark ? theme.colorScheme.primary : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      icon: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('👟', style: TextStyle(fontSize: 16)),
      label: Text(
        l10n.stepPermissionEnableCta,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

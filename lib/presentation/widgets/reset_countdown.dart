// lib/presentation/widgets/reset_countdown.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/firebase/image_generation_providers.dart';

/// 남은 시간(초)을 "13h 8m 5s" 형태로 포맷한다(언어 독립 약어).
///
/// - 1시간 이상: `13h 8m 5s`
/// - 1분 이상: `8m 5s`
/// - 그 외: `5s`
String formatCountdown(int seconds) {
  final total = seconds < 0 ? 0 : seconds;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  if (h > 0) return '${h}h ${m}m ${s}s';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}

/// 리셋까지 남은 시간을 실시간(1초)으로 카운트다운하는 텍스트.
///
/// - [resetAt]: 절대 리셋 시각(서버 `resetAt`). 매 틱 [clock]() 기준으로 다시
///   계산하므로, 백그라운드에 다녀와도(타이머가 멈췄다 재개돼도) 복귀 시 자동 보정된다.
/// - [label]: 포맷된 시간 문자열("13h 8m 5s")을 받아 최종 문장으로 감싼다(l10n 메서드 등).
/// - [autoRefresh]: true면 0초 도달 시 [quotaProvider]를 무효화해 새 할당량을 받아온다.
/// - [clock]: 현재 시각 공급자(테스트 주입용, 기본 `DateTime.now`).
class ResetCountdown extends ConsumerStatefulWidget {
  const ResetCountdown({
    super.key,
    required this.resetAt,
    required this.label,
    this.style,
    this.textAlign,
    this.autoRefresh = true,
    this.clock,
  });

  final DateTime resetAt;
  final String Function(String formatted) label;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool autoRefresh;
  final DateTime Function()? clock;

  @override
  ConsumerState<ResetCountdown> createState() => _ResetCountdownState();
}

class _ResetCountdownState extends ConsumerState<ResetCountdown> {
  Timer? _timer;
  late int _remaining;
  bool _refreshed = false;

  DateTime _now() => (widget.clock ?? DateTime.now)();

  int _compute() {
    final s = widget.resetAt.difference(_now()).inSeconds;
    return s < 0 ? 0 : s;
  }

  @override
  void initState() {
    super.initState();
    _remaining = _compute();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    final secs = widget.resetAt.difference(_now()).inSeconds;
    // 0초 도달 → 새 할당량 자동 조회(중복 방지 _refreshed)
    if (secs <= 0 && widget.autoRefresh && !_refreshed) {
      _refreshed = true;
      ref.invalidate(quotaProvider);
    }
    setState(() => _remaining = secs < 0 ? 0 : secs);
  }

  @override
  void didUpdateWidget(ResetCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 새 할당량(새 resetAt) 도착 시 카운트다운 재시작
    if (oldWidget.resetAt != widget.resetAt) {
      _refreshed = false;
      _remaining = _compute();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.label(formatCountdown(_remaining)),
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

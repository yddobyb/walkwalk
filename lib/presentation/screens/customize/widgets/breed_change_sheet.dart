// lib/presentation/screens/customize/widgets/breed_change_sheet.dart
import 'package:flutter/material.dart';

import '../../../../core/utils/breed_assets.dart';
import '../../../../l10n/app_localizations.dart';

/// 되돌릴 수 없는 품종 변경 확인 시트 (Phase 29-7).
///
/// 기존 plain `AlertDialog`를 대체한다. 앱의 다른 안내(소진 시트·미션 토스트)는
/// 전부 둥근 바텀시트 + 히어로 펫 + 그라데이션 CTA인데 여기만 기본 다이얼로그라
/// 혼자 겉돌았다.
///
/// **설계 의도: 잃는 것을 글이 아니라 그림으로 보여준다.**
/// 왼쪽에 지금 품종, 오른쪽에 바뀔 품종을 놓고, 왼쪽 위로 자물쇠가 내려앉으며
/// 흐려진다 — "이쪽이 닫힌다"가 한눈에 읽히게. 품종 SVG 아이콘을 그대로 쓰므로
/// 어떤 개를 잃는지도 구체적으로 보인다.
///
/// 색은 **앰버**(`#F5A623`). 오류가 아니라 주의라서 빨강을 쓰지 않고, 주황은
/// 프로모션 CTA 색이라 피했다. 소진 시트의 "완전 소진" 상태와 같은 톤.
class BreedChangeSheet {
  BreedChangeSheet._();

  /// 계속 진행하면 true. 시트 밖을 탭해 닫으면 false(= 안전한 쪽).
  static Future<bool> show(
    BuildContext context, {
    required String currentBreedValue,
    required String newBreedValue,
    required String currentBreedName,
    required String newBreedName,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BreedChangeContent(
        currentBreedValue: currentBreedValue,
        newBreedValue: newBreedValue,
        currentBreedName: currentBreedName,
        newBreedName: newBreedName,
      ),
    );
    return result ?? false;
  }
}

const Color _amber = Color(0xFFF5A623);

class _BreedChangeContent extends StatefulWidget {
  const _BreedChangeContent({
    required this.currentBreedValue,
    required this.newBreedValue,
    required this.currentBreedName,
    required this.newBreedName,
  });

  final String currentBreedValue;
  final String newBreedValue;
  final String currentBreedName;
  final String newBreedName;

  @override
  State<_BreedChangeContent> createState() => _BreedChangeContentState();
}

class _BreedChangeContentState extends State<_BreedChangeContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  // 한 번의 연출을 셋으로 쪼갠다: 두 펫이 등장 → 화살표가 이어짐 →
  // 자물쇠가 왼쪽에 내려앉으며 흐려짐. 순서 자체가 문장이 되도록.
  late final Animation<double> _pets =
      CurvedAnimation(parent: _c, curve: const Interval(0, .45, curve: Curves.easeOutBack));
  late final Animation<double> _arrow =
      CurvedAnimation(parent: _c, curve: const Interval(.35, .65, curve: Curves.easeOut));
  late final Animation<double> _lock =
      CurvedAnimation(parent: _c, curve: const Interval(.55, 1, curve: Curves.elasticOut));

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            _TransitionVisual(
              currentBreedValue: widget.currentBreedValue,
              newBreedValue: widget.newBreedValue,
              pets: _pets,
              arrow: _arrow,
              lock: _lock,
            ),
            const SizedBox(height: 20),

            Text(
              l10n.breedChangeWarningTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              l10n.breedChangeWarningBody(
                widget.currentBreedName,
                widget.newBreedName,
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),

            // 안전한 쪽을 주 버튼으로 둔다 — 되돌릴 수 없는 변경에서
            // 시각적 무게는 "잃지 않는 선택"에 있어야 한다.
            _GradientButton(
              label: l10n.breedChangeKeep,
              colors: const [Color(0xFFFFC062), Color(0xFFF5A623)],
              onTap: () => Navigator.of(context).pop(false),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: Text(
                l10n.breedChangeApplyAnyway,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 지금 품종 → 바뀔 품종. 왼쪽에 자물쇠가 내려앉으며 흐려진다.
class _TransitionVisual extends StatelessWidget {
  const _TransitionVisual({
    required this.currentBreedValue,
    required this.newBreedValue,
    required this.pets,
    required this.arrow,
    required this.lock,
  });

  final String currentBreedValue;
  final String newBreedValue;
  final Animation<double> pets;
  final Animation<double> arrow;
  final Animation<double> lock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 108,
      child: AnimatedBuilder(
        animation: Listenable.merge([pets, arrow, lock]),
        builder: (context, _) {
          final t = pets.value.clamp(0.0, 1.0);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.7 + 0.3 * t,
                child: _BreedOrb(
                  breed: currentBreedValue,
                  // 자물쇠가 내려앉는 만큼 흐려진다 = 닫히는 쪽.
                  // 다만 **어떤 개를 잃는지는 계속 알아볼 수 있어야** 하므로
                  // 0.72까지만 낮춘다(더 낮추면 실루엣만 남아 의미가 사라진다).
                  dim: 1.0 - 0.28 * lock.value.clamp(0.0, 1.0),
                  glow: theme.colorScheme.onSurfaceVariant,
                  lockProgress: lock.value.clamp(0.0, 1.0),
                ),
              ),
              SizedBox(
                width: 46,
                child: Opacity(
                  opacity: arrow.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(-8 + 8 * arrow.value.clamp(0.0, 1.0), 0),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 26,
                      color: _amber.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.7 + 0.3 * t,
                child: _BreedOrb(
                  breed: newBreedValue,
                  dim: 1,
                  glow: _amber,
                  lockProgress: 0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BreedOrb extends StatelessWidget {
  const _BreedOrb({
    required this.breed,
    required this.dim,
    required this.glow,
    required this.lockProgress,
  });

  final String breed;

  /// 1 = 선명, 낮을수록 흐림
  final double dim;
  final Color glow;

  /// 0이면 자물쇠 없음, 1이면 완전히 내려앉음
  final double lockProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final icon = BreedAssets.iconForBreed(breed, l10n, size: 62) ??
        const Text('🐕', style: TextStyle(fontSize: 46));

    return SizedBox(
      width: 96,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: dim,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glow.withValues(alpha: 0.26),
                    glow.withValues(alpha: 0.05),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: icon,
            ),
          ),
          if (lockProgress > 0)
            // 후광이 가장자리로 갈수록 옅어져 원의 '보이는' 크기가 88보다
            // 작다. 기하학적 45° 지점에 두면 떠 보여서 안쪽으로 당긴다.
            Positioned(
              right: 8,
              bottom: 10,
              child: Transform.scale(
                scale: lockProgress,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: 16,
                    color: theme.colorScheme.surface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 소진 시트와 같은 그라데이션 CTA (톤 통일)
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

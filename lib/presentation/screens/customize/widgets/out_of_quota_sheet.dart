// lib/presentation/screens/customize/widgets/out_of_quota_sheet.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/ad_constants.dart';
import '../../../../core/utils/breed_assets.dart';
import '../../../../data/models/quota_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/reset_countdown.dart';

/// 이미지 할당량 소진 안내 바텀시트 ("펫 충전 시트")
///
/// 기존 plain AlertDialog를 대체한다. 미션 완료 축하 토스트와 톤을 통일:
/// 그라데이션 CTA · 히어로 펫(품종 아이콘) · 상태별 컬러 · 둥근 시트.
///
/// 3가지 상태를 [quota]로부터 자동 판별한다.
/// - free + 광고 보너스 가능   → 주황: "광고 보고 +1장" 주 CTA + 프리미엄 업셀
/// - free + 완전 소진(광고 끝)  → 앰버: 리셋 카운트다운 + 프리미엄 업셀
/// - premium 소진             → 골드: 친근한 안내 + 닫기 (광고·업셀·"무료" 없음)
class OutOfQuotaSheet {
  OutOfQuotaSheet._();

  static Future<void> show(
    BuildContext context, {
    required QuotaData quota,
    required String breed,
    required VoidCallback onWatchAd,
    required VoidCallback onUpgrade,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _OutOfQuotaContent(
        quota: quota,
        breed: breed,
        onWatchAd: onWatchAd,
        onUpgrade: onUpgrade,
      ),
    );
  }
}

/// 시트의 시각 상태
enum _QuotaSheetState { freeAdEligible, freeMaxed, premiumExhausted }

class _OutOfQuotaContent extends StatelessWidget {
  const _OutOfQuotaContent({
    required this.quota,
    required this.breed,
    required this.onWatchAd,
    required this.onUpgrade,
  });

  final QuotaData quota;
  final String breed;
  final VoidCallback onWatchAd;
  final VoidCallback onUpgrade;

  // === 상태별 컬러 ===
  static const Color _orange = Color(0xFFFF8A50); // free + 광고 가능
  static const Color _amber = Color(0xFFF5A623); // free 완전 소진
  static const Color _gold = Color(0xFFE3A82E); // premium

  _QuotaSheetState get _state {
    if (quota.isPremium) return _QuotaSheetState.premiumExhausted;
    final adEligible =
        quota.isFree && quota.used < quota.total + AdConstants.maxImageAdBonus;
    return adEligible
        ? _QuotaSheetState.freeAdEligible
        : _QuotaSheetState.freeMaxed;
  }

  Color get _accent {
    switch (_state) {
      case _QuotaSheetState.freeAdEligible:
        return _orange;
      case _QuotaSheetState.freeMaxed:
        return _amber;
      case _QuotaSheetState.premiumExhausted:
        return _gold;
    }
  }

  String get _badgeEmoji {
    switch (_state) {
      case _QuotaSheetState.freeAdEligible:
        return '🎬';
      case _QuotaSheetState.freeMaxed:
        return '⏰';
      case _QuotaSheetState.premiumExhausted:
        return '💎';
    }
  }

  /// 광고로 추가 생성 가능한 남은 횟수 (기본 소진 후 최대 maxImageAdBonus)
  int get _adRemaining =>
      (quota.total + AdConstants.maxImageAdBonus - quota.used)
          .clamp(0, AdConstants.maxImageAdBonus);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final accent = _accent;

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
            // 드래그 핸들
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 히어로 펫 (품종 아이콘 + 상태 배지)
            _HeroAvatar(
              breed: breed,
              accent: accent,
              badgeEmoji: _badgeEmoji,
            ),
            const SizedBox(height: 18),

            // 제목
            Text(
              _title(l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),

            // 본문 (소진 상태는 실시간 카운트다운)
            _buildBody(context, l10n, theme),
            const SizedBox(height: 22),

            // 상태별 액션
            ..._buildActions(context, l10n, accent),
          ],
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n) {
    switch (_state) {
      case _QuotaSheetState.freeAdEligible:
        return l10n.outOfQuotaFreeAdTitle;
      case _QuotaSheetState.freeMaxed:
        return l10n.outOfQuotaMaxedTitle;
      case _QuotaSheetState.premiumExhausted:
        return l10n.outOfQuotaPremiumTitle(quota.total);
    }
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.4,
    );
    switch (_state) {
      case _QuotaSheetState.freeAdEligible:
        return Text(
          l10n.outOfQuotaFreeAdBody,
          textAlign: TextAlign.center,
          style: style,
        );
      case _QuotaSheetState.freeMaxed:
        // 시트는 일시적이라 자동 갱신은 끄고(autoRefresh:false) 표시만 실시간
        return ResetCountdown(
          resetAt: quota.resetAtDateTime,
          label: (t) => l10n.quotaResetsIn(t),
          autoRefresh: false,
          textAlign: TextAlign.center,
          style: style,
        );
      case _QuotaSheetState.premiumExhausted:
        return ResetCountdown(
          resetAt: quota.resetAtDateTime,
          label: (t) => l10n.outOfQuotaPremiumBody(t),
          autoRefresh: false,
          textAlign: TextAlign.center,
          style: style,
        );
    }
  }

  List<Widget> _buildActions(
    BuildContext context,
    AppLocalizations l10n,
    Color accent,
  ) {
    switch (_state) {
      case _QuotaSheetState.freeAdEligible:
        return [
          _GradientButton(
            label: '🎬  ${l10n.outOfQuotaWatchAd}',
            colors: const [Color(0xFFFFA86A), Color(0xFFFF7A3D)],
            onTap: () {
              Navigator.of(context).pop();
              onWatchAd();
            },
          ),
          const SizedBox(height: 10),
          Text(
            l10n.outOfQuotaAdRemaining(_adRemaining),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          _PremiumUpsellCard(onTap: () {
            Navigator.of(context).pop();
            onUpgrade();
          }),
          const SizedBox(height: 4),
          _DismissButton(onTap: () => Navigator.of(context).pop()),
        ];

      case _QuotaSheetState.freeMaxed:
        return [
          _PremiumUpsellCard(onTap: () {
            Navigator.of(context).pop();
            onUpgrade();
          }),
          const SizedBox(height: 4),
          _DismissButton(onTap: () => Navigator.of(context).pop()),
        ];

      case _QuotaSheetState.premiumExhausted:
        return [
          _GradientButton(
            label: l10n.close,
            colors: const [Color(0xFFEEC15A), Color(0xFFD49A24)],
            onTap: () => Navigator.of(context).pop(),
          ),
        ];
    }
  }
}

/// 히어로 펫 — 컬러 후광 원 + 품종 아이콘(없으면 🐕) + 상태 배지.
/// 등장 시 elasticOut 스케일인.
class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({
    required this.breed,
    required this.accent,
    required this.badgeEmoji,
  });

  final String breed;
  final Color accent;
  final String badgeEmoji;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final petIcon = BreedAssets.iconForBreed(breed, l10n, size: 72) ??
        const Text('🐕', style: TextStyle(fontSize: 54));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 620),
      curve: Curves.elasticOut,
      builder: (context, t, child) => Transform.scale(
        scale: 0.6 + 0.4 * t.clamp(0.0, 1.0),
        child: child,
      ),
      child: SizedBox(
        width: 116,
        height: 110,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 후광 원
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: 0.28),
                    accent.withValues(alpha: 0.06),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: petIcon,
            ),
            // 상태 배지
            Positioned(
              right: 2,
              bottom: 0,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(badgeEmoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 그라데이션 주 버튼 (full-width)
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

/// 프리미엄 업셀 카드 (골드 틴트 + 💎 + 혜택 한 줄)
class _PremiumUpsellCard extends StatelessWidget {
  const _PremiumUpsellCard({required this.onTap});

  final VoidCallback onTap;

  static const Color _gold = Color(0xFFC9941F);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _gold.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              const Text('💎', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.outOfQuotaUpgrade,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8A6310),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.outOfQuotaUpgradeBenefits,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: _gold.withValues(alpha: 0.8)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 닫기 텍스트 버튼
class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 44),
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Text(AppLocalizations.of(context).close),
    );
  }
}

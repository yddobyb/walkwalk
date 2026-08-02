// lib/presentation/screens/subscription/paywall_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/firebase/image_generation_providers.dart';
import '../../../services/subscription/revenue_cat_service.dart';
import '../../../services/user/user_tier_providers.dart';
import '../settings/widgets/link_account_sheet.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  StoreProduct? _product;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = await RevenueCatService.getMonthlyProduct();
    if (mounted) {
      setState(() {
        _product = product;
      });
    }
  }

  Future<void> _handlePurchase() async {
    if (!RevenueCatService.isConfigured) {
      _showSnackBar(
        AppLocalizations.of(context).paywallNotConfigured,
      );
      return;
    }

    if (_product == null) {
      _showSnackBar(
        AppLocalizations.of(context).paywallProductNotFound,
      );
      return;
    }

    setState(() => _loading = true);

    final result = await RevenueCatService.purchase(_product!);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      ref.invalidate(currentUserTierProvider);
      ref.invalidate(quotaProvider);
      _showSnackBar(AppLocalizations.of(context).paywallSuccess);
      await _promptLinkIfAnonymous();
      if (mounted) Navigator.of(context).pop(true);
    } else if (result.isCancelled) {
      // 사용자가 취소한 경우 아무 동작 없음
    } else if (result.errorMessage != null) {
      _showSnackBar(result.errorMessage!);
    }
  }

  /// 익명(게스트) 사용자가 결제/복원에 성공하면, 프리미엄을 계정에 묶도록
  /// 연동을 유도한다(선택). 연동 시 uid가 보존돼 프리미엄이 그대로 유지된다.
  Future<void> _promptLinkIfAnonymous() async {
    if (AuthService.isAnonymous && mounted) {
      await LinkAccountSheet.show(context, isPremium: true);
    }
  }

  Future<void> _handleRestore() async {
    if (!RevenueCatService.isConfigured) {
      _showSnackBar(
        AppLocalizations.of(context).paywallNotConfigured,
      );
      return;
    }

    setState(() => _loading = true);

    final result = await RevenueCatService.restorePurchases();

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      ref.invalidate(currentUserTierProvider);
      ref.invalidate(quotaProvider);
      _showSnackBar(AppLocalizations.of(context).paywallSuccess);
      await _promptLinkIfAnonymous();
      if (mounted) Navigator.of(context).pop(true);
    } else {
      _showSnackBar(
        AppLocalizations.of(context).paywallRestoreNotFound,
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    // \uc2e4\uc81c \uac00\uaca9\uc740 \uc2a4\ud1a0\uc5b4\uc5d0\uc11c \ubc1b\uc544\uc628\ub2e4(\uc2dc\uc7a5\ubcc4\ub85c \ub2e4\ub984). \uc544\ub798\ub294 \ub85c\ub4dc \uc2e4\ud328 \uc2dc
    // \ud3f4\ubc31\uc774\uba70 locale\ubcc4 \uac12\uc774\ub77c App Store Connect\uc758 \uac00\uaca9\uacfc \ud568\uaed8 \uac31\uc2e0\ud560 \uac83.
    // (Phase 28-9 \uae30\uc900: \ud83c\uddfa\ud83c\uddf8 $6.99 / \ud83c\udde8\ud83c\udde6 C$9.99 / \ud83c\uddf0\ud83c\uddf7 \u20a99,900)
    final priceString = _product?.priceString ?? l10n.paywallPriceFallback;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // ── 히어로 헤더 ────────────────────────────────────────
          _HeroHeader(
            theme: theme,
            l10n: l10n,
            onClose: () => Navigator.of(context).pop(),
          ),

          // ── 스크롤 가능한 본문 ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 혜택 섹션 타이틀
                  Text(
                    l10n.paywallTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 혜택 카드 목록
                  _BenefitTile(
                    icon: Icons.auto_awesome_rounded,
                    title: l10n.paywallBenefitQuality,
                    theme: theme,
                  ),
                  _BenefitTile(
                    icon: Icons.all_inclusive_rounded,
                    title: l10n.paywallBenefitQuota,
                    theme: theme,
                  ),
                  _BenefitTile(
                    icon: Icons.block_rounded,
                    title: l10n.paywallBenefitAds,
                    theme: theme,
                  ),
                  _BenefitTile(
                    icon: Icons.bolt_rounded,
                    title: l10n.paywallBenefitSpeed,
                    theme: theme,
                  ),

                  const SizedBox(height: 24),

                  // 가격 카드
                  _PriceCard(
                    priceString: priceString,
                    perMonth: l10n.paywallPricePerMonth,
                    theme: theme,
                  ),

                  const SizedBox(height: 20),

                  // 약관 안내
                  Text(
                    l10n.paywallTermsNote,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── 하단 고정 CTA ────────────────────────────────────
          _BottomCta(
            loading: _loading,
            subscribeLabel: l10n.paywallSubscribeButton,
            restoreLabel: l10n.paywallRestoreButton,
            bottomPadding: bottomPadding,
            onPurchase: _handlePurchase,
            onRestore: _handleRestore,
          ),
        ],
      ),
    );
  }
}

// ── 히어로 헤더 위젯 ───────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;
  final VoidCallback onClose;

  const _HeroHeader({
    required this.theme,
    required this.l10n,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? const Color(0xFFFF8A50) : Colors.white;
    final subtitleColor = isDark
        ? const Color(0xFFFF8A50).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.88);
    final closeBtnBg = isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.22);
    final closeIconColor =
        isDark ? theme.colorScheme.onSurface : Colors.white;
    final gemBgColor = isDark
        ? const Color(0xFFFF8A50).withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.18);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [
                  Color(0xFFCC4A00),
                  Color(0xFFFF8A50),
                  Color(0xFFFFB584),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDark ? theme.colorScheme.surface : null,
        border: isDark
            ? Border(
                bottom: BorderSide(
                  color: const Color(0xFFFF8A50).withValues(alpha: 0.3),
                ),
              )
            : null,
      ),
      child: Stack(
        children: [
          // 배경 장식 원
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFFFF8A50).withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFFFF8A50).withValues(alpha: 0.04)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // 콘텐츠
          Padding(
            padding: EdgeInsets.fromLTRB(24, topPadding + 12, 24, 32),
            child: Column(
              children: [
                // X 닫기 버튼
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: closeBtnBg,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: closeIconColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 💎 이모지
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gemBgColor,
                  ),
                  child: const Center(
                    child: Text(
                      '💎',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 타이틀
                Text(
                  l10n.paywallHeaderTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // 서브타이틀
                Text(
                  l10n.paywallHeaderSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 혜택 카드 위젯 ─────────────────────────────────────────────────────────────

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final ThemeData theme;

  const _BenefitTile({
    required this.icon,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 아이콘 컨테이너
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A50), Color(0xFFFFB584)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),

          // 텍스트
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 체크 아이콘
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF4CAF50),
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ── 가격 카드 위젯 ─────────────────────────────────────────────────────────────

class _PriceCard extends StatelessWidget {
  final String priceString;
  final String perMonth;
  final ThemeData theme;

  const _PriceCard({
    required this.priceString,
    required this.perMonth,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceContainerHighest
            : const Color(0xFFFFF5EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF8A50).withValues(alpha: 0.30),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // 배지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A50).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Premium',
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFFCC4A00),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 가격
          Text(
            priceString,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFCC4A00),
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 2),

          // per month
          Text(
            '/ $perMonth',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 하단 고정 CTA 위젯 ────────────────────────────────────────────────────────

class _BottomCta extends StatelessWidget {
  final bool loading;
  final String subscribeLabel;
  final String restoreLabel;
  final double bottomPadding;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;

  const _BottomCta({
    required this.loading,
    required this.subscribeLabel,
    required this.restoreLabel,
    required this.bottomPadding,
    required this.onPurchase,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 구독 버튼 (그라디언트)
          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: loading
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFCC4A00), Color(0xFFFF8A50)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: loading ? theme.colorScheme.surfaceContainerHighest : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: loading
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFFFF8A50).withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: ElevatedButton(
                onPressed: loading ? null : onPurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        subscribeLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ),

          // 복원 버튼
          TextButton(
            onPressed: loading ? null : onRestore,
            child: Text(
              restoreLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

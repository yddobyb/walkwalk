// lib/presentation/screens/subscription/paywall_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/firebase/image_generation_providers.dart';
import '../../../services/subscription/revenue_cat_service.dart';
import '../../../services/user/user_tier_providers.dart';

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
      Navigator.of(context).pop(true);
    } else if (result.isCancelled) {
      // 사용자가 취소한 경우 아무 동작 없음
    } else if (result.errorMessage != null) {
      _showSnackBar(result.errorMessage!);
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
      Navigator.of(context).pop(true);
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

    final priceString = _product?.priceString ?? '\u20a94,900';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paywallTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    '\u{1F48E}',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.paywallHeaderTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.paywallHeaderSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 혜택 리스트
            _BenefitTile(
              icon: Icons.auto_awesome,
              title: l10n.paywallBenefitQuality,
              theme: theme,
            ),
            _BenefitTile(
              icon: Icons.all_inclusive,
              title: l10n.paywallBenefitQuota,
              theme: theme,
            ),
            _BenefitTile(
              icon: Icons.block,
              title: l10n.paywallBenefitAds,
              theme: theme,
            ),
            _BenefitTile(
              icon: Icons.speed,
              title: l10n.paywallBenefitSpeed,
              theme: theme,
            ),

            const SizedBox(height: 32),

            // 가격
            Text(
              '$priceString / ${l10n.paywallPricePerMonth}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // 구독 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _handlePurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.paywallSubscribeButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // 복원 버튼
            TextButton(
              onPressed: _loading ? null : _handleRestore,
              child: Text(l10n.paywallRestoreButton),
            ),

            const SizedBox(height: 16),

            // 약관 안내
            Text(
              l10n.paywallTermsNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFB8860B),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Color(0xFFFFD700),
            size: 22,
          ),
        ],
      ),
    );
  }
}

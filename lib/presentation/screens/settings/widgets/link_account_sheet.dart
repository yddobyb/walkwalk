// lib/presentation/screens/settings/widgets/link_account_sheet.dart
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/auth/auth_service.dart';

/// 계정 연동 유도 바텀시트 ("프리미엄 보호 / 계정 연결").
///
/// 익명(게스트) 사용자가 Google/Apple 계정을 연동하도록 유도한다.
/// 연동 시 Firebase uid가 보존되므로 프리미엄·데이터가 그대로 유지된다.
/// 소진 안내 시트(out_of_quota_sheet)와 톤을 통일.
///
/// - [isPremium] true면 "프리미엄 보호" 카피(골드), false면 "백업/동기화" 카피(주황).
/// - 버튼 탭 시 시트를 먼저 닫고 [AuthService]로 로그인/링크하며,
///   결과 스낵바는 호출 측 [context]에 표시(시트 컨텍스트는 닫혀서 사용 불가).
class LinkAccountSheet {
  LinkAccountSheet._();

  static Future<void> show(
    BuildContext context, {
    required bool isPremium,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _LinkAccountContent(
        isPremium: isPremium,
        hostContext: context,
      ),
    );
  }
}

class _LinkAccountContent extends StatelessWidget {
  const _LinkAccountContent({
    required this.isPremium,
    required this.hostContext,
  });

  final bool isPremium;

  /// 시트가 닫힌 뒤 스낵바를 띄울 때 사용할, 시트 바깥(화면)의 컨텍스트.
  final BuildContext hostContext;

  static const Color _gold = Color(0xFFE3A82E);
  static const Color _orange = Color(0xFFFF8A50);

  Color get _accent => isPremium ? _gold : _orange;

  List<Color> get _ctaGradient => isPremium
      ? const [Color(0xFFEEC15A), Color(0xFFD49A24)]
      : const [Color(0xFFFFA86A), Color(0xFFFF7A3D)];

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
            // 드래그 핸들
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

            // 히어로 (후광 + 이모지 + 배지)
            _HeroAvatar(accent: _accent, isPremium: isPremium),
            const SizedBox(height: 18),

            // 제목
            Text(
              isPremium
                  ? l10n.linkAccountTitlePremium
                  : l10n.linkAccountTitleDefault,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),

            // 본문
            Text(
              isPremium
                  ? l10n.linkAccountBodyPremium
                  : l10n.linkAccountBodyDefault,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),

            // Google 연결 (주 CTA)
            _ConnectButton(
              label: l10n.signInWithGoogle,
              icon: Icons.g_mobiledata_rounded,
              gradient: _ctaGradient,
              onTap: () => _connect(context, _Provider.google, l10n),
            ),

            // Apple 연결 (iOS만)
            if (AuthService.isAppleSignInAvailable) ...[
              const SizedBox(height: 10),
              _ConnectButton(
                label: l10n.signInWithApple,
                icon: Icons.apple,
                gradient: const [Color(0xFF1C1C1E), Color(0xFF3A3A3C)],
                onTap: () => _connect(context, _Provider.apple, l10n),
              ),
            ],

            const SizedBox(height: 4),

            // 나중에
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                foregroundColor: theme.colorScheme.onSurfaceVariant,
              ),
              child: Text(l10n.linkAccountLater),
            ),
          ],
        ),
      ),
    );
  }

  /// 시트를 닫고 로그인/링크 수행 후 결과를 호스트 컨텍스트에 스낵바로 안내.
  Future<void> _connect(
    BuildContext sheetContext,
    _Provider provider,
    AppLocalizations l10n,
  ) async {
    Navigator.of(sheetContext).pop();
    try {
      final cred = provider == _Provider.google
          ? await AuthService.signInWithGoogle()
          : await AuthService.signInWithApple();
      if (!hostContext.mounted) return;
      // cred == null → 사용자가 취소 → 안내 생략
      if (cred != null) {
        _snack(l10n.signInSuccess);
      }
    } catch (_) {
      if (!hostContext.mounted) return;
      _snack(l10n.signInFailed);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(hostContext).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

enum _Provider { google, apple }

/// 후광 원 + 이모지 + (프리미엄) 🔗 배지. 등장 시 elasticOut 스케일인.
class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({required this.accent, required this.isPremium});

  final Color accent;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                isPremium ? '💎' : '🔗',
                style: const TextStyle(fontSize: 52),
              ),
            ),
            if (isPremium)
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
                  child: const Text('🔗', style: TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 그라데이션 연결 버튼 (아이콘 + 라벨, full-width)
class _ConnectButton extends StatelessWidget {
  const _ConnectButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.32),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

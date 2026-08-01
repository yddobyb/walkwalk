// lib/presentation/widgets/ai_disclosure_sheet.dart

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// AI 기반 서비스 사전 고지 시트.
///
/// Phase 27: 인공지능 기본법 제31조 ①항 — 생성형 AI를 이용한 제품·서비스를
/// 제공하려는 경우 "해당 인공지능에 기반하여 운용된다는 사실"을 이용자에게
/// **사전에** 고지해야 한다. 어떤 기능이 AI인지, 결과물의 한계가 무엇인지를
/// 함께 알린다.
///
/// 진입 경로: 설정 > AI 기능 > "AI 기능 안내", 그리고 AI 동의 시트 직전.
class AiDisclosureSheet {
  AiDisclosureSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AiDisclosureContent(),
    );
  }
}

class _AiDisclosureContent extends StatelessWidget {
  const _AiDisclosureContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
              margin: const EdgeInsets.only(top: 14, bottom: 18),
              decoration: BoxDecoration(
                color: onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiDisclosureTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.aiDisclosureIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.75),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _DisclosureItem(
                      icon: Icons.auto_awesome,
                      iconColor: theme.colorScheme.primary,
                      title: l10n.aiDisclosureStickerTitle,
                      body: l10n.aiDisclosureStickerBody,
                    ),
                    _DisclosureItem(
                      icon: Icons.chat_bubble_outline,
                      iconColor: theme.colorScheme.secondary,
                      title: l10n.aiDisclosureDialogueTitle,
                      body: l10n.aiDisclosureDialogueBody,
                    ),
                    _DisclosureItem(
                      icon: Icons.info_outline,
                      iconColor: Colors.orange,
                      title: l10n.aiDisclosureLimitTitle,
                      body: l10n.aiDisclosureLimitBody,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.aiDisclosureClose,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisclosureItem extends StatelessWidget {
  const _DisclosureItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/widgets/ai_consent_sheet.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

const _privacyPolicyUrl = 'https://walkwalkddog.web.app/privacy-policy';

/// 제3자 AI 데이터 전송 동의 바텀시트.
///
/// Phase 27: Apple 5.1.2(i)(제3자 AI 공유 전 명시적 동의) +
/// 개인정보보호법 제28조의8(국외 이전 고지)를 함께 충족하기 위해
/// "무엇이 전송되는지 / 무엇이 전송되지 않는지 / 누가 받는지 / 어디로 나가는지"를
/// 모두 한 화면에 보여준 뒤 동의를 받는다.
///
/// [show]는 사용자가 동의하면 `true`, 거부하거나 시트를 닫으면 `false`를 반환한다.
class AiConsentSheet {
  AiConsentSheet._();

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // 동의는 명시적 선택이어야 하므로 바깥 탭으로 닫혀도 false로 처리된다.
      builder: (_) => const _AiConsentContent(),
    );
    return result ?? false;
  }
}

class _AiConsentContent extends StatelessWidget {
  const _AiConsentContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
            // 드래그 핸들
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.aiConsentTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.aiConsentIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.75),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _ConsentBlock(
                      icon: Icons.upload_outlined,
                      iconColor: theme.colorScheme.primary,
                      title: l10n.aiConsentSentTitle,
                      body: l10n.aiConsentSentItems,
                    ),
                    _ConsentBlock(
                      icon: Icons.shield_outlined,
                      iconColor: Colors.green,
                      title: l10n.aiConsentNotSentTitle,
                      body: l10n.aiConsentNotSentItems,
                    ),
                    _ConsentBlock(
                      icon: Icons.hub_outlined,
                      iconColor: theme.colorScheme.secondary,
                      title: l10n.aiConsentThirdPartyTitle,
                      body: l10n.aiConsentThirdPartyItems,
                    ),
                    _ConsentBlock(
                      icon: Icons.public,
                      iconColor: Colors.orange,
                      title: l10n.aiConsentOverseasTitle,
                      body: l10n.aiConsentOverseasBody,
                    ),

                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l10n.aiConsentWithdrawNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: onSurface.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _openPrivacyPolicy(context),
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: Text(l10n.aiConsentViewPolicy),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 액션 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.aiConsentAgree,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        l10n.aiConsentDecline,
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final uri = Uri.parse(_privacyPolicyUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// 동의 시트 안의 한 항목(아이콘 + 제목 + 본문).
class _ConsentBlock extends StatelessWidget {
  const _ConsentBlock({
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
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

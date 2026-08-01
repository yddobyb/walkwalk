// lib/presentation/widgets/report_content_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../services/moderation/content_report_service.dart';

/// AI 결과물 신고 바텀시트.
///
/// Phase 27: Google Play 생성형 AI 앱 정책(앱 내 신고 경로) + Apple 1.2.
/// 사유를 고르면 즉시 접수하고 시트를 닫는다. 결과 스낵바는 시트가 닫힌 뒤
/// 호출 측 컨텍스트에 표시한다(시트 컨텍스트는 이미 dispose됨).
class ReportContentSheet {
  ReportContentSheet._();

  static Future<void> show(
    BuildContext context, {
    required ReportedContentType contentType,
    String? provider,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReportContent(
        contentType: contentType,
        provider: provider,
        hostContext: context,
      ),
    );
  }
}

class _ReportContent extends ConsumerStatefulWidget {
  const _ReportContent({
    required this.contentType,
    required this.provider,
    required this.hostContext,
  });

  final ReportedContentType contentType;
  final String? provider;

  /// 시트가 닫힌 뒤 스낵바를 띄울 화면 쪽 컨텍스트.
  final BuildContext hostContext;

  @override
  ConsumerState<_ReportContent> createState() => _ReportContentState();
}

class _ReportContentState extends ConsumerState<_ReportContent> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final reasons = <(ReportReason, String)>[
      (ReportReason.inappropriate, l10n.reportReasonInappropriate),
      (ReportReason.violent, l10n.reportReasonViolent),
      (ReportReason.sexual, l10n.reportReasonSexual),
      (ReportReason.misleading, l10n.reportReasonMisleading),
      (ReportReason.other, l10n.reportReasonOther),
    ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l10n.reportContentTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reportContentBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: onSurface.withValues(alpha: 0.7),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            for (final (reason, label) in reasons)
              ListTile(
                contentPadding: EdgeInsets.zero,
                enabled: !_submitting,
                title: Text(label, style: theme.textTheme.bodyMedium),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: onSurface.withValues(alpha: 0.4),
                ),
                onTap: _submitting ? null : () => _submit(reason),
              ),
            const SizedBox(height: 4),
            Center(
              child: TextButton(
                onPressed:
                    _submitting ? null : () => Navigator.of(context).pop(),
                child: Text(
                  l10n.commonCancel,
                  style: TextStyle(color: onSurface.withValues(alpha: 0.6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(ReportReason reason) async {
    setState(() => _submitting = true);

    final ok = await ref.read(contentReportServiceProvider).submit(
          reason: reason,
          contentType: widget.contentType,
          provider: widget.provider,
        );

    if (!mounted) return;
    Navigator.of(context).pop();

    final hostContext = widget.hostContext;
    if (!hostContext.mounted) return;
    final l10n = AppLocalizations.of(hostContext);
    ScaffoldMessenger.of(hostContext).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.reportSubmitted : l10n.reportFailed),
        backgroundColor: ok ? Colors.green : null,
      ),
    );
  }
}

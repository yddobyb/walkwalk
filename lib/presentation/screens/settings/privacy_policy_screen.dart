// lib/presentation/screens/settings/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final sections = [
      _PolicySection(
        title: l10n.privacyOverview,
        content: l10n.privacyOverviewContent,
      ),
      _PolicySection(
        title: l10n.privacyDataCollection,
        content: l10n.privacyDataCollectionContent,
      ),
      _PolicySection(
        title: l10n.privacyDataUsage,
        content: l10n.privacyDataUsageContent,
      ),
      _PolicySection(
        title: l10n.privacyDataStorage,
        content: l10n.privacyDataStorageContent,
      ),
      _PolicySection(
        title: l10n.privacyThirdParty,
        content: l10n.privacyThirdPartyContent,
      ),
      _PolicySection(
        title: l10n.privacyUserRights,
        content: l10n.privacyUserRightsContent,
      ),
      _PolicySection(
        title: l10n.privacyChanges,
        content: l10n.privacyChangesContent,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyScreenTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 시행일
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.privacyEffectiveDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 섹션들
            ...sections.map((section) => _buildSection(
                  theme, section.title, section.content)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      ThemeData theme, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });
}

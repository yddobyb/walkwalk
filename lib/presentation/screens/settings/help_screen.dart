// lib/presentation/screens/settings/help_screen.dart
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final sections = [
      _HelpSection(
        icon: Icons.rocket_launch,
        title: l10n.helpGettingStarted,
        content: l10n.helpGettingStartedContent,
      ),
      _HelpSection(
        icon: Icons.directions_walk,
        title: l10n.helpHowToWalk,
        content: l10n.helpHowToWalkContent,
      ),
      _HelpSection(
        icon: Icons.card_giftcard,
        title: l10n.helpRewards,
        content: l10n.helpRewardsContent,
      ),
      _HelpSection(
        icon: Icons.flag,
        title: l10n.helpMissions,
        content: l10n.helpMissionsContent,
      ),
      _HelpSection(
        icon: Icons.emoji_events,
        title: l10n.helpAchievements,
        content: l10n.helpAchievementsContent,
      ),
      _HelpSection(
        icon: Icons.psychology,
        title: l10n.helpAIFeatures,
        content: l10n.helpAIFeaturesContent,
      ),
      _HelpSection(
        icon: Icons.mail,
        title: l10n.helpContact,
        content: l10n.helpContactContent,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpScreenTitle),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return _HelpCard(
            icon: section.icon,
            title: section.title,
            content: section.content,
            theme: theme,
          );
        },
      ),
    );
  }
}

class _HelpSection {
  final IconData icon;
  final String title;
  final String content;

  const _HelpSection({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final ThemeData theme;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: theme.colorScheme.surface,
      collapsedBackgroundColor: theme.colorScheme.surface,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// lib/presentation/screens/walk/walk_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/tracking/step_tracking_service.dart';
import '../../../l10n/app_localizations.dart';

/// 산책 화면
/// Week 2: 기본 걸음수 표시 및 산책 시작 기능
/// Week 3+: 실시간 GPS, 산책 기록, 미션 진행도 등 추가 예정
class WalkScreen extends ConsumerWidget {
  const WalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todayStepsAsync = ref.watch(dailyStepsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).walkTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 오늘의 걸음수 카드
              _buildStepsCard(context, theme, todayStepsAsync),
              const SizedBox(height: 24),

              // 산책 안내
              _buildWalkGuide(context, theme),
              const SizedBox(height: 24),

              // Week 3+ 구현 예정 안내
              _buildComingSoonSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context, ThemeData theme, AsyncValue<int> todayStepsAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.directions_walk,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).todaySteps,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          todayStepsAsync.when(
            data: (steps) => Text(
              '$steps',
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            loading: () => const CircularProgressIndicator(
              color: Colors.white,
            ),
            error: (_, __) => Text(
              '0',
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).stepsUnit,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalkGuide(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).walkGuideTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GuideItem(
            icon: '📱',
            text: AppLocalizations.of(context).guideAutoRecording,
          ),
          const SizedBox(height: 12),
          _GuideItem(
            icon: '🎁',
            text: AppLocalizations.of(context).guideTreatReward,
          ),
          const SizedBox(height: 12),
          _GuideItem(
            icon: '😊',
            text: AppLocalizations.of(context).guideHappinessIncrease,
          ),
          const SizedBox(height: 12),
          _GuideItem(
            icon: '🏆',
            text: AppLocalizations.of(context).guideMissionReward,
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonSection(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upcoming,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).comingSoonTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FeatureItem(
            text: AppLocalizations.of(context).featureGPSTracking,
            badge: AppLocalizations.of(context).badgeWeek3,
          ),
          const SizedBox(height: 8),
          _FeatureItem(
            text: AppLocalizations.of(context).featureWalkHistory,
            badge: AppLocalizations.of(context).badgeWeek3,
          ),
          const SizedBox(height: 8),
          _FeatureItem(
            text: AppLocalizations.of(context).featureOutdoorBonus,
            badge: AppLocalizations.of(context).badgeWeek3,
          ),
          const SizedBox(height: 8),
          _FeatureItem(
            text: AppLocalizations.of(context).featureMissionProgress,
            badge: AppLocalizations.of(context).badgeWeek3,
          ),
          const SizedBox(height: 8),
          _FeatureItem(
            text: AppLocalizations.of(context).featureStatistics,
            badge: AppLocalizations.of(context).badgeWeek4,
          ),
        ],
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final String icon;
  final String text;

  const _GuideItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  final String badge;

  const _FeatureItem({
    required this.text,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
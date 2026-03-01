// lib/presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/settings/settings_service.dart';
import '../../../services/mission/mission_service.dart';
import '../../../services/notification/notification_service.dart';
import '../../../services/user/user_tier_providers.dart';
import '../../../services/user/user_tier_service.dart';
import '../../../l10n/app_localizations.dart';
import '../achievements/achievements_screen.dart';
import '../subscription/paywall_screen.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return settingsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings),
          centerTitle: true,
        ),
        body: Center(
          child: Text(AppLocalizations.of(context).settingsLoadError(error.toString())),
        ),
      ),
      data: (settings) => _buildSettingsContent(context, ref, theme, settings),
    );
  }

  Widget _buildSettingsContent(BuildContext context, WidgetRef ref, ThemeData theme, settings) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 구독
          const _SubscriptionSection(),

          const SizedBox(height: 24),

          // 게임 설정
          _SettingsSection(
            title: AppLocalizations.of(context).gameSettings,
            children: [
              _SettingsTile(
                icon: Icons.timer,
                title: AppLocalizations.of(context).dailyGoal,
                subtitle: AppLocalizations.of(context).dailyGoalSteps(settings.dailyStepGoal),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showGoalDialog(context, ref, settings.dailyStepGoal);
                },
              ),
              _SettingsTile(
                icon: Icons.emoji_events,
                title: AppLocalizations.of(context).badgesAndAchievements,
                subtitle: AppLocalizations.of(context).badgesDescription,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AchievementsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 알림 설정
          _SettingsSection(
            title: AppLocalizations.of(context).notifications,
            children: [
              _SettingsTile(
                icon: Icons.notifications,
                title: AppLocalizations.of(context).notifications,
                subtitle: AppLocalizations.of(context).notificationsDescription,
                trailing: Switch(
                  value: settings.notificationsEnabled,
                  onChanged: (value) async {
                    await _handleNotificationToggle(
                      context, ref, value, settings,
                    );
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.schedule,
                title: AppLocalizations.of(context).notificationTime,
                subtitle: '${AppLocalizations.of(context).notificationMorning} ${settings.morningReminderTime}, '
                    '${AppLocalizations.of(context).notificationEvening} ${settings.eveningReminderTime}',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showNotificationTimeDialog(context, ref, settings);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16, right: 16, top: 8,
            ),
            child: Text(
              AppLocalizations.of(context)
                  .notificationTypesInfo,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.45),
                  ),
            ),
          ),

          const SizedBox(height: 24),

          // 앱 설정
          _SettingsSection(
            title: AppLocalizations.of(context).appSettings,
            children: [
              _SettingsTile(
                icon: Icons.dark_mode,
                title: AppLocalizations.of(context).darkMode,
                subtitle: AppLocalizations.of(context).darkModeDescription,
                trailing: Switch(
                  value: settings.darkModeEnabled,
                  onChanged: (value) {
                    ref.read(settingsNotifierProvider.notifier).updateDarkMode(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.language,
                title: AppLocalizations.of(context).language,
                subtitle: settings.locale == 'ko' ? AppLocalizations.of(context).languageKorean : AppLocalizations.of(context).languageEnglish,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLanguageDialog(context, ref, settings.locale);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 정보
          _SettingsSection(
            title: AppLocalizations.of(context).information,
            children: [
              _SettingsTile(
                icon: Icons.info,
                title: AppLocalizations.of(context).appInfo,
                subtitle: AppLocalizations.of(context).appInfoVersion(AppConstants.appVersion),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _SettingsTile(
                icon: Icons.help,
                title: AppLocalizations.of(context).help,
                subtitle: AppLocalizations.of(context).helpDescription,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HelpScreen(),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: AppLocalizations.of(context).privacyPolicy,
                subtitle: AppLocalizations.of(context).privacyPolicyDescription,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showGoalDialog(BuildContext context, WidgetRef ref, int currentGoal) {
    showDialog<int>(
      context: context,
      builder: (_) => _GoalDialog(currentGoal: currentGoal),
    ).then((newGoal) async {
      if (newGoal == null) return;
      try {
        await ref.read(settingsNotifierProvider.notifier).updateDailyStepGoal(newGoal);
        ref.invalidate(activeMissionsProvider);
        ref.invalidate(dailyMissionsProvider);
        ref.invalidate(weeklyMissionsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).dailyGoalUpdated(newGoal)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).dailyGoalUpdateError(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  /// 알림 토글 변경 시 알림 스케줄/취소 처리
  Future<void> _handleNotificationToggle(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
    dynamic settings,
  ) async {
    final notifService = NotificationService.instance;
    if (!notifService.isInitialized) {
      // 서비스 미초기화 시 DB만 업데이트
      await ref.read(settingsNotifierProvider.notifier)
          .updateNotifications(enabled);
      return;
    }

    if (enabled) {
      // 권한 요청 (DB 저장 전에 먼저)
      final granted =
          await notifService.requestPermissions();
      if (!granted) {
        // 권한 거부 시 DB를 false로 유지
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)
                    .notificationPermissionDenied,
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 권한 승인 후 DB 업데이트
      await ref.read(settingsNotifierProvider.notifier)
          .updateNotifications(true);

      // 알림 스케줄
      if (context.mounted) {
        await _scheduleAllReminders(context, settings);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .notificationEnabled,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // DB 업데이트
      await ref.read(settingsNotifierProvider.notifier)
          .updateNotifications(false);

      // 모든 알림 취소
      await notifService.cancelAll();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .notificationDisabled,
            ),
          ),
        );
      }
    }
  }

  /// 모든 리마인더 스케줄
  Future<void> _scheduleAllReminders(
    BuildContext context,
    dynamic settings,
  ) async {
    final notifService = NotificationService.instance;
    final l10n = AppLocalizations.of(context);

    // 산책 리마인더 (조건부: 오늘 산책 여부 확인)
    await notifService.scheduleConditionalReminders();

    // 미션 만료 리마인더 (21:00 고정, 매일 반복)
    await notifService.scheduleMissionExpiryReminder(
      title: l10n.notificationMissionTitle,
      body: l10n.notificationMissionBody,
    );
  }

  void _showNotificationTimeDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic settings,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.notificationTime),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.notificationTimeHint),
              const SizedBox(height: 16),
              // 오전 알림 시간
              ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: Text(l10n.notificationMorning),
                trailing: Text(
                  settings.morningReminderTime,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.of(dialogContext).pop();
                  await _pickTime(context, ref, settings, isMorning: true);
                },
              ),
              const Divider(),
              // 오후 알림 시간
              ListTile(
                leading: const Icon(Icons.nights_stay),
                title: Text(l10n.notificationEvening),
                trailing: Text(
                  settings.eveningReminderTime,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.of(dialogContext).pop();
                  await _pickTime(context, ref, settings, isMorning: false);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    dynamic settings, {
    required bool isMorning,
  }) async {
    final currentTime = isMorning
        ? settings.morningReminderTime
        : settings.eveningReminderTime;
    final parts = currentTime.split(':');
    final initialHour = int.tryParse(parts[0]) ??
        (isMorning ? 9 : 18);
    final initialMinute = int.tryParse(parts[1]) ?? 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialHour,
        minute: initialMinute,
      ),
    );

    if (picked == null) return;

    final timeString =
        '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';

    try {
      final notifier = ref.read(
        settingsNotifierProvider.notifier,
      );
      if (isMorning) {
        await notifier.updateMorningReminderTime(
          timeString,
        );
      } else {
        await notifier.updateEveningReminderTime(
          timeString,
        );
      }

      // 알림이 켜져있으면 조건부 리마인더 재스케줄
      if (settings.notificationsEnabled) {
        final notifService =
            NotificationService.instance;
        if (notifService.isInitialized) {
          await notifService
              .scheduleConditionalReminders();
        }
      }

      if (context.mounted) {
        final label = isMorning
            ? AppLocalizations.of(context)
                .notificationMorning
            : AppLocalizations.of(context)
                .notificationEvening;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$label $timeString',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .notificationTimeUpdateError,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const Text('🐕', style: TextStyle(fontSize: 48)),
      children: [
        Text(AppLocalizations.of(context).appDescription),
        const SizedBox(height: 16),
        const Text('© 2025 WalkDog Team'),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String currentLocale) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.languageDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(l10n.languageKorean),
                value: 'ko',
                groupValue: currentLocale,
                onChanged: (value) async {
                  if (value != null && value != currentLocale) {
                    // Pre-capture strings BEFORE locale changes to avoid
                    // AppLocalizations.of(context) in async continuations,
                    // which triggers the 'ancestor == this' assertion.
                    final successMsg = l10n.languageUpdated(l10n.languageKorean);
                    Navigator.of(dialogContext).pop();
                    try {
                      await ref.read(settingsNotifierProvider.notifier).updateLocale(value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(successMsg),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      final errorMsg = l10n.languageChangeError(e.toString());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMsg),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(l10n.languageEnglish),
                value: 'en',
                groupValue: currentLocale,
                onChanged: (value) async {
                  if (value != null && value != currentLocale) {
                    // Pre-capture strings BEFORE locale changes to avoid
                    // AppLocalizations.of(context) in async continuations,
                    // which triggers the 'ancestor == this' assertion.
                    final successMsg = l10n.languageUpdated(l10n.languageEnglish);
                    Navigator.of(dialogContext).pop();
                    try {
                      await ref.read(settingsNotifierProvider.notifier).updateLocale(value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(successMsg),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      final errorMsg = l10n.languageChangeError(e.toString());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMsg),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// 구독 섹션 위젯
class _SubscriptionSection extends ConsumerWidget {
  const _SubscriptionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tierAsync = ref.watch(currentUserTierProvider);

    final isPremium = tierAsync.maybeWhen(
      data: (tier) => tier == UserTier.premium,
      orElse: () => false,
    );

    return _SettingsSection(
      title: l10n.subscriptionSection,
      children: [
        _SettingsTile(
          icon: isPremium
              ? Icons.workspace_premium
              : Icons.star_border,
          title: l10n.premiumTitle,
          subtitle: isPremium
              ? l10n.premiumActiveSubtitle
              : l10n.premiumInactiveSubtitle,
          trailing: isPremium
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.premiumActiveBadge,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: const Color(0xFFB8860B),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              : const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PaywallScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 일일 목표 설정 다이얼로그
/// StatefulWidget으로 TextEditingController 수명을 위젯 수명에 맞게 관리
class _GoalDialog extends StatefulWidget {
  final int currentGoal;

  const _GoalDialog({required this.currentGoal});

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentGoal.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.dailyGoalDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailyGoalDialogDescription),
            const SizedBox(height: 8),
            Text(
              l10n.dailyGoalDialogRange,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.dailyGoalDialogLabel,
                suffixText: l10n.dailyGoalDialogSuffix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.dailyGoalErrorEmpty;
                final goal = int.tryParse(value);
                if (goal == null) return l10n.dailyGoalErrorInvalid;
                if (goal < 1000 || goal > 30000) return l10n.dailyGoalErrorRange;
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(int.parse(_controller.text));
            }
          },
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
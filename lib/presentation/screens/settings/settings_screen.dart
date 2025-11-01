// lib/presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/settings/settings_service.dart';
import '../../../services/mission/mission_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return settingsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('설정'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('설정'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('설정을 불러올 수 없습니다: $error'),
        ),
      ),
      data: (settings) => _buildSettingsContent(context, ref, theme, settings),
    );
  }

  Widget _buildSettingsContent(BuildContext context, WidgetRef ref, ThemeData theme, settings) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 게임 설정
          _SettingsSection(
            title: '게임 설정',
            children: [
              _SettingsTile(
                icon: Icons.location_on,
                title: '실외 모드',
                subtitle: 'GPS를 사용한 실외 산책 감지',
                trailing: Switch(
                  value: settings.isOutdoorModeEnabled,
                  onChanged: (value) {
                    ref.read(settingsNotifierProvider.notifier).updateOutdoorMode(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.timer,
                title: '일일 목표',
                subtitle: '${settings.dailyStepGoal}걸음',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showGoalDialog(context, ref, settings.dailyStepGoal);
                },
              ),
              _SettingsTile(
                icon: Icons.emoji_events,
                title: '배지 및 업적',
                subtitle: '획득한 배지 확인',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('배지 화면은 곧 구현될 예정입니다!'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // AI 설정
          _SettingsSection(
            title: 'AI 설정',
            children: [
              _SettingsTile(
                icon: Icons.psychology,
                title: '로컬 AI 대화',
                subtitle: '기기 내에서 실행되는 AI 대화',
                trailing: Switch(
                  value: settings.localLLMEnabled,
                  onChanged: (value) {
                    ref.read(settingsNotifierProvider.notifier).updateLocalLLM(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.image,
                title: '클라우드 이미지 생성',
                subtitle: '온라인 AI를 통한 스티커 생성',
                trailing: Switch(
                  value: settings.cloudImageEnabled,
                  onChanged: (value) {
                    ref.read(settingsNotifierProvider.notifier).updateCloudImage(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.download,
                title: 'AI 모델 관리',
                subtitle: '로컬 AI 모델 다운로드 및 관리',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('AI 모델 관리는 곧 구현될 예정입니다!'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 알림 설정
          _SettingsSection(
            title: '알림',
            children: [
              _SettingsTile(
                icon: Icons.notifications,
                title: '알림 허용',
                subtitle: '산책 리마인더 및 알림',
                trailing: Switch(
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    ref.read(settingsNotifierProvider.notifier).updateNotifications(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.schedule,
                title: '알림 시간 설정',
                subtitle: '아침 09:00, 저녁 18:00',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showNotificationTimeDialog(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 앱 설정
          _SettingsSection(
            title: '앱 설정',
            children: [
              _SettingsTile(
                icon: Icons.dark_mode,
                title: '다크 모드',
                subtitle: '어두운 테마 사용',
                trailing: Switch(
                  value: settings.darkModeEnabled,
                  onChanged: (value) {
                    ref.read(settingsNotifierProvider.notifier).updateDarkMode(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.language,
                title: '언어',
                subtitle: '한국어',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('언어 설정은 곧 구현될 예정입니다!'),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.storage,
                title: '캐시 관리',
                subtitle: '이미지 및 데이터 캐시 정리',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showCacheDialog(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 정보
          _SettingsSection(
            title: '정보',
            children: [
              _SettingsTile(
                icon: Icons.info,
                title: '앱 정보',
                subtitle: 'Version ${AppConstants.appVersion}',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _SettingsTile(
                icon: Icons.help,
                title: '도움말',
                subtitle: '사용법 및 FAQ',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('도움말은 곧 구현될 예정입니다!'),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: '개인정보 처리방침',
                subtitle: '데이터 처리 및 개인정보 보호',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('개인정보 처리방침은 곧 구현될 예정입니다!'),
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
    final controller = TextEditingController(text: currentGoal.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('일일 목표 설정'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('목표 걸음수를 설정하세요'),
              const SizedBox(height: 8),
              Text(
                '(1,000 ~ 30,000 걸음)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '걸음수',
                  suffixText: '걸음',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '걸음수를 입력해주세요';
                  }
                  final goal = int.tryParse(value);
                  if (goal == null) {
                    return '올바른 숫자를 입력해주세요';
                  }
                  if (goal < 1000 || goal > 30000) {
                    return '1,000 ~ 30,000 사이의 값을 입력해주세요';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newGoal = int.parse(controller.text);
                controller.dispose();
                Navigator.of(dialogContext).pop();

                try {
                  await ref.read(settingsNotifierProvider.notifier).updateDailyStepGoal(newGoal);

                  // 미션 provider들을 새로고침하여 UI 업데이트
                  ref.invalidate(activeMissionsProvider);
                  ref.invalidate(dailyMissionsProvider);
                  ref.invalidate(weeklyMissionsProvider);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('일일 목표가 ${newGoal}걸음으로 설정되었습니다'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('목표 설정 중 오류가 발생했습니다: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showNotificationTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림 시간 설정'),
        content: const Text('아침과 저녁 알림 시간을 설정하세요'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('알림 시간 설정은 곧 구현될 예정입니다!'),
                ),
              );
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캐시 정리'),
        content: const Text('이미지 캐시와 임시 데이터를 정리하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('캐시가 정리되었습니다!'),
                ),
              );
            },
            child: const Text('정리'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const Text('🐕', style: TextStyle(fontSize: 48)),
      children: [
        const Text(AppConstants.appDescription),
        const SizedBox(height: 16),
        const Text('© 2025 WalkDog Team'),
      ],
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
                color: Colors.black.withOpacity(0.05),
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
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
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
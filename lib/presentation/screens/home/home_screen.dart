// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/pet.dart';
import '../../../l10n/app_localizations.dart';
import '../customize/customize_screen.dart';
import '../settings/settings_screen.dart';
import '../walk/walk_screen.dart';
import 'widgets/pet_avatar_widget.dart';
import 'widgets/pet_dialogue_widget.dart';
import 'widgets/conditional_low_happiness_dialogue.dart';
import 'widgets/pet_status_widget.dart';
import 'widgets/daily_stats_widget.dart';
import 'widgets/walk_button_widget.dart';
import 'widgets/achievements_widget.dart';
import 'widgets/weekly_chart_widget.dart';
import 'widgets/monthly_chart_widget.dart';
import 'widgets/streak_widget.dart';
import '../../widgets/mission_summary_widget.dart';
import '../../widgets/achievement_notification_widget.dart';
import '../../widgets/mission_notification_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  /// Optional: 펫 생성 직후 전달받은 Pet 객체
  /// 이 값이 있으면 StepTrackingService 로딩을 기다리지 않고 즉시 표시
  final Pet? initialPet;

  const HomeScreen({super.key, this.initialPet});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _HomeTabContent(initialPet: widget.initialPet),
      const WalkScreen(),
      const CustomizeScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context).tabHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_walk),
            label: AppLocalizations.of(context).tabWalk,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.palette),
            label: AppLocalizations.of(context).tabCustomize,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context).tabSettings,
          ),
        ],
      ),
    );
  }
}

class _HomeTabContent extends ConsumerWidget {
  /// Optional: 펫 생성 직후 전달받은 Pet 객체
  final Pet? initialPet;

  const _HomeTabContent({this.initialPet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalkDog'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 펫 아바타 영역
                  const PetAvatarWidget(),
                  const SizedBox(height: 16),

                  // AI 대화 영역 (인사 - 정적 화면용)
                  const PetDialogueWidget(
                    context: 'greeting_static',
                  ),
                  const SizedBox(height: 24),

                  // 펫 상태 영역
                  PetStatusWidget(initialPet: initialPet),
                  const SizedBox(height: 24),

                  // AI 대화 영역 (행복도 낮음 - 조건부)
                  const ConditionalLowHappinessDialogue(),

                  // 오늘의 통계
                  const DailyStatsWidget(),
                  const SizedBox(height: 24),

                  // 산책 시작 버튼
                  const WalkButtonWidget(),
                  const SizedBox(height: 24),

                  // 오늘의 미션
                  const MissionSummaryWidget(),
                  const SizedBox(height: 24),

                  // 연속 산책 일수
                  const StreakWidget(),
                  const SizedBox(height: 24),

                  // 주간 활동 차트
                  const WeeklyChartWidget(),
                  const SizedBox(height: 24),

                  // 월간 추세 차트
                  const MonthlyChartWidget(),
                  const SizedBox(height: 24),

                  // 최근 배지
                  const AchievementsWidget(),
                ],
              ),
            ),
            // 미션 완료 알림 오버레이
            const MissionNotificationWidget(),
            // 배지 달성 알림 오버레이
            const AchievementNotificationWidget(),
          ],
        ),
      ),
    );
  }
}

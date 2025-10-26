// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../customize/customize_screen.dart';
import '../settings/settings_screen.dart';
import '../achievements/achievements_screen.dart';
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
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTabContent(),
    const WalkScreen(),
    const CustomizeScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: '산책',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: '커스터마이즈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

class _HomeTabContent extends ConsumerWidget {
  const _HomeTabContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalkDog'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 알림 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('알림 기능은 곧 구현될 예정입니다!'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 펫 아바타 영역
                  PetAvatarWidget(),
                  SizedBox(height: 16),

                  // AI 대화 영역 (인사 - 정적 화면용)
                  PetDialogueWidget(
                    context: 'greeting_static',
                  ),
                  SizedBox(height: 24),

                  // 펫 상태 영역
                  PetStatusWidget(),
                  SizedBox(height: 24),

                  // AI 대화 영역 (행복도 낮음 - 조건부)
                  ConditionalLowHappinessDialogue(),

                  // 오늘의 통계
                  DailyStatsWidget(),
                  SizedBox(height: 24),

                  // 산책 시작 버튼
                  WalkButtonWidget(),
                  SizedBox(height: 24),

                  // 오늘의 미션
                  MissionSummaryWidget(),
                  SizedBox(height: 24),

                  // 연속 산책 일수
                  StreakWidget(),
                  SizedBox(height: 24),

                  // 주간 활동 차트
                  WeeklyChartWidget(),
                  SizedBox(height: 24),

                  // 월간 추세 차트
                  MonthlyChartWidget(),
                  SizedBox(height: 24),

                  // 최근 배지
                  AchievementsWidget(),
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

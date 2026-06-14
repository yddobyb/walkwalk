// lib/presentation/screens/onboarding/permission_priming_screen.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/breed_assets.dart';
import '../../../domain/entities/pet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/notification/notification_service.dart';
import '../../../services/sensors/pedometer_service.dart';
import '../../../services/tracking/step_tracking_service.dart';
import '../home/home_screen.dart';

/// 권한 안내(priming) 화면
///
/// 펫 생성 직후, OS 권한 다이얼로그(헬스 커넥트/알림)를 띄우기 전에
/// "왜 필요한지"를 펫의 말풍선으로 설명한다. 앱 시작 시점에 맥락 없이
/// 권한 팝업이 뜨던 문제(startup 블로킹)를 이 화면이 대체한다.
class PermissionPrimingScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const PermissionPrimingScreen({super.key, required this.pet});

  @override
  ConsumerState<PermissionPrimingScreen> createState() =>
      _PermissionPrimingScreenState();
}

class _PermissionPrimingScreenState
    extends ConsumerState<PermissionPrimingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heroScale;
  late final Animation<double> _heroFade;
  late final Animation<double> _bubbleFade;
  late final Animation<Offset> _bubbleSlide;
  late final Animation<double> _cardsFade;
  late final Animation<Offset> _cardsSlide;
  late final Animation<double> _footerFade;

  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    // 입장 스태거: 아바타 → 말풍선 → 카드 → 버튼
    _heroScale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
    ));
    _heroFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );
    _bubbleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.45, curve: Curves.easeOut),
    );
    _bubbleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
    ));
    _cardsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.75, curve: Curves.easeOut),
    );
    _cardsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    ));
    _footerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// CTA: OS 권한 다이얼로그(헬스 커넥트 → 알림)를 순서대로 띄우고
  /// 걸음수 트래킹을 (재)초기화한 뒤 홈으로 이동
  Future<void> _requestPermissions() async {
    if (_isRequesting) return;
    setState(() => _isRequesting = true);

    try {
      // 1. 걸음수(헬스 커넥트) — 거부해도 계속 진행
      await ref.read(pedometerServiceProvider).requestPermission();

      // 2. 알림 (iOS / Android 13+) + 리마인더 재스케줄
      final notifService = NotificationService.instance;
      await notifService.requestPermissions();
      await notifService.scheduleConditionalReminders();

      // 3. 권한이 생겼으니 걸음수 트래킹 초기화 (startup에서 미뤄둔 것)
      await StepTrackingService().initialize();
    } catch (e) {
      debugPrint('PermissionPriming - Error requesting permissions: $e');
    }

    if (!mounted) return;
    _goHome();
  }

  void _goHome() {
    // 펫을 트래킹 서비스에 로드해 홈의 펫 상태/대화가 바로 뜨도록 한다.
    // 특히 "나중에" 스킵 경로는 권한 초기화를 건너뛰므로, 이게 없으면
    // StepTrackingService._currentPet가 비어 채팅이 빈/로딩 상태가 된다.
    StepTrackingService().reloadCurrentPet();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(initialPet: widget.pet),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.10),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 배경 데코: 흩어진 발자국
              const _PawPrintDecoration(),

              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // 펫 아바타
                    FadeTransition(
                      opacity: _heroFade,
                      child: ScaleTransition(
                        scale: _heroScale,
                        child: _buildPetHero(theme, l10n),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 펫의 말풍선
                    FadeTransition(
                      opacity: _bubbleFade,
                      child: SlideTransition(
                        position: _bubbleSlide,
                        child: _buildSpeechBubble(theme, l10n),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 타이틀 + 권한 카드
                    FadeTransition(
                      opacity: _cardsFade,
                      child: SlideTransition(
                        position: _cardsSlide,
                        child: Column(
                          children: [
                            Text(
                              l10n.permissionPrimingTitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _PermissionCard(
                              emoji: '👟',
                              title: l10n.permissionStepsTitle,
                              description:
                                  l10n.permissionStepsDesc(widget.pet.name),
                              badge: l10n.permissionStepsBadge,
                            ),
                            const SizedBox(height: 12),
                            _PermissionCard(
                              emoji: '🔔',
                              title: l10n.permissionNotifTitle,
                              description: l10n.permissionNotifDesc,
                              badge: l10n.permissionNotifBadge,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 프라이버시 안내 + CTA + 스킵
                    FadeTransition(
                      opacity: _footerFade,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🔒', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 6),
                              Text(
                                l10n.permissionPrivacyNote,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  _isRequesting ? null : _requestPermissions,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: _isRequesting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      l10n.permissionPrimingCta,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: _isRequesting ? null : _goHome,
                            child: Text(
                              l10n.permissionPrimingSkip,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 방금 만든 펫의 품종 아이콘 히어로
  Widget _buildPetHero(ThemeData theme, AppLocalizations l10n) {
    final breedIcon =
        BreedAssets.iconForBreed(widget.pet.breed, l10n, size: 88);

    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: breedIcon ?? const Text('🐕', style: TextStyle(fontSize: 64)),
      ),
    );
  }

  /// 펫 이름이 붙은 말풍선 (위쪽 꼬리가 아바타를 향함)
  Widget _buildSpeechBubble(ThemeData theme, AppLocalizations l10n) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.pet.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                TextSpan(text: '  "${l10n.permissionPrimingBubble}"'),
              ],
            ),
            style: theme.textTheme.bodyLarge,
          ),
        ),
        // 말풍선 꼬리
        Positioned(
          top: -5,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 권한 1개를 설명하는 카드 (이모지 + 제목 + 설명 + 배지)
class _PermissionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String badge;

  const _PermissionCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
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

/// 배경에 은은하게 흩어진 발자국 데코
class _PawPrintDecoration extends StatelessWidget {
  const _PawPrintDecoration();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 28);

    Widget paw(double angle, double opacity) => Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: angle,
            child: const Text('🐾', style: style),
          ),
        );

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(top: 40, left: 28, child: paw(-0.4, 0.10)),
          Positioned(top: 90, right: 36, child: paw(0.5, 0.08)),
          Positioned(top: 215, left: 52, child: paw(0.2, 0.06)),
        ],
      ),
    );
  }
}

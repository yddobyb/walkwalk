// lib/presentation/screens/home/widgets/pet_status_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/pet/pet_reward_service.dart';
import '../../../../services/tracking/step_tracking_service.dart';

class PetStatusWidget extends ConsumerWidget {
  const PetStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 실시간 펫 데이터 가져오기 (StepTrackingService의 스트림 사용)
    final petTrackingAsync = ref.watch(petTrackingProvider);
    final petMood = ref.watch(petMoodProvider);

    return petTrackingAsync.when(
      data: (pet) => _buildPetStatus(context, theme, pet, petMood, ref),
      loading: () => _buildLoadingStatus(context, theme),
      error: (error, stack) => _buildErrorStatus(context, theme),
    );
  }

  Widget _buildPetStatus(BuildContext context, ThemeData theme, pet, PetMood? mood, WidgetRef ref) {
    final int happiness = pet?.happiness ?? 50;
    final int treats = pet?.treats ?? 0;
    final int level = pet?.level ?? 1;
    final int experience = pet?.experience ?? 0;

    // 다음 레벨에 필요한 경험치 계산
    final rewardService = ref.read(petRewardServiceProvider);
    final int requiredExp = rewardService.calculateRequiredExperience(level + 1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '펫 상태',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'LV $level',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 행복도
          _StatusBar(
            icon: '😊',
            label: '행복도',
            value: happiness,
            maxValue: 100,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(height: 16),

          // 경험치
          _StatusBar(
            icon: '⭐',
            label: '경험치',
            value: experience,
            maxValue: requiredExp,
            color: Colors.amber,
          ),

          const SizedBox(height: 16),

          // 간식 개수
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('🦴', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '간식',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$treats개',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: treats > 0 ? () => _feedTreat(context, ref, pet) : null,
                icon: const Icon(Icons.favorite, size: 16),
                label: const Text('간식 주기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 상태 메시지
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusMessageColor(happiness, theme).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getStatusMessage(happiness),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _getStatusMessageColor(happiness, theme),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusMessageColor(int happiness, ThemeData theme) {
    if (happiness >= 80) return Colors.green;
    if (happiness >= 60) return Colors.orange;
    if (happiness >= 40) return Colors.red;
    return theme.colorScheme.error;
  }

  String _getStatusMessage(int happiness) {
    if (happiness >= 90) return '아주 행복해해요! 😆';
    if (happiness >= 80) return '기분이 좋아 보여요! 😊';
    if (happiness >= 60) return '보통이에요 😐';
    if (happiness >= 40) return '조금 우울해 보여요 😔';
    if (happiness >= 20) return '많이 슬퍼해요 😢';
    return '매우 우울해해요... 😭';
  }

  Widget _buildLoadingStatus(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorStatus(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            '펫 정보를 불러올 수 없습니다',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _feedTreat(BuildContext context, WidgetRef ref, pet) async {
    if (pet == null) return;

    try {
      final rewardService = ref.read(petRewardServiceProvider);
      final updatedPet = await rewardService.feedTreat(pet.petId, 1);

      if (updatedPet != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('냠냠! 맛있어! 🐕 (행복도 +10)'),
            backgroundColor: Colors.green,
          ),
        );
        // 펫 데이터 새로고침
        ref.invalidate(activePetProvider);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('간식을 줄 수 없습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _StatusBar extends StatelessWidget {
  final String icon;
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const _StatusBar({
    required this.icon,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = value / maxValue;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$value/$maxValue',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
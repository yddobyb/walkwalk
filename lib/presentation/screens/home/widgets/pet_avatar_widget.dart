// lib/presentation/screens/home/widgets/pet_avatar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/pet.dart';
import '../../../../services/pet/pet_reward_service.dart';

class PetAvatarWidget extends ConsumerWidget {
  const PetAvatarWidget({super.key});

  String _getPersonalityText(PetPersonality personality) {
    switch (personality) {
      case PetPersonality.cheerful:
        return '명랑한 성격';
      case PetPersonality.calm:
        return '차분한 성격';
      case PetPersonality.energetic:
        return '활발한 성격';
      case PetPersonality.shy:
        return '수줍은 성격';
      case PetPersonality.playful:
        return '장난기 많은 성격';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activePetAsync = ref.watch(activePetProvider);

    return activePetAsync.when(
      data: (pet) {
        final petName = pet?.name ?? '멍멍이';
        final petBreed = pet?.breed ?? '골든 리트리버';
        final petPersonality = pet != null ? _getPersonalityText(pet.personality) : '명랑한 성격';

        return Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.secondary.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 임시 강아지 이모지 (추후 벡터 아바타로 교체)
              GestureDetector(
                onTap: () {
                  // 펫과 상호작용 (AI 대화 등)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('안녕! 나는 $petName이야! 오늘도 함께 산책하자! 🐕'),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🐕',
                      style: TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 펫 이름
              Text(
                petName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // 펫 설명
              Text(
                '$petBreed • $petPersonality',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 12),

              // 상호작용 힌트
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '펫을 터치해서 대화해보세요!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
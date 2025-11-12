// lib/presentation/screens/home/widgets/pet_avatar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/pet.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/pet/pet_reward_service.dart';
import 'pet_dialogue_widget.dart';

class PetAvatarWidget extends ConsumerWidget {
  const PetAvatarWidget({super.key});

  String _getPersonalityText(PetPersonality personality, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (personality) {
      case PetPersonality.cheerful:
        return l10n.personalityCheerfulDesc;
      case PetPersonality.calm:
        return l10n.personalityCalmDesc;
      case PetPersonality.energetic:
        return l10n.personalityEnergeticDesc;
      case PetPersonality.shy:
        return l10n.personalityShyDesc;
      case PetPersonality.playful:
        return l10n.personalityPlayfulDesc;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activePetAsync = ref.watch(activePetProvider);

    return activePetAsync.when(
      data: (pet) {
        final l10n = AppLocalizations.of(context);
        final petName = pet?.name ?? l10n.defaultPetName;
        final petBreed = pet?.breed ?? l10n.defaultPetBreed;
        final petPersonality = pet != null ? _getPersonalityText(pet.personality, context) : l10n.personalityCheerfulDesc;

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
                onTap: () => _showGreetingDialogue(context, pet),
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
                  l10n.tapPetToChat,
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
              AppLocalizations.of(context).petInfoLoadError,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGreetingDialogue(BuildContext context, pet) {
    if (pet == null) return;

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 드래그 핸들
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // AI 대화 (greeting)
              const PetDialogueWidget(
                context: 'greeting',
              ),
              const SizedBox(height: 16),
              // 닫기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).close),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }
}
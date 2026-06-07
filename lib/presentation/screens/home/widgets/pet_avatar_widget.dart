// lib/presentation/screens/home/widgets/pet_avatar_widget.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/pet/pet_reward_service.dart';
import 'pet_dialogue_widget.dart';
import '../../../../core/utils/breed_assets.dart';

class PetAvatarWidget extends ConsumerWidget {
  const PetAvatarWidget({super.key});

  /// 영문 breed → 현재 로케일에 맞게 변환
  String? _localizeBreed(String? breed, AppLocalizations l10n) {
    if (breed == null) return null;
    final mapping = {
      'Golden Retriever': l10n.breedGoldenRetriever,
      'Labrador': l10n.breedLabrador,
      'Shiba Inu': l10n.breedShiba,
      'Pomeranian': l10n.breedPomeranian,
      'Husky': l10n.breedHusky,
      'Beagle': l10n.breedBeagle,
      'Bulldog': l10n.breedBulldog,
      'Poodle': l10n.breedPoodle,
    };
    return mapping[breed] ?? breed;
  }

  /// 펫 아바타 빌드 (스티커가 있으면 이미지, 없으면 품종 아이콘 → 이모지)
  Widget _buildPetAvatar(
      BuildContext context, String? stickerPath, String? breed) {
    // 스티커 경로가 있으면 이미지 표시
    if (stickerPath != null && stickerPath.isNotEmpty) {
      final file = File(stickerPath);
      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: Image.file(
                file,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _fallbackAvatar(context, breed),
              ),
            );
          }
          // 파일이 존재하지 않으면 품종 아이콘/이모지
          return _fallbackAvatar(context, breed);
        },
      );
    }

    // 스티커가 없으면 품종 아이콘/이모지
    return _fallbackAvatar(context, breed);
  }

  /// 스티커가 없을 때 폴백: 품종 플랫 아이콘(있으면) → 이모지
  Widget _fallbackAvatar(BuildContext context, String? breed) {
    final icon = BreedAssets.iconForBreed(
      breed,
      AppLocalizations.of(context),
      size: 110,
    );
    return icon ?? const Text('🐕', style: TextStyle(fontSize: 80));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activePetAsync = ref.watch(activePetProvider);

    return activePetAsync.when(
      data: (pet) {
        final l10n = AppLocalizations.of(context);
        final petName = pet?.name ?? l10n.defaultPetName;
        final petBreed = _localizeBreed(pet?.breed, l10n) ?? l10n.defaultPetBreed;

        return Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 펫 아바타 (스티커가 있으면 표시, 없으면 이모지)
              GestureDetector(
                onTap: () => _showGreetingDialogue(context, pet),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _buildPetAvatar(context, pet?.stickerPath, pet?.breed),
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
                petBreed,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 12),

              // 상호작용 힌트
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.1),
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
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.1),
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
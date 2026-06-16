// lib/presentation/screens/customize/customize_screen.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/quota_response.dart';
import '../../../data/models/sticker_request.dart';
import '../../../data/models/sticker_response.dart';
import '../../../domain/entities/pet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/firebase/image_generation_providers.dart';
import '../../../services/firebase/image_generation_service.dart';
import '../../../services/pet/pet_reward_service.dart';
import '../../../services/sticker/sticker_save_service.dart';
import '../../../core/constants/ad_constants.dart';
import '../../../core/utils/breed_assets.dart';
import '../../../services/ads/ad_service.dart';
import '../subscription/paywall_screen.dart';

class CustomizeScreen extends ConsumerStatefulWidget {
  const CustomizeScreen({super.key});

  @override
  ConsumerState<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends ConsumerState<CustomizeScreen> {
  PetAccessory _selectedAccessory = PetAccessory.none;

  // 스티커 생성 옵션 (기본값)
  String _breed = 'Golden Retriever';
  String _color = 'golden'; // UI 색상 목록의 첫 번째 항목과 일치
  StickerStyle _style = StickerStyle.stickerFlat;
  StickerBackground _bg = StickerBackground.transparent;

  bool _breedInitialized = false;

  /// Pet.breed (로컬라이즈된 이름) → 영어 breed 값으로 역매핑
  String? _reverseMapBreed(String localizedBreed) {
    final l10n = AppLocalizations.of(context);
    final mapping = {
      l10n.breedGoldenRetriever: 'Golden Retriever',
      l10n.breedLabrador: 'Labrador',
      l10n.breedShiba: 'Shiba Inu',
      l10n.breedPomeranian: 'Pomeranian',
      l10n.breedHusky: 'Husky',
      l10n.breedBeagle: 'Beagle',
      l10n.breedBulldog: 'Bulldog',
      l10n.breedPoodle: 'Poodle',
    };
    return mapping[localizedBreed];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stickerState = ref.watch(stickerGeneratorProvider);
    final quotaAsync = ref.watch(quotaProvider);
    final applyState = ref.watch(stickerApplyProvider);
    final petAsync = ref.watch(activePetProvider);

    // 온보딩에서 선택한 품종으로 이미지 생성 기본값 설정 (최초 1회)
    if (!_breedInitialized && petAsync.hasValue && petAsync.value != null) {
      final mappedBreed = _reverseMapBreed(petAsync.value!.breed);
      if (mappedBreed != null) {
        _breed = mappedBreed;
      }
      _breedInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).customizeTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 펫 미리보기
            Container(
              width: double.infinity,
              height: 200,
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // 펫 아바타 - 저장된 스티커가 있으면 표시, 없으면 이모지
                      _PetPreviewAvatar(
                        stickerPath: petAsync.valueOrNull?.stickerPath,
                        breed: _breed,
                        selectedAccessory: _selectedAccessory,
                        getAccessoryEmoji: _getAccessoryEmoji,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    petAsync.valueOrNull?.name ?? AppLocalizations.of(context).defaultPetName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 액세서리 선택
            Text(
              AppLocalizations.of(context).accessoriesTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: PetAccessory.values.length,
              itemBuilder: (context, index) {
                final accessory = PetAccessory.values[index];
                final isSelected = _selectedAccessory == accessory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAccessory = accessory;
                    });
                    _showApplyDialog();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getAccessoryEmoji(accessory),
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getAccessoryName(accessory, context),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // 견종 선택 섹션
            Text(
              AppLocalizations.of(context).petBreed,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBreedSelector(theme),

            const SizedBox(height: 32),

            // 색상 선택 섹션
            Text(
              AppLocalizations.of(context).petColor,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildColorSelector(theme),

            const SizedBox(height: 32),

            // 스타일 선택 섹션
            Text(
              AppLocalizations.of(context).styleTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStyleSelector(theme),

            const SizedBox(height: 32),

            // 배경 선택 섹션
            Text(
              AppLocalizations.of(context).backgroundTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBackgroundSelector(theme),

            const SizedBox(height: 32),

            // 스티커 생성 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).aiStickerGeneration,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).aiStickerDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canGenerate(stickerState, quotaAsync)
                          ? _generateSticker
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (stickerState.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          else
                            const Icon(Icons.image),
                          const SizedBox(width: 8),
                          Text(
                            stickerState.isLoading
                                ? AppLocalizations.of(context).stickerGenerating
                                : AppLocalizations.of(context).generateSticker,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 할당량 표시 UI
                  const SizedBox(height: 16),
                  _QuotaIndicator(
                    quotaAsync: quotaAsync,
                    theme: theme,
                    onUpgradeTap: () async {
                      final subscribed =
                          await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => const PaywallScreen(),
                        ),
                      );
                      if (subscribed == true) {
                        ref.invalidate(quotaProvider);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 스티커 생성 결과 표시
            stickerState.when(
              data: (response) {
                if (response == null) return const SizedBox.shrink();

                final service = ref.read(imageGenerationServiceProvider);
                final imageBytes = service.decodeBase64Image(response.data.imageBase64);

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            response.data.cached ? Icons.cached : Icons.auto_awesome,
                            color: response.data.cached ? Colors.grey : theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            response.data.cached
                                ? AppLocalizations.of(context).stickerCached
                                : AppLocalizations.of(context).stickerNew,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: response.data.cached ? Colors.grey : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      // Provider 정보 표시 (새로 생성된 경우만)
                      if (!response.data.cached && response.data.provider != null) ...[
                        const SizedBox(height: 4),
                        _ProviderBadge(provider: response.data.provider!),
                      ],
                      const SizedBox(height: 16),
                      _StickerImage(imageBytes: imageBytes),
                      const SizedBox(height: 12),
                      Text(
                        '${response.data.size.width}x${response.data.size.height}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 스티커 적용 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: applyState.isLoading
                              ? null
                              : () => _applySticker(imageBytes),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (applyState.isLoading)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              else
                                const Icon(Icons.check_circle),
                              const SizedBox(width: 8),
                              Text(
                                applyState.isLoading
                                    ? AppLocalizations.of(context).stickerApplying
                                    : AppLocalizations.of(context).stickerApplyButton,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).stickerLoadingMessage,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).stickerLoadingTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, _) {
                String message = AppLocalizations.of(context).stickerErrorDefault;
                if (error is ImageGenerationException) {
                  message = error.userMessage;
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getAccessoryEmoji(PetAccessory accessory) {
    switch (accessory) {
      case PetAccessory.none:
        return '🚫';
      case PetAccessory.bandana:
        return '🔴';
      case PetAccessory.glasses:
        return '🕶️';
      case PetAccessory.bowtie:
        return '🎀';
      case PetAccessory.hat:
        return '🎩';
      case PetAccessory.collar:
        return '⭕';
    }
  }

  String _getAccessoryName(PetAccessory accessory, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (accessory) {
      case PetAccessory.none:
        return l10n.accessoryNone;
      case PetAccessory.bandana:
        return l10n.accessoryBandana;
      case PetAccessory.glasses:
        return l10n.accessoryGlasses;
      case PetAccessory.bowtie:
        return l10n.accessoryBowtie;
      case PetAccessory.hat:
        return l10n.accessoryHat;
      case PetAccessory.collar:
        return l10n.accessoryCollar;
    }
  }

  // 견종 목록 및 이모지
  static const List<Map<String, String>> _breeds = [
    {'value': 'Golden Retriever', 'key': 'breedGoldenRetriever', 'emoji': '🦮'},
    {'value': 'Labrador', 'key': 'breedLabrador', 'emoji': '🐕'},
    {'value': 'Shiba Inu', 'key': 'breedShiba', 'emoji': '🐕‍🦺'},
    {'value': 'Pomeranian', 'key': 'breedPomeranian', 'emoji': '🐶'},
    {'value': 'Husky', 'key': 'breedHusky', 'emoji': '🐺'},
    {'value': 'Beagle', 'key': 'breedBeagle', 'emoji': '🐕'},
    {'value': 'Bulldog', 'key': 'breedBulldog', 'emoji': '🐶'},
    {'value': 'Poodle', 'key': 'breedPoodle', 'emoji': '🐩'},
  ];

  String _getBreedName(String breedValue) {
    final l10n = AppLocalizations.of(context);
    switch (breedValue) {
      case 'Golden Retriever':
        return l10n.breedGoldenRetriever;
      case 'Labrador':
        return l10n.breedLabrador;
      case 'Shiba Inu':
        return l10n.breedShiba;
      case 'Pomeranian':
        return l10n.breedPomeranian;
      case 'Husky':
        return l10n.breedHusky;
      case 'Beagle':
        return l10n.breedBeagle;
      case 'Bulldog':
        return l10n.breedBulldog;
      case 'Poodle':
        return l10n.breedPoodle;
      default:
        return breedValue;
    }
  }

  Widget _buildBreedSelector(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: _breeds.length,
      itemBuilder: (context, index) {
        final breed = _breeds[index];
        final isSelected = _breed == breed['value'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _breed = breed['value']!;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  breed['emoji']!,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Text(
                  _getBreedName(breed['value']!),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 색상 목록
  static const List<Map<String, dynamic>> _colors = [
    {'value': 'golden', 'key': 'colorGolden', 'color': Color(0xFFD4A574)},
    {'value': 'brown', 'key': 'colorBrown', 'color': Color(0xFF8B4513)},
    {'value': 'black', 'key': 'colorBlack', 'color': Color(0xFF2C2C2C)},
    {'value': 'white', 'key': 'colorWhite', 'color': Color(0xFFF5F5F5)},
    {'value': 'gray', 'key': 'colorGray', 'color': Color(0xFF808080)},
    {'value': 'cream', 'key': 'colorCream', 'color': Color(0xFFFFF8DC)},
  ];

  String _getColorName(String colorValue) {
    final l10n = AppLocalizations.of(context);
    switch (colorValue) {
      case 'golden':
        return l10n.colorGolden;
      case 'brown':
        return l10n.colorBrown;
      case 'black':
        return l10n.colorBlack;
      case 'white':
        return l10n.colorWhite;
      case 'gray':
        return l10n.colorGray;
      case 'cream':
        return l10n.colorCream;
      default:
        return colorValue;
    }
  }

  Widget _buildColorSelector(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: _colors.length,
      itemBuilder: (context, index) {
        final colorData = _colors[index];
        final isSelected = _color == colorData['value'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _color = colorData['value'] as String;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorData['color'] as Color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getColorName(colorData['value'] as String),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 스타일 목록
  String _getStyleName(StickerStyle style) {
    final l10n = AppLocalizations.of(context);
    switch (style) {
      case StickerStyle.stickerFlat:
        return l10n.styleFlat;
      case StickerStyle.sticker3d:
        return l10n.style3d;
      case StickerStyle.realistic:
        return l10n.styleRealistic;
    }
  }

  String _getStyleEmoji(StickerStyle style) {
    switch (style) {
      case StickerStyle.stickerFlat:
        return '🎨';
      case StickerStyle.sticker3d:
        return '🎲';
      case StickerStyle.realistic:
        return '📷';
    }
  }

  Widget _buildStyleSelector(ThemeData theme) {
    return Row(
      children: StickerStyle.values.map((style) {
        final isSelected = _style == style;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _style = style;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getStyleEmoji(style),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStyleName(style),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 배경 목록
  String _getBackgroundName(StickerBackground bg) {
    final l10n = AppLocalizations.of(context);
    switch (bg) {
      case StickerBackground.transparent:
        return l10n.bgTransparent;
      case StickerBackground.white:
        return l10n.bgWhite;
      case StickerBackground.gradient:
        return l10n.bgGradient;
    }
  }

  String _getBackgroundEmoji(StickerBackground bg) {
    switch (bg) {
      case StickerBackground.transparent:
        return '🔲';
      case StickerBackground.white:
        return '⬜';
      case StickerBackground.gradient:
        return '🌈';
    }
  }

  Widget _buildBackgroundSelector(ThemeData theme) {
    return Row(
      children: StickerBackground.values.map((bg) {
        final isSelected = _bg == bg;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _bg = bg;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getBackgroundEmoji(bg),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBackgroundName(bg),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showApplyDialog() {
    final l10n = AppLocalizations.of(context);
    final accessoryName = _getAccessoryName(_selectedAccessory, context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.applyAccessoryTitle),
        content: Text(l10n.applyAccessoryConfirm(accessoryName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.accessoryAppliedSuccess(accessoryName)),
                ),
              );
            },
            child: Text(l10n.apply),
          ),
        ],
      ),
    );
  }

  /// 스티커 적용 (저장 및 Pet 업데이트 + 품종 동기화)
  Future<void> _applySticker(Uint8List imageBytes) async {
    final success = await ref.read(stickerApplyProvider.notifier).applySticker(
      imageBytes,
      breed: _breed,
    );

    if (!mounted) return;

    if (success) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.stickerAppliedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      // 상태 초기화
      ref.read(stickerApplyProvider.notifier).reset();
    } else {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.stickerApplyFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _generateSticker() {
    // 할당량 소진 시: 무료+광고 보너스 가능하면 리워드 다이얼로그, 아니면 안내
    final quota = ref.read(quotaProvider).valueOrNull;
    if (quota != null && quota.isExhausted) {
      _showOutOfQuotaDialog(quota);
      return;
    }
    _doGenerate();
  }

  /// 실제 스티커 생성 (할당량 통과 후 또는 리워드 광고 시청 후 호출)
  void _doGenerate() {
    // PetAccessory -> StickerAccessory 변환
    final stickerAccessory = _convertAccessory(_selectedAccessory);

    final request = StickerRequest(
      petId: 'pet_${DateTime.now().millisecondsSinceEpoch}',
      breed: _breed,
      color: _color,
      accessory: stickerAccessory,
      style: _style,
      bg: _bg,
    );

    ref.read(stickerGeneratorProvider.notifier).generate(request);
  }

  /// 무료 유저가 리워드 광고로 추가 생성 가능한지 (기본 소진 후 최대 maxImageAdBonus장)
  bool _adEligible(QuotaData quota) =>
      quota.isFree && quota.used < quota.total + AdConstants.maxImageAdBonus;

  /// 할당량 소진 다이얼로그 — [광고 보고 +1] / [프리미엄] / [닫기]
  void _showOutOfQuotaDialog(QuotaData quota) {
    final l10n = AppLocalizations.of(context);
    final adEligible = _adEligible(quota);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.outOfQuotaTitle),
        content: Text(
          adEligible
              ? l10n.outOfQuotaAdMessage
              : l10n.quotaResetsIn(quota.formattedTimeUntilReset),
        ),
        actions: [
          if (adEligible)
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _watchAdThenGenerate();
              },
              child: Text(l10n.outOfQuotaWatchAd),
            ),
          if (quota.isFree)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _openPaywall();
              },
              child: Text(l10n.outOfQuotaUpgrade),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  /// 리워드 광고 시청 → 보상 획득 시 생성, 광고 없으면 안내
  void _watchAdThenGenerate() {
    ref.read(adServiceProvider).showRewarded(
          onReward: () {
            if (mounted) _doGenerate();
          },
          onUnavailable: () {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).adNotReady)),
            );
          },
        );
  }

  /// 페이월 열기 (구독 성공 시 할당량 갱신)
  Future<void> _openPaywall() async {
    final subscribed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PaywallScreen()),
    );
    if (subscribed == true && mounted) {
      ref.invalidate(quotaProvider);
    }
  }

  /// PetAccessory -> StickerAccessory 변환
  StickerAccessory _convertAccessory(PetAccessory petAccessory) {
    switch (petAccessory) {
      case PetAccessory.none:
        return StickerAccessory.none;
      case PetAccessory.bandana:
        return StickerAccessory.bandana;
      case PetAccessory.glasses:
        return StickerAccessory.glasses;
      case PetAccessory.bowtie:
        return StickerAccessory.bowtie;
      case PetAccessory.hat:
        return StickerAccessory.hat;
      case PetAccessory.collar:
        return StickerAccessory.collar;
    }
  }

  /// 스티커 생성 가능 여부 확인
  bool _canGenerate(
    AsyncValue<StickerResponse?> stickerState,
    AsyncValue<QuotaData> quotaAsync,
  ) {
    // 로딩 중이면 비활성화
    if (stickerState.isLoading) return false;

    // 소진 여부와 무관하게 버튼은 활성 — 소진 시 _generateSticker가 적절한
    // 다이얼로그(무료: 광고/업그레이드, 프리미엄: 리셋 안내)를 띄운다.
    return true;
  }
}

/// 스티커 이미지 위젯
class _StickerImage extends StatelessWidget {
  final Uint8List imageBytes;

  const _StickerImage({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      child: Image.memory(
        imageBytes,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// 할당량 표시 위젯
class _QuotaIndicator extends StatelessWidget {
  final AsyncValue<QuotaData> quotaAsync;
  final ThemeData theme;
  final VoidCallback? onUpgradeTap;

  const _QuotaIndicator({
    required this.quotaAsync,
    required this.theme,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    return quotaAsync.when(
      data: (quota) => Column(
        children: [
          // 현재 등급 및 품질 표시 배지
          _TierBadge(quota: quota, theme: theme),
          const SizedBox(height: 12),

          // 할당량 텍스트
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).quotaRemainingToday,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${quota.remaining}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: quota.isExhausted
                          ? Colors.red
                          : theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    ' / ${quota.total}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 프로그레스 바
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: quota.remainingRate,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                quota.isExhausted
                    ? Colors.red
                    : quota.remaining <= 3
                        ? Colors.orange
                        : Colors.green,
              ),
              minHeight: 6,
            ),
          ),
          // 리셋 시간 (할당량 소진 시에만 표시)
          if (quota.isExhausted) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: Colors.red.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context).quotaResetsIn(
                    quota.formattedTimeUntilReset,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.red.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],

          // 무료 사용자에게 프리미엄 업그레이드 유도 배너
          if (quota.isFree) ...[
            const SizedBox(height: 16),
            _PremiumUpgradeBanner(
              theme: theme,
              onUpgradeTap: onUpgradeTap,
            ),
          ],
        ],
      ),
      loading: () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).quotaChecking,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
      error: (error, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: Colors.orange.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context).quotaLoadError,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// 현재 등급 표시 배지
class _TierBadge extends StatelessWidget {
  final QuotaData quota;
  final ThemeData theme;

  const _TierBadge({
    required this.quota,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = quota.isPremium;
    final bgColor = isPremium
        ? const Color(0xFFFFD700).withValues(alpha: 0.15)
        : Colors.green.withValues(alpha: 0.1);
    final borderColor = isPremium
        ? const Color(0xFFFFD700)
        : Colors.green;
    final textColor = isPremium
        ? const Color(0xFFB8860B)
        : Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quota.tierEmoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).tierQualityLabel(
              quota.isPremium
                  ? AppLocalizations.of(context).premiumTitle
                  : AppLocalizations.of(context).tierNameFree,
            ),
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${quota.providerDisplayName})',
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// 프리미엄 업그레이드 유도 배너
class _PremiumUpgradeBanner extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback? onUpgradeTap;

  const _PremiumUpgradeBanner({
    required this.theme,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFFF8A50) : Colors.white;
    final subTextColor = isDark
        ? const Color(0xFFFF8A50).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.85);
    final iconBgColor = isDark
        ? const Color(0xFFFF8A50).withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFFCC4A00),
                    Color(0xFFFF8A50),
                    Color(0xFFFFB584),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isDark ? theme.colorScheme.surfaceContainerHighest : null,
          border: isDark
              ? Border.all(
                  color: const Color(0xFFFF8A50).withValues(alpha: 0.4),
                  width: 1.5,
                )
              : null,
        ),
        child: Stack(
          children: [
            // 배경 장식 원
            Positioned(
              top: -24,
              right: -24,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFFFF8A50).withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -16,
              left: 80,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFFFF8A50).withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),

            // 콘텐츠
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 행: 💎 아이콘 + 타이틀/서브타이틀
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconBgColor,
                        ),
                        child: const Center(
                          child: Text('💎', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.premiumUpgradeTitle,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.premiumInactiveSubtitle,
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 12,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 특징 칩
                  Row(
                    children: [
                      _featureChip('✨ HD Quality', isDark),
                      const SizedBox(width: 6),
                      _featureChip('∞ 50/day', isDark),
                      const SizedBox(width: 6),
                      _featureChip('⚡ Fast', isDark),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // CTA 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onUpgradeTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? theme.colorScheme.primary
                            : Colors.white,
                        foregroundColor: isDark
                            ? theme.colorScheme.onPrimary
                            : const Color(0xFFCC4A00),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        l10n.premiumUpgradeButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFFFF8A50).withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(
                color: const Color(0xFFFF8A50).withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? const Color(0xFFFF8A50) : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Provider 배지 위젯
///
/// 스티커 생성에 사용된 AI 제공자를 표시
class _ProviderBadge extends StatelessWidget {
  final String provider;

  const _ProviderBadge({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // provider에 따른 스타일 설정
    final isGemini = provider.toLowerCase() == 'gemini';
    final bgColor = isGemini
        ? const Color(0xFF4285F4).withValues(alpha: 0.1)
        : Colors.purple.withValues(alpha: 0.1);
    final textColor = isGemini
        ? const Color(0xFF4285F4)
        : Colors.purple;
    final emoji = isGemini ? '✨' : '🎨';
    final displayName = _getProviderDisplayName(provider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getProviderDisplayName(String provider) {
    switch (provider.toLowerCase()) {
      case 'gemini':
        return 'Gemini';
      case 'cloudflare':
        return 'Cloudflare';
      case 'openai':
        return 'OpenAI';
      default:
        return provider;
    }
  }
}

/// 펫 미리보기 아바타 위젯
///
/// 저장된 스티커가 있으면 표시, 없으면 이모지 표시
class _PetPreviewAvatar extends StatelessWidget {
  final String? stickerPath;
  final String? breed;
  final PetAccessory selectedAccessory;
  final String Function(PetAccessory) getAccessoryEmoji;

  const _PetPreviewAvatar({
    required this.stickerPath,
    required this.breed,
    required this.selectedAccessory,
    required this.getAccessoryEmoji,
  });

  @override
  Widget build(BuildContext context) {
    // 스티커가 있으면 이미지 표시
    if (stickerPath != null && stickerPath!.isNotEmpty) {
      final file = File(stickerPath!);
      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패 시 폴백
                  return _buildEmojiAvatar(context);
                },
              ),
            );
          }
          // 파일이 존재하지 않으면 품종 아이콘/이모지
          return _buildEmojiAvatar(context);
        },
      );
    }

    // 스티커가 없으면 품종 아이콘/이모지 표시
    return _buildEmojiAvatar(context);
  }

  Widget _buildEmojiAvatar(BuildContext context) {
    final breedIcon = BreedAssets.iconForBreed(
      breed,
      AppLocalizations.of(context),
      size: 120,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        breedIcon ??
            const Text(
              '🐕',
              style: TextStyle(fontSize: 100),
            ),
        // 액세서리 표시
        if (selectedAccessory != PetAccessory.none)
          Positioned(
            top: 10,
            child: Text(
              getAccessoryEmoji(selectedAccessory),
              style: const TextStyle(fontSize: 30),
            ),
          ),
      ],
    );
  }
}
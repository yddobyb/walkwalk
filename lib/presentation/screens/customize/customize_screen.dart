// lib/presentation/screens/customize/customize_screen.dart
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

class CustomizeScreen extends ConsumerStatefulWidget {
  const CustomizeScreen({super.key});

  @override
  ConsumerState<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends ConsumerState<CustomizeScreen> {
  PetAccessory _selectedAccessory = PetAccessory.none;

  // 스티커 생성 옵션 (테스트용 기본값)
  String _breed = 'Shiba Inu';
  String _color = 'orange';
  StickerStyle _style = StickerStyle.stickerFlat;
  StickerBackground _bg = StickerBackground.transparent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stickerState = ref.watch(stickerGeneratorProvider);
    final quotaAsync = ref.watch(quotaProvider);

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
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.secondary.withOpacity(0.1),
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
                      // 펫 아바타
                      const Text(
                        '🐕',
                        style: TextStyle(fontSize: 100),
                      ),
                      // 액세서리 표시
                      if (_selectedAccessory != PetAccessory.none)
                        Positioned(
                          top: 10,
                          child: Text(
                            _getAccessoryEmoji(_selectedAccessory),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).defaultPetName,
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
                            : theme.colorScheme.outline.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
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

            // 스티커 생성 섹션
            Container(
              width: double.infinity,
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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _canGenerate(stickerState, quotaAsync)
                          ? _generateSticker
                          : null,
                      icon: stickerState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Icon(Icons.image),
                      label: Text(
                        stickerState.isLoading
                            ? '생성 중...'
                            : AppLocalizations.of(context).generateSticker,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  // 할당량 표시 UI
                  const SizedBox(height: 16),
                  _QuotaIndicator(quotaAsync: quotaAsync, theme: theme),
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
                      color: theme.colorScheme.primary.withOpacity(0.3),
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
                            response.data.cached ? '캐시된 스티커' : '새로 생성된 스티커',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: response.data.cached ? Colors.grey : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StickerImage(imageBytes: imageBytes),
                      const SizedBox(height: 12),
                      Text(
                        '${response.data.size.width}x${response.data.size.height}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
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
                      '스티커 생성 중...',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '약 5-8초 소요됩니다',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, _) {
                String message = '오류가 발생했습니다';
                if (error is ImageGenerationException) {
                  message = error.userMessage;
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
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

  void _generateSticker() {
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

    // 할당량 확인
    return quotaAsync.maybeWhen(
      data: (quota) => !quota.isExhausted,
      orElse: () => true, // 할당량 로딩 중/에러 시에도 일단 허용
    );
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

  const _QuotaIndicator({
    required this.quotaAsync,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return quotaAsync.when(
      data: (quota) => Column(
        children: [
          // 할당량 텍스트
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '오늘 남은 횟수',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
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
              backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                quota.isExhausted
                    ? Colors.red
                    : quota.remaining <= 5
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
                  color: Colors.red.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  '${quota.formattedTimeUntilReset} 후 리셋',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.red.withOpacity(0.7),
                  ),
                ),
              ],
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
            '할당량 확인 중...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
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
            color: Colors.orange.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            '할당량 정보를 불러올 수 없습니다',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
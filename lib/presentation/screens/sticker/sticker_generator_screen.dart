// lib/presentation/screens/sticker/sticker_generator_screen.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/sticker_request.dart';
import '../../../services/firebase/image_generation_providers.dart';
import '../../../services/firebase/image_generation_service.dart';

/// 스티커 생성 화면
///
/// Week 4: Gemini를 통한 커스텀 강아지 스티커 생성
class StickerGeneratorScreen extends ConsumerStatefulWidget {
  const StickerGeneratorScreen({super.key});

  @override
  ConsumerState<StickerGeneratorScreen> createState() => _StickerGeneratorScreenState();
}

class _StickerGeneratorScreenState extends ConsumerState<StickerGeneratorScreen> {
  String _breed = 'Shiba Inu';
  String _color = 'orange';
  StickerAccessory _accessory = StickerAccessory.none;
  StickerStyle _style = StickerStyle.stickerFlat;
  StickerBackground _bg = StickerBackground.transparent;

  void _generateSticker() {
    final request = StickerRequest(
      petId: 'test_pet_123', // TODO: 실제 펫 ID로 교체
      breed: _breed,
      color: _color,
      accessory: _accessory,
      style: _style,
      bg: _bg,
    );

    ref.read(stickerGeneratorProvider.notifier).generate(request);
  }

  @override
  Widget build(BuildContext context) {
    final stickerState = ref.watch(stickerGeneratorProvider);
    final quotaAsync = ref.watch(quotaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('스티커 생성기'),
        actions: [
          // 할당량 표시
          quotaAsync.when(
            data: (quota) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '${quota.remaining}/${quota.total}',
                  style: TextStyle(
                    color: quota.remaining > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const Icon(Icons.error, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 할당량 상세 정보
            quotaAsync.when(
              data: (quota) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '일일 생성 한도',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: quota.total > 0 ? quota.used / quota.total : 0.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(
                          quota.remaining > 5 ? Colors.green : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '사용: ${quota.used} / 남음: ${quota.remaining} / 전체: ${quota.total}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '리셋까지: ${_formatTimeUntilReset(quota.nextResetIn)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('할당량 조회 실패: $error'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 옵션 선택
            _buildOptionCard(
              '견종',
              TextField(
                decoration: const InputDecoration(labelText: '견종 입력'),
                onChanged: (value) => setState(() => _breed = value),
                controller: TextEditingController(text: _breed),
              ),
            ),

            _buildOptionCard(
              '색상',
              TextField(
                decoration: const InputDecoration(labelText: '색상 입력'),
                onChanged: (value) => setState(() => _color = value),
                controller: TextEditingController(text: _color),
              ),
            ),

            _buildOptionCard(
              '액세서리',
              DropdownButton<StickerAccessory>(
                value: _accessory,
                isExpanded: true,
                items: StickerAccessory.values.map((acc) {
                  return DropdownMenuItem(
                    value: acc,
                    child: Text(acc.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _accessory = value);
                },
              ),
            ),

            _buildOptionCard(
              '스타일',
              DropdownButton<StickerStyle>(
                value: _style,
                isExpanded: true,
                items: StickerStyle.values.map((style) {
                  return DropdownMenuItem(
                    value: style,
                    child: Text(style.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _style = value);
                },
              ),
            ),

            _buildOptionCard(
              '배경',
              DropdownButton<StickerBackground>(
                value: _bg,
                isExpanded: true,
                items: StickerBackground.values.map((bg) {
                  return DropdownMenuItem(
                    value: bg,
                    child: Text(bg.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _bg = value);
                },
              ),
            ),

            const SizedBox(height: 24),

            // 생성 버튼
            ElevatedButton(
              onPressed: stickerState.isLoading ? null : _generateSticker,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
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
                    const Icon(Icons.auto_awesome),
                  const SizedBox(width: 8),
                  Text(stickerState.isLoading ? '생성 중...' : '스티커 생성'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 결과 표시
            stickerState.when(
              data: (response) {
                if (response == null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text('스티커를 생성하려면 위 옵션을 설정하고\n"스티커 생성" 버튼을 누르세요.'),
                      ),
                    ),
                  );
                }

                final service = ref.read(imageGenerationServiceProvider);
                final imageBytes = service.decodeBase64Image(response.data.imageBase64);

                return Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              response.data.cached ? '✅ 캐시됨' : '🆕 새로 생성됨',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            _StickerImage(imageBytes: imageBytes),
                            const SizedBox(height: 16),
                            Text(
                              '크기: ${response.data.size.width}x${response.data.size.height}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Seed: ${response.data.seed}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (response.data.metadata != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                '${response.data.metadata!.breed} - ${response.data.metadata!.color}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('이미지 생성 중...'),
                        SizedBox(height: 8),
                        Text(
                          '평균 5-8초 소요됩니다',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              error: (error, _) {
                String message = '오류가 발생했습니다';
                if (error is ImageGenerationException) {
                  message = error.userMessage;
                }
                return Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  String _formatTimeUntilReset(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours시간 $minutes분';
    } else {
      return '$minutes분';
    }
  }
}

class _StickerImage extends StatelessWidget {
  final Uint8List imageBytes;

  const _StickerImage({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Image.memory(
        imageBytes,
        fit: BoxFit.contain,
      ),
    );
  }
}

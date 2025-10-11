// lib/presentation/screens/customize/customize_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/pet.dart';

class CustomizeScreen extends ConsumerStatefulWidget {
  const CustomizeScreen({super.key});

  @override
  ConsumerState<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends ConsumerState<CustomizeScreen> {
  PetAccessory _selectedAccessory = PetAccessory.none;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('커스터마이즈'),
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
                    '멍멍이',
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
              '액세서리',
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
                          _getAccessoryName(accessory),
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
                        'AI 스티커 생성',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI가 생성한 나만의 펫 스티커를 만들어보세요!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _generateSticker();
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('스티커 생성하기'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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

  String _getAccessoryName(PetAccessory accessory) {
    switch (accessory) {
      case PetAccessory.none:
        return '없음';
      case PetAccessory.bandana:
        return '반다나';
      case PetAccessory.glasses:
        return '안경';
      case PetAccessory.bowtie:
        return '나비넥타이';
      case PetAccessory.hat:
        return '모자';
      case PetAccessory.collar:
        return '목걸이';
    }
  }

  void _showApplyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('액세서리 적용'),
        content: Text('${_getAccessoryName(_selectedAccessory)}을(를) 적용하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_getAccessoryName(_selectedAccessory)}이(가) 적용되었습니다!'),
                ),
              );
            },
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _generateSticker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI 스티커 생성 기능은 곧 구현될 예정입니다! 🎨'),
      ),
    );
  }
}
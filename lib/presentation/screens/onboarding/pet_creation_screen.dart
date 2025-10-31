// lib/presentation/screens/onboarding/pet_creation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/pet.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/datasources/database_service.dart';
import '../home/home_screen.dart';

class PetCreationScreen extends ConsumerStatefulWidget {
  const PetCreationScreen({super.key});

  @override
  ConsumerState<PetCreationScreen> createState() => _PetCreationScreenState();
}

class _PetCreationScreenState extends ConsumerState<PetCreationScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedBreed = '골든 리트리버';
  String _selectedColor = '골든';
  PetPersonality _selectedPersonality = PetPersonality.cheerful;

  final List<String> _breeds = [
    '골든 리트리버',
    '래브라도',
    '시바견',
    '포메라니안',
    '허스키',
    '비글',
    '불독',
    '푸들',
  ];

  final List<String> _colors = [
    '골든',
    '브라운',
    '블랙',
    '화이트',
    '그레이',
    '크림',
  ];

  final Map<PetPersonality, String> _personalityNames = {
    PetPersonality.cheerful: '명랑한',
    PetPersonality.calm: '차분한',
    PetPersonality.energetic: '활발한',
    PetPersonality.shy: '수줍은',
    PetPersonality.playful: '장난기 많은',
  };

  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final now = DateTime.now();
      final pet = Pet(
        petId: const Uuid().v4(),
        name: _nameController.text.trim(),
        breed: _selectedBreed,
        color: _selectedColor,
        accessory: PetAccessory.none,
        happiness: 100, // 초기 행복도 100
        treats: 10, // 시작 간식 10개
        level: 1, // 초기 레벨 1
        experience: 0, // 초기 경험치 0
        stepsToday: 0,
        totalSteps: 0,
        lastUpdate: now,
        lastDecayDate: now, // 생성일에는 감소하지 않음
        personality: _selectedPersonality,
        isActive: true,
        createdAt: now,
        consecutiveDays: 0,
        bestStreak: 0,
        avgDailySteps: 0.0,
      );

      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.petModels.put(PetModel.fromDomain(pet));
      });

      if (!mounted) return;

      // 🐛 DEBUG: 펫 생성 완료, HomeScreen으로 전달할 Pet 정보
      debugPrint('🐛 PetCreationScreen - Created Pet: ${pet.name}, happiness: ${pet.happiness}, treats: ${pet.treats}');

      // 홈 화면으로 이동 (생성된 Pet 객체 전달)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(initialPet: pet),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('펫 생성 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('펫 만들기'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // 펫 미리보기 영역
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
                  // 임시 강아지 이모지 (추후 벡터 아바타로 교체)
                  const Text(
                    '🐕',
                    style: TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _nameController.text.isEmpty ? '이름 없음' : _nameController.text,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$_selectedColor $_selectedBreed',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 이름 입력
            Text(
              '이름',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '펫의 이름을 입력하세요',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '이름을 입력해주세요';
                }
                if (value.trim().length > 10) {
                  return '이름은 10자 이하로 입력해주세요';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 24),

            // 품종 선택
            Text(
              '품종',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedBreed,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _breeds.map((breed) {
                return DropdownMenuItem(
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBreed = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            // 색상 선택
            Text(
              '색상',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return ChoiceChip(
                  label: Text(color),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedColor = color;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 성격 선택
            Text(
              '성격',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PetPersonality.values.map((personality) {
                final isSelected = _selectedPersonality == personality;
                return ChoiceChip(
                  label: Text(_personalityNames[personality]!),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPersonality = personality;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // 생성 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _createPet,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: _isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        '펫 만들기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
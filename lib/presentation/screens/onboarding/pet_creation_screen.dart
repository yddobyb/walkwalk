// lib/presentation/screens/onboarding/pet_creation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../l10n/app_localizations.dart';
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

  String _selectedBreed = 'goldenRetriever'; // ARB key identifier
  String _selectedColor = 'golden'; // ARB key identifier
  PetPersonality _selectedPersonality = PetPersonality.cheerful;

  bool _isCreating = false;

  // 품종 매핑 (키 -> 표시 이름)
  Map<String, String> _getBreedMap(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return {
      'goldenRetriever': l10n.breedGoldenRetriever,
      'labrador': l10n.breedLabrador,
      'shiba': l10n.breedShiba,
      'pomeranian': l10n.breedPomeranian,
      'husky': l10n.breedHusky,
      'beagle': l10n.breedBeagle,
      'bulldog': l10n.breedBulldog,
      'poodle': l10n.breedPoodle,
    };
  }

  // 색상 매핑 (키 -> 표시 이름)
  Map<String, String> _getColorMap(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return {
      'golden': l10n.colorGolden,
      'brown': l10n.colorBrown,
      'black': l10n.colorBlack,
      'white': l10n.colorWhite,
      'gray': l10n.colorGray,
      'cream': l10n.colorCream,
    };
  }

  // 성격 매핑
  Map<PetPersonality, String> _getPersonalityMap(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return {
      PetPersonality.cheerful: l10n.personalityCheerful,
      PetPersonality.calm: l10n.personalityCalm,
      PetPersonality.energetic: l10n.personalityEnergetic,
      PetPersonality.shy: l10n.personalityShy,
      PetPersonality.playful: l10n.personalityPlayful,
    };
  }

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
      final breedMap = _getBreedMap(context);
      final colorMap = _getColorMap(context);

      final pet = Pet(
        petId: const Uuid().v4(),
        name: _nameController.text.trim(),
        breed: breedMap[_selectedBreed] ?? _selectedBreed,
        color: colorMap[_selectedColor] ?? _selectedColor,
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
          content: Text(AppLocalizations.of(context).petCreationError(e.toString())),
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
        title: Text(AppLocalizations.of(context).createPet),
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
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.1),
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
                    _nameController.text.isEmpty ? AppLocalizations.of(context).noName : _nameController.text,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final colorMap = _getColorMap(context);
                      final breedMap = _getBreedMap(context);
                      final colorName = colorMap[_selectedColor] ?? '';
                      final breedName = breedMap[_selectedBreed] ?? '';
                      return Text(
                        '$colorName $breedName',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 이름 입력
            Text(
              AppLocalizations.of(context).petName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).petNameHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context).petNameError;
                }
                if (value.trim().length > 10) {
                  return AppLocalizations.of(context).petNameLengthError;
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
              AppLocalizations.of(context).petBreed,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final breedMap = _getBreedMap(context);
                return DropdownButtonFormField<String>(
                  value: _selectedBreed,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: breedMap.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedBreed = value;
                      });
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // 색상 선택
            Text(
              AppLocalizations.of(context).petColor,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final colorMap = _getColorMap(context);
                return Wrap(
                  spacing: 8,
                  children: colorMap.entries.map((entry) {
                    final isSelected = _selectedColor == entry.key;
                    return ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedColor = entry.key;
                          });
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),

            // 성격 선택
            Text(
              AppLocalizations.of(context).petPersonality,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final personalityMap = _getPersonalityMap(context);
                return Wrap(
                  spacing: 8,
                  children: personalityMap.entries.map((entry) {
                    final isSelected = _selectedPersonality == entry.key;
                    return ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedPersonality = entry.key;
                          });
                        }
                      },
                    );
                  }).toList(),
                );
              },
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
                    : Text(
                        AppLocalizations.of(context).createPet,
                        style: const TextStyle(
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
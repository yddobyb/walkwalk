// lib/domain/entities/pet.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@freezed
class Pet with _$Pet {
  const factory Pet({
    required String petId,
    required String name,
    required String breed,
    required String color,
    required PetAccessory accessory,
    required int happiness,
    required int treats,
    required int level,
    required int experience,
    required int stepsToday,
    required int totalSteps,
    required DateTime lastUpdate,
    DateTime? lastDecayDate, // 마지막 행복도 감소 적용 날짜
    String? stickerPath,
    String? stickerUrl,
    DateTime? stickerGeneratedAt,
    required PetPersonality personality,
    required bool isActive,
    required DateTime createdAt,
    required int consecutiveDays,
    required int bestStreak,
    required double avgDailySteps,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

enum PetAccessory {
  none,
  bandana,
  glasses,
  bowtie,
  hat,
  collar,
}

enum PetPersonality {
  cheerful,   // 명랑한
  calm,       // 차분한
  energetic,  // 활발한
  shy,        // 수줍은
  playful,    // 장난기 많은
}
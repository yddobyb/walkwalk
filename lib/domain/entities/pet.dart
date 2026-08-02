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

/// 착용 액세서리.
///
/// ⚠️ **새 값은 반드시 맨 뒤에만 추가할 것.** Isar가 enum을 *인덱스*로
/// 저장하기 때문에, 중간에 끼워넣거나 순서를 바꾸거나 지우면 이미 저장된
/// 펫의 액세서리가 조용히 다른 것으로 바뀐다.
/// 이름은 서버 `ALLOWED_ACCESSORIES`와 정확히 일치해야 한다 — 다르면
/// 서버가 거부하지 않고 `none`으로 대체해서, 골라도 반영이 안 된다.
enum PetAccessory {
  none,
  bandana,
  glasses,
  bowtie,
  hat,
  collar,
  // Phase 29-2 추가
  scarf,
  crown,
  cap,
  flowerCrown,
  backpack,
  headphones,
  necktie,
  medal,
}

enum PetPersonality {
  cheerful,   // 명랑한
  calm,       // 차분한
  energetic,  // 활발한
  shy,        // 수줍은
  playful,    // 장난기 많은
}
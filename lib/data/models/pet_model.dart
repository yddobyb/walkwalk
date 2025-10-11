// lib/data/models/pet_model.dart
import 'package:isar/isar.dart';
import '../../domain/entities/pet.dart';

part 'pet_model.g.dart';

@collection
class PetModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String petId; // UUID

  late String name;
  late String breed;
  late String color;

  @Enumerated(EnumType.name)
  late PetAccessory accessory;

  late int happiness; // 0-100
  late int treats; // 보유 간식 수
  late int level; // 펫 레벨
  int experience = 0; // 경험치 (기존 펫 호환을 위한 기본값)
  late int stepsToday;
  late int totalSteps;
  late DateTime lastUpdate;

  // 이미지 경로
  String? stickerPath; // 생성된 스티커 로컬 경로
  String? stickerUrl; // 클라우드 URL (캐시용)
  DateTime? stickerGeneratedAt;

  // 성격 설정 (AI 대화용)
  @Enumerated(EnumType.name)
  late PetPersonality personality;

  // 상태
  late bool isActive;
  late DateTime createdAt;

  // 통계
  late int consecutiveDays; // 연속 산책 일수
  late int bestStreak; // 최고 연속 기록
  late double avgDailySteps; // 일평균 걸음수

  // 도메인 엔티티로 변환
  Pet toDomain() {
    return Pet(
      petId: petId,
      name: name,
      breed: breed,
      color: color,
      accessory: accessory,
      happiness: happiness,
      treats: treats,
      level: level,
      experience: experience,
      stepsToday: stepsToday,
      totalSteps: totalSteps,
      lastUpdate: lastUpdate,
      stickerPath: stickerPath,
      stickerUrl: stickerUrl,
      stickerGeneratedAt: stickerGeneratedAt,
      personality: personality,
      isActive: isActive,
      createdAt: createdAt,
      consecutiveDays: consecutiveDays,
      bestStreak: bestStreak,
      avgDailySteps: avgDailySteps,
    );
  }

  // 도메인 엔티티에서 생성
  static PetModel fromDomain(Pet pet) {
    return PetModel()
      ..petId = pet.petId
      ..name = pet.name
      ..breed = pet.breed
      ..color = pet.color
      ..accessory = pet.accessory
      ..happiness = pet.happiness
      ..treats = pet.treats
      ..level = pet.level
      ..experience = pet.experience
      ..stepsToday = pet.stepsToday
      ..totalSteps = pet.totalSteps
      ..lastUpdate = pet.lastUpdate
      ..stickerPath = pet.stickerPath
      ..stickerUrl = pet.stickerUrl
      ..stickerGeneratedAt = pet.stickerGeneratedAt
      ..personality = pet.personality
      ..isActive = pet.isActive
      ..createdAt = pet.createdAt
      ..consecutiveDays = pet.consecutiveDays
      ..bestStreak = pet.bestStreak
      ..avgDailySteps = pet.avgDailySteps;
  }
}
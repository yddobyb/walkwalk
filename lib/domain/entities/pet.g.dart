// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
      petId: json['petId'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      color: json['color'] as String,
      accessory: $enumDecode(_$PetAccessoryEnumMap, json['accessory']),
      happiness: (json['happiness'] as num).toInt(),
      treats: (json['treats'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      stepsToday: (json['stepsToday'] as num).toInt(),
      totalSteps: (json['totalSteps'] as num).toInt(),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      lastDecayDate: json['lastDecayDate'] == null
          ? null
          : DateTime.parse(json['lastDecayDate'] as String),
      stickerPath: json['stickerPath'] as String?,
      stickerUrl: json['stickerUrl'] as String?,
      stickerGeneratedAt: json['stickerGeneratedAt'] == null
          ? null
          : DateTime.parse(json['stickerGeneratedAt'] as String),
      personality: $enumDecode(_$PetPersonalityEnumMap, json['personality']),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      consecutiveDays: (json['consecutiveDays'] as num).toInt(),
      bestStreak: (json['bestStreak'] as num).toInt(),
      avgDailySteps: (json['avgDailySteps'] as num).toDouble(),
    );

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
      'petId': instance.petId,
      'name': instance.name,
      'breed': instance.breed,
      'color': instance.color,
      'accessory': _$PetAccessoryEnumMap[instance.accessory]!,
      'happiness': instance.happiness,
      'treats': instance.treats,
      'level': instance.level,
      'experience': instance.experience,
      'stepsToday': instance.stepsToday,
      'totalSteps': instance.totalSteps,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
      'lastDecayDate': instance.lastDecayDate?.toIso8601String(),
      'stickerPath': instance.stickerPath,
      'stickerUrl': instance.stickerUrl,
      'stickerGeneratedAt': instance.stickerGeneratedAt?.toIso8601String(),
      'personality': _$PetPersonalityEnumMap[instance.personality]!,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'consecutiveDays': instance.consecutiveDays,
      'bestStreak': instance.bestStreak,
      'avgDailySteps': instance.avgDailySteps,
    };

const _$PetAccessoryEnumMap = {
  PetAccessory.none: 'none',
  PetAccessory.bandana: 'bandana',
  PetAccessory.glasses: 'glasses',
  PetAccessory.bowtie: 'bowtie',
  PetAccessory.hat: 'hat',
  PetAccessory.collar: 'collar',
  PetAccessory.scarf: 'scarf',
  PetAccessory.crown: 'crown',
  PetAccessory.cap: 'cap',
  PetAccessory.flowerCrown: 'flowerCrown',
  PetAccessory.backpack: 'backpack',
  PetAccessory.headphones: 'headphones',
  PetAccessory.necktie: 'necktie',
  PetAccessory.medal: 'medal',
};

const _$PetPersonalityEnumMap = {
  PetPersonality.cheerful: 'cheerful',
  PetPersonality.calm: 'calm',
  PetPersonality.energetic: 'energetic',
  PetPersonality.shy: 'shy',
  PetPersonality.playful: 'playful',
};

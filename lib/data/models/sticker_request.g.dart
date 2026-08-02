// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StickerRequestImpl _$$StickerRequestImplFromJson(Map<String, dynamic> json) =>
    _$StickerRequestImpl(
      petId: json['petId'] as String,
      breed: json['breed'] as String? ?? "Shiba Inu",
      color: json['color'] as String? ?? "orange",
      accessory:
          $enumDecodeNullable(_$StickerAccessoryEnumMap, json['accessory']) ??
              StickerAccessory.none,
      style: $enumDecodeNullable(_$StickerStyleEnumMap, json['style']) ??
          StickerStyle.stickerFlat,
      size: (json['size'] as num?)?.toInt() ?? 512,
      bg: $enumDecodeNullable(_$StickerBackgroundEnumMap, json['bg']) ??
          StickerBackground.transparent,
      seed: (json['seed'] as num?)?.toInt(),
      force: json['force'] as bool? ?? false,
    );

Map<String, dynamic> _$$StickerRequestImplToJson(
        _$StickerRequestImpl instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'breed': instance.breed,
      'color': instance.color,
      'accessory': _$StickerAccessoryEnumMap[instance.accessory]!,
      'style': _$StickerStyleEnumMap[instance.style]!,
      'size': instance.size,
      'bg': _$StickerBackgroundEnumMap[instance.bg]!,
      'seed': instance.seed,
      'force': instance.force,
    };

const _$StickerAccessoryEnumMap = {
  StickerAccessory.none: 'none',
  StickerAccessory.bandana: 'bandana',
  StickerAccessory.glasses: 'glasses',
  StickerAccessory.bowtie: 'bowtie',
  StickerAccessory.hat: 'hat',
  StickerAccessory.collar: 'collar',
  StickerAccessory.scarf: 'scarf',
  StickerAccessory.crown: 'crown',
  StickerAccessory.cap: 'cap',
  StickerAccessory.flowerCrown: 'flowerCrown',
  StickerAccessory.backpack: 'backpack',
  StickerAccessory.headphones: 'headphones',
  StickerAccessory.necktie: 'necktie',
  StickerAccessory.medal: 'medal',
};

const _$StickerStyleEnumMap = {
  StickerStyle.stickerFlat: 'sticker-flat',
  StickerStyle.sticker3d: 'sticker-3d',
  StickerStyle.realistic: 'realistic',
  StickerStyle.watercolor: 'watercolor',
  StickerStyle.pixelArt: 'pixel-art',
  StickerStyle.lineArt: 'line-art',
};

const _$StickerBackgroundEnumMap = {
  StickerBackground.transparent: 'transparent',
  StickerBackground.white: 'white',
  StickerBackground.gradient: 'gradient',
  StickerBackground.park: 'park',
  StickerBackground.beach: 'beach',
  StickerBackground.night: 'night',
  StickerBackground.snow: 'snow',
  StickerBackground.pastel: 'pastel',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StickerResponseImpl _$$StickerResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$StickerResponseImpl(
      success: json['success'] as bool,
      data: StickerData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StickerResponseImplToJson(
        _$StickerResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

_$StickerDataImpl _$$StickerDataImplFromJson(Map<String, dynamic> json) =>
    _$StickerDataImpl(
      imageBase64: json['image_base64'] as String,
      mime: json['mime'] as String? ?? "image/webp",
      seed: (json['seed'] as num).toInt(),
      cached: json['cached'] as bool? ?? false,
      size: StickerSize.fromJson(json['size'] as Map<String, dynamic>),
      metadata: json['metadata'] == null
          ? null
          : StickerMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StickerDataImplToJson(_$StickerDataImpl instance) =>
    <String, dynamic>{
      'image_base64': instance.imageBase64,
      'mime': instance.mime,
      'seed': instance.seed,
      'cached': instance.cached,
      'size': instance.size,
      'metadata': instance.metadata,
    };

_$StickerSizeImpl _$$StickerSizeImplFromJson(Map<String, dynamic> json) =>
    _$StickerSizeImpl(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$$StickerSizeImplToJson(_$StickerSizeImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };

_$StickerMetadataImpl _$$StickerMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$StickerMetadataImpl(
      breed: json['breed'] as String,
      color: json['color'] as String,
      accessory: json['accessory'] as String,
      style: json['style'] as String,
    );

Map<String, dynamic> _$$StickerMetadataImplToJson(
        _$StickerMetadataImpl instance) =>
    <String, dynamic>{
      'breed': instance.breed,
      'color': instance.color,
      'accessory': instance.accessory,
      'style': instance.style,
    };

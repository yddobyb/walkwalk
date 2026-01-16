// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotaResponseImpl _$$QuotaResponseImplFromJson(Map<String, dynamic> json) =>
    _$QuotaResponseImpl(
      success: json['success'] as bool,
      data: QuotaData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QuotaResponseImplToJson(_$QuotaResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

_$QuotaDataImpl _$$QuotaDataImplFromJson(Map<String, dynamic> json) =>
    _$QuotaDataImpl(
      remaining: (json['remaining'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      used: (json['used'] as num).toInt(),
      resetAt: json['resetAt'] as String,
      nextResetIn: (json['nextResetIn'] as num).toInt(),
    );

Map<String, dynamic> _$$QuotaDataImplToJson(_$QuotaDataImpl instance) =>
    <String, dynamic>{
      'remaining': instance.remaining,
      'total': instance.total,
      'used': instance.used,
      'resetAt': instance.resetAt,
      'nextResetIn': instance.nextResetIn,
    };

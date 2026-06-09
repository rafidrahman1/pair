// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PairCodeModel _$PairCodeModelFromJson(Map<String, dynamic> json) =>
    _PairCodeModel(
      code: json['code'] as String,
      ownerId: json['ownerId'] as String,
      expiresAt: const TimestampConverter().fromJson(json['expiresAt']),
      used: json['used'] as bool? ?? false,
    );

Map<String, dynamic> _$PairCodeModelToJson(_PairCodeModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'ownerId': instance.ownerId,
      'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
      'used': instance.used,
    };

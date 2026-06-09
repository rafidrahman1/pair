// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PairModel _$PairModelFromJson(Map<String, dynamic> json) => _PairModel(
  id: json['id'] as String,
  memberIds: (json['memberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$PairModelToJson(_PairModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberIds': instance.memberIds,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

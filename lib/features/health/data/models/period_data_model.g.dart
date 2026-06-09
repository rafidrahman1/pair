// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PeriodDataModel _$PeriodDataModelFromJson(Map<String, dynamic> json) =>
    _PeriodDataModel(
      uid: json['uid'] as String,
      isOnPeriod: json['isOnPeriod'] as bool,
      lastPeriodStart: const TimestampConverter().fromJson(
        json['lastPeriodStart'],
      ),
      currentFlow: json['currentFlow'] as String?,
      lastFlowDate: const TimestampConverter().fromJson(json['lastFlowDate']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$PeriodDataModelToJson(_PeriodDataModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'isOnPeriod': instance.isOnPeriod,
      'lastPeriodStart': _$JsonConverterToJson<Object?, DateTime>(
        instance.lastPeriodStart,
        const TimestampConverter().toJson,
      ),
      'currentFlow': instance.currentFlow,
      'lastFlowDate': _$JsonConverterToJson<Object?, DateTime>(
        instance.lastFlowDate,
        const TimestampConverter().toJson,
      ),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

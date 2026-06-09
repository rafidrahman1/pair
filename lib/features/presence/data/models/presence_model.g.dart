// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresenceModel _$PresenceModelFromJson(Map<String, dynamic> json) =>
    _PresenceModel(
      uid: json['uid'] as String,
      online: json['online'] as bool,
      lastSeen: const TimestampConverter().fromJson(json['lastSeen']),
    );

Map<String, dynamic> _$PresenceModelToJson(_PresenceModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'online': instance.online,
      'lastSeen': const TimestampConverter().toJson(instance.lastSeen),
    };

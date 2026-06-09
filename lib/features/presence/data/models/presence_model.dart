import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/presence/domain/entities/presence_entity.dart';

part 'presence_model.freezed.dart';
part 'presence_model.g.dart';

@freezed
abstract class PresenceModel with _$PresenceModel {
  const PresenceModel._();

  const factory PresenceModel({
    required String uid,
    required bool online,
    @TimestampConverter() required DateTime lastSeen,
  }) = _PresenceModel;

  factory PresenceModel.fromJson(Map<String, dynamic> json) =>
      _$PresenceModelFromJson(json);

  factory PresenceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PresenceModel.fromJson({...data, 'uid': doc.id});
  }

  PresenceEntity toEntity() => PresenceEntity(
        uid: uid,
        online: online,
        lastSeen: lastSeen,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    return json;
  }
}

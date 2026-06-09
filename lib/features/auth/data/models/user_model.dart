import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String displayName,
    required String email,
    @Default('') String photoUrl,
    @UserRoleConverter() UserRole? role,
    String? pairId,
    String? fcmToken,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel.fromJson({...data, 'uid': doc.id});
  }

  UserEntity toEntity() => UserEntity(
        uid: uid,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
        role: role,
        pairId: pairId,
        fcmToken: fcmToken,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    return json;
  }
}

class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  Object toJson(DateTime object) => Timestamp.fromDate(object);
}

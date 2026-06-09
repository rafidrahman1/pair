import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  husband,
  wife;

  String get label => switch (this) {
        UserRole.husband => 'Husband',
        UserRole.wife => 'Wife',
      };

  static UserRole? fromString(String? value) {
    if (value == null) return null;
    for (final role in UserRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }
}

class UserRoleConverter implements JsonConverter<UserRole?, Object?> {
  const UserRoleConverter();

  @override
  UserRole? fromJson(Object? json) {
    if (json is String) {
      return UserRole.fromString(json);
    }
    return null;
  }

  @override
  Object? toJson(UserRole? role) => role?.name;
}

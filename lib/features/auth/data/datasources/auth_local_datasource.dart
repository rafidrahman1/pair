import 'dart:convert';

import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({SharedPreferences? preferences})
      : _preferences = preferences;

  static const _cachedUserKey = 'cached_user';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<UserEntity?> getCachedUser() async {
    final json = (await _prefs).getString(_cachedUserKey);
    if (json == null) return null;

    try {
      return _userFromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      await clearCachedUser();
      return null;
    }
  }

  Future<void> cacheUser(UserEntity user) async {
    await (await _prefs).setString(_cachedUserKey, jsonEncode(_userToJson(user)));
  }

  Future<void> clearCachedUser() async {
    await (await _prefs).remove(_cachedUserKey);
  }

  Map<String, dynamic> _userToJson(UserEntity user) => {
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        'role': user.role?.name,
        'pairId': user.pairId,
        'fcmToken': user.fcmToken,
        'createdAt': user.createdAt.toIso8601String(),
        'updatedAt': user.updatedAt.toIso8601String(),
      };

  UserEntity _userFromJson(Map<String, dynamic> json) => UserEntity(
        uid: json['uid'] as String,
        displayName: json['displayName'] as String,
        email: json['email'] as String,
        photoUrl: json['photoUrl'] as String? ?? '',
        role: UserRole.fromString(json['role'] as String?),
        pairId: json['pairId'] as String?,
        fcmToken: json['fcmToken'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

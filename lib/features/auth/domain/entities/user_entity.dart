import 'package:equatable/equatable.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    this.role,
    this.pairId,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final UserRole? role;
  final String? pairId;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPaired => pairId != null && pairId!.isNotEmpty;

  bool get hasRole => role != null;

  UserEntity copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    UserRole? role,
    String? pairId,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      pairId: pairId ?? this.pairId,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoUrl,
        role,
        pairId,
        fcmToken,
        createdAt,
        updatedAt,
      ];
}

import 'package:pair/core/result/result.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';

abstract class AuthRepository {
  Stream<UserEntity?> watchAuthState();

  Future<Result<UserEntity>> signInWithGoogle({required UserRole role});

  Future<Result<void>> signOut();

  Future<Result<UserEntity>> getCurrentUser();

  Future<Result<UserEntity>> syncUserProfile();

  Future<Result<void>> updateFcmToken(String token);
}

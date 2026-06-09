import 'package:pair/core/result/result.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> watchAuthState();

  Future<Result<UserEntity>> signInWithGoogle();

  Future<Result<void>> signOut();

  Future<Result<UserEntity>> getCurrentUser();

  Future<Result<UserEntity>> syncUserProfile();

  Future<Result<void>> updateFcmToken(String token);
}

import 'package:pair/core/result/result.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({required UserRole role}) =>
      _repository.signInWithGoogle(role: role);
}

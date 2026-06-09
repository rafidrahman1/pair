import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pair/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';
import 'package:pair/features/auth/domain/usecases/get_current_user.dart';
import 'package:pair/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:pair/features/auth/domain/usecases/sign_out.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.watch(authRepositoryProvider));
});

final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

final currentUserStreamProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).watchAuthState();
});

class AuthController extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final result = await ref.read(getCurrentUserProvider)();
    return result.fold((_) => null, (user) => user);
  }

  Future<void> signInWithGoogle({required UserRole role}) async {
    state = const AsyncLoading();
    final result = await ref.read(signInWithGoogleProvider)(role: role);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) {
        ref.invalidate(currentUserStreamProvider);
        return AsyncData(user);
      },
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(signOutProvider)();
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserEntity?>(AuthController.new);

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Stream<UserEntity?> watchAuthState() {
    return _dataSource.authStateChanges().asyncMap(_mapFirebaseUser);
  }

  Future<UserEntity?> _mapFirebaseUser(User? firebaseUser) async {
    if (firebaseUser == null) return null;
    try {
      final userDoc = await _dataSource.getUserDocument(firebaseUser.uid);
      if (userDoc != null) {
        return userDoc.toEntity();
      }
      final synced = await _dataSource.syncUserProfile();
      return synced.toEntity();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired' || e.code == 'invalid-credential') {
        await _dataSource.signOut();
      }
      return null;
    } catch (_) {
      try {
        final synced = await _dataSource.syncUserProfile();
        return synced.toEntity();
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle({required UserRole role}) async {
    try {
      final user = await _dataSource.signInWithGoogle(role: role);
      return success(user.toEntity());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'sign-in-cancelled') {
        return failure(AuthFailure('Sign in cancelled'));
      }
      return failure(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return failure(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _dataSource.signOut();
      return success(null);
    } on FirebaseAuthException catch (e) {
      return failure(AuthFailure(e.message ?? 'Sign out failed'));
    } catch (e) {
      return failure(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final firebaseUser = _dataSource.currentFirebaseUser;
      if (firebaseUser == null) {
        return failure(const AuthFailure('Not authenticated'));
      }
      final userDoc = await _dataSource.getUserDocument(firebaseUser.uid);
      if (userDoc == null) {
        final synced = await _dataSource.syncUserProfile();
        return success(synced.toEntity());
      }
      return success(userDoc.toEntity());
    } on FirebaseAuthException catch (e) {
      return failure(AuthFailure(e.message ?? 'Failed to get current user'));
    } catch (e) {
      return failure(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> syncUserProfile() async {
    try {
      final user = await _dataSource.syncUserProfile();
      return success(user.toEntity());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        await _dataSource.signOut();
        return failure(const AuthFailure('Session expired. Please sign in again.'));
      }
      return failure(AuthFailure(e.message ?? 'Profile sync failed'));
    } catch (e) {
      return failure(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateFcmToken(String token) async {
    try {
      final firebaseUser = _dataSource.currentFirebaseUser;
      if (firebaseUser == null) {
        return failure(const AuthFailure('Not authenticated'));
      }
      await _dataSource.updateFcmToken(firebaseUser.uid, token);
      return success(null);
    } catch (e) {
      return failure(NotificationFailure(e.toString()));
    }
  }
}

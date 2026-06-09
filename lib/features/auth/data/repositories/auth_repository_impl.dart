import 'package:firebase_auth/firebase_auth.dart';
import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:pair/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._dataSource,
    this._localDataSource,
  );

  final AuthRemoteDataSource _dataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Stream<UserEntity?> watchAuthState() async* {
    final cached = await _localDataSource.getCachedUser();
    if (cached != null) {
      yield cached;
    }

    yield* _dataSource.authStateChanges().asyncMap(_mapFirebaseUser);
  }

  Future<UserEntity?> _mapFirebaseUser(User? firebaseUser) async {
    if (firebaseUser == null) {
      await _localDataSource.clearCachedUser();
      return null;
    }

    try {
      final userDoc = await _dataSource.getUserDocument(firebaseUser.uid);
      if (userDoc != null) {
        final entity = userDoc.toEntity();
        await _localDataSource.cacheUser(entity);
        return entity;
      }
      final synced = await _dataSource.syncUserProfile();
      final entity = synced.toEntity();
      await _localDataSource.cacheUser(entity);
      return entity;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired' || e.code == 'invalid-credential') {
        await _localDataSource.clearCachedUser();
        await _dataSource.signOut();
        return null;
      }
      return _cachedUserFor(firebaseUser.uid);
    } catch (_) {
      try {
        final synced = await _dataSource.syncUserProfile();
        final entity = synced.toEntity();
        await _localDataSource.cacheUser(entity);
        return entity;
      } catch (_) {
        return _cachedUserFor(firebaseUser.uid);
      }
    }
  }

  Future<UserEntity?> _cachedUserFor(String uid) async {
    final cached = await _localDataSource.getCachedUser();
    if (cached != null && cached.uid == uid) {
      return cached;
    }
    return null;
  }

  Future<UserEntity?> _resolveCurrentUser() async {
    final firebaseUser = _dataSource.currentFirebaseUser;
    if (firebaseUser == null) {
      await _localDataSource.clearCachedUser();
      return null;
    }
    return _mapFirebaseUser(firebaseUser);
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle({required UserRole role}) async {
    try {
      final user = await _dataSource.signInWithGoogle(role: role);
      final entity = user.toEntity();
      await _localDataSource.cacheUser(entity);
      return success(entity);
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
      await _localDataSource.clearCachedUser();
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
      final user = await _resolveCurrentUser();
      if (user == null) {
        return failure(const AuthFailure('Not authenticated'));
      }
      return success(user);
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
      final entity = user.toEntity();
      await _localDataSource.cacheUser(entity);
      return success(entity);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        await _localDataSource.clearCachedUser();
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
      final cached = await _localDataSource.getCachedUser();
      if (cached != null && cached.uid == firebaseUser.uid) {
        await _localDataSource.cacheUser(cached.copyWith(fcmToken: token));
      }
      return success(null);
    } catch (e) {
      return failure(NotificationFailure(e.toString()));
    }
  }
}

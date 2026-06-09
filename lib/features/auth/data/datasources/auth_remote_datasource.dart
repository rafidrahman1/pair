import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Future<UserModel> signInWithGoogle({required UserRole role}) async {
    await _googleSignIn.signOut();

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign in was cancelled',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Firebase user is null after sign in',
      );
    }

    return _syncUserDocument(firebaseUser, role: role);
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<UserModel> syncUserProfile() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No authenticated user',
      );
    }

    await firebaseUser.reload();
    final refreshedUser = _firebaseAuth.currentUser!;
    return _syncUserDocument(refreshedUser, role: null);
  }

  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> updateFcmToken(String uid, String token) async {
    await _firestore.collection(AppConstants.usersCollection).doc(uid).update({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel> _syncUserDocument(
    User firebaseUser, {
    required UserRole? role,
  }) async {
    final docRef =
        _firestore.collection(AppConstants.usersCollection).doc(firebaseUser.uid);
    final doc = await docRef.get();
    final now = DateTime.now();

    if (doc.exists) {
      final existing = UserModel.fromFirestore(doc);
      final updated = existing.copyWith(
        displayName: firebaseUser.displayName ?? existing.displayName,
        email: firebaseUser.email ?? existing.email,
        photoUrl: firebaseUser.photoURL ?? existing.photoUrl,
        role: existing.role ?? role,
        updatedAt: now,
      );
      await docRef.update(updated.toFirestore());
      return updated;
    }

    final newUser = UserModel(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      role: role,
      createdAt: now,
      updatedAt: now,
    );
    await docRef.set(newUser.toFirestore());
    return newUser;
  }
}

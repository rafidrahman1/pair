import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/pairing/data/models/pair_code_model.dart';
import 'package:pair/features/pairing/data/models/pair_model.dart';

class PairingRemoteDataSource {
  PairingRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;
  final _random = Random.secure();

  Future<PairCodeModel> generatePairCode(String ownerId) async {
    final userDoc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(ownerId)
        .get();

    if (!userDoc.exists) {
      throw StateError('User not found');
    }

    final userData = userDoc.data()!;
    if (userData['pairId'] != null) {
      throw StateError('User is already paired');
    }

    final code = _generateUniqueCode();
    final expiresAt =
        DateTime.now().add(AppConstants.pairCodeExpiration);

    final pairCode = PairCodeModel(
      code: code,
      ownerId: ownerId,
      expiresAt: expiresAt,
    );

    await _firestore
        .collection(AppConstants.pairCodesCollection)
        .doc(code)
        .set(pairCode.toFirestore());

    return pairCode;
  }

  Stream<PairCodeModel?> watchPairCode(String code) {
    return _firestore
        .collection(AppConstants.pairCodesCollection)
        .doc(code.toUpperCase())
        .snapshots()
        .map((doc) => doc.exists ? PairCodeModel.fromFirestore(doc) : null);
  }

  Future<PairModel> joinWithCode({
    required String code,
    required String joinerId,
  }) async {
    final normalizedCode = code.toUpperCase().trim();
    final pairId = _firestore.collection(AppConstants.pairsCollection).doc().id;

    late final String ownerId;
    late final PairModel pair;

    await _firestore.runTransaction((transaction) async {
      final codeRef = _firestore
          .collection(AppConstants.pairCodesCollection)
          .doc(normalizedCode);
      final codeDoc = await transaction.get(codeRef);

      if (!codeDoc.exists) {
        throw StateError('Invalid pairing code');
      }

      final pairCode = PairCodeModel.fromFirestore(codeDoc);
      if (pairCode.used) {
        throw StateError('This code has already been used');
      }
      if (DateTime.now().isAfter(pairCode.expiresAt)) {
        throw StateError('This code has expired');
      }
      if (pairCode.ownerId == joinerId) {
        throw StateError('You cannot pair with yourself');
      }

      ownerId = pairCode.ownerId;

      final ownerRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(ownerId);
      final joinerRef =
          _firestore.collection(AppConstants.usersCollection).doc(joinerId);

      final ownerDoc = await transaction.get(ownerRef);
      final joinerDoc = await transaction.get(joinerRef);

      if (!ownerDoc.exists || !joinerDoc.exists) {
        throw StateError('User not found');
      }

      if (ownerDoc.data()?['pairId'] != null) {
        throw StateError('Code owner is already paired');
      }
      if (joinerDoc.data()?['pairId'] != null) {
        throw StateError('You are already paired');
      }

      final pairRef =
          _firestore.collection(AppConstants.pairsCollection).doc(pairId);
      pair = PairModel(
        id: pairId,
        memberIds: [ownerId, joinerId],
        createdAt: DateTime.now(),
      );

      transaction.set(pairRef, pair.toFirestore());
      transaction.update(joinerRef, {
        'pairId': pairId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.update(codeRef, {'used': true});
    });

    // Link the code owner after the pair document exists. Firestore security
    // rules cannot read a document that is being created in the same request.
    await _firestore.collection(AppConstants.usersCollection).doc(ownerId).update({
      'pairId': pairId,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return pair;
  }

  Future<PairModel?> getPair(String pairId) async {
    final doc = await _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .get();
    if (!doc.exists) return null;
    return PairModel.fromFirestore(doc);
  }

  Stream<PairModel?> watchPair(String pairId) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .snapshots()
        .map((doc) => doc.exists ? PairModel.fromFirestore(doc) : null);
  }

  String _generateUniqueCode() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const digits = '0123456789';

    String randomPart(String chars, int length) {
      return List.generate(
        length,
        (_) => chars[_random.nextInt(chars.length)],
      ).join();
    }

    return '${randomPart(letters, 4)}-${randomPart(digits, 4)}';
  }
}

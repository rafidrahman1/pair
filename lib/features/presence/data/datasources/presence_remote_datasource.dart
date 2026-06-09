import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/presence/data/models/presence_model.dart';

class PresenceRemoteDataSource {
  PresenceRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _presenceRef(
    String pairId,
    String uid,
  ) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.presenceSubcollection)
        .doc(uid);
  }

  Future<void> setOnline({
    required String pairId,
    required String uid,
  }) async {
    await _presenceRef(pairId, uid).set({
      'uid': uid,
      'online': true,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setOffline({
    required String pairId,
    required String uid,
  }) async {
    await _presenceRef(pairId, uid).set({
      'uid': uid,
      'online': false,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Stream<PresenceModel?> watchPresence({
    required String pairId,
    required String uid,
  }) {
    return _presenceRef(pairId, uid).snapshots().map(
          (doc) => doc.exists ? PresenceModel.fromFirestore(doc) : null,
        );
  }
}

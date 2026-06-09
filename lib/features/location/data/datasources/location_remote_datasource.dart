import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/location/data/models/location_model.dart';

class LocationRemoteDataSource {
  LocationRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> updateLocation({
    required String pairId,
    required LocationModel location,
  }) async {
    await _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.locationsSubcollection)
        .doc(location.uid)
        .set(location.toFirestore(), SetOptions(merge: true));
  }

  Stream<LocationModel?> watchLocation({
    required String pairId,
    required String uid,
  }) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.locationsSubcollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? LocationModel.fromFirestore(doc) : null);
  }
}

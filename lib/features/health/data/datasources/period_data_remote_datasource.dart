import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/health/data/models/period_data_model.dart';

class PeriodDataRemoteDataSource {
  PeriodDataRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> updatePeriodData({
    required String pairId,
    required PeriodDataModel data,
  }) async {
    await _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.periodDataSubcollection)
        .doc(data.uid)
        .set(data.toFirestore(), SetOptions(merge: true));
  }

  Stream<PeriodDataModel?> watchPeriodData({
    required String pairId,
    required String uid,
  }) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.periodDataSubcollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? PeriodDataModel.fromFirestore(doc) : null);
  }
}

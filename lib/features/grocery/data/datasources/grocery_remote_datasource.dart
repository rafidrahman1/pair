import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/grocery/data/models/grocery_item_model.dart';

class GroceryRemoteDataSource {
  GroceryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _itemsRef(String pairId) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.groceryItemsSubcollection);
  }

  Stream<List<GroceryItemModel>> watchItems({required String pairId}) {
    return _itemsRef(pairId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(GroceryItemModel.fromFirestore)
              .toList(),
        );
  }

  Stream<int> watchUncheckedCount({required String pairId}) {
    return _itemsRef(pairId)
        .where('isChecked', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<GroceryItemModel> addItem({
    required String pairId,
    required String itemId,
    required String addedBy,
    required String text,
  }) async {
    final now = DateTime.now();
    final item = GroceryItemModel(
      id: itemId,
      text: text.trim(),
      addedBy: addedBy,
      createdAt: now,
      updatedAt: now,
    );

    await _itemsRef(pairId).doc(itemId).set(item.toFirestore());
    return item;
  }

  Future<GroceryItemModel> toggleItem({
    required String pairId,
    required String itemId,
    required String userId,
    required bool isChecked,
  }) async {
    final ref = _itemsRef(pairId).doc(itemId);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw StateError('Grocery item not found');
    }

    final now = DateTime.now();
    final updates = <String, dynamic>{
      'isChecked': isChecked,
      'checkedBy': isChecked ? userId : null,
      'updatedAt': Timestamp.fromDate(now),
    };

    await ref.update(updates);

    final current = GroceryItemModel.fromFirestore(snapshot);
    return current.copyWith(
      isChecked: isChecked,
      checkedBy: isChecked ? userId : null,
      updatedAt: now,
    );
  }

  Future<void> deleteItem({
    required String pairId,
    required String itemId,
  }) async {
    await _itemsRef(pairId).doc(itemId).delete();
  }

  Future<void> clearCheckedItems({required String pairId}) async {
    final snapshot =
        await _itemsRef(pairId).where('isChecked', isEqualTo: true).get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

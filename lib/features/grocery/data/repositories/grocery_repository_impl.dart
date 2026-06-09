import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/grocery/data/datasources/grocery_remote_datasource.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';
import 'package:pair/features/grocery/domain/repositories/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  GroceryRepositoryImpl(this._dataSource);

  final GroceryRemoteDataSource _dataSource;

  List<GroceryItemEntity> _sortItems(List<GroceryItemEntity> items) {
    final sorted = [...items];
    sorted.sort((a, b) {
      if (a.isChecked != b.isChecked) {
        return a.isChecked ? 1 : -1;
      }
      return a.createdAt.compareTo(b.createdAt);
    });
    return sorted;
  }

  @override
  Stream<List<GroceryItemEntity>> watchItems({required String pairId}) {
    return _dataSource.watchItems(pairId: pairId).map(
          (models) => _sortItems(models.map((m) => m.toEntity()).toList()),
        );
  }

  @override
  Stream<int> watchUncheckedCount({required String pairId}) {
    return _dataSource.watchUncheckedCount(pairId: pairId);
  }

  @override
  Future<Result<GroceryItemEntity>> addItem({
    required String pairId,
    required String itemId,
    required String addedBy,
    required String text,
  }) async {
    try {
      if (text.trim().isEmpty) {
        return failure(const FirestoreFailure('Item cannot be empty'));
      }
      final item = await _dataSource.addItem(
        pairId: pairId,
        itemId: itemId,
        addedBy: addedBy,
        text: text,
      );
      return success(item.toEntity());
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<GroceryItemEntity>> toggleItem({
    required String pairId,
    required String itemId,
    required String userId,
    required bool isChecked,
  }) async {
    try {
      final item = await _dataSource.toggleItem(
        pairId: pairId,
        itemId: itemId,
        userId: userId,
        isChecked: isChecked,
      );
      return success(item.toEntity());
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteItem({
    required String pairId,
    required String itemId,
  }) async {
    try {
      await _dataSource.deleteItem(pairId: pairId, itemId: itemId);
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCheckedItems({required String pairId}) async {
    try {
      await _dataSource.clearCheckedItems(pairId: pairId);
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }
}

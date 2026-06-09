import 'package:pair/core/result/result.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';

abstract class GroceryRepository {
  Stream<List<GroceryItemEntity>> watchItems({required String pairId});

  Stream<int> watchUncheckedCount({required String pairId});

  Future<Result<GroceryItemEntity>> addItem({
    required String pairId,
    required String itemId,
    required String addedBy,
    required String text,
  });

  Future<Result<GroceryItemEntity>> toggleItem({
    required String pairId,
    required String itemId,
    required String userId,
    required bool isChecked,
  });

  Future<Result<void>> deleteItem({
    required String pairId,
    required String itemId,
  });

  Future<Result<void>> clearCheckedItems({required String pairId});
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';

part 'grocery_item_model.freezed.dart';
part 'grocery_item_model.g.dart';

@freezed
abstract class GroceryItemModel with _$GroceryItemModel {
  const GroceryItemModel._();

  const factory GroceryItemModel({
    required String id,
    required String text,
    @Default(false) bool isChecked,
    required String addedBy,
    String? checkedBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _GroceryItemModel;

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryItemModelFromJson(json);

  factory GroceryItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return GroceryItemModel.fromJson({...data, 'id': doc.id});
  }

  GroceryItemEntity toEntity() => GroceryItemEntity(
        id: id,
        text: text,
        isChecked: isChecked,
        addedBy: addedBy,
        checkedBy: checkedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

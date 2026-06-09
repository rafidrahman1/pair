// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroceryItemModel _$GroceryItemModelFromJson(Map<String, dynamic> json) =>
    _GroceryItemModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      addedBy: json['addedBy'] as String,
      checkedBy: json['checkedBy'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$GroceryItemModelToJson(_GroceryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'isChecked': instance.isChecked,
      'addedBy': instance.addedBy,
      'checkedBy': instance.checkedBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

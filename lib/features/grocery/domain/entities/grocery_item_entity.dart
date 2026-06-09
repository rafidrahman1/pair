import 'package:equatable/equatable.dart';

class GroceryItemEntity extends Equatable {
  const GroceryItemEntity({
    required this.id,
    required this.text,
    required this.isChecked,
    required this.addedBy,
    this.checkedBy,
    required this.createdAt,
    required this.updatedAt,
    this.isPending = false,
  });

  final String id;
  final String text;
  final bool isChecked;
  final String addedBy;
  final String? checkedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPending;

  GroceryItemEntity copyWith({
    String? id,
    String? text,
    bool? isChecked,
    String? addedBy,
    String? checkedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPending,
  }) {
    return GroceryItemEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
      addedBy: addedBy ?? this.addedBy,
      checkedBy: checkedBy ?? this.checkedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        isChecked,
        addedBy,
        checkedBy,
        createdAt,
        updatedAt,
        isPending,
      ];
}

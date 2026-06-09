import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/pairing/domain/entities/pair_entity.dart';

part 'pair_model.freezed.dart';
part 'pair_model.g.dart';

@freezed
abstract class PairModel with _$PairModel {
  const PairModel._();

  const factory PairModel({
    required String id,
    required List<String> memberIds,
    @TimestampConverter() required DateTime createdAt,
  }) = _PairModel;

  factory PairModel.fromJson(Map<String, dynamic> json) =>
      _$PairModelFromJson(json);

  factory PairModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PairModel.fromJson({...data, 'id': doc.id});
  }

  PairEntity toEntity() => PairEntity(
        id: id,
        memberIds: memberIds,
        createdAt: createdAt,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

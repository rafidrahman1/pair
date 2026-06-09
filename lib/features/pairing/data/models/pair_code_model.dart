import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/pairing/domain/entities/pair_code_entity.dart';

part 'pair_code_model.freezed.dart';
part 'pair_code_model.g.dart';

@freezed
abstract class PairCodeModel with _$PairCodeModel {
  const PairCodeModel._();

  const factory PairCodeModel({
    required String code,
    required String ownerId,
    @TimestampConverter() required DateTime expiresAt,
    @Default(false) bool used,
  }) = _PairCodeModel;

  factory PairCodeModel.fromJson(Map<String, dynamic> json) =>
      _$PairCodeModelFromJson(json);

  factory PairCodeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PairCodeModel.fromJson({...data, 'code': doc.id});
  }

  PairCodeEntity toEntity() => PairCodeEntity(
        code: code,
        ownerId: ownerId,
        expiresAt: expiresAt,
        used: used,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('code');
    return json;
  }
}

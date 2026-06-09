import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/health/domain/entities/period_data_entity.dart';

part 'period_data_model.freezed.dart';
part 'period_data_model.g.dart';

@freezed
abstract class PeriodDataModel with _$PeriodDataModel {
  const PeriodDataModel._();

  const factory PeriodDataModel({
    required String uid,
    required bool isOnPeriod,
    @TimestampConverter() DateTime? lastPeriodStart,
    String? currentFlow,
    @TimestampConverter() DateTime? lastFlowDate,
    @TimestampConverter() required DateTime updatedAt,
  }) = _PeriodDataModel;

  factory PeriodDataModel.fromJson(Map<String, dynamic> json) =>
      _$PeriodDataModelFromJson(json);

  factory PeriodDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PeriodDataModel.fromJson({...data, 'uid': doc.id});
  }

  factory PeriodDataModel.fromEntity(PeriodDataEntity entity) =>
      PeriodDataModel(
        uid: entity.uid,
        isOnPeriod: entity.isOnPeriod,
        lastPeriodStart: entity.lastPeriodStart,
        currentFlow: entity.currentFlow,
        lastFlowDate: entity.lastFlowDate,
        updatedAt: entity.updatedAt,
      );

  PeriodDataEntity toEntity() => PeriodDataEntity(
        uid: uid,
        isOnPeriod: isOnPeriod,
        lastPeriodStart: lastPeriodStart,
        currentFlow: currentFlow,
        lastFlowDate: lastFlowDate,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    return json;
  }
}

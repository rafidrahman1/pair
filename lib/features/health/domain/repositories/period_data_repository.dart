import 'package:pair/core/result/result.dart';
import 'package:pair/features/health/domain/entities/period_data_entity.dart';

abstract class PeriodDataRepository {
  Future<Result<bool>> requestHealthPermission();

  Future<Result<PeriodDataEntity?>> fetchLocalPeriodData(String uid);

  Future<Result<void>> syncPeriodData({
    required String pairId,
    required PeriodDataEntity data,
  });

  Stream<PeriodDataEntity?> watchPeriodData({
    required String pairId,
    required String uid,
  });
}

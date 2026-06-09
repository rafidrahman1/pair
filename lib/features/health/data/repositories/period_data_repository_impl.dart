import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/health/data/datasources/health_local_datasource.dart';
import 'package:pair/features/health/data/datasources/period_data_remote_datasource.dart';
import 'package:pair/features/health/data/models/period_data_model.dart';
import 'package:pair/features/health/domain/entities/period_data_entity.dart';
import 'package:pair/features/health/domain/repositories/period_data_repository.dart';

class PeriodDataRepositoryImpl implements PeriodDataRepository {
  PeriodDataRepositoryImpl({
    required HealthLocalDataSource localDataSource,
    required PeriodDataRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final HealthLocalDataSource _localDataSource;
  final PeriodDataRemoteDataSource _remoteDataSource;

  @override
  Future<Result<bool>> requestHealthPermission() async {
    try {
      final granted = await _localDataSource.requestPermission();
      if (!granted) {
        return failure(
          const PermissionFailure('Health data permission denied'),
        );
      }
      return success(true);
    } catch (e) {
      return failure(HealthFailure(e.toString()));
    }
  }

  @override
  Future<Result<PeriodDataEntity?>> fetchLocalPeriodData(String uid) async {
    try {
      final data = await _localDataSource.fetchPeriodData(uid);
      return success(data?.toEntity());
    } catch (e) {
      return failure(HealthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> syncPeriodData({
    required String pairId,
    required PeriodDataEntity data,
  }) async {
    try {
      await _remoteDataSource.updatePeriodData(
        pairId: pairId,
        data: PeriodDataModel.fromEntity(data),
      );
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<PeriodDataEntity?> watchPeriodData({
    required String pairId,
    required String uid,
  }) {
    return _remoteDataSource
        .watchPeriodData(pairId: pairId, uid: uid)
        .map((model) => model?.toEntity());
  }
}

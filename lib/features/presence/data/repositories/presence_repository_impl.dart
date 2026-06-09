import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/presence/data/datasources/presence_remote_datasource.dart';
import 'package:pair/features/presence/domain/entities/presence_entity.dart';
import 'package:pair/features/presence/domain/repositories/presence_repository.dart';

class PresenceRepositoryImpl implements PresenceRepository {
  PresenceRepositoryImpl(this._dataSource);

  final PresenceRemoteDataSource _dataSource;

  @override
  Future<Result<void>> setOnline({
    required String pairId,
    required String uid,
  }) async {
    try {
      await _dataSource.setOnline(pairId: pairId, uid: uid);
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> setOffline({
    required String pairId,
    required String uid,
  }) async {
    try {
      await _dataSource.setOffline(pairId: pairId, uid: uid);
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<PresenceEntity?> watchSpousePresence({
    required String pairId,
    required String spouseId,
  }) {
    return _dataSource
        .watchPresence(pairId: pairId, uid: spouseId)
        .map((model) => model?.toEntity());
  }
}

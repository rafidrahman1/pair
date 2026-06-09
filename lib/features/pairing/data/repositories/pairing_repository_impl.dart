import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/pairing/data/datasources/pairing_remote_datasource.dart';
import 'package:pair/features/pairing/domain/entities/pair_code_entity.dart';
import 'package:pair/features/pairing/domain/entities/pair_entity.dart';
import 'package:pair/features/pairing/domain/repositories/pairing_repository.dart';

class PairingRepositoryImpl implements PairingRepository {
  PairingRepositoryImpl(this._dataSource);

  final PairingRemoteDataSource _dataSource;

  @override
  Future<Result<PairCodeEntity>> generatePairCode(String ownerId) async {
    try {
      final code = await _dataSource.generatePairCode(ownerId);
      return success(code.toEntity());
    } on StateError catch (e) {
      return failure(PairingFailure(e.message));
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<PairCodeEntity?> watchPairCode(String code) {
    return _dataSource
        .watchPairCode(code)
        .map((model) => model?.toEntity());
  }

  @override
  Future<Result<PairEntity>> joinWithCode({
    required String code,
    required String joinerId,
  }) async {
    try {
      final pair = await _dataSource.joinWithCode(
        code: code,
        joinerId: joinerId,
      );
      return success(pair.toEntity());
    } on StateError catch (e) {
      return failure(PairingFailure(e.message));
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<PairEntity?>> getPair(String pairId) async {
    try {
      final pair = await _dataSource.getPair(pairId);
      return success(pair?.toEntity());
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<PairEntity?> watchPair(String pairId) {
    return _dataSource.watchPair(pairId).map((model) => model?.toEntity());
  }
}

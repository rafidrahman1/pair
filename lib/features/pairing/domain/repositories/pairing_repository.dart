import 'package:pair/core/result/result.dart';
import 'package:pair/features/pairing/domain/entities/pair_code_entity.dart';
import 'package:pair/features/pairing/domain/entities/pair_entity.dart';

abstract class PairingRepository {
  Future<Result<PairCodeEntity>> generatePairCode(String ownerId);

  Stream<PairCodeEntity?> watchPairCode(String code);

  Future<Result<PairEntity>> joinWithCode({
    required String code,
    required String joinerId,
  });

  Future<Result<PairEntity?>> getPair(String pairId);

  Stream<PairEntity?> watchPair(String pairId);
}

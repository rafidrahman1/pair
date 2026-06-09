import 'package:pair/core/result/result.dart';
import 'package:pair/features/presence/domain/entities/presence_entity.dart';

abstract class PresenceRepository {
  Future<Result<void>> setOnline({
    required String pairId,
    required String uid,
  });

  Future<Result<void>> setOffline({
    required String pairId,
    required String uid,
  });

  Stream<PresenceEntity?> watchSpousePresence({
    required String pairId,
    required String spouseId,
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/pairing/data/datasources/pairing_remote_datasource.dart';
import 'package:pair/features/pairing/data/repositories/pairing_repository_impl.dart';
import 'package:pair/features/pairing/domain/entities/pair_code_entity.dart';
import 'package:pair/features/pairing/domain/entities/pair_entity.dart';
import 'package:pair/features/pairing/domain/repositories/pairing_repository.dart';

final pairingRemoteDataSourceProvider = Provider<PairingRemoteDataSource>((ref) {
  return PairingRemoteDataSource(ref.watch(firestoreProvider));
});

final pairingRepositoryProvider = Provider<PairingRepository>((ref) {
  return PairingRepositoryImpl(ref.watch(pairingRemoteDataSourceProvider));
});

final currentPairProvider = StreamProvider<PairEntity?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  if (user?.pairId == null) {
    return Stream.value(null);
  }
  return ref.watch(pairingRepositoryProvider).watchPair(user!.pairId!);
});

class PairingController extends AsyncNotifier<PairCodeEntity?> {
  @override
  Future<PairCodeEntity?> build() => Future.value(null);

  Future<void> generateCode() async {
    final user = ref.read(currentUserStreamProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    final result =
        await ref.read(pairingRepositoryProvider).generatePairCode(user.uid);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (code) => AsyncData(code),
    );
  }

  Future<PairEntity?> joinWithCode(String code) async {
    final user = ref.read(currentUserStreamProvider).valueOrNull;
    if (user == null) return null;

    state = const AsyncLoading();
    final result = await ref
        .read(pairingRepositoryProvider)
        .joinWithCode(code: code, joinerId: user.uid);

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (pair) {
        state = const AsyncData(null);
        ref.invalidate(currentUserStreamProvider);
        return pair;
      },
    );
  }
}

final pairingControllerProvider =
    AsyncNotifierProvider<PairingController, PairCodeEntity?>(
  PairingController.new,
);

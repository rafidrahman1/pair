import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';
import 'package:pair/features/presence/data/datasources/presence_remote_datasource.dart';
import 'package:pair/features/presence/data/repositories/presence_repository_impl.dart';
import 'package:pair/features/presence/data/services/presence_service.dart';
import 'package:pair/features/presence/domain/entities/presence_entity.dart';
import 'package:pair/features/presence/domain/repositories/presence_repository.dart';

final presenceRemoteDataSourceProvider = Provider<PresenceRemoteDataSource>((ref) {
  return PresenceRemoteDataSource(ref.watch(firestoreProvider));
});

final presenceRepositoryProvider = Provider<PresenceRepository>((ref) {
  return PresenceRepositoryImpl(ref.watch(presenceRemoteDataSourceProvider));
});

final spousePresenceProvider = StreamProvider<PresenceEntity?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value(null);
  }

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return Stream.value(null);

  return ref.watch(presenceRepositoryProvider).watchSpousePresence(
        pairId: pair.id,
        spouseId: spouseId,
      );
});

final presenceServiceProvider = Provider<PresenceService?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return null;
  }

  return PresenceService(
    repository: ref.watch(presenceRepositoryProvider),
    pairId: pair.id,
    userId: user.uid,
  );
});

/// Starts presence heartbeats once the user is paired and auth/pair data is ready.
final presenceServiceLifecycleProvider = Provider<void>((ref) {
  final service = ref.watch(presenceServiceProvider);
  if (service == null) return;

  service.start();
  ref.onDispose(service.stop);
});

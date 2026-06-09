import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/health/data/datasources/health_local_datasource.dart';
import 'package:pair/features/health/data/datasources/period_data_remote_datasource.dart';
import 'package:pair/features/health/data/repositories/period_data_repository_impl.dart';
import 'package:pair/features/health/data/services/period_sync_service.dart';
import 'package:pair/features/health/domain/entities/period_data_entity.dart';
import 'package:pair/features/health/domain/repositories/period_data_repository.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';
import 'package:pair/features/profile/presentation/providers/profile_providers.dart';

final healthLocalDataSourceProvider = Provider<HealthLocalDataSource>((ref) {
  return HealthLocalDataSource();
});

final periodDataRemoteDataSourceProvider =
    Provider<PeriodDataRemoteDataSource>((ref) {
  return PeriodDataRemoteDataSource(ref.watch(firestoreProvider));
});

final periodDataRepositoryProvider = Provider<PeriodDataRepository>((ref) {
  return PeriodDataRepositoryImpl(
    localDataSource: ref.watch(healthLocalDataSourceProvider),
    remoteDataSource: ref.watch(periodDataRemoteDataSourceProvider),
  );
});

/// Wife's period data synced to Firestore for the spouse to view.
final wifePeriodDataProvider = StreamProvider<PeriodDataEntity?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;
  final spouse = ref.watch(spouseUserProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return Stream.value(null);
  }

  final wifeId = switch (user.role) {
    UserRole.wife => user.uid,
    UserRole.husband => spouse?.uid,
    null => null,
  };

  if (wifeId == null || wifeId.isEmpty) {
    return Stream.value(null);
  }

  return ref.watch(periodDataRepositoryProvider).watchPeriodData(
        pairId: pair.id,
        uid: wifeId,
      );
});

final periodSyncServiceProvider = Provider<PeriodSyncService?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null ||
      pair == null ||
      !user.isPaired ||
      user.role != UserRole.wife) {
    return null;
  }

  return PeriodSyncService(
    repository: ref.watch(periodDataRepositoryProvider),
    pairId: pair.id,
    userId: user.uid,
  );
});

/// Starts period sync only for the wife role.
final periodSyncLifecycleProvider = Provider<void>((ref) {
  final service = ref.watch(periodSyncServiceProvider);
  if (service == null) return;

  service.start();
  ref.onDispose(service.stop);
});

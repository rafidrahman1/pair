import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/location/data/datasources/location_local_datasource.dart';
import 'package:pair/features/location/data/datasources/location_remote_datasource.dart';
import 'package:pair/features/location/data/repositories/location_repository_impl.dart';
import 'package:pair/features/location/data/services/location_service.dart';
import 'package:pair/features/location/data/services/proximity_notification_service.dart';
import 'package:pair/features/location/domain/entities/location_entity.dart';
import 'package:pair/features/location/domain/repositories/location_repository.dart';
import 'package:pair/features/notifications/presentation/providers/notification_providers.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';

final locationLocalDataSourceProvider = Provider<LocationLocalDataSource>((ref) {
  return LocationLocalDataSource();
});

final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSource(ref.watch(firestoreProvider));
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    localDataSource: ref.watch(locationLocalDataSourceProvider),
    remoteDataSource: ref.watch(locationRemoteDataSourceProvider),
  );
});

final spouseLocationProvider = StreamProvider<LocationEntity?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return Stream.value(null);
  }

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return Stream.value(null);

  return ref.watch(locationRepositoryProvider).watchSpouseLocation(
        pairId: pair.id,
        spouseId: spouseId,
      );
});

final myLocationProvider = StreamProvider<LocationEntity?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value(null);
  }

  return ref.watch(locationRepositoryProvider).watchUserLocation(
        pairId: pair.id,
        uid: user.uid,
      );
});

final locationServiceProvider = Provider<LocationService?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return null;
  }

  return LocationService(
    repository: ref.watch(locationRepositoryProvider),
    pairId: pair.id,
    userId: user.uid,
  );
});

/// Starts location updates once the user is paired and auth/pair data is ready.
final locationServiceLifecycleProvider = Provider<void>((ref) {
  final service = ref.watch(locationServiceProvider);
  if (service == null) return;

  service.start();
  ref.onDispose(service.stop);
});

final proximityNotificationServiceProvider =
    Provider<ProximityNotificationService?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return null;
  }

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return null;

  return ProximityNotificationService(
    repository: ref.watch(locationRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
    authDataSource: ref.watch(authRemoteDataSourceProvider),
    pairId: pair.id,
    userId: user.uid,
    spouseId: spouseId,
  );
});

/// Notifies both spouses when they come within 1 km of each other.
final proximityNotificationLifecycleProvider = Provider<void>((ref) {
  ref.watch(notificationInitProvider);
  final service = ref.watch(proximityNotificationServiceProvider);
  if (service == null) return;

  service.start();
  ref.onDispose(service.stop);
});

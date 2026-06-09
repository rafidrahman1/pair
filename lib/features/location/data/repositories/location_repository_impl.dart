import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/location/data/datasources/location_local_datasource.dart';
import 'package:pair/features/location/data/datasources/location_remote_datasource.dart';
import 'package:pair/features/location/data/models/location_model.dart';
import 'package:pair/features/location/domain/entities/location_entity.dart';
import 'package:pair/features/location/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    required LocationLocalDataSource localDataSource,
    required LocationRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final LocationLocalDataSource _localDataSource;
  final LocationRemoteDataSource _remoteDataSource;

  @override
  Future<Result<bool>> requestPermission() async {
    try {
      final granted = await _localDataSource.requestPermission();
      if (!granted) {
        final permanentlyDenied =
            await _localDataSource.isPermissionPermanentlyDenied();
        if (permanentlyDenied) {
          return failure(
            const PermissionFailure(
              'Location permission permanently denied. Open settings to enable.',
            ),
          );
        }
        return failure(const PermissionFailure('Location permission denied'));
      }
      return success(true);
    } catch (e) {
      return failure(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isPermissionGranted() async {
    try {
      return success(await _localDataSource.isPermissionGranted());
    } catch (e) {
      return failure(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> openAppSettings() async {
    try {
      return success(await _localDataSource.openAppSettings());
    } catch (e) {
      return failure(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Result<LocationEntity>> getCurrentLocation(String uid) async {
    try {
      final location = await _localDataSource.getCurrentLocation(uid);
      return success(location.toEntity());
    } on StateError catch (e) {
      return failure(LocationFailure(e.message));
    } catch (e) {
      return failure(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateLocation({
    required String pairId,
    required LocationEntity location,
  }) async {
    try {
      final model = LocationEntity(
        uid: location.uid,
        latitude: location.latitude,
        longitude: location.longitude,
        accuracy: location.accuracy,
        batteryLevel: location.batteryLevel,
        updatedAt: location.updatedAt,
      );
      await _remoteDataSource.updateLocation(
        pairId: pairId,
        location: LocationModel(
          uid: model.uid,
          latitude: model.latitude,
          longitude: model.longitude,
          accuracy: model.accuracy,
          batteryLevel: model.batteryLevel,
          updatedAt: model.updatedAt,
        ),
      );
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<LocationEntity?> watchSpouseLocation({
    required String pairId,
    required String spouseId,
  }) {
    return _remoteDataSource
        .watchLocation(pairId: pairId, uid: spouseId)
        .map((model) => model?.toEntity());
  }

  @override
  Stream<LocationEntity?> watchUserLocation({
    required String pairId,
    required String uid,
  }) {
    return _remoteDataSource
        .watchLocation(pairId: pairId, uid: uid)
        .map((model) => model?.toEntity());
  }
}

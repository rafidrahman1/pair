import 'package:pair/core/result/result.dart';
import 'package:pair/features/location/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<Result<bool>> requestPermission();

  Future<Result<bool>> isPermissionGranted();

  Future<Result<bool>> openAppSettings();

  Future<Result<LocationEntity>> getCurrentLocation(String uid);

  Future<Result<void>> updateLocation({
    required String pairId,
    required LocationEntity location,
  });

  Stream<LocationEntity?> watchSpouseLocation({
    required String pairId,
    required String spouseId,
  });

  Stream<LocationEntity?> watchUserLocation({
    required String pairId,
    required String uid,
  });
}

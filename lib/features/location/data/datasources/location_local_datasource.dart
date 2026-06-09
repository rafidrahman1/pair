import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pair/features/location/data/models/location_model.dart';

class LocationLocalDataSource {
  LocationLocalDataSource({
    Battery? battery,
  }) : _battery = battery ?? Battery();

  final Battery _battery;

  Future<bool> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> isPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> isPermissionPermanentlyDenied() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  Future<LocationModel> getCurrentLocation(String uid) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw StateError('Location services are disabled');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    int? batteryLevel;
    try {
      batteryLevel = await _battery.batteryLevel;
    } catch (_) {
      batteryLevel = null;
    }

    return LocationModel(
      uid: uid,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      batteryLevel: batteryLevel,
      updatedAt: DateTime.now(),
    );
  }
}

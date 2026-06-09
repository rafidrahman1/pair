import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pair/features/location/data/models/location_model.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationLocalDataSource {
  LocationLocalDataSource({
    Battery? battery,
  }) : _battery = battery ?? Battery();

  final Battery _battery;

  Future<bool> requestPermission() async {
    if (!await _ensureWhenInUsePermission()) return false;
    return _ensureAlwaysPermission();
  }

  Future<bool> isPermissionGranted() async {
    return Permission.locationAlways.isGranted;
  }

  Future<bool> _ensureWhenInUsePermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;

    status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> _ensureAlwaysPermission() async {
    var status = await Permission.locationAlways.status;
    if (status.isGranted) return true;

    status = await Permission.locationAlways.request();
    return status.isGranted;
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

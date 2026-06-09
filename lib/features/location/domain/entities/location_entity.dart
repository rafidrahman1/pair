import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  const LocationEntity({
    required this.uid,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.batteryLevel,
    required this.updatedAt,
  });

  final String uid;
  final double latitude;
  final double longitude;
  final double accuracy;
  final int? batteryLevel;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        uid,
        latitude,
        longitude,
        accuracy,
        batteryLevel,
        updatedAt,
      ];
}

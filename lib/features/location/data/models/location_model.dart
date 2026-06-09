import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/location/domain/entities/location_entity.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
abstract class LocationModel with _$LocationModel {
  const LocationModel._();

  const factory LocationModel({
    required String uid,
    required double latitude,
    required double longitude,
    required double accuracy,
    int? batteryLevel,
    @TimestampConverter() required DateTime updatedAt,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  factory LocationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return LocationModel.fromJson({...data, 'uid': doc.id});
  }

  LocationEntity toEntity() => LocationEntity(
        uid: uid,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        batteryLevel: batteryLevel,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    return json;
  }
}

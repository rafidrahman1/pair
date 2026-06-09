import 'dart:async';

import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/core/utils/distance_calculator.dart';
import 'package:pair/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pair/features/location/domain/entities/location_entity.dart';
import 'package:pair/features/location/domain/repositories/location_repository.dart';
import 'package:pair/features/notifications/data/services/notification_service.dart';

class ProximityNotificationService {
  ProximityNotificationService({
    required LocationRepository repository,
    required NotificationService notificationService,
    required AuthRemoteDataSource authDataSource,
    required String pairId,
    required String userId,
    required String spouseId,
  })  : _repository = repository,
        _notificationService = notificationService,
        _authDataSource = authDataSource,
        _pairId = pairId,
        _userId = userId,
        _spouseId = spouseId;

  final LocationRepository _repository;
  final NotificationService _notificationService;
  final AuthRemoteDataSource _authDataSource;
  final String _pairId;
  final String _userId;
  final String _spouseId;

  StreamSubscription<LocationEntity?>? _myLocationSub;
  StreamSubscription<LocationEntity?>? _spouseLocationSub;
  LocationEntity? _myLocation;
  LocationEntity? _spouseLocation;
  bool _wasWithinProximity = false;
  bool _hasBaseline = false;
  bool _running = false;

  Future<void> start() async {
    if (_running) return;
    _running = true;

    _myLocationSub = _repository
        .watchUserLocation(pairId: _pairId, uid: _userId)
        .listen(_onMyLocation, onError: (_) {});
    _spouseLocationSub = _repository
        .watchSpouseLocation(pairId: _pairId, spouseId: _spouseId)
        .listen(_onSpouseLocation, onError: (_) {});
  }

  Future<void> stop() async {
    if (!_running) return;
    _running = false;

    await _myLocationSub?.cancel();
    await _spouseLocationSub?.cancel();
    _myLocationSub = null;
    _spouseLocationSub = null;
    _myLocation = null;
    _spouseLocation = null;
    _wasWithinProximity = false;
    _hasBaseline = false;
  }

  void _onMyLocation(LocationEntity? location) {
    _myLocation = location;
    _evaluateProximity();
  }

  void _onSpouseLocation(LocationEntity? location) {
    _spouseLocation = location;
    _evaluateProximity();
  }

  void _evaluateProximity() {
    final myLocation = _myLocation;
    final spouseLocation = _spouseLocation;
    if (myLocation == null || spouseLocation == null) return;

    final meters = DistanceCalculator.haversineMeters(
      lat1: myLocation.latitude,
      lon1: myLocation.longitude,
      lat2: spouseLocation.latitude,
      lon2: spouseLocation.longitude,
    );
    final isWithin = meters < AppConstants.proximityNotifyMeters;

    if (!_hasBaseline) {
      _wasWithinProximity = isWithin;
      _hasBaseline = true;
      return;
    }

    if (isWithin && !_wasWithinProximity) {
      _wasWithinProximity = true;
      unawaited(_notifyProximity(meters));
      return;
    }

    _wasWithinProximity = isWithin;
  }

  Future<void> _notifyProximity(double meters) async {
    final spouseDoc = await _authDataSource.getUserDocument(_spouseId);
    final spouseName = spouseDoc?.displayName ?? 'Your spouse';
    final distanceText = DistanceCalculator.formatDistance(meters);

    await _notificationService.notifySpouseNearby(
      spouseName: spouseName,
      distanceText: distanceText,
      pairId: _pairId,
    );
  }
}

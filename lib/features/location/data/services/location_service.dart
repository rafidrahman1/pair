import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/location/domain/repositories/location_repository.dart';

/// Manages foreground location updates with hooks for background tracking.
class LocationService with WidgetsBindingObserver {
  LocationService({
    required LocationRepository repository,
    required String pairId,
    required String userId,
    Duration foregroundInterval = AppConstants.foregroundLocationInterval,
  })  : _repository = repository,
        _pairId = pairId,
        _userId = userId,
        _foregroundInterval = foregroundInterval;

  final LocationRepository _repository;
  final String _pairId;
  final String _userId;
  final Duration _foregroundInterval;

  Timer? _foregroundTimer;
  bool _isForeground = true;
  bool _running = false;

  /// Hook for background location tracking integration.
  /// Call from a background service / workmanager when implementing background mode.
  Future<void> onBackgroundLocationTick() async {
    await _publishCurrentLocation();
  }

  Future<void> start() async {
    if (_running) return;
    _running = true;

    WidgetsBinding.instance.addObserver(this);

    final permission = await _repository.requestPermission();
    permission.fold((_) => null, (_) => null);

    await _publishCurrentLocation();
    _startForegroundTimer();
  }

  void stop() {
    if (!_running) return;
    _running = false;

    WidgetsBinding.instance.removeObserver(this);
    _foregroundTimer?.cancel();
    _foregroundTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (_isForeground) {
      _startForegroundTimer();
      _publishCurrentLocation();
    } else {
      _foregroundTimer?.cancel();
      _foregroundTimer = null;
    }
  }

  void _startForegroundTimer() {
    _foregroundTimer?.cancel();
    _foregroundTimer = Timer.periodic(_foregroundInterval, (_) {
      if (_isForeground) {
        _publishCurrentLocation();
      }
    });
  }

  Future<void> _publishCurrentLocation() async {
    final locationResult = await _repository.getCurrentLocation(_userId);
    await locationResult.fold(
      (_) async {},
      (location) => _repository.updateLocation(
        pairId: _pairId,
        location: location,
      ),
    );
  }
}

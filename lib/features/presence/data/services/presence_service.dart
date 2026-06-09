import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/presence/domain/repositories/presence_repository.dart';

class PresenceService with WidgetsBindingObserver {
  PresenceService({
    required PresenceRepository repository,
    required String pairId,
    required String userId,
  })  : _repository = repository,
        _pairId = pairId,
        _userId = userId;

  final PresenceRepository _repository;
  final String _pairId;
  final String _userId;

  Timer? _heartbeatTimer;
  bool _running = false;

  Future<void> start() async {
    if (_running) return;
    _running = true;

    WidgetsBinding.instance.addObserver(this);
    await _setOnline();
    _startHeartbeat();
  }

  Future<void> stop() async {
    if (!_running) return;
    _running = false;

    WidgetsBinding.instance.removeObserver(this);
    _stopHeartbeat();
    await _repository.setOffline(pairId: _pairId, uid: _userId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _setOnline();
        _startHeartbeat();
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopHeartbeat();
        _repository.setOffline(pairId: _pairId, uid: _userId);
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      AppConstants.presenceHeartbeatInterval,
      (_) => _setOnline(),
    );
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> _setOnline() async {
    await _repository.setOnline(pairId: _pairId, uid: _userId);
  }
}

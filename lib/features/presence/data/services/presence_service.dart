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
    _heartbeatTimer = Timer.periodic(
      AppConstants.presenceHeartbeatInterval,
      (_) => _setOnline(),
    );
  }

  Future<void> stop() async {
    if (!_running) return;
    _running = false;

    WidgetsBinding.instance.removeObserver(this);
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    await _repository.setOffline(pairId: _pairId, uid: _userId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOnline();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _repository.setOffline(pairId: _pairId, uid: _userId);
    }
  }

  Future<void> _setOnline() async {
    await _repository.setOnline(pairId: _pairId, uid: _userId);
  }
}

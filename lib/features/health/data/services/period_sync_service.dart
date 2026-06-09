import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/health/domain/repositories/period_data_repository.dart';

/// Syncs period data from Health Connect / Apple Health for the wife role.
class PeriodSyncService with WidgetsBindingObserver {
  PeriodSyncService({
    required PeriodDataRepository repository,
    required String pairId,
    required String userId,
    Duration syncInterval = AppConstants.periodSyncInterval,
  })  : _repository = repository,
        _pairId = pairId,
        _userId = userId,
        _syncInterval = syncInterval;

  final PeriodDataRepository _repository;
  final String _pairId;
  final String _userId;
  final Duration _syncInterval;

  Timer? _syncTimer;
  bool _running = false;

  Future<void> start() async {
    if (_running) return;
    _running = true;

    WidgetsBinding.instance.addObserver(this);
    await _repository.requestHealthPermission();
    await _sync();
    _startSyncTimer();
  }

  void stop() {
    if (!_running) return;
    _running = false;

    WidgetsBinding.instance.removeObserver(this);
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sync();
      _startSyncTimer();
    } else if (state == AppLifecycleState.paused) {
      _syncTimer?.cancel();
      _syncTimer = null;
    }
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_syncInterval, (_) => _sync());
  }

  Future<void> _sync() async {
    final result = await _repository.fetchLocalPeriodData(_userId);
    await result.fold(
      (_) async {},
      (data) async {
        if (data == null) return;
        await _repository.syncPeriodData(pairId: _pairId, data: data);
      },
    );
  }
}

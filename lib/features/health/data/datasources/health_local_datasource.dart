import 'dart:io';

import 'package:health/health.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/health/data/models/period_data_model.dart';

class HealthLocalDataSource {
  HealthLocalDataSource({Health? health}) : _health = health ?? Health();

  final Health _health;
  bool _configured = false;

  static const _periodTypes = [HealthDataType.MENSTRUATION_FLOW];

  Future<bool> configure() async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    if (_configured) return true;
    await _health.configure();
    _configured = true;
    return true;
  }

  Future<bool> requestPermission() async {
    if (!await configure()) return false;
    return _health.requestAuthorization(
      _periodTypes,
      permissions: [HealthDataAccess.READ],
    );
  }

  Future<PeriodDataModel?> fetchPeriodData(String uid) async {
    if (!await configure()) return null;

    final hasPermission = await _health.hasPermissions(
      _periodTypes,
      permissions: [HealthDataAccess.READ],
    );
    if (hasPermission != true) return null;

    final now = DateTime.now();
    final start = now.subtract(
      const Duration(days: AppConstants.periodLookbackDays),
    );

    final points = await _health.getHealthDataFromTypes(
      types: _periodTypes,
      startTime: start,
      endTime: now,
    );

    if (points.isEmpty) return null;

    points.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));

    final flows = <_FlowEntry>[];
    for (final point in points) {
      final value = point.value;
      if (value is! MenstruationFlowHealthValue) continue;
      flows.add(
        _FlowEntry(
          date: value.dateTime,
          flow: value.flow,
          isStartOfCycle: value.isStartOfCycle ?? false,
        ),
      );
    }

    if (flows.isEmpty) return null;

    final latest = flows.first;
    final activeFlows = flows.where((entry) => entry.isActive).toList();
    final isOnPeriod = activeFlows.isNotEmpty &&
        now.difference(activeFlows.first.date).inDays <= 7;

    DateTime? lastPeriodStart;
    for (final entry in flows) {
      if (entry.isStartOfCycle) {
        lastPeriodStart = entry.date;
        break;
      }
    }
    lastPeriodStart ??= _inferPeriodStart(activeFlows);

    return PeriodDataModel(
      uid: uid,
      isOnPeriod: isOnPeriod,
      lastPeriodStart: lastPeriodStart,
      currentFlow: latest.flow?.name,
      lastFlowDate: latest.date,
      updatedAt: now,
    );
  }
}

class _FlowEntry {
  const _FlowEntry({
    required this.date,
    required this.flow,
    required this.isStartOfCycle,
  });

  final DateTime date;
  final MenstrualFlow? flow;
  final bool isStartOfCycle;

  bool get isActive {
    return switch (flow) {
      MenstrualFlow.light ||
      MenstrualFlow.medium ||
      MenstrualFlow.heavy ||
      MenstrualFlow.spotting =>
        true,
      _ => false,
    };
  }
}

DateTime? _inferPeriodStart(List<_FlowEntry> activeFlows) {
  if (activeFlows.isEmpty) return null;

  final sorted = [...activeFlows]..sort((a, b) => a.date.compareTo(b.date));
  var periodStart = sorted.last.date;

  for (var i = sorted.length - 2; i >= 0; i--) {
    final gap = sorted[i + 1].date.difference(sorted[i].date).inDays;
    if (gap > 2) break;
    periodStart = sorted[i].date;
  }

  return periodStart;
}

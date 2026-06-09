import 'package:equatable/equatable.dart';

class PeriodDataEntity extends Equatable {
  const PeriodDataEntity({
    required this.uid,
    required this.isOnPeriod,
    this.lastPeriodStart,
    this.currentFlow,
    this.lastFlowDate,
    required this.updatedAt,
  });

  final String uid;
  final bool isOnPeriod;
  final DateTime? lastPeriodStart;
  final String? currentFlow;
  final DateTime? lastFlowDate;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        uid,
        isOnPeriod,
        lastPeriodStart,
        currentFlow,
        lastFlowDate,
        updatedAt,
      ];
}

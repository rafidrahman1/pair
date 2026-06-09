import 'package:equatable/equatable.dart';

class PairCodeEntity extends Equatable {
  const PairCodeEntity({
    required this.code,
    required this.ownerId,
    required this.expiresAt,
    required this.used,
  });

  final String code;
  final String ownerId;
  final DateTime expiresAt;
  final bool used;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isValid => !used && !isExpired;

  @override
  List<Object?> get props => [code, ownerId, expiresAt, used];
}

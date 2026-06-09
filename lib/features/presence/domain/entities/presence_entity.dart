import 'package:equatable/equatable.dart';

class PresenceEntity extends Equatable {
  const PresenceEntity({
    required this.uid,
    required this.online,
    required this.lastSeen,
  });

  final String uid;
  final bool online;
  final DateTime lastSeen;

  @override
  List<Object?> get props => [uid, online, lastSeen];
}

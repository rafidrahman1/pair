import 'package:equatable/equatable.dart';
import 'package:pair/core/constants/app_constants.dart';

class PresenceEntity extends Equatable {
  const PresenceEntity({
    required this.uid,
    required this.online,
    required this.lastSeen,
  });

  final String uid;
  final bool online;
  final DateTime lastSeen;

  /// True only when marked online and the heartbeat is still fresh.
  bool get isEffectivelyOnline =>
      online &&
      DateTime.now().difference(lastSeen) <=
          AppConstants.presenceOfflineThreshold;

  @override
  List<Object?> get props => [uid, online, lastSeen];
}

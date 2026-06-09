import 'package:equatable/equatable.dart';

class TypingEntity extends Equatable {
  const TypingEntity({
    required this.uid,
    required this.isTyping,
    required this.updatedAt,
  });

  final String uid;
  final bool isTyping;
  final DateTime updatedAt;

  bool get isActive {
    if (!isTyping) return false;
    return DateTime.now().difference(updatedAt).inSeconds < 5;
  }

  @override
  List<Object?> get props => [uid, isTyping, updatedAt];
}

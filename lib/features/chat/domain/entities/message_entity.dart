import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.readBy = const {},
    this.isPending = false,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final Map<String, DateTime> readBy;
  final bool isPending;

  bool isReadBy(String userId) => readBy.containsKey(userId);

  MessageEntity copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? createdAt,
    Map<String, DateTime>? readBy,
    bool? isPending,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      readBy: readBy ?? this.readBy,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  List<Object?> get props => [id, senderId, text, createdAt, readBy, isPending];
}

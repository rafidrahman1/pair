import 'package:pair/core/result/result.dart';
import 'package:pair/features/chat/domain/entities/message_entity.dart';
import 'package:pair/features/chat/domain/entities/typing_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> watchMessages({
    required String pairId,
    int limit,
  });

  Future<Result<List<MessageEntity>>> loadMoreMessages({
    required String pairId,
    required DateTime before,
    int limit,
  });

  Future<Result<MessageEntity>> sendMessage({
    required String pairId,
    required String messageId,
    required String senderId,
    required String text,
  });

  Future<Result<void>> markMessagesAsRead({
    required String pairId,
    required String userId,
    required List<String> messageIds,
  });

  Stream<int> watchUnreadCount({
    required String pairId,
    required String userId,
  });

  Future<Result<void>> setTyping({
    required String pairId,
    required String userId,
    required bool isTyping,
  });

  Stream<TypingEntity?> watchSpouseTyping({
    required String pairId,
    required String spouseId,
  });
}

import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:pair/features/chat/domain/entities/message_entity.dart';
import 'package:pair/features/chat/domain/entities/typing_entity.dart';
import 'package:pair/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Stream<List<MessageEntity>> watchMessages({
    required String pairId,
    int limit = 30,
  }) {
    return _dataSource
        .watchMessages(pairId: pairId, limit: limit)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<List<MessageEntity>>> loadMoreMessages({
    required String pairId,
    required DateTime before,
    int limit = 30,
  }) async {
    try {
      final messages = await _dataSource.loadMoreMessages(
        pairId: pairId,
        before: before,
        limit: limit,
      );
      return success(messages.map((m) => m.toEntity()).toList());
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<MessageEntity>> sendMessage({
    required String pairId,
    required String messageId,
    required String senderId,
    required String text,
  }) async {
    try {
      if (text.trim().isEmpty) {
        return failure(const FirestoreFailure('Message cannot be empty'));
      }
      final message = await _dataSource.sendMessage(
        pairId: pairId,
        messageId: messageId,
        senderId: senderId,
        text: text,
      );
      return success(message.toEntity());
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markMessagesAsRead({
    required String pairId,
    required String userId,
    required List<String> messageIds,
  }) async {
    try {
      await _dataSource.markMessagesAsRead(
        pairId: pairId,
        userId: userId,
        messageIds: messageIds,
      );
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<int> watchUnreadCount({
    required String pairId,
    required String userId,
  }) {
    return _dataSource.watchUnreadCount(pairId: pairId, userId: userId);
  }

  @override
  Future<Result<void>> setTyping({
    required String pairId,
    required String userId,
    required bool isTyping,
  }) async {
    try {
      await _dataSource.setTyping(
        pairId: pairId,
        userId: userId,
        isTyping: isTyping,
      );
      return success(null);
    } catch (e) {
      return failure(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<TypingEntity?> watchSpouseTyping({
    required String pairId,
    required String spouseId,
  }) {
    return _dataSource.watchSpouseTyping(
      pairId: pairId,
      spouseId: spouseId,
    );
  }
}

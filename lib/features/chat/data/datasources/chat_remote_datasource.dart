import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/chat/data/models/message_model.dart';
import 'package:pair/features/chat/domain/entities/typing_entity.dart';
class ChatRemoteDataSource {
  ChatRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messagesRef(String pairId) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.messagesSubcollection);
  }

  DocumentReference<Map<String, dynamic>> _readStatusRef(
    String pairId,
    String userId,
  ) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.readStatusSubcollection)
        .doc(userId);
  }

  DocumentReference<Map<String, dynamic>> _typingRef(
    String pairId,
    String userId,
  ) {
    return _firestore
        .collection(AppConstants.pairsCollection)
        .doc(pairId)
        .collection(AppConstants.typingSubcollection)
        .doc(userId);
  }

  Stream<List<MessageModel>> watchMessages({
    required String pairId,
    int limit = AppConstants.chatPageSize,
  }) {
    return _messagesRef(pairId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(MessageModel.fromFirestore)
              .toList(),
        );
  }

  Future<List<MessageModel>> loadMoreMessages({
    required String pairId,
    required DateTime before,
    int limit = AppConstants.chatPageSize,
  }) async {
    final snapshot = await _messagesRef(pairId)
        .orderBy('createdAt', descending: true)
        .where('createdAt', isLessThan: Timestamp.fromDate(before))
        .limit(limit)
        .get();

    return snapshot.docs.map(MessageModel.fromFirestore).toList();
  }

  Future<MessageModel> sendMessage({
    required String pairId,
    required String messageId,
    required String senderId,
    required String text,
  }) async {
    final now = DateTime.now();
    final message = MessageModel(
      id: messageId,
      senderId: senderId,
      text: text.trim(),
      createdAt: now,
      readBy: {senderId: now},
    );

    await _messagesRef(pairId).doc(messageId).set(message.toFirestore());
    return message;
  }

  Future<void> markMessagesAsRead({
    required String pairId,
    required String userId,
    required List<String> messageIds,
  }) async {
    if (messageIds.isEmpty) return;

    final batch = _firestore.batch();
    final now = Timestamp.now();

    for (final messageId in messageIds) {
      final ref = _messagesRef(pairId).doc(messageId);
      batch.update(ref, {
        'readBy.$userId': now,
      });
    }

    batch.set(
      _readStatusRef(pairId, userId),
      {
        'lastReadAt': now,
        'uid': userId,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Stream<int> watchUnreadCount({
    required String pairId,
    required String userId,
  }) {
    return _readStatusRef(pairId, userId).snapshots().asyncMap((readDoc) async {
      final lastReadAt = readDoc.data()?['lastReadAt'] as Timestamp?;
      final query = _messagesRef(pairId)
          .where('senderId', isNotEqualTo: userId);

      if (lastReadAt != null) {
        final unread = await query
            .where('createdAt', isGreaterThan: lastReadAt)
            .count()
            .get();
        return unread.count ?? 0;
      }

      final unread = await query.count().get();
      return unread.count ?? 0;
    });
  }

  Future<void> setTyping({
    required String pairId,
    required String userId,
    required bool isTyping,
  }) async {
    await _typingRef(pairId, userId).set({
      'uid': userId,
      'isTyping': isTyping,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<TypingEntity?> watchSpouseTyping({
    required String pairId,
    required String spouseId,
  }) {
    return _typingRef(pairId, spouseId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      return TypingEntity(
        uid: spouseId,
        isTyping: data['isTyping'] as bool? ?? false,
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    });
  }
}

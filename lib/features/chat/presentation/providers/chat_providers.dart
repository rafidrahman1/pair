import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:pair/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:pair/features/chat/data/services/chat_notification_service.dart';
import 'package:pair/features/notifications/presentation/providers/notification_providers.dart';
import 'package:pair/features/chat/domain/entities/message_entity.dart';
import 'package:pair/features/chat/domain/entities/typing_entity.dart';
import 'package:pair/features/chat/domain/repositories/chat_repository.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';
import 'package:uuid/uuid.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(ref.watch(firestoreProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider));
});

final messagesStreamProvider = StreamProvider<List<MessageEntity>>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value([]);
  }

  return ref.watch(chatRepositoryProvider).watchMessages(pairId: pair.id);
});

final unreadCountProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value(0);
  }

  return ref.watch(chatRepositoryProvider).watchUnreadCount(
        pairId: pair.id,
        userId: user.uid,
      );
});

final spouseTypingProvider = StreamProvider<TypingEntity?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value(null);
  }

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return Stream.value(null);

  return ref.watch(chatRepositoryProvider).watchSpouseTyping(
        pairId: pair.id,
        spouseId: spouseId,
      );
});

class ChatController extends StateNotifier<AsyncValue<List<MessageEntity>>> {
  ChatController(this._ref) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  final Ref _ref;
  StreamSubscription<List<MessageEntity>>? _subscription;
  final List<MessageEntity> _optimisticMessages = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;

  void _subscribe() {
    _subscription?.cancel();
    final user = _ref.read(currentUserStreamProvider).valueOrNull;
    final pair = _ref.read(currentPairProvider).valueOrNull;

    if (user == null || pair == null) {
      state = const AsyncValue.data([]);
      return;
    }

    _subscription = _ref
        .read(chatRepositoryProvider)
        .watchMessages(pairId: pair.id)
        .listen(
      (messages) {
        final merged = _mergeWithOptimistic(messages);
        state = AsyncValue.data(merged);
        _markUnreadAsRead(user.uid, pair.id, merged);
      },
      onError: (Object error, StackTrace stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  List<MessageEntity> _mergeWithOptimistic(List<MessageEntity> serverMessages) {
    final serverIds = serverMessages.map((m) => m.id).toSet();
    _optimisticMessages.removeWhere(
      (m) => serverIds.contains(m.id) || !m.isPending,
    );
    return [..._optimisticMessages, ...serverMessages];
  }

  void _applyOptimisticState() {
    final serverMessages =
        (state.valueOrNull ?? []).where((m) => !m.isPending).toList();
    state = AsyncValue.data(_mergeWithOptimistic(serverMessages));
  }

  Future<void> _markUnreadAsRead(
    String userId,
    String pairId,
    List<MessageEntity> messages,
  ) async {
    final unreadIds = messages
        .where((m) => m.senderId != userId && !m.isReadBy(userId))
        .map((m) => m.id)
        .toList();

    if (unreadIds.isEmpty) return;

    await _ref.read(chatRepositoryProvider).markMessagesAsRead(
          pairId: pairId,
          userId: userId,
          messageIds: unreadIds,
        );
  }

  Future<void> sendMessage(String text) async {
    final user = _ref.read(currentUserStreamProvider).valueOrNull;
    final pair = _ref.read(currentPairProvider).valueOrNull;
    if (user == null || pair == null || text.trim().isEmpty) return;

    final messageId = const Uuid().v4();
    final optimistic = MessageEntity(
      id: messageId,
      senderId: user.uid,
      text: text.trim(),
      createdAt: DateTime.now(),
      readBy: {user.uid: DateTime.now()},
      isPending: true,
    );

    _optimisticMessages.insert(0, optimistic);
    _applyOptimisticState();

    final result = await _ref.read(chatRepositoryProvider).sendMessage(
          pairId: pair.id,
          messageId: messageId,
          senderId: user.uid,
          text: text,
        );

    result.fold(
      (failure) {
        _optimisticMessages.removeWhere((m) => m.id == messageId);
        _applyOptimisticState();
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Firestore stream will replace the optimistic message once delivered.
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    final pair = _ref.read(currentPairProvider).valueOrNull;
    final messages = state.valueOrNull;
    if (pair == null || messages == null || messages.isEmpty) return;

    _isLoadingMore = true;
    final oldest = messages.last;

    final result = await _ref.read(chatRepositoryProvider).loadMoreMessages(
          pairId: pair.id,
          before: oldest.createdAt,
          limit: AppConstants.chatPageSize,
        );

    result.fold(
      (_) {},
      (older) {
        if (older.length < AppConstants.chatPageSize) {
          _hasMore = false;
        }
        state = AsyncValue.data([...state.valueOrNull!, ...older]);
      },
    );
    _isLoadingMore = false;
  }

  Timer? _typingTimer;

  void onTypingChanged(String text) {
    final user = _ref.read(currentUserStreamProvider).valueOrNull;
    final pair = _ref.read(currentPairProvider).valueOrNull;
    if (user == null || pair == null) return;

    _ref.read(chatRepositoryProvider).setTyping(
          pairId: pair.id,
          userId: user.uid,
          isTyping: text.isNotEmpty,
        );

    _typingTimer?.cancel();
    if (text.isNotEmpty) {
      _typingTimer = Timer(AppConstants.typingIndicatorTimeout, () {
        _ref.read(chatRepositoryProvider).setTyping(
              pairId: pair.id,
              userId: user.uid,
              isTyping: false,
            );
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, AsyncValue<List<MessageEntity>>>(
  ChatController.new,
);

/// True while the chat screen is visible (suppresses local message notifications).
final chatScreenActiveProvider = StateProvider<bool>((ref) => false);

final chatNotificationServiceProvider =
    Provider<ChatNotificationService?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return null;
  }

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return null;

  return ChatNotificationService(
    repository: ref.watch(chatRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
    authDataSource: ref.watch(authRemoteDataSourceProvider),
    pairId: pair.id,
    spouseId: spouseId,
    isChatScreenActive: () => ref.read(chatScreenActiveProvider),
  );
});

/// Notifies the user when their spouse sends a chat message.
final chatNotificationLifecycleProvider = Provider<void>((ref) {
  ref.watch(notificationInitProvider);
  final service = ref.watch(chatNotificationServiceProvider);
  if (service == null) return;

  service.start();
  ref.onDispose(service.stop);
});

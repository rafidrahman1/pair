import 'dart:async';

import 'package:pair/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pair/features/chat/domain/entities/message_entity.dart';
import 'package:pair/features/chat/domain/repositories/chat_repository.dart';
import 'package:pair/features/notifications/data/services/notification_service.dart';

class ChatNotificationService {
  ChatNotificationService({
    required ChatRepository repository,
    required NotificationService notificationService,
    required AuthRemoteDataSource authDataSource,
    required String pairId,
    required String spouseId,
    required bool Function() isChatScreenActive,
  })  : _repository = repository,
        _notificationService = notificationService,
        _authDataSource = authDataSource,
        _pairId = pairId,
        _spouseId = spouseId,
        _isChatScreenActive = isChatScreenActive;

  final ChatRepository _repository;
  final NotificationService _notificationService;
  final AuthRemoteDataSource _authDataSource;
  final String _pairId;
  final String _spouseId;
  final bool Function() _isChatScreenActive;

  StreamSubscription<List<MessageEntity>>? _subscription;
  final Set<String> _knownMessageIds = {};
  bool _isInitialSnapshot = true;
  bool _running = false;

  Future<void> start() async {
    if (_running) return;
    _running = true;

    _subscription = _repository.watchMessages(pairId: _pairId).listen(
      _handleMessagesUpdate,
      onError: (Object error) {
        // Keep listening after transient stream errors.
      },
    );
  }

  Future<void> stop() async {
    if (!_running) return;
    _running = false;

    await _subscription?.cancel();
    _subscription = null;
    _knownMessageIds.clear();
    _isInitialSnapshot = true;
  }

  Future<void> _handleMessagesUpdate(List<MessageEntity> messages) async {
    if (_isInitialSnapshot) {
      _knownMessageIds.addAll(messages.map((message) => message.id));
      _isInitialSnapshot = false;
      return;
    }

    if (_isChatScreenActive()) {
      _knownMessageIds.addAll(messages.map((message) => message.id));
      return;
    }

    final newMessages = messages.where(
      (message) =>
          !_knownMessageIds.contains(message.id) &&
          message.senderId == _spouseId,
    );

    for (final message in newMessages) {
      _knownMessageIds.add(message.id);
      await _notifyForMessage(message);
    }

    _knownMessageIds.addAll(
      messages
          .map((message) => message.id)
          .where((id) => !_knownMessageIds.contains(id)),
    );
  }

  Future<void> _notifyForMessage(MessageEntity message) async {
    final spouseDoc = await _authDataSource.getUserDocument(_spouseId);
    final spouseName = spouseDoc?.displayName ?? 'Your spouse';
    final preview = message.text.length > 100
        ? '${message.text.substring(0, 100)}...'
        : message.text;

    await _notificationService.notifyNewMessage(
      senderName: spouseName,
      messagePreview: preview,
      pairId: _pairId,
      messageId: message.id,
    );
  }
}

import 'dart:async';

import 'package:pair/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';
import 'package:pair/features/grocery/domain/repositories/grocery_repository.dart';
import 'package:pair/features/notifications/data/services/notification_service.dart';

class GroceryNotificationService {
  GroceryNotificationService({
    required GroceryRepository repository,
    required NotificationService notificationService,
    required AuthRemoteDataSource authDataSource,
    required String pairId,
    required String userId,
    required String spouseId,
  })  : _repository = repository,
        _notificationService = notificationService,
        _authDataSource = authDataSource,
        _pairId = pairId,
        _userId = userId,
        _spouseId = spouseId;

  final GroceryRepository _repository;
  final NotificationService _notificationService;
  final AuthRemoteDataSource _authDataSource;
  final String _pairId;
  final String _userId;
  final String _spouseId;

  StreamSubscription<List<GroceryItemEntity>>? _subscription;
  final Set<String> _knownItemIds = {};
  bool _isInitialSnapshot = true;
  bool _running = false;

  Future<void> start() async {
    if (_running) return;
    _running = true;

    _subscription = _repository.watchItems(pairId: _pairId).listen(
      _handleItemsUpdate,
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
    _knownItemIds.clear();
    _isInitialSnapshot = true;
  }

  Future<void> _handleItemsUpdate(List<GroceryItemEntity> items) async {
    if (_isInitialSnapshot) {
      _knownItemIds.addAll(items.map((item) => item.id));
      _isInitialSnapshot = false;
      return;
    }

    final newItems = items.where(
      (item) =>
          !_knownItemIds.contains(item.id) && item.addedBy != _userId,
    );

    for (final item in newItems) {
      _knownItemIds.add(item.id);
      await _notifyForItem(item);
    }

    _knownItemIds.addAll(
      items.map((item) => item.id).where((id) => !_knownItemIds.contains(id)),
    );
  }

  Future<void> _notifyForItem(GroceryItemEntity item) async {
    final spouseDoc = await _authDataSource.getUserDocument(_spouseId);
    final spouseName = spouseDoc?.displayName ?? 'Your spouse';

    await _notificationService.notifyNewGroceryItem(
      senderName: spouseName,
      itemText: item.text,
      pairId: _pairId,
      itemId: item.id,
    );
  }
}

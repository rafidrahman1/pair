import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/grocery/data/datasources/grocery_remote_datasource.dart';
import 'package:pair/features/grocery/data/repositories/grocery_repository_impl.dart';
import 'package:pair/features/grocery/data/services/grocery_notification_service.dart';
import 'package:pair/features/notifications/presentation/providers/notification_providers.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';
import 'package:pair/features/grocery/domain/repositories/grocery_repository.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';
import 'package:uuid/uuid.dart';

final groceryRemoteDataSourceProvider = Provider<GroceryRemoteDataSource>((ref) {
  return GroceryRemoteDataSource(ref.watch(firestoreProvider));
});

final groceryRepositoryProvider = Provider<GroceryRepository>((ref) {
  return GroceryRepositoryImpl(ref.watch(groceryRemoteDataSourceProvider));
});

final groceryItemsStreamProvider =
    StreamProvider<List<GroceryItemEntity>>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value([]);
  }

  return ref.watch(groceryRepositoryProvider).watchItems(pairId: pair.id);
});

final groceryUncheckedCountProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) {
    return Stream.value(0);
  }

  return ref
      .watch(groceryRepositoryProvider)
      .watchUncheckedCount(pairId: pair.id);
});

class GroceryController
    extends StateNotifier<AsyncValue<List<GroceryItemEntity>>> {
  GroceryController(this._ref) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  final Ref _ref;
  StreamSubscription<List<GroceryItemEntity>>? _subscription;
  final List<GroceryItemEntity> _optimisticItems = [];

  void _subscribe() {
    _subscription?.cancel();
    final user = _ref.read(currentUserStreamProvider).valueOrNull;
    final pair = _ref.read(currentPairProvider).valueOrNull;

    if (user == null || pair == null) {
      state = const AsyncValue.data([]);
      return;
    }

    _subscription = _ref
        .read(groceryRepositoryProvider)
        .watchItems(pairId: pair.id)
        .listen(
      (items) {
        final merged = _mergeWithOptimistic(items);
        state = AsyncValue.data(merged);
      },
      onError: (Object error, StackTrace stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  List<GroceryItemEntity> _mergeWithOptimistic(
    List<GroceryItemEntity> serverItems,
  ) {
    final serverIds = serverItems.map((item) => item.id).toSet();
    _optimisticItems.removeWhere(
      (item) => serverIds.contains(item.id) || !item.isPending,
    );
    return _sortItems([..._optimisticItems, ...serverItems]);
  }

  List<GroceryItemEntity> _sortItems(List<GroceryItemEntity> items) {
    final sorted = [...items];
    sorted.sort((a, b) {
      if (a.isChecked != b.isChecked) {
        return a.isChecked ? 1 : -1;
      }
      return a.createdAt.compareTo(b.createdAt);
    });
    return sorted;
  }

  void _applyOptimisticState() {
    final serverItems =
        (state.valueOrNull ?? []).where((item) => !item.isPending).toList();
    state = AsyncValue.data(_mergeWithOptimistic(serverItems));
  }

  Future<void> addItem(String text) async {
    final user = _ref.read(currentUserStreamProvider).valueOrNull;
    final pair = _ref.read(currentPairProvider).valueOrNull;
    if (user == null || pair == null || text.trim().isEmpty) return;

    final itemId = const Uuid().v4();
    final now = DateTime.now();
    final optimistic = GroceryItemEntity(
      id: itemId,
      text: text.trim(),
      isChecked: false,
      addedBy: user.uid,
      createdAt: now,
      updatedAt: now,
      isPending: true,
    );

    _optimisticItems.insert(0, optimistic);
    _applyOptimisticState();

    final result = await _ref.read(groceryRepositoryProvider).addItem(
          pairId: pair.id,
          itemId: itemId,
          addedBy: user.uid,
          text: text,
        );

    result.fold(
      (failure) {
        _optimisticItems.removeWhere((item) => item.id == itemId);
        _applyOptimisticState();
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {},
    );
  }

  Future<void> toggleItem(GroceryItemEntity item) async {
    final user = _ref.read(currentUserStreamProvider).valueOrNull;
    final pair = _ref.read(currentPairProvider).valueOrNull;
    if (user == null || pair == null || item.isPending) return;

    final newChecked = !item.isChecked;
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(
      _sortItems(
        current.map((existing) {
          if (existing.id != item.id) return existing;
          return existing.copyWith(
            isChecked: newChecked,
            checkedBy: newChecked ? user.uid : null,
            updatedAt: DateTime.now(),
          );
        }).toList(),
      ),
    );

    final result = await _ref.read(groceryRepositoryProvider).toggleItem(
          pairId: pair.id,
          itemId: item.id,
          userId: user.uid,
          isChecked: newChecked,
        );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {},
    );
  }

  Future<void> deleteItem(GroceryItemEntity item) async {
    final pair = _ref.read(currentPairProvider).valueOrNull;
    if (pair == null) return;

    if (item.isPending) {
      _optimisticItems.removeWhere((existing) => existing.id == item.id);
      _applyOptimisticState();
      return;
    }

    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(
      current.where((existing) => existing.id != item.id).toList(),
    );

    final result = await _ref.read(groceryRepositoryProvider).deleteItem(
          pairId: pair.id,
          itemId: item.id,
        );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {},
    );
  }

  Future<void> clearCheckedItems() async {
    final pair = _ref.read(currentPairProvider).valueOrNull;
    if (pair == null) return;

    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(
      current.where((item) => !item.isChecked).toList(),
    );

    final result = await _ref
        .read(groceryRepositoryProvider)
        .clearCheckedItems(pairId: pair.id);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {},
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final groceryControllerProvider = StateNotifierProvider<GroceryController,
    AsyncValue<List<GroceryItemEntity>>>(
  GroceryController.new,
);

final groceryNotificationServiceProvider =
    Provider<GroceryNotificationService?>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null || !user.isPaired) {
    return null;
  }

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return null;

  return GroceryNotificationService(
    repository: ref.watch(groceryRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
    authDataSource: ref.watch(authRemoteDataSourceProvider),
    pairId: pair.id,
    userId: user.uid,
    spouseId: spouseId,
  );
});

/// Notifies the user when their spouse adds grocery items.
final groceryNotificationLifecycleProvider = Provider<void>((ref) {
  ref.watch(notificationInitProvider);
  final service = ref.watch(groceryNotificationServiceProvider);
  if (service == null) return;

  service.start();
  ref.onDispose(service.stop);
});

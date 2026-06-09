import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/providers/firebase_providers.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/notifications/data/services/foreground_notification_service.dart';
import 'package:pair/features/notifications/data/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    messaging: ref.watch(firebaseMessagingProvider),
    authRepository: ref.watch(authRepositoryProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final foregroundNotificationServiceProvider =
    Provider<ForegroundNotificationService>((ref) {
  return ForegroundNotificationService();
});

final notificationInitProvider = FutureProvider<void>((ref) async {
  await ref.watch(notificationServiceProvider).initialize();
});

/// Starts a persistent foreground notification while signed in so the app stays alive.
final foregroundNotificationLifecycleProvider = Provider<void>((ref) {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final service = ref.watch(foregroundNotificationServiceProvider);

  if (user == null || !user.hasRole) {
    service.stop();
    return;
  }

  service.start();
});

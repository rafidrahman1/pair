import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const notificationChannelId = 'pair_notifications';
const notificationChannelName = 'Pair Notifications';

final FlutterLocalNotificationsPlugin _backgroundNotifications =
    FlutterLocalNotificationsPlugin();

bool _backgroundNotificationsInitialized = false;

Future<void> ensureBackgroundNotificationsInitialized() async {
  if (_backgroundNotificationsInitialized) return;

  const androidSettings =
      AndroidInitializationSettings('@drawable/ic_notification');
  const settings = InitializationSettings(
    android: androidSettings,
    iOS: DarwinInitializationSettings(),
  );

  await _backgroundNotifications.initialize(settings);

  const androidChannel = AndroidNotificationChannel(
    notificationChannelId,
    notificationChannelName,
    description: 'Notifications for Pair app',
    importance: Importance.high,
  );

  await _backgroundNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  _backgroundNotificationsInitialized = true;
}

Future<void> showNotificationFromRemoteMessage(RemoteMessage message) async {
  await ensureBackgroundNotificationsInitialized();

  final data = message.data;
  final notification = message.notification;

  final title = notification?.title ?? data['title'] ?? 'Pair';
  final body = notification?.body ?? data['body'] ?? '';
  if (body.isEmpty) return;

  final stableId = data['messageId'] ??
      data['itemId'] ??
      message.messageId ??
      DateTime.now().millisecondsSinceEpoch.toString();

  const androidDetails = AndroidNotificationDetails(
    notificationChannelId,
    notificationChannelName,
    importance: Importance.high,
    priority: Priority.high,
    icon: '@drawable/ic_notification',
  );
  const details = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await _backgroundNotifications.show(
    stableId.hashCode,
    title,
    body,
    details,
    payload: jsonEncode(data),
  );
}

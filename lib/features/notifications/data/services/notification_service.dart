import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';
import 'package:pair/features/notifications/data/services/notification_background.dart';

enum NotificationType {
  newMessage,
  newGroceryItem,
  pairAccepted,
  spouseOnline,
  spouseNearby,
}

class NotificationService {
  NotificationService({
    required FirebaseMessaging messaging,
    required AuthRepository authRepository,
    required FirebaseFirestore firestore,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging,
        _authRepository = authRepository,
        _firestore = firestore,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static const _channelId = notificationChannelId;
  static const _channelName = notificationChannelName;
  static const _dedupeWindow = Duration(seconds: 10);

  final Map<String, DateTime> _recentNotificationKeys = {};

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _messaging.requestPermission();

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications for Pair app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    final token = await _messaging.getToken();
    if (token != null) {
      await _authRepository.updateFcmToken(token);
    }

    _messaging.onTokenRefresh.listen((token) {
      _authRepository.updateFcmToken(token);
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final dedupeKey = _dedupeKeyForMessage(message.data);
    showLocalNotification(
      title: notification.title ?? 'Pair',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
      dedupeKey: dedupeKey,
    );
  }

  void _handleMessageOpened(RemoteMessage message) {
    debugPrint('Message opened: ${message.data}');
  }

  bool _shouldSkipDuplicate(String dedupeKey) {
    final lastShown = _recentNotificationKeys[dedupeKey];
    if (lastShown == null) return false;

    return DateTime.now().difference(lastShown) < _dedupeWindow;
  }

  void _markNotificationShown(String dedupeKey) {
    _recentNotificationKeys[dedupeKey] = DateTime.now();
    _recentNotificationKeys.removeWhere(
      (_, shownAt) => DateTime.now().difference(shownAt) > _dedupeWindow,
    );
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String? dedupeKey,
  }) async {
    if (dedupeKey != null && _shouldSkipDuplicate(dedupeKey)) return;
    if (dedupeKey != null) _markNotificationShown(dedupeKey);

    await _showLocalNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> sendToUser({
    required String recipientUid,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final userDoc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(recipientUid)
        .get();

    final token = userDoc.data()?['fcmToken'] as String?;
    if (token == null) return;

  }

  Future<void> notifyNewMessage({
    required String senderName,
    required String messagePreview,
    required String pairId,
    required String messageId,
  }) async {
    await showLocalNotification(
      title: senderName,
      body: messagePreview,
      payload: jsonEncode({
        'type': 'new_message',
        'pairId': pairId,
        'messageId': messageId,
      }),
      dedupeKey: 'message_$messageId',
    );
  }

  Future<void> notifyPairAccepted({
    required String recipientUid,
    required String spouseName,
    required String pairId,
  }) async {
    await sendToUser(
      recipientUid: recipientUid,
      type: NotificationType.pairAccepted,
      title: 'You are now paired!',
      body: '$spouseName accepted your pairing request',
      data: {
        'type': 'pair_accepted',
        'pairId': pairId,
      },
    );
  }

  String? _dedupeKeyForMessage(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    if (type == 'new_grocery_item') {
      final itemId = data['itemId'] as String?;
      if (itemId != null) return 'grocery_$itemId';
    }
    if (type == 'new_message') {
      final messageId = data['messageId'] as String?;
      if (messageId != null) return 'message_$messageId';
    }
    return null;
  }

  Future<void> notifyNewGroceryItem({
    required String senderName,
    required String itemText,
    required String pairId,
    required String itemId,
  }) async {
    await showLocalNotification(
      title: senderName,
      body: 'Added "$itemText" to the grocery list',
      payload: jsonEncode({
        'type': 'new_grocery_item',
        'pairId': pairId,
        'itemId': itemId,
      }),
      dedupeKey: 'grocery_$itemId',
    );
  }

  Future<void> notifySpouseNearby({
    required String spouseName,
    required String distanceText,
    required String pairId,
  }) async {
    await showLocalNotification(
      title: '$spouseName is nearby',
      body: 'You are within $distanceText of each other',
      payload: jsonEncode({
        'type': 'spouse_nearby',
        'pairId': pairId,
      }),
    );
  }

  Future<void> notifySpouseOnline({
    required String recipientUid,
    required String spouseName,
    required String pairId,
  }) async {
    await sendToUser(
      recipientUid: recipientUid,
      type: NotificationType.spouseOnline,
      title: spouseName,
      body: 'is now online',
      data: {
        'type': 'spouse_online',
        'pairId': pairId,
      },
    );
  }
}

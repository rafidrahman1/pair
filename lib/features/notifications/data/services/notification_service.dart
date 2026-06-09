import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

enum NotificationType {
  newMessage,
  pairAccepted,
  spouseOnline,
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

  static const _channelId = 'pair_notifications';
  static const _channelName = 'Pair Notifications';

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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

    _showLocalNotification(
      title: notification.title ?? 'Pair',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageOpened(RemoteMessage message) {
    debugPrint('Message opened: ${message.data}');
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
    required String recipientUid,
    required String senderName,
    required String messagePreview,
    required String pairId,
  }) async {
    await sendToUser(
      recipientUid: recipientUid,
      type: NotificationType.newMessage,
      title: senderName,
      body: messagePreview,
      data: {
        'type': 'new_message',
        'pairId': pairId,
      },
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

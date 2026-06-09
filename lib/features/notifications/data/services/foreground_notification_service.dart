import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pair/features/notifications/data/services/pair_foreground_task_handler.dart';

class ForegroundNotificationService {
  static const _serviceId = 1001;
  static const _channelId = 'pair_foreground_service';
  static const _channelName = 'Pair Background Service';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _channelId,
        channelName: _channelName,
        channelDescription:
            'Keeps Pair running so you can receive messages and updates.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    _initialized = true;
  }

  Future<void> start() async {
    if (!Platform.isAndroid) return;

    await initialize();
    await _requestAndroidPermissions();

    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
      return;
    }

    final result = await FlutterForegroundTask.startService(
      serviceId: _serviceId,
      serviceTypes: const [ForegroundServiceTypes.remoteMessaging],
      notificationTitle: 'Pair is active',
      notificationText: 'Listening for messages and updates from your spouse',
      notificationIcon: null,
      notificationInitialRoute: '/',
      callback: pairForegroundTaskCallback,
    );

    if (result is ServiceRequestFailure) {
      debugPrint('Failed to start foreground service: ${result.error}');
    }
  }

  Future<void> stop() async {
    if (!Platform.isAndroid) return;
    if (!await FlutterForegroundTask.isRunningService) return;

    await FlutterForegroundTask.stopService();
  }

  Future<void> _requestAndroidPermissions() async {
    final notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }
}

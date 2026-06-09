import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const restoreForegroundServiceCommand = 'restore_foreground_service';

const foregroundNotificationTitle = 'Pair is active';
const foregroundNotificationText =
    'Staying connected so you never miss a message';
const foregroundNotificationIcon = NotificationIcon(
  metaDataName: 'com.redpanda.pair.service.NOTIFICATION_ICON',
);

@pragma('vm:entry-point')
void pairForegroundTaskCallback() {
  FlutterForegroundTask.setTaskHandler(PairForegroundTaskHandler());
}

class PairForegroundTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Re-assert the ongoing notification so OEMs cannot silently drop it.
    FlutterForegroundTask.updateService(
      notificationTitle: foregroundNotificationTitle,
      notificationText: foregroundNotificationText,
      notificationIcon: foregroundNotificationIcon,
    );
    FlutterForegroundTask.sendDataToMain(restoreForegroundServiceCommand);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }

  @override
  void onNotificationDismissed() {
    // Android 14+ lets users swipe away FGS notifications, which stops the
    // service. Re-post immediately and ask the main isolate to restart.
    FlutterForegroundTask.updateService(
      notificationTitle: foregroundNotificationTitle,
      notificationText: foregroundNotificationText,
      notificationIcon: foregroundNotificationIcon,
    );
    FlutterForegroundTask.sendDataToMain(restoreForegroundServiceCommand);
  }
}

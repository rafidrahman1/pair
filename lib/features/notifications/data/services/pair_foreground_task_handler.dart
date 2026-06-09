import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const restoreForegroundServiceCommand = 'restore_foreground_service';

// Minimal content keeps the required FGS notification out of the status bar.
const foregroundNotificationTitle = '\u200B';
const foregroundNotificationText = '\u200B';
const foregroundNotificationIcon = NotificationIcon(
  metaDataName: 'com.redpanda.pair.service.NOTIFICATION_ICON_SILENT',
);

@pragma('vm:entry-point')
void pairForegroundTaskCallback() {
  FlutterForegroundTask.setTaskHandler(PairForegroundTaskHandler());
}

class PairForegroundTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

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

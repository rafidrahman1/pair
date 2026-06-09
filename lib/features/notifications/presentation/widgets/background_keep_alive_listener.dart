import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/features/notifications/presentation/providers/notification_providers.dart';

/// Keeps the foreground service and notification permissions active app-wide.
class BackgroundKeepAliveListener extends ConsumerStatefulWidget {
  const BackgroundKeepAliveListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BackgroundKeepAliveListener> createState() =>
      _BackgroundKeepAliveListenerState();
}

class _BackgroundKeepAliveListenerState
    extends ConsumerState<BackgroundKeepAliveListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationInitProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(foregroundNotificationServiceProvider).start();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(foregroundNotificationLifecycleProvider);
    return widget.child;
  }
}

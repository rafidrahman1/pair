import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/chat/presentation/providers/chat_providers.dart';
import 'package:pair/features/grocery/presentation/providers/grocery_providers.dart';
import 'package:pair/features/health/presentation/providers/period_providers.dart';
import 'package:pair/features/location/presentation/providers/location_providers.dart';
import 'package:pair/features/notifications/presentation/providers/notification_providers.dart';
import 'package:pair/features/presence/presentation/providers/presence_providers.dart';
import 'package:pair/router/route_paths.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationInitProvider);
    });
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case RoutePaths.home:
        return 0;
      case RoutePaths.chat:
        return 1;
      case RoutePaths.profile:
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(presenceServiceLifecycleProvider);
    ref.watch(locationServiceLifecycleProvider);
    ref.watch(groceryNotificationLifecycleProvider);
    ref.watch(chatNotificationLifecycleProvider);
    ref.watch(foregroundNotificationLifecycleProvider);
    ref.watch(periodSyncLifecycleProvider);

    final user = ref.watch(currentUserStreamProvider).valueOrNull;
    final showNav = user?.isPaired ?? false;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: showNav
          ? NavigationBar(
              selectedIndex: _selectedIndex(context),
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go(RoutePaths.home);
                  case 1:
                    context.go(RoutePaths.chat);
                  case 2:
                    context.go(RoutePaths.profile);
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble),
                  label: 'Chat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }
}

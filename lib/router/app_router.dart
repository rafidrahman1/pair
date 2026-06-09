import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/auth/presentation/screens/login_screen.dart';
import 'package:pair/features/auth/presentation/screens/splash_screen.dart';
import 'package:pair/features/chat/presentation/screens/chat_screen.dart';
import 'package:pair/features/grocery/presentation/screens/grocery_screen.dart';
import 'package:pair/features/home/presentation/screens/home_screen.dart';
import 'package:pair/features/home/presentation/screens/main_shell.dart';
import 'package:pair/features/pairing/presentation/screens/pairing_screen.dart';
import 'package:pair/features/profile/presentation/screens/profile_screen.dart';
import 'package:pair/router/route_paths.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefresh(ref);

  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final streamAuth = ref.read(currentUserStreamProvider);
      final controllerAuth = ref.read(authControllerProvider);

      final user = streamAuth.valueOrNull ?? controllerAuth.valueOrNull;
      final isLoading = streamAuth.isLoading || controllerAuth.isLoading;
      final isAuthenticated = user != null;
      final location = state.matchedLocation;

      if (isLoading && location != RoutePaths.splash) {
        return RoutePaths.splash;
      }

      if (!isLoading) {
        final isSplash = location == RoutePaths.splash;
        final isLogin = location == RoutePaths.login;

        if (!isAuthenticated && !isLogin) {
          return RoutePaths.login;
        }

        if (isAuthenticated && !user.hasRole && !isLogin) {
          return RoutePaths.login;
        }

        if (isAuthenticated && user.hasRole && (isLogin || isSplash)) {
          return RoutePaths.home;
        }

        if (isAuthenticated &&
            !user.isPaired &&
            location != RoutePaths.pairing &&
            location != RoutePaths.profile &&
            location != RoutePaths.home) {
          return RoutePaths.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (context, state) => _fadePage(state, const HomeScreen()),
          ),
          GoRoute(
            path: RoutePaths.chat,
            pageBuilder: (context, state) => _fadePage(state, const ChatScreen()),
          ),
          GoRoute(
            path: RoutePaths.grocery,
            pageBuilder: (context, state) =>
                _fadePage(state, const GroceryScreen()),
          ),
          GoRoute(
            path: RoutePaths.profile,
            pageBuilder: (context, state) =>
                _fadePage(state, const ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.pairing,
        pageBuilder: (context, state) =>
            _fadePage(state, const PairingScreen()),
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _ref.listen(currentUserStreamProvider, (_, _) => notifyListeners());
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}

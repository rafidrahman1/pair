import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pair/core/theme/app_theme.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/router/route_paths.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  void _navigate(BuildContext context, AsyncValue<UserEntity?> authState) {
    if (!context.mounted) return;

    authState.when(
      loading: () {},
      error: (_, _) => context.go(RoutePaths.login),
      data: (user) {
        if (user != null) {
          context.go(RoutePaths.home);
        } else {
          context.go(RoutePaths.login);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamAuth = ref.watch(currentUserStreamProvider);
    final controllerAuth = ref.watch(authControllerProvider);
    final isLoading = streamAuth.isLoading && controllerAuth.isLoading;
    final resolvedUser = streamAuth.valueOrNull ?? controllerAuth.valueOrNull;

    ref.listen(currentUserStreamProvider, (previous, next) {
      if (next.isLoading) return;
      _navigate(context, next);
    });
    ref.listen(authControllerProvider, (previous, next) {
      if (next.isLoading) return;
      _navigate(context, next);
    });

    if (!isLoading && resolvedUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RoutePaths.home);
      });
    } else if (!isLoading && resolvedUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RoutePaths.login);
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.favorite,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pair',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stay connected with your spouse',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 48),
            if (streamAuth.hasError && controllerAuth.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Could not connect to Firebase.\nCheck your setup and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

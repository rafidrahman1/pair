import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/theme/app_theme.dart';
import 'package:pair/features/notifications/presentation/widgets/background_keep_alive_listener.dart';
import 'package:pair/router/app_router.dart';

class PairApp extends ConsumerWidget {
  const PairApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return BackgroundKeepAliveListener(
      child: MaterialApp.router(
        title: 'Pair',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}

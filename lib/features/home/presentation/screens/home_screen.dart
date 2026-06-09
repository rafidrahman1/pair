import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pair/core/constants/app_constants.dart';
import 'package:pair/core/theme/app_theme.dart';
import 'package:pair/core/utils/date_formatter.dart';
import 'package:pair/core/utils/distance_calculator.dart';
import 'package:pair/core/widgets/skeleton_loader.dart';
import 'package:pair/features/auth/domain/entities/user_role.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/health/domain/entities/period_data_entity.dart';
import 'package:pair/features/health/presentation/providers/period_providers.dart';
import 'package:pair/features/chat/presentation/providers/chat_providers.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';
import 'package:pair/features/grocery/presentation/providers/grocery_providers.dart';
import 'package:pair/features/location/presentation/providers/location_providers.dart';
import 'package:pair/features/presence/presentation/providers/presence_providers.dart';
import 'package:pair/features/profile/presentation/providers/profile_providers.dart';
import 'package:pair/router/route_paths.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserStreamProvider).valueOrNull;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!user.isPaired) {
      return _UnpairedHome(userName: user.displayName);
    }

    return _PairedHome();
  }
}

class _UnpairedHome extends StatelessWidget {
  const _UnpairedHome({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pair')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, $userName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Connect with your spouse to start sharing.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pair exclusively with your spouse using a secure code.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.push(RoutePaths.pairing),
              child: const Text('Get Started'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push(RoutePaths.profile),
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PairedHome extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spouseAsync = ref.watch(spouseUserProvider);
    final presence = ref.watch(spousePresenceProvider).valueOrNull;
    final myLocation = ref.watch(myLocationProvider).valueOrNull;
    final spouseLocation = ref.watch(spouseLocationProvider).valueOrNull;
    final messages = ref.watch(messagesStreamProvider).valueOrNull ?? [];
    final unread = ref.watch(unreadCountProvider).valueOrNull ?? 0;
    final groceryItems = ref.watch(groceryItemsStreamProvider).valueOrNull ?? [];
    final groceryUnchecked =
        ref.watch(groceryUncheckedCountProvider).valueOrNull ?? 0;
    final user = ref.watch(currentUserStreamProvider).valueOrNull;
    final periodData = ref.watch(wifePeriodDataProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pair'),
        actions: [
          if (unread > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge(
                label: Text('$unread'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          spouseAsync.when(
            data: (spouse) {
              if (spouse == null) {
                return const SkeletonLoader(
                  child: SkeletonBox(height: 80),
                );
              }
              return _SpouseCard(
                name: spouse.displayName,
                photoUrl: spouse.photoUrl,
                isOnline: presence?.online ?? false,
                lastSeen: presence?.lastSeen,
              );
            },
            loading: () => const SkeletonLoader(
              child: SkeletonBox(height: 80),
            ),
            error: (_, _) => const Card(
              child: ListTile(
                title: Text('Could not load spouse info'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _LocationCard(
            myLocation: myLocation,
            spouseLocation: spouseLocation,
            onTap: () => context.go(RoutePaths.map),
          ),
          const SizedBox(height: 16),
          _ChatPreviewCard(
            lastMessage: messages.isNotEmpty ? messages.first : null,
            unreadCount: unread,
            onTap: () => context.go(RoutePaths.chat),
          ),
          const SizedBox(height: 16),
          if (user?.role == UserRole.husband || user?.role == UserRole.wife)
            ...[
              _PeriodCard(
                periodData: periodData,
                isWife: user?.role == UserRole.wife,
              ),
              const SizedBox(height: 16),
            ],
          _GroceryPreviewCard(
            items: groceryItems,
            uncheckedCount: groceryUnchecked,
            onTap: () => context.push(RoutePaths.grocery),
          ),
        ],
      ),
    );
  }
}

class _SpouseCard extends StatelessWidget {
  const _SpouseCard({
    required this.name,
    required this.photoUrl,
    required this.isOnline,
    this.lastSeen,
  });

  final String name;
  final String photoUrl;
  final bool isOnline;
  final DateTime? lastSeen;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primaryContainer,
              backgroundImage:
                  photoUrl.isNotEmpty ? CachedNetworkImageProvider(photoUrl) : null,
              child: photoUrl.isEmpty
                  ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?')
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline
                            ? 'Online'
                            : lastSeen != null
                                ? 'Last seen ${DateFormatter.relative(lastSeen!)}'
                                : 'Offline',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.myLocation,
    required this.spouseLocation,
    required this.onTap,
  });

  final dynamic myLocation;
  final dynamic spouseLocation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String distanceText = 'Distance unavailable';
    if (myLocation != null && spouseLocation != null) {
      final meters = DistanceCalculator.haversineMeters(
        lat1: myLocation.latitude,
        lon1: myLocation.longitude,
        lat2: spouseLocation.latitude,
        lon2: spouseLocation.longitude,
      );
      distanceText = DistanceCalculator.formatDistance(meters);
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                distanceText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (spouseLocation != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Spouse updated ${DateFormatter.relative(spouseLocation.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({
    required this.periodData,
    required this.isWife,
  });

  final PeriodDataEntity? periodData;
  final bool isWife;

  @override
  Widget build(BuildContext context) {
    final codeWord = AppConstants.healthCodeWord;
    final title = isWife ? '$codeWord (sharing with spouse)' : codeWord;

    if (periodData == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_outline, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isWife
                    ? 'Connect Health Connect to sync $codeWord updates with your spouse.'
                    : '$codeWord updates will appear once synced from Health Connect.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    final statusText =
        periodData!.isOnPeriod ? '$codeWord active' : '$codeWord clear';
    final flowText = _formatFlow(periodData!.currentFlow);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              statusText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (flowText != null) ...[
              const SizedBox(height: 4),
              Text(
                'Level: $flowText',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (periodData!.lastPeriodStart != null) ...[
              const SizedBox(height: 4),
              Text(
                'Started ${DateFormatter.relative(periodData!.lastPeriodStart!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Updated ${DateFormatter.relative(periodData!.updatedAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String? _formatFlow(String? flow) {
    if (flow == null || flow.isEmpty) return null;
    return flow[0].toUpperCase() + flow.substring(1);
  }
}

class _GroceryPreviewCard extends StatelessWidget {
  const _GroceryPreviewCard({
    required this.items,
    required this.uncheckedCount,
    required this.onTap,
  });

  final List<GroceryItemEntity> items;
  final int uncheckedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final uncheckedItems = items.where((item) => !item.isChecked).toList();
    final previewText = uncheckedItems.isNotEmpty
        ? uncheckedItems.take(3).map((item) => item.text).join(', ')
        : items.isNotEmpty
            ? 'All items checked off'
            : 'No items yet';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Grocery List',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (uncheckedCount > 0)
                    Badge(label: Text('$uncheckedCount')),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                previewText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatPreviewCard extends StatelessWidget {
  const _ChatPreviewCard({
    required this.lastMessage,
    required this.unreadCount,
    required this.onTap,
  });

  final dynamic lastMessage;
  final int unreadCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Chat',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (unreadCount > 0)
                    Badge(label: Text('$unreadCount')),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                lastMessage?.text ?? 'No messages yet',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

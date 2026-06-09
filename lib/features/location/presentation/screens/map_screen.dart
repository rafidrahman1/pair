import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pair/core/theme/app_theme.dart';
import 'package:pair/core/utils/date_formatter.dart';
import 'package:pair/core/utils/distance_calculator.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/location/presentation/providers/location_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    await ref.read(locationRepositoryProvider).requestPermission();
    ref.invalidate(locationPermissionProvider);
  }

  Future<void> _openLocationSettings() async {
    await ref.read(locationRepositoryProvider).openAppSettings();
    ref.invalidate(locationPermissionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserStreamProvider).valueOrNull;
    final myLocation = ref.watch(myLocationProvider).valueOrNull;
    final spouseLocation = ref.watch(spouseLocationProvider).valueOrNull;
    final permissionAsync = ref.watch(locationPermissionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: permissionAsync.when(
        data: (granted) {
          if (!granted) {
            return _PermissionDenied(
              onRequest: _requestLocationPermission,
              onOpenSettings: _openLocationSettings,
            );
          }

          if (myLocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final myLatLng =
              LatLng(myLocation.latitude, myLocation.longitude);

          String distanceText = '—';
          if (spouseLocation != null) {
            final meters = DistanceCalculator.haversineMeters(
              lat1: myLocation.latitude,
              lon1: myLocation.longitude,
              lat2: spouseLocation.latitude,
              lon2: spouseLocation.longitude,
            );
            distanceText = DistanceCalculator.formatDistance(meters);
          }

          final markers = <Marker>{
            Marker(
              markerId: MarkerId(user?.uid ?? 'me'),
              position: myLatLng,
              infoWindow: const InfoWindow(title: 'You'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose,
              ),
            ),
            if (spouseLocation != null)
              Marker(
                markerId: const MarkerId('spouse'),
                position: LatLng(
                  spouseLocation.latitude,
                  spouseLocation.longitude,
                ),
                infoWindow: InfoWindow(
                  title: 'Spouse',
                  snippet: spouseLocation.batteryLevel != null
                      ? 'Battery: ${spouseLocation.batteryLevel}%'
                      : null,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
          };

          final positions = <LatLng>[myLatLng];
          if (spouseLocation != null) {
            positions.add(
              LatLng(spouseLocation.latitude, spouseLocation.longitude),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_mapController != null && positions.length > 1) {
              _fitBounds(positions);
            }
          });

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: myLatLng,
                  zoom: 14,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (controller) => _mapController = controller,
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.straighten, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Distance: $distanceText',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        if (spouseLocation != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Spouse last updated ${DateFormatter.relative(spouseLocation.updatedAt)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (spouseLocation.batteryLevel != null)
                            Text(
                              'Battery: ${spouseLocation.batteryLevel}%',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }

  Future<void> _fitBounds(List<LatLng> positions) async {
    if (positions.length < 2 || _mapController == null) return;

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final pos in positions) {
      minLat = minLat < pos.latitude ? minLat : pos.latitude;
      maxLat = maxLat > pos.latitude ? maxLat : pos.latitude;
      minLng = minLng < pos.longitude ? minLng : pos.longitude;
      maxLng = maxLng > pos.longitude ? maxLng : pos.longitude;
    }

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80,
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  const _PermissionDenied({
    required this.onRequest,
    required this.onOpenSettings,
  });

  final Future<dynamic> Function() onRequest;
  final Future<dynamic> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Location permission is required to share your location with your spouse.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRequest,
              child: const Text('Grant Permission'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onOpenSettings,
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final result = await ref.read(locationRepositoryProvider).isPermissionGranted();
  return result.fold((_) => false, (granted) => granted);
});

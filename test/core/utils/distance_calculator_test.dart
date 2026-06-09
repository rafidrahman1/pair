import 'package:flutter_test/flutter_test.dart';
import 'package:pair/core/utils/distance_calculator.dart';

void main() {
  group('DistanceCalculator', () {
    test('haversineMeters returns 0 for same point', () {
      final distance = DistanceCalculator.haversineMeters(
        lat1: 37.7749,
        lon1: -122.4194,
        lat2: 37.7749,
        lon2: -122.4194,
      );
      expect(distance, closeTo(0, 1));
    });

    test('formatDistance shows meters for short distances', () {
      expect(DistanceCalculator.formatDistance(500), '500 m');
    });

    test('formatDistance shows kilometers for long distances', () {
      expect(DistanceCalculator.formatDistance(2500), '2.5 km');
    });
  });
}

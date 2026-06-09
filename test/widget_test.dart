import 'package:flutter_test/flutter_test.dart';
import 'package:pair/core/utils/distance_calculator.dart';

void main() {
  test('Pair app utilities compile', () {
    expect(DistanceCalculator.formatDistance(100), '100 m');
  });
}

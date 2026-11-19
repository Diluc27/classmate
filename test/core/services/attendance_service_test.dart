import 'package:flutter_test/flutter_test.dart';
import 'package:classmate/core/services/attendance_service.dart';

void main() {
  group('AttendanceStats', () {
    test('Test 1: Zero classes held returns zeros', () {
      final stats = AttendanceStats(
        present: 0,
        absent: 0,
        cancelled: 0,
        targetPercent: 75,
      );
      expect(stats.total, 0);
      expect(stats.percent, 0);
      expect(stats.safeLeaves, 0);
      expect(stats.classesNeeded, 0);
    });

    test('Test 2: Exactly at target percent', () {
      final stats = AttendanceStats(
        present: 3,
        absent: 1,
        cancelled: 0,
        targetPercent: 75,
      );
      expect(stats.total, 4);
      expect(stats.percent, 75.0);
      expect(stats.safeLeaves, 0);
      expect(stats.classesNeeded, 0);
      expect(stats.isSafe, isTrue);
    });

    test('Test 3: Below target clamps safeLeaves to 0 and classesNeeded positive', () {
      final stats = AttendanceStats(
        present: 6,
        absent: 4,
        cancelled: 0,
        targetPercent: 75,
      );
      expect(stats.percent, 60.0);
      expect(stats.safeLeaves, 0);
      expect(stats.classesNeeded, 6);
      expect(stats.classesNeeded, greaterThan(0));
      expect(stats.isDanger, isTrue);
    });

    test('Test 4: Above target has positive safeLeaves', () {
      final stats = AttendanceStats(
        present: 9,
        absent: 1,
        cancelled: 0,
        targetPercent: 75,
      );
      expect(stats.percent, 90.0);
      expect(stats.safeLeaves, 1);
      expect(stats.safeLeaves, greaterThan(0));
      expect(stats.classesNeeded, 0);
      expect(stats.isSafe, isTrue);
    });

    test('Test 5: classesNeeded rounds up to next whole integer', () {
      // With targetPercent = 85, 3 present out of 5 total (60%):
      // ((85 * 5 - 100 * 3) / (100 - 85)) = 125 / 15 = 8.333...
      // Ceil rounds 8.333... up to 9.
      final stats = AttendanceStats(
        present: 3,
        absent: 2,
        cancelled: 0,
        targetPercent: 85,
      );
      expect(stats.classesNeeded, 9);
    });
  });
}

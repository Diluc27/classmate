import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ateno/core/services/reminder_guardian.dart';
import 'package:ateno/core/utils/constants.dart';

void main() {
  group('ReminderGuardian window boundaries', () {
    final reminderTime = DateTime(2026, 11, 20, 10, 0, 0);

    test('19 minutes late fires (within 20-minute window)', () {
      final now = reminderTime.add(const Duration(minutes: 19));
      expect(
        ReminderGuardian.isInWindow(reminderTime: reminderTime, now: now),
        isTrue,
      );
    });

    test('21 minutes late does not fire (outside 20-minute window)', () {
      final now = reminderTime.add(const Duration(minutes: 21));
      expect(
        ReminderGuardian.isInWindow(reminderTime: reminderTime, now: now),
        isFalse,
      );
    });

    test('2 minutes early does not fire (exceeds ~1 min early limit)', () {
      final now = reminderTime.subtract(const Duration(minutes: 2));
      expect(
        ReminderGuardian.isInWindow(reminderTime: reminderTime, now: now),
        isFalse,
      );
    });

    test('30 seconds early fires (within ~1 min early margin)', () {
      final now = reminderTime.subtract(const Duration(seconds: 30));
      expect(
        ReminderGuardian.isInWindow(reminderTime: reminderTime, now: now),
        isTrue,
      );
    });

    test('Exact 1 minute early boundary fires', () {
      final now = reminderTime.subtract(const Duration(minutes: 1));
      expect(
        ReminderGuardian.isInWindow(reminderTime: reminderTime, now: now),
        isTrue,
      );
    });

    test('Exact 20 minutes late boundary fires', () {
      final now = reminderTime.add(const Duration(minutes: 20));
      expect(
        ReminderGuardian.isInWindow(reminderTime: reminderTime, now: now),
        isTrue,
      );
    });
  });

  group('ReminderGuardian duplicate prevention', () {
    final now = DateTime(2026, 11, 20, 10, 15, 0);

    test('Recurring reminder already fired today does not refire', () {
      final firedEarlierToday = DateTime(2026, 11, 20, 9, 30, 0);
      expect(
        ReminderGuardian.isAlreadyFiredToday(
          lastReminderFiredDate: firedEarlierToday,
          now: now,
        ),
        isTrue,
      );
    });

    test('Recurring reminder fired yesterday is eligible to fire today', () {
      final firedYesterday = DateTime(2026, 11, 19, 10, 0, 0);
      expect(
        ReminderGuardian.isAlreadyFiredToday(
          lastReminderFiredDate: firedYesterday,
          now: now,
        ),
        isFalse,
      );
    });

    test('Recurring reminder with null lastReminderFiredDate is eligible to fire', () {
      expect(
        ReminderGuardian.isAlreadyFiredToday(
          lastReminderFiredDate: null,
          now: now,
        ),
        isFalse,
      );
    });

    test('One-time reminder marker prevents duplicate firing', () {
      expect(ReminderGuardian.isOneTimeAlreadyFired(true), isTrue);
      expect(ReminderGuardian.isOneTimeAlreadyFired(false), isFalse);
    });
  });

  group('ReminderGuardian switch effect via injected callbacks', () {
    test('Turning switch ON registers WorkManager periodic task and saves preference', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? registeredUniqueName;
      String? registeredTaskName;
      Duration? registeredFrequency;

      await ReminderGuardian.setBackgroundCatchUp(
        true,
        prefs: prefs,
        registerFn: (uniqueName, taskName, {frequency, existingWorkPolicy, constraints}) async {
          registeredUniqueName = uniqueName;
          registeredTaskName = taskName;
          registeredFrequency = frequency;
        },
      );

      expect(prefs.getBool(prefBackgroundCatchUp), isTrue);
      expect(registeredUniqueName, ReminderGuardian.taskUniqueName);
      expect(registeredTaskName, ReminderGuardian.taskName);
      expect(registeredFrequency, const Duration(minutes: 15));
    });

    test('Turning switch OFF cancels WorkManager periodic task and saves preference', () async {
      SharedPreferences.setMockInitialValues({prefBackgroundCatchUp: true});
      final prefs = await SharedPreferences.getInstance();

      String? cancelledUniqueName;

      await ReminderGuardian.setBackgroundCatchUp(
        false,
        prefs: prefs,
        cancelFn: (uniqueName) async {
          cancelledUniqueName = uniqueName;
        },
      );

      expect(prefs.getBool(prefBackgroundCatchUp), isFalse);
      expect(cancelledUniqueName, ReminderGuardian.taskUniqueName);
    });

    test('Default value for background catch-up is true when unset', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final enabled = await ReminderGuardian.isBackgroundCatchUpEnabled(prefs: prefs);
      expect(enabled, isTrue);
    });
  });
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';

import 'package:classmate/core/database/app_database.dart';

/// Top-level entry point for the WorkManager background isolate.
///
/// This must be a top-level or static function annotated with
/// `@pragma('vm:entry-point')` so the Dart VM keeps it
/// accessible for background execution.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('[ReminderGuardian] Background task started: $task');
    try {
      final db = AppDatabase();
      await checkAndFireDueReminders(db);
      await db.close();
      debugPrint('[ReminderGuardian] Background task completed');
      return Future.value(true);
    } catch (e, stack) {
      debugPrint('[ReminderGuardian] Background task error: $e\n$stack');
      // Always return true to prevent WorkManager retry-storm on transient errors
      return Future.value(true);
    }
  });
}

/// Query all undismissed deadlines with reminders and fire any that are due.
///
/// This is a shared function used both by the WorkManager background callback
/// and by the manual "Run Guardian Check Now" button in Settings.
Future<void> checkAndFireDueReminders(AppDatabase db) async {
  // Init notification plugin fresh in this isolate
  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
  const settings = InitializationSettings(android: androidSettings);
  await plugin.initialize(settings);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Get all undismissed deadlines (Dart-side filter for reminder presence)
  final allDeadlines = await (db.select(db.deadlines)
        ..where((d) => d.isDone.equals(false)))
      .get();

  // Narrow to deadlines that have at least one reminder configured
  final deadlines = allDeadlines.where((d) =>
      d.reminderDate != null || d.reminderTime != null);

  int fired = 0;

  for (final deadline in deadlines) {
    // ── One-time reminder (reminderDate) ──────────────────────────
    if (deadline.reminderDate != null && !deadline.repeatUntilDue) {
      final due = deadline.reminderDate!;
      if (!deadline.reminderFired && !due.isAfter(now)) {
        await _fire(plugin, deadline);
        await (db.update(db.deadlines)..where((d) => d.id.equals(deadline.id)))
            .write(const DeadlinesCompanion(
          reminderFired: Value(true),
        ));
        fired++;
      }
      continue;
    }

    // ── Recurring / repeat-until-due reminder (reminderTime) ─────
    if (deadline.reminderTime != null) {
      // Skip past-due deadlines (unless repeatUntilDue keeps them alive)
      if (!deadline.repeatUntilDue && deadline.dueDate.isBefore(today)) continue;

      final parts = deadline.reminderTime!.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]);
      final min = int.tryParse(parts[1]);
      if (hour == null || min == null) continue;

      final reminderToday =
          DateTime(now.year, now.month, now.day, hour, min);

      // Fire window: reminder time ± 15 minutes
      if (now.isBefore(reminderToday.subtract(const Duration(minutes: 15)))) continue;
      if (now.isAfter(reminderToday.add(const Duration(minutes: 1)))) continue;

      // Check if today is a scheduled day
      if (!_isScheduledDay(deadline, now)) continue;

      // Check if already fired today (lastReminderFiredDate guard)
      final lastFire = deadline.lastReminderFiredDate;
      if (lastFire != null && !lastFire.isBefore(today)) continue;

      await _fire(plugin, deadline);
      await (db.update(db.deadlines)..where((d) => d.id.equals(deadline.id)))
          .write(DeadlinesCompanion(
        lastReminderFiredDate: Value(now),
      ));
      fired++;
    }
  }

  debugPrint('[ReminderGuardian] Fired $fired reminder(s)');
}

/// Check whether [deadline] is scheduled to fire on [now]'s weekday.
///
/// * `repeatUntilDue` → every day (fire every day until due)
/// * `reminderDays` empty/null → every day
/// * otherwise → CSV of weekday numbers (1=Mon … 7=Sun)
bool _isScheduledDay(Deadline deadline, DateTime now) {
  if (deadline.repeatUntilDue) return true;
  final raw = deadline.reminderDays;
  if (raw == null || raw.trim().isEmpty) return true; // daily
  final days = raw
      .split(',')
      .map((s) => int.tryParse(s.trim()))
      .where((n) => n != null)
      .cast<int>()
      .toList();
  return days.contains(now.weekday);
}

/// Fire a local notification for [deadline] using the direct `.show()` path
/// (bypasses AlarmManager broadcasts that Samsung suppresses).
Future<void> _fire(FlutterLocalNotificationsPlugin plugin, Deadline deadline) async {
  final androidDetails = AndroidNotificationDetails(
    'classmate_deadlines',
    'Deadline Reminders',
    channelDescription: 'Reminders for upcoming deadlines',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  final details = NotificationDetails(android: androidDetails);

  await plugin.show(
    deadline.id + 10000, // offset to avoid ID collision with zonedSchedule
    deadline.title,
    'Due: ${deadline.type}',
    details,
  );
  debugPrint('[ReminderGuardian] Fired ▶ deadline ${deadline.id}: ${deadline.title}');
}

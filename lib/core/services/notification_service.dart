import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../database/app_database.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'classmate_deadlines';
  static const _channelName = 'Deadline Reminders';

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint('[NotificationService] Notification tapped: ${response.payload}');
    });
    _initialized = true;
  }

  /// Request notification permission on Android 13+.
  /// Returns true if permission is granted (or not needed on older OS).
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return true;

    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return true;

    final granted = await androidImpl.requestNotificationsPermission();
    final result = granted ?? false;

    debugPrint('[NotificationService] Permission request result: $result');
    return result;
  }



  /// Check if exact alarm scheduling is allowed (Android 12+).
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return false;
    try {
      const channel = MethodChannel('com.classmate.classmate/alarm');
      final result = await channel.invokeMethod<bool>('canScheduleExactAlarms');
      return result ?? false;
    } catch (e) {
      debugPrint('[NotificationService] canScheduleExactAlarms error: $e');
      return false;
    }
  }

  /// Open system settings to request SCHEDULE_EXACT_ALARM permission.
  Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;
    try {
      const channel = MethodChannel('com.classmate.classmate/alarm');
      await channel.invokeMethod('requestExactAlarmPermission');
    } catch (e) {
      debugPrint('[NotificationService] requestExactAlarmPermission error: $e');
    }
  }

  /// Resolve the appropriate [AndroidScheduleMode] based on exact alarm permission.
  /// Uses the plugin's built-in API to check [canScheduleExactNotifications].
  /// Returns [exactAllowWhileIdle] if SCHEDULE_EXACT_ALARM is granted,
  /// [inexactAllowWhileIdle] if denied (graceful degradation).
  Future<AndroidScheduleMode> _resolveScheduleMode() async {
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final canExact = await androidImpl?.canScheduleExactNotifications() ?? false;
      if (canExact) {
        debugPrint('[NotificationService] Using exactAllowWhileIdle (permission GRANTED)');
        return AndroidScheduleMode.exactAllowWhileIdle;
      }
      if (Platform.isAndroid) {
        debugPrint('[NotificationService] Exact alarm DENIED — using inexactAllowWhileIdle');
      }
      return AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (e) {
      debugPrint('[NotificationService] _resolveScheduleMode error: $e');
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }

  /// Schedule a reminder for the given deadline.
  /// Returns true if successfully scheduled, false if permission was denied.
  Future<bool> scheduleDeadlineReminder(Deadline deadline) async {
    await init();

    // Request notification permission (Android 13+). If denied, don't schedule.
    final granted = await requestPermission();
    if (!granted) {
      debugPrint('[NotificationService] Permission denied — not scheduling');
      return false;
    }

    // Ensure exact alarm permission for reliable timing
    final canExact = await canScheduleExactAlarms();
    if (!canExact && Platform.isAndroid) {
      debugPrint('[NotificationService] Exact alarm not allowed — requesting...');
      await requestExactAlarmPermission();
    }

    // Resolve schedule mode based on current permission state (re-checks after request)
    final scheduleMode = await _resolveScheduleMode();

    final location = tz.local;

    // Cancel any existing notifications for this deadline
    await cancelDeadlineReminder(deadline.id);

    // Don't schedule if due date is already past (expired)
    if (deadline.dueDate.isBefore(DateTime.now())) {
      debugPrint('[NotificationService] Deadline ${deadline.id} is past due — skipping');
      return true;
    }

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Reminders for upcoming deadlines',
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    // One-time reminder (legacy reminderDate field)
    if (deadline.reminderDate != null) {
      final tzDate = tz.TZDateTime.from(deadline.reminderDate!, location);
      try {
        await _plugin.zonedSchedule(
          deadline.id,
          deadline.title,
          'Due: ${deadline.type}',
          tzDate,
          details,
          androidScheduleMode: scheduleMode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        debugPrint('[NotificationService] Scheduled one-time reminder for deadline ${deadline.id}');
      } catch (e, stack) {
        debugPrint('[NotificationService] Failed to schedule one-time reminder: $e\n$stack');
      }
      return true;
    }

    // Recurring reminder: reminderTime + reminderDays
    if (deadline.reminderTime == null) {
      debugPrint('[NotificationService] No reminderTime set for deadline ${deadline.id} — skipping');
      return true;
    }

    final timeParts = deadline.reminderTime!.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // ── Schedule one-shot exact alarms ──
    // Uses exactAllowWhileIdle instead of alarmClock mode because:
    //   - alarmClock (AlarmManager.setAlarmClock()) doesn't trigger the plugin's
    //     broadcast receiver on some Samsung One UI devices — notification never shows.
    //   - exactAllowWhileIdle (setExactAndAllowWhileIdle()) works reliably across
    //     all Samsung/Android versions.
    //   - Requires USE_EXACT_ALARM or SCHEDULE_EXACT_ALARM permission (both declared).
    //
    // TZDateTime timezone note:
    //   On some Samsung devices tz.local resolves to UTC instead of the correct
    //   timezone. So we build target times using DateTime.now() (device-local IST)
    //   and only convert to TZDateTime UTC at the very end for zonedSchedule.

    final now = DateTime.now(); // device local time (IST)

    if (deadline.repeatUntilDue) {
      // Schedule one alarm per day from now until due date
      var targetLocal = DateTime(now.year, now.month, now.day, hour, minute);
      if (targetLocal.isBefore(now) || targetLocal.isAtSameMomentAs(now)) {
        targetLocal = targetLocal.add(const Duration(days: 1));
      }

      int dayIndex = 0;
      while (!targetLocal.isAfter(deadline.dueDate)) {
        final tzTarget = tz.TZDateTime.from(targetLocal.toUtc(), tz.UTC);
        try {
          await _plugin.zonedSchedule(
            deadline.id * 100 + dayIndex,
            deadline.title,
            '${deadline.type} reminder',
            tzTarget,
            details,
            androidScheduleMode: scheduleMode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          debugPrint('[NotificationService] Scheduled repeatUntilDue day $dayIndex for deadline $deadline.id at $hour:$minute on $targetLocal');
        } catch (e, stack) {
          debugPrint('[NotificationService] Failed to schedule repeatUntilDue day $dayIndex: $e\n$stack');
        }
        targetLocal = targetLocal.add(const Duration(days: 1));
        dayIndex++;
      }
      return true;
    }

    // Parse selected days (1=Monday ... 7=Sunday)
    final days = deadline.reminderDays != null && deadline.reminderDays!.isNotEmpty
        ? deadline.reminderDays!.split(',').map((s) => int.parse(s.trim())).toList()
        : [1, 2, 3, 4, 5, 6, 7];

    if (days.length == 7) {
      // ── Daily (schedule next 14 days worth) ────────────────
      var targetLocal = DateTime(now.year, now.month, now.day, hour, minute);
      if (targetLocal.isBefore(now) || targetLocal.isAtSameMomentAs(now)) {
        targetLocal = targetLocal.add(const Duration(days: 1));
      }

      for (int i = 0; i < 14; i++) {
        final tzTarget = tz.TZDateTime.from(targetLocal.toUtc(), tz.UTC);
        try {
          await _plugin.zonedSchedule(
            deadline.id * 100 + i,
            deadline.title,
            '${deadline.type} reminder',
            tzTarget,
            details,
            androidScheduleMode: scheduleMode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          debugPrint('[NotificationService] Scheduled daily reminder #$i for deadline $deadline.id at $targetLocal');
        } catch (e, stack) {
          debugPrint('[NotificationService] Failed to schedule daily reminder #$i: $e\n$stack');
        }
        targetLocal = targetLocal.add(const Duration(days: 1));
      }
    } else {
      // ── Specific days of week (schedule next 4 weeks worth) ─
      for (int week = 0; week < 4; week++) {
        for (final day in days) {
          final targetWeekday = day; // 1=Mon ... 7=Sun
          final currentWeekday = now.weekday;

          var daysUntil = targetWeekday - currentWeekday;
          if (daysUntil <= 0) {
            daysUntil += 7;
          }
          daysUntil += week * 7;
          if (daysUntil == 0) {
            final currentMinutes = now.hour * 60 + now.minute;
            final targetMinutes = hour * 60 + minute;
            if (currentMinutes >= targetMinutes) {
              daysUntil = 7; // time passed, next week
            }
          }

          final targetLocal = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          ).add(Duration(days: daysUntil));

          final tzTarget = tz.TZDateTime.from(targetLocal.toUtc(), tz.UTC);
          try {
            await _plugin.zonedSchedule(
              deadline.id * 100 + day + week * 10,
              deadline.title,
              '${deadline.type} reminder',
              tzTarget,
              details,
              androidScheduleMode: scheduleMode,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
            debugPrint('[NotificationService] Scheduled day $day reminder (week $week) for deadline $deadline.id at $targetLocal');
          } catch (e, stack) {
            debugPrint('[NotificationService] Failed to schedule day $day reminder (week $week): $e\n$stack');
          }
        }
      }
    }
    return true;
  }

  /// Show a test notification immediately to verify the system works.
  /// Returns true if shown successfully, false if permission denied.
  Future<bool> showTestNotification() async {
    await init();

    final granted = await requestPermission();
    if (!granted) {
      debugPrint('[NotificationService] Permission denied — cannot show test');
      return false;
    }

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Reminders for upcoming deadlines',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    final details = NotificationDetails(android: androidDetails);

    try {
      await _plugin.show(
        -1, // unique test ID
        'Test Notification',
        'Your notification system is working!',
        details,
      );
      debugPrint('[NotificationService] Test notification shown immediately');
      return true;
    } catch (e) {
      debugPrint('[NotificationService] Failed to show test notification: $e');
      return false;
    }
  }

  Future<void> cancelDeadlineReminder(int deadlineId) async {
    // Cancel all individual one-shot alarms (0..99)
    for (int i = 0; i < 100; i++) {
      await _plugin.cancel(deadlineId * 100 + i);
    }
  }

  /// Expose the Android-specific plugin implementation for direct API access
  /// (e.g., [canScheduleExactNotifications], [requestExactAlarmsPermission]).
  AndroidFlutterLocalNotificationsPlugin? resolveAndroidPlugin() {
    return _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
  }

  Future<void> rescheduleAll(List<Deadline> deadlines) async {
    await _plugin.cancelAll();
    for (final d in deadlines) {
      await scheduleDeadlineReminder(d);
    }
  }

  /// Cancel notifications for deadlines with [repeatUntilDue] that are past due.
  Future<void> cancelExpiredRecurring(List<Deadline> deadlines) async {
    final now = DateTime.now();
    for (final d in deadlines) {
      if (d.repeatUntilDue && d.dueDate.isBefore(now)) {
        await cancelDeadlineReminder(d.id);
      }
    }
  }
}

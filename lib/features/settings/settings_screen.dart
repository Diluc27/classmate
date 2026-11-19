import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/services/android_share_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/reminder_guardian.dart';
import '../../core/providers/theme_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/session_generator.dart';
import '../../core/database/app_database.dart';
import '../../core/database/daos/subject_dao.dart';
import '../../core/database/daos/slot_dao.dart';
import '../../core/database/daos/session_dao.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  DateTime? _semesterStart;
  DateTime? _semesterEnd;
  double _defaultTarget = defaultTargetPercent.toDouble();
  String _collegeName = '';
  int _lectureDuration = 50;
  TimeOfDay _firstLectureStart = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay? _breakStart = const TimeOfDay(hour: 12, minute: 30);
  TimeOfDay? _breakEnd = const TimeOfDay(hour: 13, minute: 0);
  bool? _notificationGranted;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadLectureConfig();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    if (!Platform.isAndroid) return;
    final ns = NotificationService();
    await ns.init();
    final granted = await ns.requestPermission();
    if (mounted) setState(() => _notificationGranted = granted);
  }

  Future<void> _sendTestNotification() async {
    final ns = NotificationService();
    final sent = await ns.showTestNotification();
    if (!mounted) return;
    if (sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test notification scheduled — check in 5 seconds'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification permission denied — enable in system settings'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _checkExactAlarmStatus() async {
    if (!Platform.isAndroid) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exact alarms: not applicable (iOS)')),
      );
      return;
    }
    try {
      final ns = NotificationService();
      await ns.init();
      final plugin = ns.resolveAndroidPlugin();
      final canExact = await plugin?.canScheduleExactNotifications() ?? false;
      if (!mounted) return;
      if (canExact) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exact alarms: GRANTED — reminders will fire on time'),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Exact alarms: DENIED — reminders may be delayed. Tap to open settings'),
            backgroundColor: const Color(0xFFC62828),
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Open Settings',
              textColor: Colors.white,
              onPressed: () async {
                final ns = NotificationService();
                await ns.requestExactAlarmPermission();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking alarm status: $e')),
      );
    }
  }

  Future<void> _sendTestReminder() async {
    try {
      final ns = NotificationService();
      await ns.init();
      final plugin = ns.resolveAndroidPlugin();

      // Determine schedule mode
      AndroidScheduleMode mode = AndroidScheduleMode.inexactAllowWhileIdle;
      try {
        final canExact = await plugin?.canScheduleExactNotifications() ?? false;
        mode = canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle;
      } catch (_) {}

      // Schedule 1 minute from now
      final now = DateTime.now();
      final target = now.add(const Duration(minutes: 1));
      final tzTarget = tz.TZDateTime.from(target.toUtc(), tz.UTC);

      final androidDetails = AndroidNotificationDetails(
        'classmate_deadlines',
        'Deadline Reminders',
        channelDescription: 'Reminders for upcoming deadlines',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      // AndroidFlutterLocalNotificationsPlugin.zonedSchedule uses
      // AndroidNotificationDetails and 'scheduleMode' (not 'androidScheduleMode')
      await plugin?.zonedSchedule(
        -2, // test reminder ID
        'Test Reminder',
        'This is a 1-minute test reminder',
        tzTarget,
        androidDetails,
        scheduleMode: mode,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Test reminder scheduled for ${target.hour}:${target.minute.toString().padLeft(2, '0')} '
            '(1 min) — mode: ${mode.name}',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule test reminder: $e')),
      );
    }
  }

  Future<void> _runGuardianCheck() async {
    if (!mounted) return;
    final db = ref.read(databaseProvider);
    try {
      await checkAndFireDueReminders(db);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Guardian check complete — due reminders fired'),
          backgroundColor: Color(0xFF2E7D32),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guardian check error: $e')),
      );
    }
  }

  Future<void> _requestNotificationPermission() async {
    if (!Platform.isAndroid) return;
    final ns = NotificationService();
    await ns.init();
    final granted = await ns.requestPermission();
    if (mounted) setState(() => _notificationGranted = granted);
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission denied — enable in app settings')),
      );
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final start = prefs.getString(prefSemesterStart);
    final end = prefs.getString(prefSemesterEnd);
    final target = prefs.getInt(prefDefaultTargetPercent);
    if (mounted) {
      setState(() {
        if (start != null) _semesterStart = DateTime.tryParse(start);
        if (end != null) _semesterEnd = DateTime.tryParse(end);
        if (target != null) _defaultTarget = target.toDouble();
      });
    }
  }

  Future<void> _loadLectureConfig() async {
    final db = ref.read(databaseProvider);
    final config = await db.lectureConfigDao.getConfig();
    if (config != null && mounted) {
      setState(() {
        _collegeName = config.collegeName ?? '';
        _lectureDuration = config.lectureDurationMins;
        _firstLectureStart = _parseTime(config.firstLectureStart);
        _breakStart = _parseTime(config.breakStart);
        _breakEnd = _parseTime(config.breakEnd);
      });
    }
  }

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _saveSemesterDates() async {
    final prefs = await SharedPreferences.getInstance();
    if (_semesterStart != null) {
      await prefs.setString(
        prefSemesterStart,
        _semesterStart!.toIso8601String(),
      );
    }
    if (_semesterEnd != null) {
      await prefs.setString(prefSemesterEnd, _semesterEnd!.toIso8601String());
    }

    if (_semesterStart != null && _semesterEnd != null) {
      final db = ref.read(databaseProvider);
      final generator = SessionGeneratorService(db);
      final count = await generator.generateSessions(
        semesterStart: _semesterStart!,
        semesterEnd: _semesterEnd!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generated $count class sessions')),
        );
      }
    }
  }

  Future<void> _saveTarget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefDefaultTargetPercent, _defaultTarget.round());
  }

  Future<void> _saveLectureConfig() async {
    final db = ref.read(databaseProvider);
    await db.lectureConfigDao.upsertConfig(
      LectureScheduleConfigCompanion(
        id: const Value(1),
        collegeName: Value(_collegeName.isEmpty ? null : _collegeName),
        lectureDurationMins: Value(_lectureDuration),
        firstLectureStart: Value('${_firstLectureStart.hour.toString().padLeft(2, '0')}:${_firstLectureStart.minute.toString().padLeft(2, '0')}'),
        breakStart: Value('${_breakStart!.hour.toString().padLeft(2, '0')}:${_breakStart!.minute.toString().padLeft(2, '0')}'),
        breakEnd: Value('${_breakEnd!.hour.toString().padLeft(2, '0')}:${_breakEnd!.minute.toString().padLeft(2, '0')}'),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lecture schedule saved')),
      );
    }
  }

  Future<void> _selectThemeMode() async {
    final currentThemeMode = ref.read(themeModeProvider);
    final selected = await showModalBottomSheet<AppThemePreference>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemePreference.values.map((mode) {
            final isSelected = mode == currentThemeMode;
            return ListTile(
              title: Text(themeModeLabel(mode)),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, mode),
            );
          }).toList(),
        ),
      ),
    );

    if (selected == null) return;
    await ref.read(themeModeProvider.notifier).setThemeMode(selected);
  }

  Future<void> _importData() async {
    // Read JSON from clipboard
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null ||
        clipboardData.text == null ||
        clipboardData.text!.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nothing to import — copy exported JSON first'),
          ),
        );
      }
      return;
    }

    final raw = clipboardData.text!.trim();
    Map<String, dynamic> json;
    try {
      json = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid JSON — check clipboard content'),
          ),
        );
      }
      return;
    }

    final db = ref.read(databaseProvider);

    if (!mounted) return;

    // Confirm with user
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
          'This will add all subjects, timetable slots, and sessions '
          'from the clipboard. Existing subjects with the same name '
          'will be reused.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Import'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    // Parse & import subjects
    final subjectDao = SubjectDao(db);
    final subjectsJson = json['subjects'] as List<dynamic>? ?? [];
    final subjectNameToId = <String, int>{};

    for (final sJson in subjectsJson) {
      final name = sJson['name'] as String? ?? '';
      if (name.isEmpty) continue;

      // Check if subject already exists
      final existing = await subjectDao.getAllSubjects();
      final match = existing
          .where((s) => s.name.toLowerCase() == name.toLowerCase())
          .firstOrNull;

      if (match != null) {
        subjectNameToId[name.toLowerCase()] = match.id;
      } else {
        final inserted = await subjectDao.insertSubject(
          SubjectsCompanion(
            name: Value(name),
            colorHex: Value(sJson['colorHex'] as String? ?? '#4A90D9'),
            targetPercent: Value(sJson['targetPercent'] as int? ?? 75),
          ),
        );
        subjectNameToId[name.toLowerCase()] = inserted.id;
      }
    }

    // Parse & import timetable slots
    final slotDao = SlotDao(db);
    var slotsImported = 0;
    final slotsJson = json['timetableSlots'] as List<dynamic>? ?? [];
    for (final slJson in slotsJson) {
      final subjectName = (slJson['subject'] as String? ?? '').toLowerCase();
      final subjectId = subjectNameToId[subjectName];
      if (subjectId == null) continue;

      final weekday = slJson['weekday'] as int?;
      if (weekday == null || weekday < 1 || weekday > 7) continue;

      final startTime = slJson['startTime'] as String? ?? '00:00';
      final endTime = slJson['endTime'] as String? ?? '00:00';

      // Skip if conflicting slot already exists
      final hasConflict = await slotDao.hasConflict(weekday, startTime, endTime);
      if (hasConflict) continue;

      await slotDao.insertSlot(
        TimetableSlotsCompanion(
          subjectId: Value(subjectId),
          weekday: Value(weekday),
          startTime: Value(startTime),
          endTime: Value(endTime),
          room: Value(slJson['room'] as String?),
        ),
      );
      slotsImported++;
    }

    // Parse & import sessions
    final sessionDao = SessionDao(db);
    final sessionsJson = json['sessions'] as List<dynamic>? ?? [];
    var sessionsImported = 0;

    for (final sJson in sessionsJson) {
      final subjectName = (sJson['subject'] as String? ?? '').toLowerCase();
      final subjectId = subjectNameToId[subjectName];
      if (subjectId == null) continue;

      final dateStr = sJson['date'] as String?;
      if (dateStr == null) continue;
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;

      await sessionDao.insertSession(
        ClassSessionsCompanion(
          subjectId: Value(subjectId),
          date: Value(date),
          startTime: Value(sJson['startTime'] as String? ?? '00:00'),
          endTime: Value(sJson['endTime'] as String? ?? '00:00'),
          status: Value(sJson['status'] as String? ?? 'absent'),
        ),
      );
      sessionsImported++;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported ${subjectsJson.length} subject(s), '
            '$slotsImported slot(s), and $sessionsImported session(s)',
          ),
        ),
      );
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete ALL subjects, deadlines, timetable slots, '
          'class sessions, and reset all settings. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    // Clear database
    final db = ref.read(databaseProvider);
    await db.clearAllData();

    // Reset SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefUserName);
    await prefs.remove(prefSemesterStart);
    await prefs.remove(prefSemesterEnd);
    await prefs.remove(prefDefaultTargetPercent);
    await prefs.remove(prefAllowPreMarking);
    await prefs.remove(prefThemeMode);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All data cleared.')),
    );

    // Pop back so user sees the empty app state
    Navigator.of(context).pop();
    ref.invalidate(databaseProvider);
    ref.invalidate(themeModeProvider);
  }

  Future<void> _exportData() async {
    try {
      final db = ref.read(databaseProvider);
      final subjects = await db.subjectDao.getAllSubjects();
      final allSessions = <Map<String, dynamic>>[];
      for (final s in subjects) {
        final sessions = await db.sessionDao.getSessionsBySubject(s.id);
        allSessions.addAll(
          sessions.map(
            (ss) => {
              'subject': s.name,
              'date': ss.date.toIso8601String(),
              'startTime': ss.startTime,
              'endTime': ss.endTime,
              'status': ss.status,
            },
          ),
        );
      }

      final export = jsonEncode({
        'exportDate': DateTime.now().toIso8601String(),
        'semesterStart': _semesterStart?.toIso8601String(),
        'semesterEnd': _semesterEnd?.toIso8601String(),
        'subjects': subjects
            .map(
              (s) => {
                'name': s.name,
                'targetPercent': s.targetPercent,
                'colorHex': s.colorHex,
              },
            )
            .toList(),
        'sessions': allSessions,
      });

      await AndroidShareService.shareText(
        text: export,
        subject: 'Ateno Data Export',
        title: 'Share Ateno Data Export',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Semester section
          _SectionHeader(title: 'Semester'),
          _SettingTile(
            title: 'Start Date',
            subtitle: _semesterStart != null
                ? '${_semesterStart!.day}/${_semesterStart!.month}/${_semesterStart!.year}'
                : 'Not set',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _semesterStart ?? DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );
              if (!context.mounted) return;
              if (picked != null) {
                setState(() => _semesterStart = picked);
                _saveSemesterDates();
              }
            },
          ),
          _SettingTile(
            title: 'End Date',
            subtitle: _semesterEnd != null
                ? '${_semesterEnd!.day}/${_semesterEnd!.month}/${_semesterEnd!.year}'
                : 'Not set',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate:
                    _semesterEnd ??
                    DateTime.now().add(const Duration(days: 180)),
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );
              if (!context.mounted) return;
              if (picked != null) {
                if (_semesterStart != null &&
                    picked.isBefore(_semesterStart!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('End date must be after start date'),
                    ),
                  );
                  return;
                }
                setState(() => _semesterEnd = picked);
                _saveSemesterDates();
              }
            },
          ),

          const Divider(),

          // Attendance section
          _SectionHeader(title: 'Attendance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Default Target %',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_defaultTarget.round()}%',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _defaultTarget,
                  min: 50,
                  max: 100,
                  divisions: 10,
                  onChanged: (v) => setState(() => _defaultTarget = v),
                  onChangeEnd: (_) => _saveTarget(),
                ),
              ],
            ),
          ),

          const Divider(),

          // Lecture Schedule section
          _SectionHeader(title: 'Lecture Schedule'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _collegeName,
                  decoration: const InputDecoration(
                    labelText: 'College Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _collegeName = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Duration (min): ', style: TextStyle(fontSize: 14)),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: _lectureDuration.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() {
                          _lectureDuration = int.tryParse(v) ?? 50;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SettingTile(
                  title: 'First Lecture Start',
                  subtitle: _firstLectureStart.format(context),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _firstLectureStart,
                    );
                    if (picked != null) setState(() => _firstLectureStart = picked);
                  },
                ),
                _SettingTile(
                  title: 'Break Start',
                  subtitle: _breakStart?.format(context) ?? '—',
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _breakStart ?? const TimeOfDay(hour: 12, minute: 0),
                    );
                    if (picked != null) setState(() => _breakStart = picked);
                  },
                ),
                _SettingTile(
                  title: 'Break End',
                  subtitle: _breakEnd?.format(context) ?? '—',
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _breakEnd ?? const TimeOfDay(hour: 13, minute: 0),
                    );
                    if (picked != null) setState(() => _breakEnd = picked);
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _saveLectureConfig,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Lecture Schedule'),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // App section
          _SectionHeader(title: 'App'),
          _SettingTile(
            title: 'Theme',
            subtitle: themeModeLabel(ref.watch(themeModeProvider)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectThemeMode,
          ),
          _SettingTile(
            title: 'Import Data',
            subtitle: 'Paste exported JSON from clipboard',
            trailing: const Icon(Icons.chevron_right),
            onTap: _importData,
          ),
          _SettingTile(
            title: 'Export Data',
            subtitle: 'Export all data as JSON',
            trailing: const Icon(Icons.chevron_right),
            onTap: _exportData,
          ),
          _SettingTile(
            title: 'About',
            subtitle: 'Ateno v1.0.0',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Ateno',
              applicationVersion: '1.0.0',
            ),
          ),

          const Divider(),

          // Notification section
          _SectionHeader(title: 'Notifications & Reminders'),
          _SettingTile(
            title: 'Notification Status',
            subtitle: _notificationGranted == null
                ? 'Checking...'
                : _notificationGranted!
                    ? 'Notifications enabled'
                    : 'Notifications disabled — tap to enable',
            trailing: Icon(
              _notificationGranted == true
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _notificationGranted == true
                  ? AppColors.success
                  : AppColors.danger,
            ),
            onTap: _notificationGranted == false
                ? _requestNotificationPermission
                : () {},
          ),
          _SettingTile(
            title: 'Reminder Default',
            subtitle: 'New deadlines default to 9:00 AM on weekdays',
            trailing: const Icon(Icons.access_time),
            onTap: () {},
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 240,
              child: OutlinedButton.icon(
                onPressed: _sendTestNotification,
                icon: const Icon(Icons.notifications_outlined, size: 18),
                label: const Text('Send Test Notification'),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: SizedBox(
              width: 240,
              child: OutlinedButton.icon(
                onPressed: _checkExactAlarmStatus,
                icon: const Icon(Icons.alarm_outlined, size: 18),
                label: const Text('Check Exact Alarm Status'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 240,
              child: OutlinedButton.icon(
                onPressed: _sendTestReminder,
                icon: const Icon(Icons.timer_outlined, size: 18),
                label: const Text('Send Test Reminder (1 min)'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 240,
              child: OutlinedButton.icon(
                onPressed: _runGuardianCheck,
                icon: const Icon(Icons.shield_outlined, size: 18),
                label: const Text('Run Guardian Check Now'),
              ),
            ),
          ),
          const SizedBox(height: 4),

          const Divider(),

          // Danger zone
          _SectionHeader(title: 'Data'),
          _SettingTile(
            title: 'Clear All Data',
            subtitle: 'Delete all subjects, deadlines, sessions, and reset settings',
            trailing: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onTap: _clearAllData,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textMuted),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

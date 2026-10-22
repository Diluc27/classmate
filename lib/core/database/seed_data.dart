import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_database.dart';
import '../models/subjects.dart';
import '../models/class_sessions.dart';

class SeedData {
  static const _seedKey = 'seed_v1';

  /// Slot timing definitions (50 min each, break 12:30-1:00)
  static const _slotTimings = {
    1: ('10:00', '10:50'),
    2: ('10:50', '11:40'),
    3: ('11:40', '12:30'),
    4: ('13:00', '13:50'),
    5: ('13:50', '14:40'),
    6: ('14:40', '15:30'),
  };

  /// All 17 subjects with name -> hex color mapping
  static const _subjects = {
    'AEC (Hindi)': '#4A90D9',
    'DS': '#9B59B6',
    'DS LAB 1': '#E91E63',
    'Extension': '#FF9800',
    'LAB 2': '#4CAF50',
    'LIBRARY': '#00BCD4',
    'MERN': '#FFEB3B',
    'MERN LAB 1': '#9E9E9E',
    'MPG': '#2196F3',
    'PBB': '#8E44AD',
    'PP': '#FF69B4',
    'Python': '#FF5722',
    'POS': '#2E7D32',
    'R Programming': '#0097A7',
    'R Lab1': '#FBC02D',
    'RM': '#757575',
    'Python Lab1': '#1565C0',
  };

  /// Daily session data: [year, month, day, [(slot, subjectName), ...]]
  static const _dailySessions = [
    (2026, 6, 11, [
      (1, 'MERN'),
      (2, 'R Programming'),
      (3, 'Python'),
    ]),
    (2026, 6, 12, [
      (1, 'DS'),
      (2, 'POS'),
      (3, 'R Programming'),
    ]),
    (2026, 6, 13, [
      (1, 'MERN'),
      (2, 'Extension'),
      (3, 'POS'),
    ]),
    (2026, 6, 15, [
      (1, 'PP'),
      (2, 'R Programming'),
      (3, 'DS'),
    ]),
    (2026, 6, 16, [
      (1, 'RM'),
      (2, 'POS'),
      (3, 'R Programming'),
      (4, 'AEC (Hindi)'),
    ]),
    (2026, 6, 17, [
      (1, 'DS'),
      (2, 'RM'),
      (3, 'LIBRARY'),
      (4, 'MERN'),
      (5, 'RM'),
      (6, 'POS Lab1'),
      (6, 'POS Lab1'), // double slot
    ]),
    (2026, 6, 18, [
      (1, 'MERN LAB 1'),
      (2, 'MERN LAB 1'),
      (3, 'PBB'),
      (4, 'MPG'),
      (5, 'AEC (Hindi)'),
      (6, 'DS LAB 1'),
      (6, 'DS LAB 1'), // double slot
    ]),
    (2026, 6, 19, [
      (1, 'DS'),
      (2, 'MERN'),
      (3, 'MERN'),
    ]),
    (2026, 6, 20, [
      (1, 'MERN'),
      (2, 'POS'),
      (3, 'LAB 2'),
    ]),
    (2026, 6, 23, [
      (1, 'RM'),
      (2, 'POS'),
      (3, 'R Programming'),
      (4, 'AEC (Hindi)'),
      (5, 'Extension'),
    ]),
    (2026, 6, 24, [
      (1, 'AEC (Hindi)'),
      (2, 'RM'),
      (3, 'DS'),
      (4, 'MERN'),
      (5, 'Extension'),
      (6, 'POS Lab1'),
    ]),
    (2026, 6, 25, [
      (1, 'MERN LAB 1'),
      (2, 'PP'),
      (3, 'MPG'),
      (4, 'AEC (Hindi)'),
      (5, 'DS LAB 1'),
    ]),
    (2026, 6, 27, [
      (1, 'MERN'),
      (2, 'POS'),
      (3, 'Extension'),
      (4, 'R Lab1'),
      (5, 'Python Lab1'),
    ]),
  ];

  /// Maps subject name to its actual DB id (after insert).
  static final Map<String, int> _subjectIdMap = {};

  /// Compute end time given slot start time and duration (50 min).
  static String _computeEndTime(String startTime) {
    final parts = startTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final totalMinutes = hour * 60 + minute + 50;
    final endHour = totalMinutes ~/ 60;
    final endMinute = totalMinutes % 60;
    return '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
  }

  /// Map "POS Lab1" to "POS" (its lab variant).
  static String _resolveSubjectName(String name) {
    return name == 'POS Lab1' ? 'POS' : name;
  }

  /// Run the seed — checks SharedPreferences flag first.
  static Future<void> run(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_seedKey) == true) {
      return; // already seeded
    }

    // 1. Insert all subjects
    for (final entry in _subjects.entries) {
      final companion = SubjectsCompanion(
        name: Value(entry.key),
        colorHex: Value(entry.value),
      );
      final subject = await db.subjectDao.insertSubject(companion);
      _subjectIdMap[entry.key] = subject.id;
    }

    print('Seed: Inserted ${_subjectIdMap.length} subjects');

    // 2. Insert all class sessions
    int sessionCount = 0;
    final allCompanions = <ClassSessionsCompanion>[];

    for (final (year, month, day, slots) in _dailySessions) {
      final date = DateTime(year, month, day);
      // Track inserted (subjectId, startTime) for this date to handle duplicate slots
      final insertedKeys = <String>{};

      for (final (slotNum, rawSubjectName) in slots) {
        final subjectName = _resolveSubjectName(rawSubjectName);
        final subjectId = _subjectIdMap[subjectName];
        if (subjectId == null) {
          print('Seed WARNING: Unknown subject "$subjectName" on $date slot $slotNum — skipping');
          continue;
        }

        final (startTime, _) = _slotTimings[slotNum]!;
        final endTime = _computeEndTime(startTime);

        // Handle consecutive same-slot entries (e.g., double-lab) by offsetting start/end by 5 min
        final key = '$subjectId|$startTime';
        String actualStart = startTime;
        String actualEnd = endTime;
        if (insertedKeys.contains(key)) {
          actualStart = _offsetTime(startTime, 5);
          actualEnd = _offsetTime(endTime, 5);
        }

        allCompanions.add(ClassSessionsCompanion.insert(
          subjectId: subjectId,
          date: date,
          startTime: actualStart,
          endTime: actualEnd,
        ));

        insertedKeys.add('$subjectId|$startTime');
        sessionCount++;
      }
    }

    // Batch insert all sessions (insertOrIgnore skips duplicates safely)
    await db.sessionDao.insertSessions(allCompanions);

    print('Seed: Inserted $sessionCount class sessions');

    // 3. Mark seed as done
    await prefs.setBool(_seedKey, true);
    print('Seed: Completed successfully');
  }

  /// Offset a "HH:mm" time string by [minutes] minutes.
  static String _offsetTime(String time, int minutes) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final totalMinutes = hour * 60 + minute + minutes;
    final newHour = totalMinutes ~/ 60;
    final newMinute = totalMinutes % 60;
    return '${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
  }
}

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/subjects.dart';
import '../models/timetable_slots.dart';
import '../models/class_sessions.dart';
import '../models/deadlines.dart';
import '../models/lecture_config.dart';
import 'daos/subject_dao.dart';
import 'daos/slot_dao.dart';
import 'daos/session_dao.dart';
import 'daos/deadline_dao.dart';
import 'daos/lecture_config_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Subjects,
    TimetableSlots,
    ClassSessions,
    Deadlines,
    LectureScheduleConfig,
  ],
  daos: [
    SubjectDao,
    SlotDao,
    SessionDao,
    DeadlineDao,
    LectureConfigDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        await migrator.addColumn(deadlines, deadlines.reminderTime);
        await migrator.addColumn(deadlines, deadlines.reminderDays);
      }
      if (from <= 2) {
        await migrator.addColumn(deadlines, deadlines.repeatUntilDue);
      }
      if (from <= 3) {
        await migrator.createTable(lectureScheduleConfig);
      }
      if (from <= 4) {
        // v4 created table without primary key; drop and recreate with PK
        await migrator.drop(lectureScheduleConfig);
        await migrator.createTable(lectureScheduleConfig);
      }
      if (from <= 5) {
        await migrator.addColumn(deadlines, deadlines.reminderFired);
        await migrator.addColumn(deadlines, deadlines.lastReminderFiredDate);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'classmate_db');
  }

  /// Deletes ALL rows from every table (respects FK order).
  Future<void> clearAllData() async {
    await delete(classSessions).go();
    await delete(deadlines).go();
    await delete(timetableSlots).go();
    await delete(subjects).go();
  }
}


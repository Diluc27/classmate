import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../utils/date_utils.dart' as app_utils;

class SessionGeneratorService {
  final AppDatabase _db;

  SessionGeneratorService(this._db);

  Future<int> generateSessions({
    required DateTime semesterStart,
    required DateTime semesterEnd,
  }) async {
    final allSlots = await _db.slotDao.getAllActiveSlots();
    final dates = app_utils.AppDateUtils.getDateRange(semesterStart, semesterEnd);
    var created = 0;

    for (final date in dates) {
      final weekday = date.weekday;
      final slotsForDay =
          allSlots.where((s) => s.weekday == weekday).toList();

      for (final slot in slotsForDay) {
        final existing = await _db.sessionDao.findSessionBySlotAndDate(
          slot.id,
          date,
        );
        if (existing == null) {
          await _db.sessionDao.insertSession(ClassSessionsCompanion(
            slotId: Value(slot.id),
            subjectId: Value(slot.subjectId),
            date: Value(date),
            startTime: Value(slot.startTime),
            endTime: Value(slot.endTime),
            status: const Value('absent'),
          ));
          created++;
        }
      }
    }
    return created;
  }

  Future<int> generateFutureSessions({int weeks = 2}) async {
    final today = DateTime.now();
    final endDate = today.add(Duration(days: weeks * 7));
    return generateSessions(
      semesterStart: today.add(const Duration(days: 1)),
      semesterEnd: endDate,
    );
  }

  Future<void> regenerateForNewRange({
    required DateTime oldStart,
    required DateTime oldEnd,
    required DateTime newStart,
    required DateTime newEnd,
  }) async {
    await _db.sessionDao.deleteSessionsOutsideRange(newStart, newEnd);
    await generateSessions(semesterStart: newStart, semesterEnd: newEnd);
  }

  Future<void> handleSlotAdded({required DateTime semesterEnd}) async {
    final today = DateTime.now();
    if (semesterEnd.isBefore(today)) return;
    await generateSessions(semesterStart: today, semesterEnd: semesterEnd);
  }

  Future<void> deleteFutureAbsentSessions(int slotId) async {
    await _db.sessionDao.deleteSessionsForSlot(slotId);
  }
}

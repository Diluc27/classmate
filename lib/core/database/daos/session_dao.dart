import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../models/class_sessions.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [ClassSessions])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<ClassSession> insertSession(ClassSessionsCompanion entry) =>
      into(classSessions).insertReturning(entry);

  Future<void> insertSessions(List<ClassSessionsCompanion> entries) =>
      batch((batch) {
        batch.insertAll(classSessions, entries,
            mode: InsertMode.insertOrIgnore);
      });

  Future<void> updateSessionSubject(int sessionId, int newSubjectId) =>
      (update(classSessions)..where((s) => s.id.equals(sessionId)))
          .write(ClassSessionsCompanion(subjectId: Value(newSubjectId)));

  Future<void> updateSessionStatus(int id, String status) =>
      (update(classSessions)..where((s) => s.id.equals(id)))
          .write(ClassSessionsCompanion(status: Value(status)));

  Future<void> updateSession(ClassSession entry) =>
      (update(classSessions)..where((s) => s.id.equals(entry.id))).write(
        ClassSessionsCompanion(
          slotId: Value(entry.slotId),
          subjectId: Value(entry.subjectId),
          date: Value(entry.date),
          startTime: Value(entry.startTime),
          endTime: Value(entry.endTime),
          status: Value(entry.status),
          note: Value(entry.note),
        ),
      );

  Future<void> deleteSessionsForSlot(int slotId) =>
      (delete(classSessions)
            ..where((s) => s.slotId.equals(slotId))
            ..where((s) => s.status.equals('absent')))
          .go();

  Future<void> deleteSession(int id) =>
      (delete(classSessions)..where((s) => s.id.equals(id))).go();

  Future<void> deleteSessionsOutsideRange(DateTime start, DateTime end) async {
    final allSessions = await (select(classSessions)
          ..where((s) => s.status.equals('absent')))
        .get();
    final toDelete = allSessions
        .where((s) => s.date.isBefore(start) || s.date.isAfter(end))
        .toList();
    for (final s in toDelete) {
      await (delete(classSessions)..where((c) => c.id.equals(s.id))).go();
    }
  }

  Stream<List<ClassSession>> watchSessionsByDate(DateTime date) =>
      (select(classSessions)
            ..where((s) =>
                s.date.isBiggerOrEqualValue(date) &
                s.date.isSmallerThanValue(date.add(const Duration(days: 1))))
            ..orderBy([(s) => OrderingTerm(expression: s.startTime)]))
          .watch();

  Stream<List<ClassSession>> watchSessionsBySubject(int subjectId) =>
      (select(classSessions)
            ..where((s) => s.subjectId.equals(subjectId))
            ..orderBy([(s) =>
                OrderingTerm(expression: s.date, mode: OrderingMode.desc)]))
          .watch();

  Future<ClassSession?> findSessionBySlotAndDate(int slotId, DateTime date) =>
      (select(classSessions)
            ..where((s) => s.slotId.equals(slotId))
            ..where((s) => s.date.equals(date)))
          .getSingleOrNull();

  Future<List<ClassSession>> getSessionsBySubject(int subjectId) =>
      (select(classSessions)
            ..where((s) => s.subjectId.equals(subjectId)))
          .get();

  Future<List<ClassSession>> getAllSessions() =>
      (select(classSessions)).get();

  Stream<List<ClassSession>> watchAllSessions() =>
      (select(classSessions)).watch();

  Future<ClassSession?> findSessionBySubjectDateAndTime(
      int subjectId, DateTime date, String startTime) =>
      (select(classSessions)
            ..where((s) => s.subjectId.equals(subjectId))
            ..where((s) => s.date.equals(date))
            ..where((s) => s.startTime.equals(startTime)))
          .getSingleOrNull();
}

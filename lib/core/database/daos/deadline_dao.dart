import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../models/deadlines.dart';

part 'deadline_dao.g.dart';

@DriftAccessor(tables: [Deadlines])
class DeadlineDao extends DatabaseAccessor<AppDatabase> with _$DeadlineDaoMixin {
  DeadlineDao(super.db);

  Future<Deadline> insertDeadline(DeadlinesCompanion entry) =>
      into(deadlines).insertReturning(entry);

  Future<void> updateDeadline(Deadline entry) =>
      update(deadlines).replace(entry);

  Future<void> deleteDeadline(int id) =>
      (delete(deadlines)..where((s) => s.id.equals(id))).go();

  Future<void> toggleDone(int id, bool isDone) =>
      (update(deadlines)..where((s) => s.id.equals(id)))
          .write(DeadlinesCompanion(isDone: Value(isDone)));

  Stream<List<Deadline>> watchAllDeadlines() =>
      (select(deadlines)..orderBy([(d) => OrderingTerm(expression: d.dueDate)]))
          .watch();

  Stream<List<Deadline>> watchDeadlinesBySubject(int subjectId) =>
      (select(deadlines)
            ..where((s) => s.subjectId.equals(subjectId))
            ..orderBy([(d) => OrderingTerm(expression: d.dueDate)]))
          .watch();

  Stream<List<Deadline>> watchUpcomingDeadlines({int limit = 3}) {
    return (select(deadlines)
              ..where((d) => d.isDone.equals(false))
              ..orderBy([(d) => OrderingTerm(expression: d.dueDate)])
              ..limit(limit))
        .watch();
  }

  Future<List<Deadline>> getDeadlinesWithReminders() =>
      (select(deadlines)
            ..where((d) =>
                d.reminderDate.isNotNull() |
                d.reminderTime.isNotNull())
            ..where((d) => d.isDone.equals(false)))
          .get();
}

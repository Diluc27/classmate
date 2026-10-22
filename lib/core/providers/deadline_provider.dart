import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

part 'deadline_provider.g.dart';

@riverpod
Stream<List<Deadline>> deadlineList(DeadlineListRef ref) {
  final db = ref.watch(databaseProvider);
  return db.deadlineDao.watchAllDeadlines();
}

@riverpod
Stream<List<Deadline>> upcomingDeadlines(UpcomingDeadlinesRef ref) {
  final db = ref.watch(databaseProvider);
  return db.deadlineDao.watchUpcomingDeadlines(limit: 3);
}

@riverpod
Stream<List<Deadline>> deadlinesBySubject(DeadlinesBySubjectRef ref, int subjectId) {
  final db = ref.watch(databaseProvider);
  return db.deadlineDao.watchDeadlinesBySubject(subjectId);
}

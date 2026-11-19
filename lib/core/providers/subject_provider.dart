import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

part 'subject_provider.g.dart';

@riverpod
class SubjectList extends _$SubjectList {
  @override
  Stream<List<Subject>> build() {
    final db = ref.watch(databaseProvider);
    return db.subjectDao.watchAllSubjects();
  }
}

@riverpod
Stream<List<String>> subjectNames(SubjectNamesRef ref) {
  final db = ref.watch(databaseProvider);
  return db.subjectDao.watchSubjectNames();
}

@riverpod
Future<Subject?> getSubject(GetSubjectRef ref, int id) {
  final db = ref.watch(databaseProvider);
  return db.subjectDao.getSubject(id);
}

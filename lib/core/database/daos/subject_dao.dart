import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../models/subjects.dart';

part 'subject_dao.g.dart';

@DriftAccessor(tables: [Subjects])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {
  SubjectDao(super.db);

  Future<Subject> insertSubject(SubjectsCompanion entry) =>
      into(subjects).insertReturning(entry);

  Future<void> updateSubject(Subject entry) =>
      update(subjects).replace(entry);

  Future<void> deleteSubject(int id) =>
      (delete(subjects)..where((s) => s.id.equals(id))).go();

  Future<Subject?> getSubject(int id) =>
      (select(subjects)..where((s) => s.id.equals(id))).getSingleOrNull();

  Stream<List<Subject>> watchAllSubjects() => select(subjects).watch();

  Future<List<Subject>> getAllSubjects() => select(subjects).get();

  Stream<List<String>> watchSubjectNames() =>
      select(subjects).watch().map((list) => list.map((s) => s.name).toList());
}

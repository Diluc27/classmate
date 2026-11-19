import 'package:drift/drift.dart';
import 'subjects.dart';

class TimetableSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subjectId => integer().references(Subjects, #id)();
  IntColumn get weekday => integer()(); // 1=Mon, 7=Sun
  TextColumn get startTime => text()(); // "HH:mm"
  TextColumn get endTime => text()(); // "HH:mm"
  TextColumn get room => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

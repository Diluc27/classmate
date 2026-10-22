import 'package:drift/drift.dart';
import 'subjects.dart';
import 'timetable_slots.dart';

class ClassSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get slotId => integer().nullable().references(TimetableSlots, #id)();
  IntColumn get subjectId => integer().references(Subjects, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  // status: 'present' | 'absent' | 'cancelled'
  TextColumn get status => text().withDefault(const Constant('absent'))();
  TextColumn get note => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [{subjectId, date, startTime}];
}

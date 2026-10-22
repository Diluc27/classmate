import 'package:drift/drift.dart';
import 'subjects.dart';

class Deadlines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subjectId => integer().nullable().references(Subjects, #id)();
  TextColumn get title => text()();
  // type: 'assignment' | 'exam' | 'viva' | 'practical' | 'test' | 'project' | 'other'
  TextColumn get type => text().withDefault(const Constant('assignment'))();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get reminderDate => dateTime().nullable()();
  TextColumn get reminderTime => text().nullable()();  // "HH:mm" or null
  TextColumn get reminderDays => text().nullable()();  // CSV of weekday numbers "1,2,3,4,5" | null=no specific days
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  BoolColumn get repeatUntilDue => boolean().withDefault(const Constant(false))();
  BoolColumn get reminderFired => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastReminderFiredDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

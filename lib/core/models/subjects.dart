import 'package:drift/drift.dart';

class Subjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get colorHex => text().withDefault(const Constant('#4A90D9'))();
  IntColumn get targetPercent => integer().withDefault(const Constant(75))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

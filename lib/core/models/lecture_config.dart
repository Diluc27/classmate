import 'package:drift/drift.dart';

class LectureScheduleConfig extends Table {
  IntColumn get id => integer()(); // always 1 (singleton)
  TextColumn get collegeName => text().nullable()();
  IntColumn get lectureDurationMins => integer().withDefault(const Constant(50))();
  TextColumn get firstLectureStart => text().withDefault(const Constant("10:00"))();
  TextColumn get breakStart => text().withDefault(const Constant("12:30"))();
  TextColumn get breakEnd => text().withDefault(const Constant("13:00"))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pure data class used by [LectureSlotCalculator] — no DB dependency.
class LectureConfigData {
  final String firstLectureStart;
  final int lectureDurationMins;
  final String? breakStart;
  final String? breakEnd;

  const LectureConfigData({
    this.firstLectureStart = '10:00',
    this.lectureDurationMins = 50,
    this.breakStart = '12:30',
    this.breakEnd = '13:00',
  });
}

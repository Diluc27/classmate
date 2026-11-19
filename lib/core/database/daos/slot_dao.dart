import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../models/timetable_slots.dart';

part 'slot_dao.g.dart';

@DriftAccessor(tables: [TimetableSlots])
class SlotDao extends DatabaseAccessor<AppDatabase> with _$SlotDaoMixin {
  SlotDao(super.db);

  Future<TimetableSlot> insertSlot(TimetableSlotsCompanion entry) =>
      into(timetableSlots).insertReturning(entry);

  Future<void> updateSlot(TimetableSlot entry) =>
      update(timetableSlots).replace(entry);

  Future<void> softDeleteSlot(int id) =>
      (update(timetableSlots)..where((s) => s.id.equals(id)))
          .write(const TimetableSlotsCompanion(isActive: Value(false)));

  Future<void> hardDeleteSlot(int id) =>
      (delete(timetableSlots)..where((s) => s.id.equals(id))).go();

  Stream<List<TimetableSlot>> watchSlotsByWeekday(int weekday) =>
      (select(timetableSlots)
            ..where((s) => s.weekday.equals(weekday))
            ..where((s) => s.isActive.equals(true)))
          .watch();

  Stream<List<TimetableSlot>> watchAllActiveSlots() =>
      (select(timetableSlots)..where((s) => s.isActive.equals(true))).watch();

  Future<List<TimetableSlot>> getAllActiveSlots() =>
      (select(timetableSlots)..where((s) => s.isActive.equals(true))).get();

  Future<TimetableSlot?> getSlotById(int id) =>
      (select(timetableSlots)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<bool> hasConflict(int weekday, String startTime, String endTime,
      {int? excludeSlotId}) async {
    final query = select(timetableSlots)
      ..where((s) => s.weekday.equals(weekday))
      ..where((s) => s.isActive.equals(true))
      ..where((s) => s.startTime.equals(startTime))
      ..where((s) => s.endTime.equals(endTime));
    final results = await query.get();
    if (excludeSlotId != null) {
      return results.any((s) => s.id != excludeSlotId);
    }
    return results.isNotEmpty;
  }
}

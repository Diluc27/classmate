import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../database/daos/lecture_config_dao.dart';
import '../models/lecture_config.dart';
import '../services/lecture_slot_calculator.dart';
import 'database_provider.dart';

part 'lecture_config_provider.g.dart';

@riverpod
LectureConfigDao lectureConfigDao(LectureConfigDaoRef ref) {
  final db = ref.watch(databaseProvider);
  return db.lectureConfigDao;
}

@riverpod
Stream<LectureScheduleConfigData?> lectureConfigProvider(LectureConfigProviderRef ref) {
  final dao = ref.watch(lectureConfigDaoProvider);
  return dao.watchConfig();
}

@riverpod
List<LectureSlot> lectureSlotsProvider(LectureSlotsProviderRef ref, int count) {
  final config = ref.watch(lectureConfigProviderProvider).valueOrNull;
  if (config == null) return [];
  final data = LectureConfigData(
    firstLectureStart: config.firstLectureStart,
    lectureDurationMins: config.lectureDurationMins,
    breakStart: config.breakStart,
    breakEnd: config.breakEnd,
  );
  return LectureSlotCalculator.generateSlots(data, count);
}

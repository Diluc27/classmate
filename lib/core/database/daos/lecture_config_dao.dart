import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../models/lecture_config.dart';

part 'lecture_config_dao.g.dart';

@DriftAccessor(tables: [LectureScheduleConfig])
class LectureConfigDao extends DatabaseAccessor<AppDatabase> with _$LectureConfigDaoMixin {
  LectureConfigDao(super.db);

  Future<void> upsertConfig(LectureScheduleConfigCompanion entry) =>
      into(lectureScheduleConfig).insertOnConflictUpdate(entry);

  Stream<LectureScheduleConfigData?> watchConfig() =>
      (select(lectureScheduleConfig)..where((c) => c.id.equals(1))).watchSingleOrNull();

  Future<LectureScheduleConfigData?> getConfig() =>
      (select(lectureScheduleConfig)..where((c) => c.id.equals(1))).getSingleOrNull();
}

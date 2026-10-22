import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../services/attendance_service.dart';
import '../utils/date_utils.dart' as app_utils;
import 'database_provider.dart';

part 'session_provider.g.dart';

@riverpod
Stream<List<ClassSession>> sessionsByDate(SessionsByDateRef ref, DateTime date) {
  final db = ref.watch(databaseProvider);
  return db.sessionDao.watchSessionsByDate(date);
}

@riverpod
Stream<List<ClassSession>> sessionsBySubject(SessionsBySubjectRef ref, int subjectId) {
  final db = ref.watch(databaseProvider);
  return db.sessionDao.watchSessionsBySubject(subjectId);
}

@riverpod
Stream<Set<DateTime>> presentSessionDates(PresentSessionDatesRef ref) {
  final db = ref.watch(databaseProvider);
  return db.sessionDao.watchAllSessions().map((sessions) => sessions
      .where((s) => s.status == 'present')
      .map((s) => app_utils.AppDateUtils.normalizeDate(s.date))
      .toSet());
}

/// Maps each date to its attendance badge type:
/// - `'present'` if at least one session was present
/// - `'absent'` if all sessions on that date were absent
/// - absent from map if no sessions or all cancelled
@riverpod
Stream<Map<DateTime, String>> attendanceByDate(AttendanceByDateRef ref) {
  final db = ref.watch(databaseProvider);
  return db.sessionDao.watchAllSessions().map((sessions) {
    final map = <DateTime, String>{};
    // Group sessions by normalized date
    final grouped = <DateTime, List<ClassSession>>{};
    for (final s in sessions) {
      final date = app_utils.AppDateUtils.normalizeDate(s.date);
      grouped.putIfAbsent(date, () => []).add(s);
    }
    for (final entry in grouped.entries) {
      // Skip future dates — can't be absent before the day arrives
      if (entry.key.isAfter(DateTime.now())) continue;

      final statuses = entry.value.map((s) => s.status).toSet();
      if (statuses.contains('present')) {
        map[entry.key] = 'present';
      } else if (statuses.contains('absent') && !statuses.contains('present')) {
        // All sessions are absent (or absent + cancelled — still all absent)
        map[entry.key] = 'absent';
      }
      // If only 'cancelled' or other statuses → no entry = no badge
    }
    return map;
  });
}

@riverpod
class AttendanceStatsNotifier extends _$AttendanceStatsNotifier {
  @override
  Future<AttendanceStats?> build(int subjectId) async {
    final db = ref.watch(databaseProvider);
    final subject = await db.subjectDao.getSubject(subjectId);
    if (subject == null) return null;

    final sessions = await db.sessionDao.getSessionsBySubject(subjectId);
    final present = sessions.where((s) => s.status == 'present').length;
    final absent = sessions.where((s) => s.status == 'absent').length;
    final cancelled = sessions.where((s) => s.status == 'cancelled').length;

    return AttendanceService.calculate(
      present: present,
      absent: absent,
      cancelled: cancelled,
      targetPercent: subject.targetPercent,
    );
  }

  Future<void> invalidate() async {
    ref.invalidateSelf();
  }
}

/// Per-subject slice for the total breakdown pie chart.
class SubjectSlice {
  final String name;
  final String colorHex;
  final int total;
  final int present;
  final int absent;
  final int cancelled;
  final double fraction;

  SubjectSlice({
    required this.name,
    required this.colorHex,
    required this.total,
    required this.present,
    required this.absent,
    required this.cancelled,
    required this.fraction,
  });
}

/// Aggregated breakdown for the total attendance card.
class TotalBreakdown {
  final AttendanceStats overall;
  final List<SubjectSlice> slices;

  TotalBreakdown({required this.overall, required this.slices});
}

@riverpod
Future<TotalBreakdown?> totalAttendanceBreakdown(TotalAttendanceBreakdownRef ref) async {
  final db = ref.watch(databaseProvider);
  final subjects = await db.subjectDao.getAllSubjects();
  if (subjects.isEmpty) return null;

  int totalPresent = 0;
  int totalAbsent = 0;
  int totalCancelled = 0;
  int targetSum = 0;
  final raw = <({String name, String colorHex, int total, int present, int absent, int cancelled})>[];

  for (final subject in subjects) {
    final sessions = await db.sessionDao.getSessionsBySubject(subject.id);
    final present = sessions.where((s) => s.status == 'present').length;
    final absent = sessions.where((s) => s.status == 'absent').length;
    final cancelled = sessions.where((s) => s.status == 'cancelled').length;
    totalPresent += present;
    totalAbsent += absent;
    totalCancelled += cancelled;
    targetSum += subject.targetPercent;
    raw.add((name: subject.name, colorHex: subject.colorHex, total: present + absent, present: present, absent: absent, cancelled: cancelled));
  }

  var slices = raw
      .map((s) => SubjectSlice(
            name: s.name,
            colorHex: s.colorHex,
            total: s.total,
            present: s.present,
            absent: s.absent,
            cancelled: s.cancelled,
            fraction: totalPresent > 0 ? s.present / totalPresent : 0,
          ))
      .toList();
  slices.sort((a, b) => b.present.compareTo(a.present));

  final avgTarget = subjects.isNotEmpty ? targetSum ~/ subjects.length : 75;
  final overall = AttendanceService.calculate(
    present: totalPresent,
    absent: totalAbsent,
    cancelled: totalCancelled,
    targetPercent: avgTarget,
  );

  return TotalBreakdown(overall: overall, slices: slices);
}

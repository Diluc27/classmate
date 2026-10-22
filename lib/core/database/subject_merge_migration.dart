import 'package:shared_preferences/shared_preferences.dart';

import 'app_database.dart';

/// One-time migration: merges "PP" and "PBB" subjects into "Python".
///
/// - Moves all class sessions from PP and PBB to Python
/// - Handles date/time conflicts (skips duplicates)
/// - Deletes PP and PBB subject records
/// - Runs only once, tracked by SharedPreferences flag
class SubjectMergeMigration {
  static const _migrationKey = 'migrate_merge_pp_pbb_to_python';

  static Future<void> run(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationKey) == true) return;

    // 1. Find subjects by name
    final allSubjects = await db.subjectDao.getAllSubjects();
    final pp = allSubjects.where((s) => s.name == 'PP').firstOrNull;
    final pbb = allSubjects.where((s) => s.name == 'PBB').firstOrNull;
    final python =
        allSubjects.where((s) => s.name == 'Python').firstOrNull;

    if (pp == null || pbb == null || python == null) {
      print('Migration: PP, PBB, or Python subject not found — skipping');
      return;
    }

    final pythonId = python.id;

    // 2. Get all sessions for PP and PBB
    final ppSessions = await db.sessionDao.getSessionsBySubject(pp.id);
    final pbbSessions = await db.sessionDao.getSessionsBySubject(pbb.id);
    final sessionsToMigrate = [...ppSessions, ...pbbSessions];

    if (sessionsToMigrate.isEmpty) {
      // No sessions, just delete the subjects
      await db.subjectDao.deleteSubject(pp.id);
      await db.subjectDao.deleteSubject(pbb.id);
      await prefs.setBool(_migrationKey, true);
      print('Migration: No sessions to migrate — just deleted PP and PBB');
      return;
    }

    // 3. Migrate sessions in a transaction
    int migrated = 0;
    int skipped = 0;
    await db.transaction(() async {

      for (final session in sessionsToMigrate) {
        // Check if Python already has a session on same date + startTime
        final existing = await db.sessionDao
            .findSessionBySubjectDateAndTime(
                pythonId, session.date, session.startTime);

        if (existing != null) {
          // Conflict: Python already has a session at this time
          // Delete the PP/PBB session (it was covering the same slot)
          await db.sessionDao.deleteSession(session.id);
          skipped++;
        } else {
          // No conflict: update subject_id to Python
          await db.sessionDao.updateSessionSubject(session.id, pythonId);
          migrated++;
        }
      }

      // 4. Delete PP and PBB subjects
      await db.subjectDao.deleteSubject(pp.id);
      await db.subjectDao.deleteSubject(pbb.id);
    });

    // 5. Mark migration as done (outside transaction to avoid flagging if DB rolls back)
    await prefs.setBool(_migrationKey, true);
    print(
        'Migration: Merged PP + PBB into Python — $migrated migrated, $skipped skipped (duplicates)');
  }
}

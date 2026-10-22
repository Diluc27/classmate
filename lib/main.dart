import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_data.dart';
import 'core/database/subject_merge_migration.dart';
import 'core/services/reminder_guardian.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager background task dispatcher
  await Workmanager().initialize(callbackDispatcher);

  // Register periodic guardian — runs every ~15 min (Android minimum)
  // ExistingPeriodicWorkPolicy.update replaces any previous registration
  // with the same unique name to avoid duplicates across restarts.
  await Workmanager().registerPeriodicTask(
    'com.classmate.classmate/reminder-guardian',
    'checkDueReminders',
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    constraints: Constraints(
      networkType: NetworkType.notRequired,
    ),
  );

  // Seed database with subjects and past class sessions
  final db = AppDatabase();
  await SeedData.run(db);
  await SubjectMergeMigration.run(db);

  runApp(
    const ProviderScope(
      child: AtenoApp(),
    ),
  );
}

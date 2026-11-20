import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/services/reminder_guardian.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager background task dispatcher
  await Workmanager().initialize(callbackDispatcher);

  // Cancel old WorkManager task once if migrating from pre-rename build
  await ReminderGuardian.cancelOldPeriodicTaskOnce();

  // Register periodic guardian if background catch-up is enabled (ON by default)
  final catchUpEnabled = await ReminderGuardian.isBackgroundCatchUpEnabled();
  if (catchUpEnabled) {
    await ReminderGuardian.registerPeriodicTask();
  }

  runApp(
    const ProviderScope(
      child: AtenoApp(),
    ),
  );
}

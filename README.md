# Ateno

A student planner app designed to help track attendance targets, manage weekly timetables, organize deadlines, and ensure reliable reminder alarms.

### Features
- **Attendance Tracking & Insights:** Log class session attendance (present, absent, cancelled) and calculate percentage vs. targets, safe leaves, and required catch-up classes.
- **Timetable & Session Management:** Define recurring weekly lecture slots with automatic timetable calculation and batch session generation.
- **Academic Planner & Deadlines:** Manage course deadlines, tasks, and exams with completion tracking and reminder dates.
- **Interactive Calendar:** View daily class sessions and upcoming deadlines by date.
- **Reliable Reminders:** Dual-layer alarm system combining local notifications with periodic background WorkManager execution (`ReminderGuardian`).
- **Theme & Personalization:** Custom display name and multiple themes (Light, Dark, AMOLED, System).

## Requirements
- **Flutter SDK:** Version satisfying Dart SDK `^3.12.0`
- **Java Development Kit (JDK):** Java 17
- **Android SDK:** Configured for Android platform builds (Android only; iOS is not supported)

## Setup and Run
1. Fetch dependencies:
   ```bash
   flutter pub get
   ```
2. Launch the application on a connected Android device or emulator:
   ```bash
   flutter run
   ```

## Commands Reference

| Task | Command |
| :--- | :--- |
| Install dependencies | `flutter pub get` |
| Static analysis | `flutter analyze` |
| Run test suite | `flutter test` |
| Start application | `flutter run` |
| Build release APK | `flutter build apk --release` |
| Run code generation | `dart run build_runner build --delete-conflicting-outputs` |

## Code Generation

> **WARNING: Generated `.g.dart` files are committed in version control. After changing Drift database tables (`lib/core/models/`) or `@riverpod` annotated providers (`lib/core/providers/`), you MUST run:**
> ```bash
> dart run build_runner build --delete-conflicting-outputs
> ```
> **Never hand-edit `.g.dart` files.**

## Architecture Map

- **Entry Point:** `lib/main.dart` initializes WorkManager background tasks and starts `AtenoApp`; `lib/app.dart` configures theme switching, GoRouter stateful shell navigation, and overlay routing.
- **Data Layer:**
  - **Models:** `lib/core/models/` contains Drift table definitions (`Subjects`, `TimetableSlots`, `ClassSessions`, `Deadlines`, `LectureScheduleConfig`).
  - **Database & DAOs:** `lib/core/database/app_database.dart` defines `AppDatabase` (schema version: 6) and registers DAOs in `lib/core/database/daos/`.
  - **Migrations:** Managed in `AppDatabase.migration` via `MigrationStrategy.onUpgrade`. To add a migration:
    1. Increment `schemaVersion` in `lib/core/database/app_database.dart`.
    2. Add a conditional upgrade block (e.g., `if (from <= 6) { ... }`) to `onUpgrade`.
    3. Run `dart run build_runner build --delete-conflicting-outputs`.
- **State Management (Providers):** `lib/core/providers/` holds Riverpod providers (database instance, subjects, sessions, deadlines, calendar date, lecture config, themes, user settings).
- **Services:** `lib/core/services/` contains isolated business logic and platform interfaces (`attendance_service.dart`, `reminder_guardian.dart`, `session_generator.dart`, `lecture_slot_calculator.dart`, `notification_service.dart`, `android_share_service.dart`).
- **Features (UI):** `lib/features/` organizes screen-level UI by domain (`home/`, `calendar/`, `subjects/`, `planner/`, `settings/`, `splash/`), supported by reusable styling and components in `lib/shared/`.

## Testing

Test files live in the `test/` directory (`test/widget_test.dart`, `test/core/services/lecture_slot_calculator_test.dart`, and `test/core/services/attendance_service_test.dart`).

To run a specific test file:
```bash
flutter test test/core/services/lecture_slot_calculator_test.dart
```

## Project Status

Pre-release: release signing is not set up yet (release builds currently default to debug signing keys).

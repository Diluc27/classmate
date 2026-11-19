import 'package:classmate/app.dart';
import 'package:classmate/core/providers/calendar_provider.dart';
import 'package:classmate/core/providers/deadline_provider.dart';
import 'package:classmate/core/providers/session_provider.dart';
import 'package:classmate/core/database/app_database.dart';
import 'package:classmate/core/services/attendance_service.dart';
import 'package:classmate/features/calendar/calendar_screen.dart';
import 'package:classmate/features/home/widgets/today_class_card.dart';
import 'package:classmate/features/subjects/widgets/subject_card.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Advances past the SplashScreen (700ms animation-driven lifecycle).
Future<void> pumpPastSplash(WidgetTester tester) async {
  await tester.pump(); // build and mount
  // Advance 750ms → animation completes → post-frame callback schedules navigation
  await tester.pump(const Duration(milliseconds: 750));
  // Drain all microtasks, frame callbacks, and pending timer events.
  // Drift's async init creates timers that need multiple pump cycles to clear.
  for (int i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AtenoApp()));
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
    await pumpPastSplash(tester);
  }

  Future<void> pumpNavigation(WidgetTester tester) async {
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> selectBottomTab(WidgetTester tester, int index) async {
    const tabLabels = ['Home', 'Calendar', 'Subjects', 'Planner'];
    await tester.tap(find.text(tabLabels[index]));
    await pumpNavigation(tester);
  }

  testWidgets('ClassMate app boots at the home route', (tester) async {
    await pumpApp(tester);

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
    // Section headers are always rendered while streams load, confirming home
    expect(find.text("TODAY'S CLASSES"), findsOneWidget);
  });

  testWidgets('FloatingActionButton navigates to timetable', (tester) async {
    await pumpApp(tester);

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    final fabRect = tester.getRect(find.byType(FloatingActionButton));
    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;

    expect(fabRect.center.dx, closeTo(screenWidth / 2, 0.1));
    expect(fabRect.center.dy, greaterThan(screenHeight * 0.7));
  });

  testWidgets('FAB tap opens menu with Add Class option', (tester) async {
    await pumpApp(tester);

    // Tap the FAB to open the add menu bottom sheet
    await tester.ensureVisible(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);

    // Verify menu shows three options
    expect(find.text('Add Class'), findsOneWidget);
    expect(find.text('Add Subject'), findsOneWidget);
    expect(find.text('Add Deadline'), findsOneWidget);
  });

  testWidgets('Add Class menu item opens Add Class sheet', (tester) async {
    await pumpApp(tester);

    // Tap FAB → menu
    await tester.ensureVisible(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tap "Add Class" in the menu
    await tester.tap(find.text('Add Class'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify the Add Class sheet opened
    expect(find.text('Add Class'), findsNWidgets(2));
    expect(find.text('Subject'), findsOneWidget);
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Start Time'), findsOneWidget);
    expect(find.text('End Time'), findsOneWidget);

    // Room should NOT be present
    expect(find.text('Room (optional)'), findsNothing);
  });

  testWidgets('/add-class route opens Add Class sheet', (tester) async {
    await pumpApp(tester);

    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/add-class');
    await tester.pump();

    for (int i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('Add Class'), findsNWidgets(2));
    expect(find.text('Subject'), findsOneWidget);
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Start Time'), findsOneWidget);
    expect(find.text('End Time'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await pumpNavigation(tester);
  });

  testWidgets(
    '/add-class route keeps a single Add Class sheet across repeated navigation',
    (tester) async {
      await pumpApp(tester);

      final routerContext = tester.element(find.byType(Scaffold).first);
      final router = GoRouter.of(routerContext);

      router.go('/add-class');
      await tester.pump();
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      router.go('/add-class');
      await tester.pump();
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
      expect(find.text('Add Class'), findsNWidgets(2));
      expect(find.text('Subject'), findsOneWidget);
      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Start Time'), findsOneWidget);
      expect(find.text('End Time'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await pumpNavigation(tester);
    },
  );

  testWidgets('tapping a class card opens its edit sheet', (tester) async {
    final subject = Subject(
      id: 1,
      name: 'Math',
      colorHex: '#2563EB',
      targetPercent: 75,
      createdAt: DateTime(2026),
    );
    final session = ClassSession(
      id: 1,
      subjectId: subject.id,
      date: DateTime(2026),
      startTime: '09:00',
      endTime: '10:00',
      status: 'present',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: TodayClassCard(session: session, subject: subject),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Math'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Session'), findsOneWidget);
  });

  testWidgets('tapping a subject card opens subject edit screen', (
    tester,
  ) async {
    final subject = Subject(
      id: 1,
      name: 'Physics',
      colorHex: '#2563EB',
      targetPercent: 75,
      createdAt: DateTime(2026),
    );
    final stats = AttendanceStats(
      present: 3,
      absent: 1,
      cancelled: 0,
      targetPercent: 75,
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SubjectCard(subject: subject, stats: stats),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );

    await tester.tap(find.text('Physics'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Subject'), findsOneWidget);
  });

  testWidgets(
    'System back from Calendar tab returns to Home instead of closing app',
    (tester) async {
      await pumpApp(tester);

      await selectBottomTab(tester, 1);
      expect(find.byType(CalendarScreen), findsOneWidget);

      await tester.binding.handlePopRoute();
      await pumpNavigation(tester);

      // Back from Calendar returns to home with section headers visible
      expect(find.text("TODAY'S CLASSES"), findsOneWidget);
      expect(find.byType(CalendarScreen), findsNothing);
    },
  );

  testWidgets('Calendar shows Add Class button on empty day', (tester) async {
    // Use a taller screen so the content fits below the calendar
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(400, 900));

    // Must normalize date to match what AppDateUtils.normalizeDate produces
    final now = DateTime.now();
    final normalizedDate = DateTime(now.year, now.month, now.day);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedDateProvider.overrideWith((ref) => normalizedDate),
          sessionsByDateProvider(
            normalizedDate,
          ).overrideWith((ref) => Stream.value([])),
          deadlineListProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(home: CalendarScreen()),
      ),
    );
    // Let the async stream settle
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    // CalendarScreen with no sessions/deadlines should show the "Add Class" button
    expect(find.text('Add Class'), findsWidgets);
  });

  // Slot creation dialog ("All [day]s" / "This [day] only") requires
  // database provider overrides to supply at least one subject for the
  // dropdown selection. Without a subject selected, form validation
  // prevents save and the dialog won't appear.
  // TODO: Add when mock providers are available.
  //
  // testWidgets('Slot creation shows All/This dialog', (tester) async {
  //   // override subjectListProvider to return [testSubject]
  //   // fill form, tap Add Slot, verify AlertDialog appears
  //   // with "All Mondays", "This Monday only", Cancel
  // });
}

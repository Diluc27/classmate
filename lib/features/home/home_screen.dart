import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/navigation.dart';

import '../../shared/theme/app_colors.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/date_utils.dart' as app_utils;
import '../../core/utils/constants.dart' as constants;
import '../../core/providers/subject_provider.dart';
import '../../core/providers/session_provider.dart';
import '../../core/providers/deadline_provider.dart';
import '../../core/providers/user_provider.dart';
import '../subjects/add_edit_subject_screen.dart';
import 'widgets/today_class_card.dart';
import 'widgets/attendance_pill.dart';
import 'widgets/attendance_detail_screen.dart';
import 'widgets/upcoming_deadline_chip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();

    final subjectsAsync = ref.watch(subjectListProvider);
    final todaySessionsAsync = ref.watch(
      sessionsByDateProvider(app_utils.AppDateUtils.normalizeDate(today)),
    );
    final upcomingDeadlinesAsync = ref.watch(upcomingDeadlinesProvider);
    final userNameAsync = ref.watch(userNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: userNameAsync.when(
          data: (name) => GestureDetector(
            onTap: () => _showNameEditDialog(context, ref, name),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Hey, $name'),
                const SizedBox(width: 4),
                const Text('👋', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          loading: () => const Text('Hey...'),
          error: (_, _) => const Text('Hey, User'),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 22),
              onPressed: () => openSettings(context),
            ),
          ),
        ],
      ),
      body: _buildBody(
        context,
        ref,
        subjectsAsync,
        todaySessionsAsync,
        upcomingDeadlinesAsync,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Subject>> subjectsAsync,
    AsyncValue<List<ClassSession>> sessionsAsync,
    AsyncValue<List<Deadline>> deadlinesAsync,
  ) {
    // Peek at current resolved values — null while a stream is still loading.
    final subjects = subjectsAsync.valueOrNull;
    final sessions = sessionsAsync.valueOrNull;
    final deadlines = deadlinesAsync.valueOrNull;

    // When ALL three streams have resolved and every list is empty → beautiful
    // centered onboarding with clear CTAs. Not scrollable — fills the screen.
    if (subjects != null &&
        sessions != null &&
        deadlines != null &&
        subjects.isEmpty &&
        sessions.isEmpty &&
        deadlines.isEmpty) {
      return _buildEmptyHome(context);
    }

    // Sectioned layout. Each section uses its own .when() so loading/error
    // states don't block the AppBar or other sections. Section headers are
    // always rendered so the layout feels stable.
    return RefreshIndicator(
      onRefresh: () => _onRefresh(ref),
      color: AppColors.primary,
      backgroundColor: Theme.of(context).cardColor,
      displacement: 24,
      edgeOffset: 8,
      strokeWidth: 2.5,
      child: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── TODAY'S CLASSES ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "TODAY'S CLASSES",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          sessionsAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return _compactEmptyMessage(
                  icon: Icons.event_busy,
                  message: 'No classes today \u2014 enjoy your day off!',
                );
              }
              return Column(
                children: data.map((session) {
                  return ref
                      .watch(getSubjectProvider(session.subjectId))
                      .when(
                        data: (subject) {
                          if (subject == null) return const SizedBox.shrink();
                          return TodayClassCard(
                            session: session,
                            subject: subject,
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      );
                }).toList(),
              );
            },
            loading: () => const SizedBox(height: 100),
            error: (_, _) => const SizedBox(height: 100),
          ),

          const SizedBox(height: 24),

          // ─── ATTENDANCE OVERVIEW ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ATTENDANCE OVERVIEW',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          subjectsAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return _compactEmptyMessage(
                  icon: Icons.library_books_outlined,
                  message: 'No subjects yet \u2014 add one to track attendance',
                );
              }
              return Column(
                children: [
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final subject = data[index];
                        return ref
                            .watch(attendanceStatsNotifierProvider(subject.id))
                            .when(
                              data: (stats) {
                                if (stats == null) return const SizedBox.shrink();
                                return AttendancePill(
                                  subject: subject,
                                  stats: stats,
                                );
                              },
                              loading: () => _loadingPill(context),
                              error: (_, _) => _loadingPill(context),
                            );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ref.watch(totalAttendanceBreakdownProvider).when(
                    data: (bd) {
                      if (bd == null) return const SizedBox.shrink();
                      return TotalAttendanceCard(
                        stats: bd.overall,
                        slices: bd.slices,
                        onTap: () => pushPage(
                          context,
                          AttendanceDetailScreen(
                            overallStats: bd.overall,
                            slices: bd.slices,
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(height: 130),
            error: (_, _) => const SizedBox(height: 130),
          ),

          const SizedBox(height: 24),

          // ─── UPCOMING DEADLINES ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'UPCOMING DEADLINES',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          deadlinesAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return _compactEmptyMessage(
                  icon: Icons.event_note_outlined,
                  message: 'No upcoming deadlines',
                );
              }

              final today = app_utils.AppDateUtils.normalizeDate(DateTime.now());
              final upcoming = data.where(
                (d) => !app_utils.AppDateUtils.normalizeDate(d.dueDate).isBefore(today),
              ).toList();
              final overdue = data.where(
                (d) => app_utils.AppDateUtils.normalizeDate(d.dueDate).isBefore(today),
              ).toList();

              final allDeadlines = [...upcoming, ...overdue];
              return Column(
                children: allDeadlines.map((d) {
                  final isOverdue = overdue.contains(d);
                  Color? subjectColor;
                  if (d.subjectId != null) {
                    final subject = ref
                        .watch(getSubjectProvider(d.subjectId!))
                        .valueOrNull;
                    if (subject != null) {
                      subjectColor = Color(
                        int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
                      );
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 3,
                    ),
                    child: UpcomingDeadlineChip(
                      deadline: d,
                      subjectColor: subjectColor,
                      isOverdue: isOverdue,
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(height: 100),
            error: (_, _) => const SizedBox(height: 100),
          ),
        ],
      ),
      ), // Closing SingleChildScrollView
    ); // Closing RefreshIndicator
  }

  /// Beautiful full-screen empty state for a brand-new app with no data.
  Widget _buildEmptyHome(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),

            // Title
            Text(
              'Welcome to\nClassMate',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),

            // Subtitle
            Text(
              'Add your first class to get started.\n'
              'Track attendance, manage deadlines,\n'
              'and stay on top of your studies.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 15,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),

            // Primary CTA
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: () => openAddClassSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Add Your First Class',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Secondary CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => pushPage(
                  context,
                  const AddEditSubjectScreen(mode: constants.FormMode.add),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.border),
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add a Subject',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // (import hint removed per user request)
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    // Invalidate all data providers so they refetch from the database
    ref.invalidate(subjectListProvider);
    ref.invalidate(totalAttendanceBreakdownProvider);
    ref.invalidate(upcomingDeadlinesProvider);
    ref.invalidate(userNameProvider);

    // Re-fetch today's sessions
    final today = app_utils.AppDateUtils.normalizeDate(DateTime.now());
    ref.invalidate(sessionsByDateProvider(today));

    // Re-fetch per-subject stats
    final subjects = ref.read(subjectListProvider).valueOrNull ?? [];
    for (final s in subjects) {
      ref.invalidate(attendanceStatsNotifierProvider(s.id));
    }

    // Wait for the rebuild to settle
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  /// Shows a dialog to edit the user's displayed name.
  Future<void> _showNameEditDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.pop(ctx, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null &&
        result.trim().isNotEmpty &&
        result.trim() != currentName) {
      await saveUserName(result);
      ref.invalidate(userNameProvider);
    }
  }

  /// A compact, visually consistent empty-section placeholder.
  Widget _compactEmptyMessage({
    required IconData icon,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingPill(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const SizedBox(),
    );
  }
}

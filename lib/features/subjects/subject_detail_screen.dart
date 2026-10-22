import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import '../../shared/theme/app_colors.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/subject_provider.dart';
import '../../core/providers/session_provider.dart';
import '../../core/providers/deadline_provider.dart';
import '../../core/services/attendance_service.dart';
import '../../core/utils/constants.dart' as constants;
import '../../core/utils/navigation.dart';
import 'add_edit_subject_screen.dart';
import 'widgets/attendance_log_tile.dart';
import '../planner/widgets/deadline_tile.dart';

class SubjectDetailScreen extends ConsumerWidget {
  final int subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectAsync = ref.watch(getSubjectProvider(subjectId));
    final statsAsync = ref.watch(attendanceStatsNotifierProvider(subjectId));
    final sessionsAsync = ref.watch(sessionsBySubjectProvider(subjectId));
    final deadlinesAsync = ref.watch(deadlinesBySubjectProvider(subjectId));

    return subjectAsync.when(
      data: (subject) {
        if (subject == null) {
          return const Scaffold(body: Center(child: Text('Subject not found')));
        }
        final subjectColor = Color(
          int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
        );

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(subject.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => pushPage(
                    context,
                    AddEditSubjectScreen(
                      mode: constants.FormMode.edit,
                      subjectId: subjectId,
                    ),
                  ),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Attendance Log'),
                  Tab(text: 'Deadlines'),
                ],
              ),
            ),
            body: Column(
              children: [
                // Stats row
                statsAsync.when(
                  data: (stats) => _StatsRow(stats: stats, color: subjectColor),
                  loading: () => const SizedBox(height: 80),
                  error: (_, _) => const SizedBox(height: 80),
                ),
                // Insight card
                statsAsync.when(
                  data: (stats) {
                    if (stats == null || stats.total == 0) {
                      return const SizedBox(height: 8);
                    }
                    return _InsightCard(stats: stats);
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      _AttendanceLogTab(sessionsAsync: sessionsAsync),
                      _DeadlinesTab(
                        deadlinesAsync: deadlinesAsync,
                        subjectId: subjectId,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final AttendanceStats? stats;
  final Color color;

  const _StatsRow({required this.stats, required this.color});

  @override
  Widget build(BuildContext context) {
    final percent = stats?.percent ?? 0;
    final present = stats?.present ?? 0;
    final absent = stats?.absent ?? 0;
    final cancelled = stats?.cancelled ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            value: '${percent.toStringAsFixed(1)}%',
            label: 'Attendance',
            color: color,
          ),
          _StatItem(
            value: '$present',
            label: 'Present',
            color: AppColors.success,
          ),
          _StatItem(value: '$absent', label: 'Absent', color: AppColors.danger),
          _StatItem(
            value: '$cancelled',
            label: 'Cancelled',
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final AttendanceStats stats;

  const _InsightCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isSafe = stats.isSafe;
    final message = isSafe
        ? 'You can miss ${stats.safeLeaves} more classes'
        : 'Attend ${stats.classesNeeded} classes to reach ${stats.targetPercent}%';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              isSafe ? Icons.thumb_up_alt_outlined : Icons.info_outline,
              color: isSafe ? AppColors.success : AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceLogTab extends ConsumerWidget {
  final AsyncValue<List<ClassSession>> sessionsAsync;

  const _AttendanceLogTab({required this.sessionsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return sessionsAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return const Center(child: Text('No attendance records yet'));
        }
        // Group by month
        final grouped = <String, List<ClassSession>>{};
        for (final s in sessions) {
          final key =
              '${s.date.year}-${s.date.month.toString().padLeft(2, '0')}';
          grouped.putIfAbsent(key, () => []).add(s);
        }
        return ListView(
          children: grouped.entries.map((entry) {
            final parts = entry.key.split('-');
            final year = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final monthName = DateFormat(
              'MMMM yyyy',
            ).format(DateTime(year, month));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    monthName,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                ...entry.value.map((s) => AttendanceLogTile(session: s)),
              ],
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _DeadlinesTab extends ConsumerWidget {
  final AsyncValue<List<Deadline>> deadlinesAsync;
  final int subjectId;

  const _DeadlinesTab({required this.deadlinesAsync, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return deadlinesAsync.when(
      data: (deadlines) {
        if (deadlines.isEmpty) {
          return const Center(child: Text('No deadlines'));
        }
        return ListView(
          children: [...deadlines.map((d) => DeadlineTile(deadline: d))],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

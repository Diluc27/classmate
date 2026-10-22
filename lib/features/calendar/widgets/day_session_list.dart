import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/color_dot.dart';
import '../../../shared/widgets/edit_session_sheet.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/subject_provider.dart';
import '../../../core/providers/session_provider.dart';

class DaySessionList extends ConsumerWidget {
  final List<ClassSession> sessions;

  const DaySessionList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sessions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Classes',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...sessions.map((s) => _SessionTile(session: s)),
      ],
    );
  }
}

class _SessionTile extends ConsumerWidget {
  final ClassSession session;

  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectAsync = ref.watch(getSubjectProvider(session.subjectId));

    return subjectAsync.when(
      data: (subject) {
        if (subject == null) return const SizedBox.shrink();
        final subjectColor = Color(
          int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
        );
        final isPresent = session.status == 'present';
        final isAbsent = session.status == 'absent';
        final statusColor = isPresent
            ? AppColors.success
            : (isAbsent ? AppColors.danger : AppColors.textMuted);

        return GestureDetector(
          onTap: () => _editSession(context, ref),
          onLongPressStart: (details) =>
              _showContextMenu(context, ref, subject, details.globalPosition),
          child: EntranceFadeSlide(
            key: ValueKey('calendar_session_${session.id}'),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: ListTile(
              leading: ColorDot(color: subjectColor),
              title: Text(
                subject.name,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${session.startTime} - ${session.endTime}',
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              trailing: GestureDetector(
                onTap: () => _toggleStatus(ref),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPresent ? 'Present' : (isAbsent ? 'Absent' : 'Cancelled'),
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),
        );
      },
      loading: () => const SizedBox(height: 50),
      error: (_, _) => const SizedBox(height: 50),
    );
  }

  void _showContextMenu(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    Offset globalPosition,
  ) {
    showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        final screenWidth = MediaQuery.of(ctx).size.width;
        double left = globalPosition.dx;
        double top = globalPosition.dy - 60;
        if (top < 20) top = globalPosition.dy + 20;
        if (left > screenWidth - 140) left = screenWidth - 160;
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        onTap: () => Navigator.pop(ctx, 'edit'),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text('Edit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const Divider(height: 1),
                      InkWell(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        onTap: () => Navigator.pop(ctx, 'delete'),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (!context.mounted) return;
      if (value == 'edit') _editSession(context, ref);
      if (value == 'delete') _confirmDelete(context, ref, subject);
    });
  }

  void _editSession(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: EditSessionSheet(session: session, onSaved: () {}),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Session'),
        content: Text('Delete "${subject.name}" at ${session.startTime}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.sessionDao.deleteSession(session.id);
    }
  }

  void _toggleStatus(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final newStatus = switch (session.status) {
      'present' => 'absent',
      'absent' => 'cancelled',
      'cancelled' => 'present',
      _ => 'absent',
    };
    await db.sessionDao.updateSessionStatus(session.id, newStatus);
    ref.invalidate(attendanceStatsNotifierProvider(session.subjectId));
    ref.invalidate(totalAttendanceBreakdownProvider);
  }
}

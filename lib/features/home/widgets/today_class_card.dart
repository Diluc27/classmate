import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/edit_session_sheet.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../core/utils/date_utils.dart' as app_utils;
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/session_provider.dart';

class TodayClassCard extends ConsumerWidget {
  final ClassSession session;
  final Subject subject;

  const TodayClassCard({
    super.key,
    required this.session,
    required this.subject,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'present':
        return AppColors.success;
      case 'absent':
        return AppColors.danger;
      case 'cancelled':
        return AppColors.textMuted;
      default:
        return AppColors.textMuted;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'present':
        return 'Present';
      case 'absent':
        return 'Absent';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectColor = Color(
      int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
    );

    return GestureDetector(
      onTap: () => _editSession(context, ref),
      onLongPressStart: (details) =>
          _showContextMenu(context, ref, details.globalPosition),
      child: EntranceFadeSlide(
        key: ValueKey('session_${session.id}'),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: subjectColor, width: 4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Time column
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: subjectColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          app_utils.AppDateUtils.formatTime(session.startTime),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: subjectColor,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 8,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: subjectColor.withValues(alpha: 0.3),
                        ),
                        Text(
                          app_utils.AppDateUtils.formatTime(session.endTime),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: subjectColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (session.note != null && session.note!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            session.note!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  _StatusChip(
                    status: session.status,
                    color: _statusColor(session.status),
                    label: _statusLabel(session.status),
                    onTap: () => _toggleStatus(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(
    BuildContext context,
    WidgetRef ref,
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
      if (value == 'delete') _confirmDelete(context, ref);
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

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
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

  void _toggleStatus(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final newStatus = switch (session.status) {
      'present' => 'absent',
      'absent' => 'cancelled',
      'cancelled' => 'present',
      _ => 'absent',
    };
    await db.sessionDao.updateSessionStatus(session.id, newStatus);
    ref.invalidate(attendanceStatsNotifierProvider(subject.id));
    ref.invalidate(totalAttendanceBreakdownProvider);
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _StatusChip({
    required this.status,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status == 'present'
                  ? Icons.check_circle
                  : status == 'absent'
                  ? Icons.cancel
                  : Icons.remove_circle,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

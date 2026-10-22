import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart' as app_utils;
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/session_provider.dart';

class AttendanceLogTile extends ConsumerWidget {
  final ClassSession session;

  const AttendanceLogTile({super.key, required this.session});

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
    final statusColor = _statusColor(session.status);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '${session.date.day}',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ),
      ),
      title: Text(
        app_utils.AppDateUtils.formatDayMonth(session.date),
        style: TextStyle(fontFamily: 'Inter', 
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        '${app_utils.AppDateUtils.formatTime(session.startTime)} - '
        '${app_utils.AppDateUtils.formatTime(session.endTime)}',
        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted),
      ),
      trailing: GestureDetector(
        onTap: () => _toggleStatus(ref),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _statusLabel(session.status),
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
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

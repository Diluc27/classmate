import 'package:flutter/material.dart';

import '../../../core/services/attendance_service.dart';
import '../../../core/providers/session_provider.dart';
import '../../../shared/theme/app_colors.dart';

class AttendanceDetailScreen extends StatelessWidget {
  final AttendanceStats overallStats;
  final List<SubjectSlice> slices;

  const AttendanceDetailScreen({
    super.key,
    required this.overallStats,
    required this.slices,
  });

  Color _overallColor() {
    final s = overallStats;
    if (s.total == 0) return AppColors.textMuted.withValues(alpha: 0.3);
    if (s.percent >= s.targetPercent) return AppColors.success;
    if (s.percent >= s.targetPercent - 5) return AppColors.warning;
    return AppColors.danger;
  }

  Color _attendanceColor(double pct) {
    if (pct >= 75) return AppColors.success;
    if (pct >= 70) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final sortedSlices = List<SubjectSlice>.from(slices)
      ..sort((a, b) => b.present.compareTo(a.present));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Details',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Overall summary card ───────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Overall Attendance',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _overallColor().withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${overallStats.percent.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _overallColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${overallStats.present} Present / ${overallStats.total} Total',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        overallStats.isSafe
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        size: 16,
                        color: _overallColor(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        overallStats.total == 0
                            ? 'No attendance data'
                            : overallStats.isSafe
                                ? 'On track'
                                : 'Need ${overallStats.classesNeeded} more',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: _overallColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Per-subject breakdown header ────────────────────
            Row(
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
                  'PER SUBJECT BREAKDOWN',
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
            const SizedBox(height: 12),

            if (sortedSlices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No subjects found',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: sortedSlices.length,
                itemBuilder: (context, index) =>
                    _subjectGridCard(context, sortedSlices[index]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _subjectGridCard(BuildContext context, SubjectSlice slice) {
    final subjectColor =
        Color(int.parse(slice.colorHex.replaceFirst('#', '0xFF')));
    final attendancePct = slice.total > 0
        ? (slice.present / slice.total * 100).clamp(0.0, 100.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subject name
          Text(
            slice.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Attendance percentage
          Text(
            '${attendancePct.toStringAsFixed(1)}%',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _attendanceColor(attendancePct),
            ),
          ),
          const SizedBox(height: 14),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _statChip('${slice.present}', 'Present', AppColors.success),
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.border,
              ),
              _statChip('${slice.absent}', 'Absent', AppColors.danger),
            ],
          ),
          const SizedBox(height: 16),

          // Contribution bar
          if (slice.fraction > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                height: 8,
                width: double.infinity,
                color: AppColors.border,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: slice.fraction,
                  child: Container(color: subjectColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/color_dot.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../core/services/attendance_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/providers/session_provider.dart';
import '../../subjects/subject_detail_screen.dart';

class AttendancePill extends ConsumerWidget {
  final Subject subject;
  final AttendanceStats stats;

  const AttendancePill({super.key, required this.subject, required this.stats});

  Color _piePresentColor() {
    if (stats.total == 0) return AppColors.textMuted.withValues(alpha: 0.3);
    if (stats.percent >= stats.targetPercent) return AppColors.success;
    if (stats.percent >= stats.targetPercent - 5) return AppColors.warning;
    return AppColors.danger;
  }

  Color _pieAbsentColor() {
    return AppColors.textMuted.withValues(alpha: 0.2);
  }

  Color _centerTextColor() {
    if (stats.total == 0) return AppColors.textMuted;
    if (stats.percent >= stats.targetPercent) return AppColors.success;
    if (stats.percent >= stats.targetPercent - 5) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectColor = Color(
      int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
    );

    return GestureDetector(
      onTap: () =>
          pushPage(context, SubjectDetailScreen(subjectId: subject.id)),
      child: EntranceFadeSlide(
        key: ValueKey('attendance_${subject.id}'),
        child: Container(
          width: 136,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ColorDot(color: subjectColor, size: 10),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      subject.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: AttendancePieChart(
                    present: stats.present,
                    absent: stats.absent,
                    presentColor: _piePresentColor(),
                    absentColor: _pieAbsentColor(),
                    centerText: stats.total == 0
                        ? '--'
                        : '${stats.percent.toStringAsFixed(0)}%',
                    centerTextColor: _centerTextColor(),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Center(
                child: Text(
                  '${stats.present}P · ${stats.absent}A',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendancePieChart extends StatelessWidget {
  final int present;
  final int absent;
  final Color presentColor;
  final Color absentColor;
  final String centerText;
  final Color centerTextColor;

  const AttendancePieChart({
    super.key,
    required this.present,
    required this.absent,
    required this.presentColor,
    required this.absentColor,
    required this.centerText,
    required this.centerTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PieChartPainter(
        present: present,
        absent: absent,
        presentColor: presentColor,
        absentColor: absentColor,
      ),
      child: Center(
        child: Text(
          centerText,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: centerTextColor,
          ),
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final int present;
  final int absent;
  final Color presentColor;
  final Color absentColor;

  _PieChartPainter({
    required this.present,
    required this.absent,
    required this.presentColor,
    required this.absentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = present + absent;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    const strokeWidth = 7.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    if (total == 0) {
      final paint = Paint()
        ..color = absentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
      return;
    }

    final presentAngle = (present / total) * 2 * 3.141592653589793;
    const startAngle = -3.141592653589793 / 2;

    // Present arc
    if (present > 0) {
      final presentPaint = Paint()
        ..color = presentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, presentAngle, false, presentPaint);
    }

    // Absent arc
    if (absent > 0) {
      final absentPaint = Paint()
        ..color = absentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        startAngle + presentAngle,
        -((absent / total) * 2 * 3.141592653589793),
        false,
        absentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.present != present ||
        oldDelegate.absent != absent ||
        oldDelegate.presentColor != presentColor ||
        oldDelegate.absentColor != absentColor;
  }
}

/// A single segment for the donut chart.
class AttendanceSegment {
  final String label;
  final double percentage;
  final Color color;

  const AttendanceSegment({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

/// Donut chart drawn with thick stroked arcs separated by gaps.
class _DonutPainter extends CustomPainter {
  final List<AttendanceSegment> segments;
  final double strokeWidth;

  _DonutPainter({required this.segments, required this.strokeWidth});

  static const double _gapDeg = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<double>(0, (s, seg) => s + seg.percentage);
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2 - 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gapRad = _gapDeg * (math.pi / 180);
    final fullCircle = 2 * math.pi;
    final availableAngle = fullCircle - gapRad * segments.length;
    double startAngle = -math.pi / 2;

    for (final seg in segments) {
      if (seg.percentage <= 0) continue;
      final sweep = (seg.percentage / total) * availableAngle;
      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        Paint()
          ..color = seg.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt,
      );
      startAngle += sweep + gapRad;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.strokeWidth != strokeWidth;
}

/// Thick-ring donut chart with separated segments. No center text.
class AttendanceDonutChart extends StatelessWidget {
  final List<AttendanceSegment> segments;
  final double size;
  final double strokeWidth;

  const AttendanceDonutChart({
    super.key,
    required this.segments,
    this.size = 120,
    this.strokeWidth = 28,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _DonutPainter(segments: segments, strokeWidth: strokeWidth),
      ),
    );
  }
}

/// Clean minimal card with donut + legend. No shadows, no borders.
/// Shows first [initialCount] legend items with a "N more +" expand button
/// if there are more subjects. Total attendance % displayed below the donut.
class TotalAttendanceCard extends StatefulWidget {
  final AttendanceStats stats;
  final List<SubjectSlice> slices;
  final VoidCallback? onTap;

  const TotalAttendanceCard({
    super.key,
    required this.stats,
    required this.slices,
    this.onTap,
  });

  @override
  State<TotalAttendanceCard> createState() => _TotalAttendanceCardState();
}

class _TotalAttendanceCardState extends State<TotalAttendanceCard> {
  bool _showAll = false;
  static const int initialCount = 5;

  Color _overallColor() {
    final s = widget.stats;
    if (s.total == 0) return AppColors.textMuted.withValues(alpha: 0.3);
    if (s.percent >= s.targetPercent) return AppColors.success;
    if (s.percent >= s.targetPercent - 5) return AppColors.warning;
    return AppColors.danger;
  }

  static AttendanceSegment _placeholder() => AttendanceSegment(
    label: '\u2014\u2014',
    percentage: 0,
    color: AppColors.textMuted.withValues(alpha: 0.25),
  );

  Widget _legendRow(AttendanceSegment seg) {
    final isEmpty = seg.percentage <= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isEmpty
                  ? AppColors.textMuted.withValues(alpha: 0.25)
                  : seg.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isEmpty ? '\u2014\u2014' : seg.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: isEmpty
                    ? AppColors.textMuted.withValues(alpha: 0.4)
                    : AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isEmpty ? '0.00%' : '${seg.percentage.toStringAsFixed(2)}%',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: isEmpty
                  ? AppColors.textMuted.withValues(alpha: 0.4)
                  : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final realSegments = widget.slices.where((s) => s.fraction > 0).map((s) {
      return AttendanceSegment(
        label: s.name,
        percentage: s.fraction * 100,
        color: Color(int.parse(s.colorHex.replaceFirst('#', '0xFF'))),
      );
    }).toList();

    final hasMore = realSegments.length > initialCount;

    // Pad to at least initialCount so legend doesn't look sparse.
    final padded = List<AttendanceSegment>.from(realSegments);
    while (padded.length < initialCount) {
      padded.add(_placeholder());
    }

    final visibleSegments = _showAll
        ? padded
        : padded.take(initialCount).toList();
    final hiddenCount = realSegments.length - initialCount;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────────────
          Row(
            children: [
              Flexible(
                child: Text(
                  'Overall Attendance',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _chip(
                '${widget.stats.present}P / ${widget.stats.total}',
                AppColors.success,
              ),
              const SizedBox(width: 6),
              _chip(
                widget.stats.safeLeaves > 0
                    ? '${widget.stats.safeLeaves} safe'
                    : widget.stats.classesNeeded > 0
                    ? 'Need ${widget.stats.classesNeeded}'
                    : 'On track',
                _overallColor(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Body: donut (left) + legend (right) ───────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donut + total %
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AttendanceDonutChart(
                      segments: padded,
                      size: 120,
                      strokeWidth: 26,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.stats.percent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _overallColor(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...visibleSegments.map(_legendRow),
                    if (hasMore)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: GestureDetector(
                          onTap: () => setState(() => _showAll = !_showAll),
                          child: Text(
                            _showAll ? 'Show less -' : '$hiddenCount more +',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

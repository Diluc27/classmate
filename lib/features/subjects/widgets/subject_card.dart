import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../core/services/attendance_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/navigation.dart';
import '../add_edit_subject_screen.dart';

class SubjectCard extends ConsumerWidget {
  final Subject subject;
  final AttendanceStats stats;

  const SubjectCard({super.key, required this.subject, required this.stats});

  Color _statusColor() {
    if (stats.total == 0) return AppColors.textMuted;
    if (stats.percent >= stats.targetPercent) return AppColors.success;
    if (stats.percent >= stats.targetPercent - 5) return AppColors.warning;
    return AppColors.danger;
  }

  String _statusLabel() {
    if (stats.total == 0) return 'No data';
    if (stats.percent >= stats.targetPercent) return 'Safe';
    if (stats.isDanger) return 'Danger';
    return 'At Risk';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectColor = Color(
      int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
    );
    final statusColor = _statusColor();

    return GestureDetector(
      onTap: () => pushPage(
        context,
        AddEditSubjectScreen(mode: FormMode.edit, subjectId: subject.id),
      ),
      child: EntranceFadeSlide(
        key: ValueKey('subject_card_${subject.id}'),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: subjectColor, width: 4),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Subject icon with color background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: subjectColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: subjectColor,
                    size: 22,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (stats.total > 0) ...[
                            Text(
                              '${stats.percent.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                            Text(
                              ' · ${stats.present}P · ${stats.absent}A',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ] else
                            Text(
                              'No classes yet',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

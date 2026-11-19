import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/color_dot.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/utils/date_utils.dart' as app_utils;
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/subject_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/database/app_database.dart';
import '../add_edit_deadline_screen.dart';

class DeadlineTile extends ConsumerWidget {
  final Deadline deadline;

  const DeadlineTile({super.key, required this.deadline});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? subjectColor;
    if (deadline.subjectId != null) {
      final subject = ref
          .watch(getSubjectProvider(deadline.subjectId!))
          .valueOrNull;
      if (subject != null) {
        subjectColor = Color(
          int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
        );
      }
    }

    final isOverdue =
        !deadline.isDone &&
        app_utils.AppDateUtils.normalizeDate(
          deadline.dueDate,
        ).isBefore(app_utils.AppDateUtils.normalizeDate(DateTime.now()));

    return GestureDetector(
      onLongPressStart: (details) => _showContextMenu(context, ref, details.globalPosition),
      child: EntranceFadeSlide(
        key: ValueKey('deadline_tile_${deadline.id}'),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => pushPage(
            context,
            AddEditDeadlineScreen(mode: FormMode.edit, deadlineId: deadline.id),
          ),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Done checkbox
              GestureDetector(
                onTap: () => _toggleDone(ref),
                child: Icon(
                  deadline.isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: deadline.isDone
                      ? AppColors.success
                      : AppColors.textMuted,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Subject color dot
              if (subjectColor != null) ...[
                ColorDot(color: subjectColor, size: 10),
                const SizedBox(width: 8),
              ],
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deadline.title,
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: deadline.isDone
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        decoration: deadline.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _TypeBadge(type: deadline.type),
                        const SizedBox(width: 8),
                        Text(
                          app_utils.AppDateUtils.daysRemaining(
                            deadline.dueDate,
                          ),
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 12,
                            color: isOverdue
                                ? AppColors.danger
                                : AppColors.textMuted,
                            fontWeight: isOverdue
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, WidgetRef ref, Offset globalPosition) {
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
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        onTap: () => Navigator.pop(ctx, 'edit'),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text('Edit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const Divider(height: 1),
                      InkWell(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        onTap: () => Navigator.pop(ctx, 'delete'),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text('Delete', style: TextStyle(fontSize: 16, color: Colors.red)),
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
      if (value == 'edit') _editDeadline(context);
      if (value == 'delete') _confirmDelete(context, ref);
    });
  }

  void _editDeadline(BuildContext context) {
    pushPage(
      context,
      AddEditDeadlineScreen(mode: FormMode.edit, deadlineId: deadline.id),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Deadline'),
        content: Text('Delete "${deadline.title}"?'),
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
      await db.deadlineDao.deleteDeadline(deadline.id);
    }
  }

  void _toggleDone(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final newIsDone = !deadline.isDone;
    await db.deadlineDao.toggleDone(deadline.id, newIsDone);
    if (newIsDone) {
      await NotificationService().cancelDeadlineReminder(deadline.id);
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type[0].toUpperCase() + type.substring(1),
        style: TextStyle(fontFamily: 'Inter', 
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

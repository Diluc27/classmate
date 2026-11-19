import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../shared/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/subject_provider.dart';
import '../../core/services/notification_service.dart';
import '../../core/database/app_database.dart';

class AddEditDeadlineScreen extends ConsumerStatefulWidget {
  final FormMode mode;
  final int? deadlineId;

  const AddEditDeadlineScreen({super.key, required this.mode, this.deadlineId});

  @override
  ConsumerState<AddEditDeadlineScreen> createState() =>
      _AddEditDeadlineScreenState();
}

class _AddEditDeadlineScreenState extends ConsumerState<AddEditDeadlineScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _type;
  int? _subjectId;
  late DateTime _dueDate;
  bool _hasReminder = true;
  late TimeOfDay _reminderTime;
  late Set<int> _reminderDays;
  bool _repeatUntilDue = false;
  bool _isSaving = false;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _dayValues = [1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    _type = 'assignment';
    _dueDate = DateTime.now().add(const Duration(days: 7));
    _reminderTime = const TimeOfDay(hour: 9, minute: 0);
    _reminderDays = {1, 2, 3, 4, 5}; // weekdays by default

    if (widget.mode == FormMode.edit && widget.deadlineId != null) {
      _loadDeadline();
    }
  }

  void _loadDeadline() async {
    final db = ref.read(databaseProvider);
    final deadline = (await db.deadlineDao.watchAllDeadlines().first)
        .where((d) => d.id == widget.deadlineId)
        .firstOrNull;
    if (deadline != null && mounted) {
      _titleController.text = deadline.title;
      _type = deadline.type;
      _subjectId = deadline.subjectId;
      _dueDate = deadline.dueDate;
      _hasReminder = deadline.reminderDate != null ||
          deadline.reminderTime != null;
      _reminderTime = deadline.reminderTime != null
          ? _parseTime(deadline.reminderTime!)
          : const TimeOfDay(hour: 9, minute: 0);
      _reminderDays = deadline.reminderDays != null
          ? deadline.reminderDays!
              .split(',')
              .where((s) => s.isNotEmpty)
              .map((s) => int.parse(s.trim()))
              .toSet()
          : deadline.reminderDate != null
              ? {_dueDate.weekday}
              : {1, 2, 3, 4, 5};
      _repeatUntilDue = deadline.repeatUntilDue;
      setState(() {});
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final timeStr = _hasReminder
          ? '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}'
          : null;
      final daysStr =
          _hasReminder && _reminderDays.isNotEmpty ? _reminderDays.join(',') : null;

      if (widget.mode == FormMode.edit && widget.deadlineId != null) {
        final existing = (await db.deadlineDao.watchAllDeadlines().first)
            .where((d) => d.id == widget.deadlineId)
            .firstOrNull;
        if (existing != null) {
          final updated = existing.copyWith(
            title: _titleController.text.trim(),
            type: _type,
            subjectId: Value<int?>(_subjectId),
            dueDate: _dueDate,
            reminderDate: Value<DateTime?>(null),
            reminderTime: Value<String?>(timeStr),
            reminderDays: Value<String?>(daysStr),
            repeatUntilDue: _repeatUntilDue,
          );
          await db.deadlineDao.updateDeadline(updated);
          // Reschedule or cancel notification after edit
          if (_hasReminder) {
            final scheduled = await NotificationService()
                .scheduleDeadlineReminder(updated);
            if (!scheduled && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification permission denied — enable in Settings'),
                ),
              );
            }
          } else {
            await NotificationService()
                .cancelDeadlineReminder(existing.id);
          }
        }
      } else {
        final deadline = await db.deadlineDao.insertDeadline(
          DeadlinesCompanion(
            title: Value(_titleController.text.trim()),
            type: Value(_type),
            subjectId: Value<int?>(_subjectId),
            dueDate: Value(_dueDate),
            reminderTime: Value<String?>(timeStr),
            reminderDays: Value<String?>(daysStr),
            repeatUntilDue: Value(_repeatUntilDue),
          ),
        );
        if (_hasReminder) {
          final scheduled = await NotificationService()
              .scheduleDeadlineReminder(deadline);
          if (!scheduled && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification permission denied — enable in Settings'),
              ),
            );
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.mode == FormMode.edit
                  ? 'Deadline updated'
                  : 'Deadline saved',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving deadline: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    if (widget.deadlineId == null) return;
    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      await db.deadlineDao.deleteDeadline(widget.deadlineId!);
      await NotificationService().cancelDeadlineReminder(widget.deadlineId!);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _closeScreen() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isAdd = widget.mode == FormMode.add;
    final subjects = ref.watch(subjectListProvider).valueOrNull ?? [];
    final isAllSelected = _reminderDays.length == 7;
    final selectedCount = _reminderDays.length;

    return BackButtonListener(
      onBackButtonPressed: () async {
        _closeScreen();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _closeScreen),
          title: Text(isAdd ? 'Add Deadline' : 'Edit Deadline'),
          actions: [
            if (!isAdd)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _isSaving ? null : _delete,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Title',
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Chapter 5 Homework',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // Type selector
                Text(
                  'Type',
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: deadlineTypes.map((t) {
                    final selected = _type == t;
                    return ChoiceChip(
                      label: Text(t[0].toUpperCase() + t.substring(1)),
                      selected: selected,
                      onSelected: (_) => setState(() => _type = t),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Subject selector
                Text(
                  'Subject (optional)',
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  initialValue: _subjectId,
                  decoration: const InputDecoration(
                    hintText: 'No subject / General',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No subject / General'),
                    ),
                    ...subjects.map(
                      (s) => DropdownMenuItem(
                        value: s.id,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    s.colorHex.replaceFirst('#', '0xFF'),
                                  ),
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(s.name),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _subjectId = v),
                ),
                const SizedBox(height: 20),

                // Due date
                Text(
                  'Due Date',
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _pickDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Reminder section ──────────────────────────────
                SwitchListTile(
                  title: Text(
                    'Reminder',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: _hasReminder,
                  onChanged: (v) => setState(() => _hasReminder = v),
                  contentPadding: EdgeInsets.zero,
                ),

                if (_hasReminder) ...[
                  const SizedBox(height: 8),

                  // Time picker
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime,
                      );
                      if (picked != null) {
                        setState(() => _reminderTime = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Reminder time',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(
                        '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Repeat on label + daily chip
                  Row(
                    children: [
                      Text(
                        selectedCount == 7 ? 'Daily' : 'Repeat on',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isAllSelected) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Every day',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Day circles row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final day = _dayValues[i];
                      final label = _dayLabels[i];
                      final isSelected = _reminderDays.contains(day);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _reminderDays.remove(day);
                            } else {
                              _reminderDays.add(day);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textMuted.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Repeat until due date toggle
                  SwitchListTile(
                    title: Text(
                      'Repeat until due date',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Reminds you daily until the deadline',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                    value: _repeatUntilDue,
                    onChanged: (v) => setState(() => _repeatUntilDue = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: Text(_isSaving ? 'Saving...' : 'Save Deadline'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }
}

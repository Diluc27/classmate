import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../core/utils/date_utils.dart' as app_utils;
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/subject_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/session_generator.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../core/providers/lecture_config_provider.dart';

class AddClassSheet extends ConsumerStatefulWidget {
  final int day;
  final TimetableSlot? existingSlot;
  final VoidCallback onSaved;
  final DateTime? defaultDate;

  const AddClassSheet({
    super.key,
    required this.day,
    this.existingSlot,
    required this.onSaved,
    this.defaultDate,
  });

  @override
  ConsumerState<AddClassSheet> createState() => _AddClassSheetState();
}

class _AddClassSheetState extends ConsumerState<AddClassSheet> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedSubjectId;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _selectedDate;
  late int _selectedDay;
  bool _applyToAll = false;
  bool _useLectureSchedule = false;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.day;
    _selectedDate = widget.defaultDate;
    if (widget.existingSlot != null) {
      final slot = widget.existingSlot!;
      _selectedSubjectId = slot.subjectId;
      _selectedDay = slot.weekday;
      final parts = slot.startTime.split(':');
      _startTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      final endParts = slot.endTime.split(':');
      _endTime = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );
      _selectedDate = _nextWeekdayDate(slot.weekday);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  DateTime _nextWeekdayDate(int targetWeekday) {
    final today = DateTime.now();
    final diff = targetWeekday - today.weekday;
    final daysUntil = diff >= 0 ? diff : diff + 7;
    return DateTime(
      today.year,
      today.month,
      today.day,
    ).add(Duration(days: daysUntil));
  }

  String _weekdayName(int weekday) {
    const names = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[weekday.clamp(1, 7)];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubjectId == null || _startTime == null || _endTime == null) {
      return;
    }

    final startStr =
        '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
    final endStr =
        '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

    final db = ref.read(databaseProvider);

    // Editing — no dialog, just update
    if (widget.existingSlot != null) {
      final hasConflict = await db.slotDao.hasConflict(
        _selectedDay,
        startStr,
        endStr,
        excludeSlotId: widget.existingSlot?.id,
      );
      if (hasConflict) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This slot conflicts with an existing class'),
            ),
          );
        }
        return;
      }
      await db.slotDao.updateSlot(
        widget.existingSlot!.copyWith(
          subjectId: _selectedSubjectId!,
          startTime: startStr,
          endTime: endStr,
          weekday: _selectedDay,
        ),
      );
      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
      return;
    }

    // New slot — use toggle to decide recurring vs single
    if (_applyToAll) {
      // Slot-level conflict only matters for recurring
      final hasConflict = await db.slotDao.hasConflict(
        _selectedDay,
        startStr,
        endStr,
      );
      if (hasConflict) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This slot conflicts with an existing class'),
            ),
          );
        }
        return;
      }

      // Create recurring timetable slot
      await db.slotDao.insertSlot(
        TimetableSlotsCompanion(
          subjectId: Value(_selectedSubjectId!),
          weekday: Value(_selectedDay),
          startTime: Value(startStr),
          endTime: Value(endStr),
        ),
      );

      // Auto-generate 4 weeks of session instances from all active slots
      final today = DateTime.now();
      final generator = SessionGeneratorService(db);
      await generator.generateSessions(
        semesterStart: today,
        semesterEnd: today.add(const Duration(days: 28)),
      );
    } else {
      // Create single session for selected date (or next occurrence)
      final targetDate = _selectedDate ?? _nextWeekdayDate(_selectedDay);

      // Check session-level conflict on that specific date
      final existingSession = await db.sessionDao
          .findSessionBySubjectDateAndTime(
            _selectedSubjectId!,
            targetDate,
            startStr,
          );
      if (existingSession != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'A session already exists at this time on that date',
              ),
            ),
          );
        }
        return;
      }

      await db.sessionDao.insertSession(
        ClassSessionsCompanion(
          slotId: const Value(null),
          subjectId: Value(_selectedSubjectId!),
          date: Value(targetDate),
          startTime: Value(startStr),
          endTime: Value(endStr),
          status: const Value('absent'),
          note: Value(
            _noteController.text.isEmpty ? null : _noteController.text,
          ),
        ),
      );
    }

    widget.onSaved();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectListProvider).valueOrNull ?? [];
    final config = ref.watch(lectureConfigProviderProvider).valueOrNull;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              widget.existingSlot != null ? 'Edit Class' : 'Add Class',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Subject
            DropdownButtonFormField<int>(
              initialValue: _selectedSubjectId,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: subjects
                  .map(
                    (s) => DropdownMenuItem(
                      value: s.id,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(s.colorHex.replaceFirst('#', '0xFF')),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(s.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedSubjectId = v),
              validator: (v) => v == null ? 'Select a subject' : null,
            ),
            const SizedBox(height: 20),

            // Date + Day side by side
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 30),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                          _selectedDay =
                              picked.weekday; // auto-detect day from date
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                            : 'Select date',
                        style: TextStyle(
                          color: _selectedDate != null ? null : theme.hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedDay,
                    decoration: const InputDecoration(labelText: 'Day'),
                    items: List.generate(7, (i) {
                      final day = i + 1;
                      return DropdownMenuItem(
                        value: day,
                        child: Text(app_utils.AppDateUtils.weekdayName(day)),
                      );
                    }),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedDay = v);
                    },
                    validator: (v) => v == null ? 'Select a day' : null,
                  ),
                ),
              ],
            ),
            // Schedule toggles row
            if (config != null || widget.existingSlot == null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  if (config != null)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Use ${config.collegeName ?? "lecture"} schedule',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Switch(
                            value: _useLectureSchedule,
                            activeThumbColor: AppColors.primary,
                            onChanged: (v) => setState(() => _useLectureSchedule = v),
                          ),
                        ],
                      ),
                    ),
                  if (widget.existingSlot == null)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Apply to all ${_weekdayName(_selectedDay)}s',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Switch(
                            value: _applyToAll,
                            activeThumbColor: AppColors.primary,
                            onChanged: (v) => setState(() => _applyToAll = v),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // Time section — smoothly animated between lecture dropdown and manual pickers
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: config != null && _useLectureSchedule
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Select Lecture'),
                          items: List.generate(
                            8,
                            (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text('Lecture ${i + 1}'),
                            ),
                          ),
                          onChanged: (v) {
                            if (v == null) return;
                            final slots = ref.read(lectureSlotsProviderProvider(8));
                            if (v <= slots.length) {
                              setState(() {
                                _startTime = slots[v - 1].start;
                                _endTime = slots[v - 1].end;
                              });
                            }
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        _startTime ?? const TimeOfDay(hour: 8, minute: 0),
                                  );
                                  if (picked != null) setState(() => _startTime = picked);
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(labelText: 'Start Time'),
                                  child: Text(
                                    _startTime != null
                                        ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
                                        : 'Select time',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        _endTime ?? const TimeOfDay(hour: 9, minute: 0),
                                  );
                                  if (picked != null) setState(() => _endTime = picked);
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(labelText: 'End Time'),
                                  child: Text(
                                    _endTime != null
                                        ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
                                        : 'Select time',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],

            // Manual time pickers — standalone when toggles spread isn't shown
            if (config == null && widget.existingSlot != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              _startTime ?? const TimeOfDay(hour: 8, minute: 0),
                        );
                        if (picked != null) setState(() => _startTime = picked);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Start Time'),
                        child: Text(
                          _startTime != null
                              ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
                              : 'Select time',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              _endTime ?? const TimeOfDay(hour: 9, minute: 0),
                        );
                        if (picked != null) setState(() => _endTime = picked);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'End Time'),
                        child: Text(
                          _endTime != null
                              ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
                              : 'Select time',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),

            // Note
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(
                  widget.existingSlot != null ? 'Update' : 'Add Class',
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

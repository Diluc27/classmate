import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/session_generator.dart';
import '../../core/utils/date_utils.dart' as app_utils;
import '../../core/providers/lecture_config_provider.dart';

class EditSessionSheet extends ConsumerStatefulWidget {
  final ClassSession session;
  final VoidCallback onSaved;

  const EditSessionSheet({
    super.key,
    required this.session,
    required this.onSaved,
  });

  @override
  ConsumerState<EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends ConsumerState<EditSessionSheet> {
  final _formKey = GlobalKey<FormState>();
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _noteController;
  late bool _applyToAll;

  @override
  void initState() {
    super.initState();
    final startParts = widget.session.startTime.split(':');
    _startTime = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
    final endParts = widget.session.endTime.split(':');
    _endTime = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
    _noteController = TextEditingController(text: widget.session.note ?? '');
    _applyToAll = widget.session.slotId != null;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final startStr =
        '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endStr =
        '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    final db = ref.read(databaseProvider);
    final wasApplyToAll = widget.session.slotId != null;
    final note = _noteController.text.isEmpty ? null : _noteController.text;

    try {
      if (wasApplyToAll && !_applyToAll) {
        // Toggle OFF: detach this session from its recurring slot
        await db.sessionDao.updateSession(widget.session.copyWith(
          slotId: Value<int?>(null),
          startTime: startStr,
          endTime: endStr,
          note: Value<String?>(note),
        ));
      } else if (!wasApplyToAll && _applyToAll) {
        // Toggle ON: make this session recurring by linking to a slot
        final weekday = widget.session.date.weekday;

        // Check if a matching slot already exists
        final existingSlots = await db.slotDao.getAllActiveSlots();
        final matchingSlot = existingSlots.where((s) =>
            s.subjectId == widget.session.subjectId &&
            s.weekday == weekday &&
            s.startTime == startStr &&
            s.endTime == endStr).firstOrNull;

        int slotId;
        if (matchingSlot != null) {
          slotId = matchingSlot.id;
        } else {
          // Create a new recurring slot
          final newSlot = await db.slotDao.insertSlot(
            TimetableSlotsCompanion(
              subjectId: Value(widget.session.subjectId),
              weekday: Value(weekday),
              startTime: Value(startStr),
              endTime: Value(endStr),
            ),
          );
          slotId = newSlot.id;

          // Generate future sessions for this new slot
          final generator = SessionGeneratorService(db);
          await generator.generateSessions(
            semesterStart: DateTime.now(),
            semesterEnd: DateTime.now().add(const Duration(days: 28)),
          );
        }

        await db.sessionDao.updateSession(widget.session.copyWith(
          slotId: Value<int?>(slotId),
          startTime: startStr,
          endTime: endStr,
          note: Value<String?>(note),
        ));
      } else {
        // Same state: just update the session normally
        await db.sessionDao.updateSession(widget.session.copyWith(
          startTime: startStr,
          endTime: endStr,
          note: Value<String?>(note),
        ));
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().contains('UNIQUE constraint')
                ? 'A class session already exists at this time.'
                : 'Failed to save: ${e.toString()}'),
          ),
        );
      }
      return;
    }

    widget.onSaved();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Session',
              style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600),
            ),
            // Lecture dropdown
            if (ref.watch(lectureConfigProviderProvider).valueOrNull != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Select Lecture'),
                  items: [
                    ...List.generate(8, (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('Lecture ${i + 1}'),
                    )),
                    const DropdownMenuItem(
                      value: 0,
                      child: Text('Custom'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null || v == 0) return;
                    final slots = ref.read(lectureSlotsProviderProvider(8));
                    if (v <= slots.length) {
                      setState(() {
                        _startTime = slots[v - 1].start;
                        _endTime = slots[v - 1].end;
                      });
                    }
                  },
                  validator: (v) => null,
                ),
              ),
            const SizedBox(height: 20),

            // Start time
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (picked != null) setState(() => _startTime = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Start Time'),
                child: Text(
                  '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // End time
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                );
                if (picked != null) setState(() => _endTime = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'End Time'),
                child: Text(
                  '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Note
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
              ),
            ),
            const SizedBox(height: 16),

            // Apply to all days toggle
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Apply to all ${app_utils.AppDateUtils.weekdayFullName(widget.session.date.weekday)}s',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                ),
                Switch(
                  value: _applyToAll,
                  onChanged: (v) => setState(() => _applyToAll = v),
                ),
              ],
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

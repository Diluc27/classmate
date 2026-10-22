import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/subject_autocomplete_field.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/constants.dart' as constants;

class AddEditSubjectScreen extends ConsumerStatefulWidget {
  final constants.FormMode mode;
  final int? subjectId;

  const AddEditSubjectScreen({super.key, required this.mode, this.subjectId});

  @override
  ConsumerState<AddEditSubjectScreen> createState() =>
      _AddEditSubjectScreenState();
}

class _AddEditSubjectScreenState extends ConsumerState<AddEditSubjectScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double _targetPercent;
  late Color _selectedColor;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _targetPercent = constants.defaultTargetPercent.toDouble();
    _selectedColor = constants.subjectColors[0];
    if (widget.mode == constants.FormMode.edit && widget.subjectId != null) {
      _loadSubject();
    }
  }

  void _loadSubject() async {
    final db = ref.read(databaseProvider);
    final subject = await db.subjectDao.getSubject(widget.subjectId!);
    if (subject != null && mounted) {
      _nameController.text = subject.name;
      _targetPercent = subject.targetPercent.toDouble();
      _selectedColor = Color(
        int.parse(subject.colorHex.replaceFirst('#', '0xFF')),
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final colorHex =
          '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

      if (widget.mode == constants.FormMode.edit && widget.subjectId != null) {
        final existing = await db.subjectDao.getSubject(widget.subjectId!);
        if (existing != null) {
          await db.subjectDao.updateSubject(
            existing.copyWith(
              name: _nameController.text.trim(),
              colorHex: colorHex,
              targetPercent: _targetPercent.round(),
            ),
          );
        }
      } else {
        await db.subjectDao.insertSubject(
          SubjectsCompanion(
            name: Value(_nameController.text.trim()),
            colorHex: Value(colorHex),
            targetPercent: Value(_targetPercent.round()),
          ),
        );
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving subject: $e')));
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
    final isAdd = widget.mode == constants.FormMode.add;

    return BackButtonListener(
      onBackButtonPressed: () async {
        _closeScreen();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _closeScreen),
          title: Text(isAdd ? 'Add Subject' : 'Edit Subject'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field with autocomplete
                Text(
                  'Subject Name',
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                SubjectAutocompleteField(
                  controller: _nameController,
                  hintText: 'e.g. Mathematics',
                ),

                const SizedBox(height: 24),

                // Color picker
                Text(
                  'Color',
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: constants.subjectColors.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.textPrimary,
                                  width: 3,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Target % slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target Attendance',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_targetPercent.round()}%',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _targetPercent,
                  min: 50,
                  max: 100,
                  divisions: 10,
                  label: '${_targetPercent.round()}%',
                  onChanged: (v) => setState(() => _targetPercent = v),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: Text(_isSaving ? 'Saving...' : 'Save Subject'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/subject_provider.dart';
import '../theme/app_colors.dart';

class SubjectAutocompleteField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final void Function(String selected)? onSelected;
  final bool enabled;

  const SubjectAutocompleteField({
    super.key,
    required this.controller,
    this.hintText,
    this.onSelected,
    this.enabled = true,
  });

  @override
  ConsumerState<SubjectAutocompleteField> createState() =>
      _SubjectAutocompleteFieldState();
}

class _SubjectAutocompleteFieldState
    extends ConsumerState<SubjectAutocompleteField> {
  final _focusNode = FocusNode();
  List<String> _suggestions = [];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = ref.watch(subjectNamesProvider).valueOrNull ?? [];
    final showSuggestions =
        _focusNode.hasFocus &&
        widget.controller.text.length >= 2 &&
        names.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          onChanged: (value) {
            setState(() {
              if (value.length >= 2) {
                _suggestions = names
                    .where((n) => n.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              } else {
                _suggestions = [];
              }
            });
            widget.onSelected?.call(value);
          },
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search subject...',
            hintStyle: TextStyle(fontFamily: 'Inter', 
              color: AppColors.textMuted,
              fontSize: 14,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() => _suggestions = []);
                      widget.onSelected?.call('');
                    },
                  )
                : null,
          ),
        ),
        if (showSuggestions && _suggestions.isNotEmpty)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    suggestion,
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                  ),
                  onTap: () {
                    widget.controller.text = suggestion;
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: suggestion.length),
                    );
                    widget.onSelected?.call(suggestion);
                    _focusNode.unfocus();
                    setState(() => _suggestions = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

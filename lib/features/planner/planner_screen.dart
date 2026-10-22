import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/navigation.dart';
import '../../core/utils/date_utils.dart' as app_utils;
import '../../core/providers/deadline_provider.dart';
import 'add_edit_deadline_screen.dart';
import 'widgets/deadline_tile.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final deadlinesAsync = ref.watch(deadlineListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => pushPage(
              context,
              const AddEditDeadlineScreen(mode: FormMode.add),
            ),
          ),
        ],
      ),
      body: deadlinesAsync.when(
        data: (deadlines) {
          // Filter by type
          final filtered = _selectedFilter == 'All'
              ? deadlines
              : deadlines.where(
                  (d) => d.type.toLowerCase() == _selectedFilter.toLowerCase(),
                ).toList();

          if (filtered.isEmpty) {
            return Column(
              children: [
                _buildFilterBar(),
                const Expanded(
                  child: EmptyState(
                    icon: Icons.assignment_outlined,
                    title: 'No deadlines yet',
                    subtitle: 'Add assignments, exams, and projects to stay on track',
                    actionLabel: 'Add Deadline',
                    onAction: null,
                  ),
                ),
              ],
            );
          }

          final now = app_utils.AppDateUtils.normalizeDate(DateTime.now());
          final weekEnd = now.add(const Duration(days: 7));

          final overdue = filtered
              .where(
                (d) =>
                    !d.isDone &&
                    app_utils.AppDateUtils.normalizeDate(
                      d.dueDate,
                    ).isBefore(now),
              )
              .toList();
          final thisWeek = filtered
              .where(
                (d) =>
                    !d.isDone &&
                    !app_utils.AppDateUtils.normalizeDate(
                      d.dueDate,
                    ).isBefore(now) &&
                    app_utils.AppDateUtils.normalizeDate(
                      d.dueDate,
                    ).isBefore(weekEnd.add(const Duration(days: 1))),
              )
              .toList();
          final upcoming = filtered
              .where(
                (d) =>
                    !d.isDone &&
                    !app_utils.AppDateUtils.normalizeDate(
                      d.dueDate,
                    ).isBefore(weekEnd.add(const Duration(days: 1))),
              )
              .toList();
          final done = filtered.where((d) => d.isDone).toList();

          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              // Filter chips
              _buildFilterBar(),

              // Overdue
              if (overdue.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: _SectionHeader(
                    title: 'Overdue',
                    color: AppColors.danger,
                  ),
                ),
                ...overdue.map((d) => DeadlineTile(deadline: d)),
              ],
              // This Week
              if (thisWeek.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: _SectionHeader(
                    title: 'This Week',
                    color: AppColors.primary,
                  ),
                ),
                ...thisWeek.map((d) => DeadlineTile(deadline: d)),
              ],
              // Upcoming
              if (upcoming.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: _SectionHeader(
                    title: 'Upcoming',
                    color: AppColors.textPrimary,
                  ),
                ),
                ...upcoming.map((d) => DeadlineTile(deadline: d)),
              ],
              // Done
              if (done.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: _SectionHeader(
                    title: 'Done',
                    color: AppColors.textMuted,
                  ),
                ),
                ...done.map((d) => DeadlineTile(deadline: d)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildFilterBar() {
    const filterLabels = ['All', 'Assignment', 'Exam', 'Viva', 'Practical', 'Test'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterLabels.map((label) {
            final selected = _selectedFilter == label;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: selected ? 1.5 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

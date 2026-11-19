import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/empty_state.dart';
import '../../core/utils/constants.dart' as constants;
import '../../core/utils/navigation.dart';
import '../../core/providers/subject_provider.dart';
import '../../core/providers/session_provider.dart';
import 'add_edit_subject_screen.dart';
import 'widgets/subject_card.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => pushPage(
              context,
              const AddEditSubjectScreen(mode: constants.FormMode.add),
            ),
          ),
        ],
      ),
      body: subjectsAsync.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return const EmptyState(
              icon: Icons.library_books_outlined,
              title: 'Add your first subject',
              subtitle: 'Track attendance and deadlines for each subject',
              actionLabel: 'Add Subject',
              onAction: null, // handled by AppBar button
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return ref
                  .watch(attendanceStatsNotifierProvider(subject.id))
                  .when(
                    data: (stats) {
                      if (stats == null) return const SizedBox.shrink();
                      return SubjectCard(subject: subject, stats: stats);
                    },
                    loading: () => const SizedBox(height: 80),
                    error: (_, _) => const SizedBox(height: 80),
                  );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

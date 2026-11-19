import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../shared/theme/app_colors.dart';
import '../../core/utils/date_utils.dart' as app_utils;
import '../../core/providers/calendar_provider.dart';
import '../../core/providers/session_provider.dart';
import '../../core/providers/deadline_provider.dart';
import 'widgets/day_session_list.dart';
import 'widgets/day_deadline_list.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final sessionsAsync = ref.watch(
      sessionsByDateProvider(
        app_utils.AppDateUtils.normalizeDate(selectedDate),
      ),
    );
    final allDeadlinesAsync = ref.watch(deadlineListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          // Calendar
          Consumer(
            builder: (context, ref, _) {
              final selected = ref.watch(selectedDateProvider);
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final attendanceMap = ref.watch(attendanceByDateProvider);

              return TableCalendar(
                firstDay: DateTime(2024),
                lastDay: DateTime(2030),
                focusedDay: selected,
                selectedDayPredicate: (day) =>
                    app_utils.AppDateUtils.isSameDay(selected, day),
                onDaySelected: (selectedDay, focusedDay) {
                  ref.read(selectedDateProvider.notifier).state = selectedDay;
                },
                calendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  defaultTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  weekendTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  outsideTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  withinRangeTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  weekendStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white60 : Colors.black45,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  prioritizedBuilder: (context, date, focusedDay) {
                    final attendance = attendanceMap.valueOrNull ?? {};
                    final key = DateTime(date.year, date.month, date.day);
                    final badgeType = attendance[key];
                    final isToday = app_utils.AppDateUtils.isSameDay(DateTime.now(), date);
                    final isSelected = app_utils.AppDateUtils.isSameDay(selected, date);
                    final isOutside = date.month != focusedDay.month || date.year != focusedDay.year;

                    return Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary
                                  : isToday
                                      ? AppColors.primary.withValues(alpha: 0.2)
                                      : null,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: isToday ? FontWeight.w600 : null,
                                  color: isSelected
                                      ? Colors.white
                                      : isToday
                                          ? AppColors.primary
                                          : isOutside
                                              ? (isDark ? Colors.white24 : Colors.black26)
                                              : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Transparent icon over the date number (date visible underneath)
                        if (badgeType != null)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                badgeType == 'present'
                                    ? Icons.check
                                    : Icons.close,
                                size: 26,
                                color: badgeType == 'present'
                                    ? Colors.green.withValues(alpha: 0.75)
                                    : Colors.red.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          // Selected date header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                app_utils.AppDateUtils.formatFullDate(selectedDate),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: allDeadlinesAsync.when(
              data: (allDeadlines) {
                final dayDeadlines = allDeadlines
                    .where(
                      (d) => app_utils.AppDateUtils.isSameDay(
                        d.dueDate,
                        selectedDate,
                      ),
                    )
                    .toList();
                return sessionsAsync.when(
                  data: (sessions) {
                    if (sessions.isEmpty && dayDeadlines.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 24),
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.event_busy_rounded,
                                  size: 32,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nothing planned here',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap the button below to add a class\nor deadline for this day.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DaySessionList(sessions: sessions),
                          DayDeadlineList(deadlines: dayDeadlines),
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) =>
                      const Center(child: Text('Error loading sessions')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text('Error loading deadlines')),
            ),
          ),
        ],
      ),
    );
  }
}

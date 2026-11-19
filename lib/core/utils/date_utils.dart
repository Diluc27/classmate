import 'package:intl/intl.dart';

class AppDateUtils {
  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static final _dayMonthFormat = DateFormat('d MMM');
  static final _fullDateFormat = DateFormat('EEEE, d MMMM');
  static final _monthYearFormat = DateFormat('MMMM yyyy');

  static String formatTime(String hhmm) => hhmm;

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatDayMonth(DateTime date) => _dayMonthFormat.format(date);

  static String formatFullDate(DateTime date) => _fullDateFormat.format(date);

  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);

  static String daysRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final diff = DateTime(dueDate.year, dueDate.month, dueDate.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff < 0) return 'Overdue by ${-diff}d';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return '$diff days left';
  }

  static String weekdayName(int weekday) {
    const days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday];
  }

  static String weekdayFullName(int weekday) {
    const days = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday];
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static List<DateTime> getDateRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = normalizeDate(start);
    final endDate = normalizeDate(end);
    while (!current.isAfter(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }
}

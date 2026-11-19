import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final calendarViewModeProvider = StateProvider<CalendarMode>((ref) => CalendarMode.month);

enum CalendarMode { month, week }

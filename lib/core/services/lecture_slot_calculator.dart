import 'package:flutter/material.dart';
import '../models/lecture_config.dart' show LectureConfigData;

const int MAX_LECTURE_SLOTS = 8;

class LectureSlot {
  final int number;
  final TimeOfDay start;
  final TimeOfDay end;
  const LectureSlot({required this.number, required this.start, required this.end});
}

class LectureSlotCalculator {
  static List<LectureSlot> generateSlots(LectureConfigData config, int count) {
    final int maxCount = count > MAX_LECTURE_SLOTS ? MAX_LECTURE_SLOTS : count;
    final List<LectureSlot> slots = [];

    final int firstStart = _toMinutes(config.firstLectureStart);
    final int duration = config.lectureDurationMins;
    final int? breakStart = config.breakStart != null ? _toMinutes(config.breakStart!) : null;
    final int? breakEnd = config.breakEnd != null ? _toMinutes(config.breakEnd!) : null;

    int previousEnd = firstStart;

    for (int i = 0; i < maxCount; i++) {
      int currentStart = (i == 0) ? firstStart : previousEnd;

      if (breakStart != null && breakEnd != null && currentStart >= breakStart && currentStart < breakEnd) {
        currentStart = breakEnd;
      }

      int currentEnd = currentStart + duration;

      slots.add(LectureSlot(
        number: i + 1,
        start: _toTimeOfDay(currentStart),
        end: _toTimeOfDay(currentEnd),
      ));

      previousEnd = currentEnd;
    }

    return slots;
  }

  static LectureSlot getSlot(LectureConfigData config, int lectureNumber) {
    return generateSlots(config, lectureNumber).last;
  }

  static int _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static TimeOfDay _toTimeOfDay(int minutesSinceMidnight) {
    return TimeOfDay(
      hour: minutesSinceMidnight ~/ 60,
      minute: minutesSinceMidnight % 60,
    );
  }
}

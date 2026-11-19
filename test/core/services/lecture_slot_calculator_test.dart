import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:classmate/core/models/lecture_config.dart';
import 'package:classmate/core/services/lecture_slot_calculator.dart';

void main() {
  group('LectureSlotCalculator', () {
    test('Test 1: Default config produces correct slots', () {
      final config = const LectureConfigData(
        firstLectureStart: '10:00',
        lectureDurationMins: 50,
        breakStart: '12:30',
        breakEnd: '13:00',
      );
      final slots = LectureSlotCalculator.generateSlots(config, 8);
      expect(slots.length, 8);
      expect(slots[0].start, const TimeOfDay(hour: 10, minute: 0));
      expect(slots[0].end, const TimeOfDay(hour: 10, minute: 50));
      expect(slots[2].end, const TimeOfDay(hour: 12, minute: 30));
      expect(slots[3].start, const TimeOfDay(hour: 13, minute: 0));
    });

    test('Test 2: No break config produces sequential slots', () {
      final config = const LectureConfigData(
        firstLectureStart: '10:00',
        lectureDurationMins: 50,
      );
      final slots = LectureSlotCalculator.generateSlots(config, 3);
      expect(slots.length, 3);
      expect(slots[0].end, const TimeOfDay(hour: 10, minute: 50));
      expect(slots[1].start, const TimeOfDay(hour: 10, minute: 50));
    });

    test('Test 3: Lecture starting during break advances to breakEnd', () {
      final config = const LectureConfigData(
        firstLectureStart: '11:00',
        lectureDurationMins: 60,
        breakStart: '12:00',
        breakEnd: '13:00',
      );
      final slots = LectureSlotCalculator.generateSlots(config, 4);
      expect(slots[1].start, const TimeOfDay(hour: 13, minute: 0));
      expect(slots[2].start, const TimeOfDay(hour: 14, minute: 0));
    });

    test('Test 4: count=0 returns empty list', () {
      final config = const LectureConfigData(
        firstLectureStart: '10:00',
        lectureDurationMins: 50,
        breakStart: '12:30',
        breakEnd: '13:00',
      );
      final slots = LectureSlotCalculator.generateSlots(config, 0);
      expect(slots, isEmpty);
    });

    test('Test 5: count > MAX_LECTURE_SLOTS returns 8 slots max', () {
      final config = const LectureConfigData(
        firstLectureStart: '10:00',
        lectureDurationMins: 50,
      );
      final slots = LectureSlotCalculator.generateSlots(config, 20);
      expect(slots.length, MAX_LECTURE_SLOTS);
    });

    test('Test 6: getSlot matches generateSlots last element', () {
      final config = const LectureConfigData(
        firstLectureStart: '10:00',
        lectureDurationMins: 50,
        breakStart: '12:30',
        breakEnd: '13:00',
      );
      final slots = LectureSlotCalculator.generateSlots(config, 3);
      final single = LectureSlotCalculator.getSlot(config, 3);
      expect(single.start, slots.last.start);
      expect(single.end, slots.last.end);
    });

    test('Test 7: Custom config with 60-min lectures', () {
      final config = const LectureConfigData(
        firstLectureStart: '08:00',
        lectureDurationMins: 60,
        breakStart: '12:00',
        breakEnd: '13:00',
      );
      final slots = LectureSlotCalculator.generateSlots(config, 6);
      expect(slots[3].start, const TimeOfDay(hour: 11, minute: 0));
      expect(slots[3].end, const TimeOfDay(hour: 12, minute: 0));
      expect(slots[4].start, const TimeOfDay(hour: 13, minute: 0));
      expect(slots[4].end, const TimeOfDay(hour: 14, minute: 0));
    });
  });
}

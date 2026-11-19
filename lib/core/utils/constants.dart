import 'package:flutter/material.dart';

// SharedPreferences keys
const String prefUserName = 'user_name';
const String prefSemesterStart = 'semester_start';
const String prefSemesterEnd = 'semester_end';
const String prefDefaultTargetPercent = 'default_target_percent';
const String prefAllowPreMarking = 'allow_pre_marking';
const String prefThemeMode = 'theme_mode';

// Default values
const int defaultTargetPercent = 75;
const bool defaultAllowPreMarking = true;

// Session status constants
const String sessionStatusPresent = 'present';
const String sessionStatusAbsent = 'absent';
const String sessionStatusCancelled = 'cancelled';

// Deadline types
const List<String> deadlineTypes = [
  'assignment',
  'exam',
  'viva',
  'practical',
  'test',
  'project',
  'other',
];

// Subject color palette (8 presets)
const List<Color> subjectColors = [
  Color(0xFF2563EB), // blue
  Color(0xFF7C3AED), // violet
  Color(0xFFDB2777), // pink
  Color(0xFFEA580C), // orange
  Color(0xFF16A34A), // green
  Color(0xFF0891B2), // cyan
  Color(0xFFCA8A04), // yellow
  Color(0xFF6B7280), // grey
];

// Form mode for add/edit screens
enum FormMode { add, edit }

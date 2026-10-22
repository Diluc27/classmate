import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

enum AppThemePreference { system, light, dark, amoled }

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemePreference>(
      (ref) => ThemeModeNotifier()..load(),
    );

class ThemeModeNotifier extends StateNotifier<AppThemePreference> {
  ThemeModeNotifier() : super(AppThemePreference.system);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = _preferenceFromName(prefs.getString(prefThemeMode));
  }

  Future<void> setThemeMode(AppThemePreference preference) async {
    state = preference;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefThemeMode, preference.name);
  }
}

AppThemePreference _preferenceFromName(String? name) {
  return switch (name) {
    'light' => AppThemePreference.light,
    'dark' => AppThemePreference.dark,
    'amoled' => AppThemePreference.amoled,
    _ => AppThemePreference.system,
  };
}

ThemeMode flutterThemeMode(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
    AppThemePreference.amoled => ThemeMode.dark,
    AppThemePreference.system => ThemeMode.system,
  };
}

String themeModeLabel(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.light => 'Light',
    AppThemePreference.dark => 'Dark',
    AppThemePreference.amoled => 'AMOLED black',
    AppThemePreference.system => 'System default',
  };
}

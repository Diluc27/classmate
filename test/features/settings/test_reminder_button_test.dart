import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ateno/core/utils/constants.dart';
import 'package:ateno/features/settings/settings_screen.dart';

void main() {
  group('SettingsScreen test reminder button visibility decision', () {
    test('Default: with no stored value (null), the button shows (default ON)', () {
      final shows = SettingsScreen.shouldShowTestReminderButton(null);
      expect(shows, isTrue);
    });

    test('Stored true: the button shows', () {
      final shows = SettingsScreen.shouldShowTestReminderButton(true);
      expect(shows, isTrue);
    });

    test('Stored false: the button hides', () {
      final shows = SettingsScreen.shouldShowTestReminderButton(false);
      expect(shows, isFalse);
    });
  });

  group('SettingsScreen SharedPreferences test reminder button integration', () {
    test('With no value in SharedPreferences, isTestReminderButtonEnabled defaults to true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final enabled = await SettingsScreen.isTestReminderButtonEnabled(prefs: prefs);
      expect(enabled, isTrue);
    });

    test('With prefShowTestReminderButton set to true, isTestReminderButtonEnabled returns true', () async {
      SharedPreferences.setMockInitialValues({prefShowTestReminderButton: true});
      final prefs = await SharedPreferences.getInstance();

      final enabled = await SettingsScreen.isTestReminderButtonEnabled(prefs: prefs);
      expect(enabled, isTrue);
    });

    test('With prefShowTestReminderButton set to false, isTestReminderButtonEnabled returns false', () async {
      SharedPreferences.setMockInitialValues({prefShowTestReminderButton: false});
      final prefs = await SharedPreferences.getInstance();

      final enabled = await SettingsScreen.isTestReminderButtonEnabled(prefs: prefs);
      expect(enabled, isFalse);
    });
  });
}

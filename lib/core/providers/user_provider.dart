import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Default display name shown when none has been set.
const String defaultUserName = 'User';

/// Riverpod provider that reads the user name from SharedPreferences.
/// Call [ref.invalidate(userNameProvider)] after saving a new name to trigger
/// a UI rebuild.
final userNameProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(prefUserName) ?? defaultUserName;
});

/// Save a new display name and return the saved value (trimmed, never empty).
Future<String> saveUserName(String name) async {
  final trimmed = name.trim();
  final safe = trimmed.isEmpty ? defaultUserName : trimmed;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(prefUserName, safe);
  return safe;
}

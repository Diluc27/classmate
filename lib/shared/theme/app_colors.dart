import 'package:flutter/material.dart';

enum AppColorMode { light, dark, amoled }

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color accent = Color(0xFF7C3AED);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static AppColorMode _mode = AppColorMode.light;

  static void setMode(AppColorMode mode) {
    _mode = mode;
  }

  static bool get _isDark => _mode != AppColorMode.light;
  static bool get _isAmoled => _mode == AppColorMode.amoled;

  static Color get surface => _isAmoled
      ? const Color(0xFF000000)
      : (_isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC));
  static Color get surfaceCard => _isAmoled
      ? const Color(0xFF050505)
      : (_isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF));
  static Color get surfaceElevated => _isAmoled
      ? const Color(0xFF0A0A0A)
      : (_isDark ? const Color(0xFF253349) : const Color(0xFFF1F5F9));
  static Color get textPrimary => _isAmoled
      ? const Color(0xFFFFFFFF)
      : (_isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A));
  static Color get textMuted => _isAmoled
      ? const Color(0xFFD1D5DB)
      : (_isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));
  static Color get border => _isAmoled
      ? const Color(0xFF404040)
      : (_isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));

  /// Premium gradient for headers and hero sections
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle card gradient for premium feel
  static LinearGradient get cardGradient => _isDark
      ? LinearGradient(
          colors: [
            surfaceCard,
            surfaceCard.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : LinearGradient(
          colors: [
            surfaceCard,
            const Color(0xFFF8FAFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  /// Premium shadow for elevated elements
  static List<BoxShadow> get premiumShadow => [
    BoxShadow(
      color: primary.withValues(alpha: _isDark ? 0.15 : 0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: _isDark ? 0.3 : 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Subtle shadow for cards
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: _isDark ? 0.2 : 0.04),
      blurRadius: 12,
      offset: const Offset(0, 2),
      spreadRadius: -1,
    ),
  ];
}

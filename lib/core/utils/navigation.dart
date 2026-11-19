import 'package:flutter/material.dart';

import '../../features/settings/settings_screen.dart';
import '../../features/home/widgets/add_class_sheet.dart';
import '../../shared/widgets/premium_animations.dart';

final shellOverlayDepth = ValueNotifier<int>(0);

void _showShellOverlay() => shellOverlayDepth.value++;

void _hideShellOverlay() {
  if (shellOverlayDepth.value > 0) {
    shellOverlayDepth.value--;
  }
}

/// Push a full-screen overlay page with premium transition on the current
/// branch's Navigator.
/// Bypasses GoRouter — the page is pushed directly onto the nearest
/// Navigator stack, so the system back button pops it within the
/// branch without affecting GoRouter's root stack.
void pushPage(BuildContext context, Widget page) {
  _showShellOverlay();
  Navigator.of(context)
      .push(PremiumPageRoute(page: page))
      .whenComplete(_hideShellOverlay);
}

/// Open the Add Class bottom sheet directly.
Future<void> openAddClassSheet(
  BuildContext context, {
  double topRadius = 24,
  DateTime? selectedDate,
}) async {
  _showShellOverlay();
  try {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: AddClassSheet(
          day: selectedDate?.weekday ?? DateTime.now().weekday,
          onSaved: () {},
          defaultDate: selectedDate,
        ),
      ),
    );
  } finally {
    _hideShellOverlay();
  }
}

/// Push SettingsScreen onto the current Navigator stack.
void openSettings(BuildContext context) {
  pushPage(context, const SettingsScreen());
}

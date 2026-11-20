import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ateno/core/services/notification_service.dart';

void main() {
  group('NotificationService exact reminders mode decision', () {
    test('Combination 1: Switch OFF, Permission DENIED -> inexactAllowWhileIdle', () {
      final mode = NotificationService.determineScheduleMode(
        exactRemindersEnabled: false,
        canScheduleExact: false,
      );
      expect(mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });

    test('Combination 2: Switch OFF, Permission GRANTED -> inexactAllowWhileIdle', () {
      final mode = NotificationService.determineScheduleMode(
        exactRemindersEnabled: false,
        canScheduleExact: true,
      );
      expect(mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });

    test('Combination 3: Switch ON, Permission DENIED -> inexactAllowWhileIdle', () {
      final mode = NotificationService.determineScheduleMode(
        exactRemindersEnabled: true,
        canScheduleExact: false,
      );
      expect(mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });

    test('Combination 4: Switch ON, Permission GRANTED -> exactAllowWhileIdle', () {
      final mode = NotificationService.determineScheduleMode(
        exactRemindersEnabled: true,
        canScheduleExact: true,
      );
      expect(mode, AndroidScheduleMode.exactAllowWhileIdle);
    });
  });
}

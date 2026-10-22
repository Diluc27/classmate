import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class AndroidShareService {
  AndroidShareService._();

  static const String channelName = 'com.classmate.classmate/share';
  static const String shareTextMethod = 'shareText';
  static const String textKey = 'text';
  static const String subjectKey = 'subject';
  static const String titleKey = 'title';

  static const MethodChannel _channel = MethodChannel(channelName);

  static Future<void> shareText({
    required String text,
    String? subject,
    String? title,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('AndroidShareService is only available on Android.');
    }

    final arguments = <String, Object>{
      textKey: text,
    };
    if (subject != null) {
      arguments[subjectKey] = subject;
    }
    if (title != null) {
      arguments[titleKey] = title;
    }

    await _channel.invokeMethod<void>(shareTextMethod, arguments);
  }
}

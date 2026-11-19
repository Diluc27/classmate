package com.classmate.classmate

import android.content.Intent
import android.content.ActivityNotFoundException
import android.os.Build
import android.app.AlarmManager
import android.content.Context
import android.provider.Settings
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private companion object {
        const val CHANNEL_NAME = "com.classmate.classmate/share"
        const val ALARM_CHANNEL = "com.classmate.classmate/alarm"
        const val METHOD_SHARE_TEXT = "shareText"
        const val METHOD_CAN_SCHEDULE_EXACT = "canScheduleExactAlarms"
        const val METHOD_REQUEST_EXACT = "requestExactAlarmPermission"
        const val ARG_TEXT = "text"
        const val ARG_SUBJECT = "subject"
        const val ARG_TITLE = "title"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Share channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    METHOD_SHARE_TEXT -> {
                        val arguments = call.arguments as? Map<*, *>
                        val text = arguments?.get(ARG_TEXT) as? String

                        if (text.isNullOrBlank()) {
                            result.error("invalid_args", "text is required", null)
                            return@setMethodCallHandler
                        }

                        val subject = arguments?.get(ARG_SUBJECT) as? String
                        val title = arguments?.get(ARG_TITLE) as? String
                        val shareIntent = Intent(Intent.ACTION_SEND).apply {
                            type = "text/plain"
                            putExtra(Intent.EXTRA_TEXT, text)
                            if (!subject.isNullOrBlank()) putExtra(Intent.EXTRA_SUBJECT, subject)
                            if (!title.isNullOrBlank()) putExtra(Intent.EXTRA_TITLE, title)
                        }

                        try {
                            startActivity(Intent.createChooser(shareIntent, title))
                            result.success(null)
                        } catch (_: ActivityNotFoundException) {
                            result.error("activity_not_found", "No activity found to share content", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        // Alarm permission channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    METHOD_CAN_SCHEDULE_EXACT -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                            result.success(alarmManager.canScheduleExactAlarms())
                        } else {
                            result.success(true)
                        }
                    }
                    METHOD_REQUEST_EXACT -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val intent = Intent(
                                Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM
                            ).apply {
                                data = Uri.fromParts("package", packageName, null)
                            }
                            startActivity(intent)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}

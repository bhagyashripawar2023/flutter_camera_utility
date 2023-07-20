import 'package:flutter/foundation.dart';

// Static logging utility class.

// NOTE: Future version may add configurable logging setting to control
// in which build modes logging occurs.
class LogUtils {
  static void log(String message) {
    if (!kReleaseMode) {
      debugPrint("${DateTime.now().toIso8601String()}: $message");
    }
  }
}

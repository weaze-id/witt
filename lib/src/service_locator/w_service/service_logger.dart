import 'dart:developer' as dev;

import '../../../witt.dart';

enum LogType { created, disposed }

class ServiceLogger {
  static void log(Type instanceType, LogType logType) {
    if (!WService.enableLog) {
      return;
    }

    switch (logType) {
      case LogType.created:
        dev.log("Creating $instanceType.", name: "WService");
        break;
      case LogType.disposed:
        dev.log("Disposing $instanceType.", name: "WService");
        break;
      default:
    }
  }
}

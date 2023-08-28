import 'dart:developer' as dev;

class LogController {
  static void log(String message, {String name = "DEBUG"}) {
    dev.log(message, name: name);
  }

  static void splittedLog(String message, {String name = "DEBUG"}) {
    dev.log(" ", name: name);
    dev.log(message, name: name);
  }

  static void log2(String message, {String name = "DEBUG"}) {
    dev.log(message, name: name);
  }

  static void errorLog(Object e, {String name = "ERROR"}) {
    log("\n--------------------ERROR-------------------");
    dev.log("", error: e, name: name, level: 1);
    log("Occurs at: ${DateTime.now()}");
    log("--------------------------------------------\n");
  }

  static void warningLog(Object e, {String name = "WARNING"}) {
    log("\n--------------------WARNING-------------------");
    dev.log("", error: e, time: DateTime.now(), name: name, level: 1);
    log("--------------------------------------------\n");
  }
}

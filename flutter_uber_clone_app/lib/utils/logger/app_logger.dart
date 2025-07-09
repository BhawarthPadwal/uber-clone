import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._(); // private constructor

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // number of stacktrace lines
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static void i(dynamic message) => _logger.i(message); // Info
  static void d(dynamic message) => _logger.d(message); // Debug
  static void w(dynamic message) => _logger.w(message); // Warning
  static void e(dynamic message) => _logger.e(message); // Error
}

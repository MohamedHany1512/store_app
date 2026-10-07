import 'dart:math' as math;

import '../constants/app_strings.dart';

/// Presentation helpers. Pure functions - no Flutter dependency, so they are
/// trivial to unit test.
abstract final class AppFormatters {
  const AppFormatters._();

  static const String currencySymbol = 'EGP';

  /// `EGP 1,299.00`
  static String price(double value, {String symbol = currencySymbol}) {
    final fixed = value.toStringAsFixed(2);
    final separator = fixed.indexOf('.');
    if (separator == -1) {
      return '$symbol ${groupThousands(fixed)}';
    }
    // Only the integer part gets separators - never the decimals.
    return '$symbol ${groupThousands(fixed.substring(0, separator))}'
        '.${fixed.substring(separator + 1)}';
  }

  /// `1.3k` - used where horizontal space is tight.
  static String compactPrice(double value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands >= 10 ? 0 : 1)}k';
    }
    return value.toStringAsFixed(0);
  }

  /// Inserts thousand separators into the **integer part** of a numeric string.
  static String groupThousands(String value) {
    final isNegative = value.startsWith('-');
    final digits = isNegative ? value.substring(1) : value;

    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final remaining = digits.length - index;
      buffer.write(digits[index]);
      if (remaining % 3 == 1 && remaining > 1) {
        buffer.write(',');
      }
    }
    return isNegative ? '-$buffer' : buffer.toString();
  }

  /// Time-aware greeting for the home header.
  static String greeting(DateTime now) {
    if (now.hour < 12) {
      return AppStrings.greetingMorning;
    }
    if (now.hour < 18) {
      return AppStrings.greetingAfternoon;
    }
    return AppStrings.greetingEvening;
  }

  /// `4.7`
  static String rating(double value) => value.toStringAsFixed(1);

  /// Clamps a double into an inclusive range.
  static double clamp(double value, double min, double max) =>
      math.max(min, math.min(max, value));
}

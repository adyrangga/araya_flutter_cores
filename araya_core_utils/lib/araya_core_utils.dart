library araya_core_utils;

import 'dart:ui';

import 'package:intl/intl.dart';

/// Araya Core Utils for global use.
class ArayaCoreUtils {
  /// convert hex color to material color.
  ///
  /// [hexColor] - example: #RRGGBB or #AARRGGBB
  static Color fromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse('0x$hexColor'));
  }

  /// currency formatter
  static String currencyFormat(
    double value, {
    String locale = 'id',
    String symbol = 'Rp.',
    int? decimalDigit = 0,
  }) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(value);
  }

  /// unformat currency formatted
  static String unformatCurrency(
    String value, {
    String decimalSign = '',
    String defaultValue = '0',
  }) {
    String numberStr = value.replaceAll(RegExp('([^0-9$decimalSign])'), '');
    // remove first character dot in [numberStr].
    numberStr = numberStr.replaceFirst(RegExp(r'^\.'), '');
    return numberStr.isEmpty ? defaultValue : numberStr;
  }
}

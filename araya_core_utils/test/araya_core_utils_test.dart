import 'package:araya_core_utils/araya_core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Araya Core Utils - fromHex method', () {
    test('8 digits hex color, color must be white', () {
      Color color = ArayaCoreUtils.fromHex('#FFFFFFFF');
      expect(color, Colors.white);
    });
    test('6 digits hex color, color must be white', () {
      Color color = ArayaCoreUtils.fromHex('#FFFFFF');
      expect(color, Colors.white);
    });
  });

  group('Araya Core Utils - currencyFormat method', () {
    test('value must be Rp.0', () {
      String value = ArayaCoreUtils.currencyFormat(0);
      expect(value, 'Rp.0');
    });
    test('value must be Rp.0', () {
      String value = ArayaCoreUtils.currencyFormat(0.0);
      expect(value, 'Rp.0');
    });
    test('value must be Rp.1.000', () {
      String value = ArayaCoreUtils.currencyFormat(1000,
          locale: 'en-US', symbol: '\$ ', decimalDigit: 2);
      expect(value, '\$ 1,000.00');
    });
  });

  group('Araya Core Utils - unformatCurrency method', () {
    test('value must be 0', () {
      String value = ArayaCoreUtils.unformatCurrency('');
      expect(value, '0');
    });
    test('value must be empty', () {
      String value = ArayaCoreUtils.unformatCurrency('', defaultValue: '');
      expect(value, '');
    });
    test('value must be 0', () {
      String value = ArayaCoreUtils.unformatCurrency('0.1');
      expect(value, '01');
    });
    test('value must be 1000', () {
      String value = ArayaCoreUtils.unformatCurrency('Rp.1000');
      expect(value, '1000');
    });
    test('value must be 100', () {
      String value =
          ArayaCoreUtils.unformatCurrency('RP.1.00', decimalSign: '.');
      expect(value, '1.00');
    });
  });
}

import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_commons/my_commons.dart';

void main() {
  group('bdParse', () {
    test('parses valid number strings', () {
      expect(bdParse('12'), BigDecimal.parse('12'));
      expect(bdParse('-3.5'), BigDecimal.parse('-3.5'));
      expect(bdParse('+7'), BigDecimal.parse('7'));
      expect(bdParse('0.0001'), BigDecimal.parse('0.0001'));
    });

    test('trims surrounding whitespace', () {
      expect(bdParse('  42  '), BigDecimal.parse('42'));
      expect(bdParse('\t8.5\n'), BigDecimal.parse('8.5'));
    });

    test('passes BigDecimal through unchanged', () {
      final value = BigDecimal.parse('99.99');
      expect(bdParse(value), value);
    });

    test('parses num input', () {
      expect(bdParse(10), BigDecimal.parse('10'));
      expect(bdParse(-7), BigDecimal.parse('-7'));
      expect(bdParse(1.5), BigDecimal.parse('1.5'));
    });

    test('falls back to zero for null and empty input', () {
      expect(bdParse(null), BigDecimal.zero);
      expect(bdParse(''), BigDecimal.zero);
      expect(bdParse('   '), BigDecimal.zero);
    });

    test('falls back to zero for unparsable input', () {
      expect(bdParse('abc'), BigDecimal.zero);
      expect(bdParse('12abc'), BigDecimal.zero);
      expect(bdParse({'a': 1}), BigDecimal.zero);
    });

    test('uses orElse instead of zero', () {
      final fallback = BigDecimal.parse('-1');
      expect(bdParse(null, orElse: fallback), fallback);
      expect(bdParse('', orElse: fallback), fallback);
      expect(bdParse('nope', orElse: fallback), fallback);
    });
  });

  group('bdOrZero', () {
    test('returns zero for null', () {
      expect(bdOrZero(null), BigDecimal.zero);
    });

    test('returns the same value when not null', () {
      final value = BigDecimal.parse('5.5');
      expect(bdOrZero(value), value);
    });

    test('keeps the value usable in arithmetic', () {
      final total = bdOrZero(null) + BigDecimal.parse('1.5');
      expect(total.compareTo(BigDecimal.parse('1.5')), 0);
    });
  });

  group('bdNormalize', () {
    test('strips trailing zeros', () {
      expect(bdNormalize(BigDecimal.parse('12.000')), '12');
      expect(bdNormalize(BigDecimal.parse('1.50')), '1.5');
      expect(bdNormalize(BigDecimal.parse('0.000')), '0');
    });

    test('normalizes negative zero', () {
      expect(bdNormalize(BigDecimal.parse('-0.0')), '0');
    });

    test('keeps significant digits', () {
      expect(bdNormalize(BigDecimal.parse('1.010')), '1.01');
      expect(bdNormalize(BigDecimal.parse('-2.500')), '-2.5');
      expect(bdNormalize(BigDecimal.parse('100')), '100');
      expect(bdNormalize(BigDecimal.parse('-0.1')), '-0.1');
    });

    test('returns orElse for null', () {
      expect(bdNormalize(null), '');
      expect(bdNormalize(null, orElse: '-'), '-');
    });
  });

  group('bdText', () {
    test('normalizes for display', () {
      expect(bdText(BigDecimal.parse('3.1400')), '3.14');
      expect(bdText(BigDecimal.parse('20.00')), '20');
    });

    test('uses orElse for null', () {
      expect(bdText(null), '');
      expect(bdText(null, orElse: 'N/A'), 'N/A');
    });
  });

  group('bdToNum', () {
    test('returns int for integer-looking values', () {
      expect(bdToNum(BigDecimal.parse('42.00')), isA<int>());
      expect(bdToNum(BigDecimal.parse('42.00')), 42);
      expect(bdToNum(BigDecimal.parse('-7')), -7);
    });

    test('returns double when a fraction remains', () {
      expect(bdToNum(BigDecimal.parse('1.5')), isA<double>());
      expect(bdToNum(BigDecimal.parse('1.5')), 1.5);
    });

    test('returns null for null', () {
      expect(bdToNum(null), isNull);
    });
  });

  group('bdIsZero', () {
    test('treats null as zero', () {
      expect(bdIsZero(null), isTrue);
    });

    test('detects zero regardless of scale and sign', () {
      expect(bdIsZero(BigDecimal.zero), isTrue);
      expect(bdIsZero(BigDecimal.parse('0.000')), isTrue);
      expect(bdIsZero(BigDecimal.parse('-0.0')), isTrue);
    });

    test('rejects non-zero values', () {
      expect(bdIsZero(BigDecimal.parse('0.001')), isFalse);
      expect(bdIsZero(BigDecimal.parse('1')), isFalse);
      expect(bdIsZero(BigDecimal.parse('-0.5')), isFalse);
    });
  });

  group('DecimalTextInputFormatter', () {
    const positive = DecimalTextInputFormatter();
    const signed = DecimalTextInputFormatter(allowNegative: true);

    TextEditingValue typed(String text) => TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );

    String apply(
      DecimalTextInputFormatter formatter,
      String from,
      String to,
    ) =>
        formatter.formatEditUpdate(typed(from), typed(to)).text;

    test('allows empty input', () {
      expect(apply(positive, '12.5', ''), '');
      expect(apply(signed, '-12.5', ''), '');
    });

    test('allows integers and up to three decimals', () {
      expect(apply(positive, '', '0'), '0');
      expect(apply(positive, '1', '12'), '12');
      expect(apply(positive, '12', '12.'), '12.');
      expect(apply(positive, '12.', '12.3'), '12.3');
      expect(apply(positive, '12.3', '12.345'), '12.345');
    });

    test('rejects a fourth decimal place', () {
      expect(apply(positive, '12.34', '12.3456'), '12.34');
    });

    test('rejects malformed input', () {
      expect(apply(positive, '', 'abc'), '');
      expect(apply(positive, '12', '1.2.3'), '12');
      expect(apply(positive, '12', '1,2'), '12');
    });

    test('rejects minus sign unless allowNegative', () {
      expect(apply(positive, '12', '-12'), '12');
    });

    test('accepts minus sign when allowNegative', () {
      expect(apply(signed, '', '-'), '-');
      expect(apply(signed, '-', '-1'), '-1');
      expect(apply(signed, '-1', '-1.25'), '-1.25');
      expect(apply(signed, '-1', '-1.2345'), '-1');
    });
  });
}
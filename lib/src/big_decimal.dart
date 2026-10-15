import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/services.dart';

/// 把後端/輸入框傳來的值安全轉成 [BigDecimal]。
/// null、空字串、無法解析的值都會退回 [orElse]（預設 [BigDecimal.zero]）。
BigDecimal bdParse(Object? value, {BigDecimal? orElse}) {
  final fallback = orElse ?? BigDecimal.zero;
  if (value == null) return fallback;
  if (value is BigDecimal) return value;
  if (value is num) return BigDecimal.tryParse(value.toString()) ?? fallback;
  final text = value.toString().trim();
  if (text.isEmpty) return fallback;
  return BigDecimal.tryParse(text) ?? fallback;
}

/// null 安全取值，方便直接做四則運算。
BigDecimal bdOrZero(BigDecimal? value) => value ?? BigDecimal.zero;

/// 正規化成「整數外觀」：去掉尾端多餘的小數 0。
/// 12.000 -> 12、1.50 -> 1.5、0.000 -> 0、-0.0 -> 0
String bdNormalize(BigDecimal? value, {String orElse = ''}) {
  if (value == null) return orElse;
  var text = value.toPlainString();
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '');
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
    }
  }
  if (text.isEmpty || text == '-' || text == '-0') return '0';
  return text;
}

/// 顯示用文字（已正規化成整數外觀），方便塞進 Text 或表格。
String bdText(BigDecimal? value, {String orElse = ''}) =>
    bdNormalize(value, orElse: orElse);

/// 送給後端的數值：整數外觀回傳 int，帶小數回傳 double，null 維持 null。
num? bdToNum(BigDecimal? value) {
  if (value == null) return null;
  final text = bdNormalize(value);
  return int.tryParse(text) ?? double.tryParse(text) ?? value.toDouble();
}

/// 是否為零值（null 視為零）。
bool bdIsZero(BigDecimal? value) =>
    value == null || value.compareTo(BigDecimal.zero) == 0;

/// 數量輸入框：小數最多三位。[allowNegative] 為 true 時可輸入負號（用於送多）。
class DecimalTextInputFormatter extends TextInputFormatter {
  const DecimalTextInputFormatter({this.allowNegative = false});

  final bool allowNegative;

  static final RegExp _positivePattern = RegExp(r'^\d*\.?\d{0,3}$');
  static final RegExp _signedPattern = RegExp(r'^-?\d*\.?\d{0,3}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final pattern = allowNegative ? _signedPattern : _positivePattern;
    if (pattern.hasMatch(newValue.text)) return newValue;
    return oldValue;
  }
}

import 'package:flutter/services.dart';

class MoneyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var filteredText = newValue.text.replaceAll(RegExp(r'[^0-9,]'), '');

    if (filteredText.startsWith(',')) {
      filteredText = oldValue.text;
    }

    if (filteredText.replaceAll(RegExp(r'[^,]'), '').length > 1) {
      filteredText = oldValue.text;
    }

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}


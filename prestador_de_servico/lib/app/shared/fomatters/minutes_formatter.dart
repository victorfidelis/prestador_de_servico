import 'package:flutter/services.dart';

class MinutesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var filteredText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (filteredText.isNotEmpty && int.parse(filteredText) >= 60) {
      filteredText = oldValue.text;
    }

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}

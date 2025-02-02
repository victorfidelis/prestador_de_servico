import 'package:flutter/services.dart';

class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.trim().replaceAll(RegExp(r'[^0-9:]'), '');

    if (text.startsWith(':')) {
      text = oldValue.text;
    }

    int quantityTwoPoint = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ':') {
        quantityTwoPoint += 1;
      }
    }
    if (quantityTwoPoint > 1) {
      text = oldValue.text;
    }

    if (text.length == 1 && int.parse(text) > 2) {
      text = '0$text:';
    }

    if (text.length == 2 && text[1] == ':') {
      text = '0$text';
    }

    if (text.length == 2 && int.parse(text) > 23) {
      text = oldValue.text;
    }

    if (text.length == 3 && !text.contains(':')) {
      text = '${text.substring(0, 2)}:${text.substring(2, 3)}';
    }

    if (text.length == 4 && !text.contains(':')) { 
      text = '${text.substring(0, 2)}:${text.substring(2, 4)}';
    }

    if (text.length == 4 && text[2] == ':' && int.parse(text[3]) >= 6) {
      text = oldValue.text;
    }
    
    if (text.length == 5 && text[2] != ':') {
      text = oldValue.text;
    } 

    if (text.length == 5 && int.parse(text.substring(3, 5)) >= 60) {
      text = oldValue.text;
    }

    if (text.length > 5) {
      text = oldValue.text;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

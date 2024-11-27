
import 'package:prestador_de_servico/app/shared/extensions/string_extensions.dart';

class Formatters {
  static String formatPrice(double price) {
    var textPrice = price.toStringAsFixed(2).replaceAll('.', ',').trim();
    textPrice = addThousandsSeparator(textPrice);
    textPrice = 'R\$ $textPrice';
    return textPrice;
  }

  static String addThousandsSeparator(String value) {
    var reverseTextPrice = value.reverse();
    var formatReverseTextPrice = reverseTextPrice.substring(0, 3);
    for (int i = 3; i < reverseTextPrice.length; i++) {
      var intIndex = i - 3;
      if (intIndex > 0 && intIndex % 3 == 0) {
        formatReverseTextPrice += '.';
      }
      formatReverseTextPrice += reverseTextPrice[i];
    }
    return formatReverseTextPrice.reverse();
  }

  static String formatHoursAndMinutes(int hours, int minutes) {
    var textHoursAndMinutes = '';
    if (hours > 0) {
      textHoursAndMinutes = '${hours.toString().trim()} h';
    }
    if (minutes > 0) {
      textHoursAndMinutes += (textHoursAndMinutes.isEmpty ? '' : ' e ');
      textHoursAndMinutes += '${minutes.toString().trim()} min';
    }
    return textHoursAndMinutes;
  }
}
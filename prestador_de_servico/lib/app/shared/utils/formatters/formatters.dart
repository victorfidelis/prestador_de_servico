
import 'package:prestador_de_servico/app/shared/utils/extensions/string_extensions.dart';

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

  static String defaultFormatHoursAndMinutes(int hours, int minutes) {
    var textHoursAndMinutes = '';
    textHoursAndMinutes = '${hours.toString().padLeft(2, '0')}:';
    textHoursAndMinutes += minutes.toString().padLeft(2, '0');
    return textHoursAndMinutes;
  }
  
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Mês inválido: $month');
    }

    const months = [
      '',
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return months[month];
  }

  static getWeekDayName(int weekDay) {
    if (weekDay < 1 || weekDay > 7) {
      throw ArgumentError('Dia da semana inválida: $weekDay');
    }

    const weekDays = [
      '',
      'Segunda feira',
      'Terça feira',
      'Quarta feira',
      'Quinta feira',
      'Sexta feira',
      'Sábado',
      'Domingo',
    ];

    return weekDays[weekDay];

  }

  static getWeekDayNameWithDoubleLine(int weekDay) {
    if (weekDay < 1 || weekDay > 7) {
      throw ArgumentError('Dia da semana inválida: $weekDay');
    }

    const weekDays = [
      '',
      'Segunda\nfeira',
      'Terça\nfeira',
      'Quarta\nfeira',
      'Quinta\nfeira',
      'Sexta\nfeira',
      'Sábado',
      'Domingo',
    ];

    return weekDays[weekDay];

  }

  static String defaultFormatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
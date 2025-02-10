class DateFunctions {
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
}

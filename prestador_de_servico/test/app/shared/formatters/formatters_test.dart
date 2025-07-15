import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';

void main() {
  group(
    'formatPrice',
    () {
      test(
        'Deve retornar "R\$ 5,00" quando o preço for 5',
        () {
          const double price = 5;
          const textPriceExpect = 'R\$ 5,00';

          final textPrice = DataConverter.formatPrice(price);

          expect(textPrice, equals(textPriceExpect));
        },
      );

      test(
        'Deve retornar "R\$ 5,98" quando o preço for 5.98',
        () {
          const double price = 5.98;
          const textPriceExpect = 'R\$ 5,98';

          final textPrice = DataConverter.formatPrice(price);

          expect(textPrice, equals(textPriceExpect));
        },
      );

      test(
        'Deve retornar "R\$ 5.000,98" quando o preço for 5000.98',
        () {
          const double price = 5000.98;
          const textPriceExpect = 'R\$ 5.000,98';

          final textPrice = DataConverter.formatPrice(price);

          expect(textPrice, equals(textPriceExpect));
        },
      );

      test(
        'Deve retornar "R\$ 59.875.123,99" quando o preço for 59875123.99',
        () {
          const double price = 59875123.99;
          const textPriceExpect = 'R\$ 59.875.123,99';

          final textPrice = DataConverter.formatPrice(price);

          expect(textPrice, equals(textPriceExpect));
        },
      );
    },
  );

  group(
    'formatHoursAndMinutes',
    () {
      test(
        'Deve retornar "" quando a hora e o minuto forem 0',
        () {
          const int hours = 0;
          const int minutes = 0;
          const hoursAndMinutesExpect = '';

          final hoursAndMinutes = DataConverter.formatHoursAndMinutes(hours, minutes);

          expect(hoursAndMinutes, equals(hoursAndMinutesExpect));
        },
      );

      test(
        'Deve retornar "1 h" quando a hora for 1 e o minuto for 0',
        () {
          const int hours = 1;
          const int minutes = 0;
          const hoursAndMinutesExpect = '1 h';

          final hoursAndMinutes = DataConverter.formatHoursAndMinutes(hours, minutes);

          expect(hoursAndMinutes, equals(hoursAndMinutesExpect));
        },
      );
      
      test(
        'Deve retornar "1 h e 10 min" quando a hora for 1 e o minuto for 10',
        () {
          const int hours = 1;
          const int minutes = 10;
          const hoursAndMinutesExpect = '1 h e 10 min';

          final hoursAndMinutes = DataConverter.formatHoursAndMinutes(hours, minutes);

          expect(hoursAndMinutes, equals(hoursAndMinutesExpect));
        },
      );
      
      test(
        'Deve retornar "10 min" quando a hora for 0 e o minuto for 10',
        () {
          const int hours = 0;
          const int minutes = 10;
          const hoursAndMinutesExpect = '10 min';

          final hoursAndMinutes = DataConverter.formatHoursAndMinutes(hours, minutes);

          expect(hoursAndMinutes, equals(hoursAndMinutesExpect));
        },
      );
    },
  );
}

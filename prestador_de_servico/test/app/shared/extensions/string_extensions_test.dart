import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/shared/extensions/string_extensions.dart';

void main() {
  
  group(
    'reverse',
    () {
      test(
        'Deve retornar "987654321" quando o valor for "123456789"',
        () {
          const input = '123456789';
          const outExpected = '987654321';

          final out = input.reverse();

          expect(out, equals(outExpected));
        },
      );
    },
  );
}
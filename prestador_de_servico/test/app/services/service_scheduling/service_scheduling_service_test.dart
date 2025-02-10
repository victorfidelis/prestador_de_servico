import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late SchedulingService serviceSchedulingService;

  late SchedulingDay schedulingDayBefore10Days;
  late SchedulingDay schedulingDayAfter10Days;
  late SchedulingDay schedulingDayAfter100Days;

  void setUpValues() {
    serviceSchedulingService = SchedulingService(
      onlineRepository: onlineMockSchedulingRepository,
    );

    final actualTime = DateTime.now();
    final actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);

    schedulingDayBefore10Days = SchedulingDay(
      date: actualDate.add(const Duration(days: -10)),
      isSelected: false,
      hasService: true,
      isToday: false,
      numberOfServices: 1,
    );
    schedulingDayAfter10Days = SchedulingDay(
      date: actualDate.add(const Duration(days: 10)),
      isSelected: false,
      hasService: true,
      isToday: false,
      numberOfServices: 1,
    );
    schedulingDayAfter100Days = SchedulingDay(
      date: actualDate.add(const Duration(days: 100)),
      isSelected: false,
      hasService: true,
      isToday: false,
      numberOfServices: 1,
    );
  }

  setUp(() {
    setUpMockServiceSchedulingRepository();
    setUpValues();
  });

  group(
    'getDates',
    () {
      test(
        'Deve retorno um Failure caso algum erro ocorra no repository',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isLeft, isTrue);
          expect(datesEither.left!.message, equals(failureMessage));
        },
      );

      test(
        'Deve retorno um NetworkFailure caso não tenha acesso a internet',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isLeft, isTrue);
          expect(datesEither.left is NetworkFailure, isTrue);
          expect(datesEither.left!.message, equals(failureMessage));
        },
      );

      test('''Deve retornar uma lista de datas iniciando no dia atual e terminando após 90 dias
        quando não existirem serviços''', () async {
        const daysToAdd = 90;
        final List<SchedulingDay> schedulesPerDay = [];

        final actualTime = DateTime.now();
        final actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);
        final finalDate = actualDate.add(const Duration(days: daysToAdd));

        when(onlineMockSchedulingRepository.getDaysWithService())
            .thenAnswer((_) async => Either.right(schedulesPerDay));

        final datesEither = await serviceSchedulingService.getDates();

        expect(datesEither.isRight, isTrue);
        final dates = datesEither.right!;
        expect(dates.length, equals(daysToAdd + 1));
        expect(dates[0].date, equals(actualDate));
        expect(dates[daysToAdd].date, equals(finalDate));
      });

      test(
        '''Deve retornar uma lista de datas iniciando na data do primeiro serviço e 
        terminando 90 dias depois da data atual quando existirem serviços anteriores
        a data atual e não existirem serviços posteriores a 90 dias da data atual''',
        () async {
          const daysToAdd = 90;
          const daysToRemoveOfActualDate = 10; 

          final List<SchedulingDay> schedulesPerDay = [
            schedulingDayBefore10Days,
            schedulingDayAfter10Days,
          ];

          final actualTime = DateTime.now();
          final actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);

          final finalDate = actualDate.add(const Duration(days: daysToAdd));

          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAdd + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(schedulingDayBefore10Days));
          expect(dates[daysToAdd + daysToRemoveOfActualDate].date, equals(finalDate));
        },
      );

      test(
        '''Deve retornar uma lista de datas iniciando na data do primeiro serviço e 
        terminando na data do último serviço quando existirem serviços anteriores
        a data atual e existirem serviços posteriores a 90 dias da data atual''',
        () async {
          const daysToAddOfActualDate = 100; 
          const daysToRemoveOfActualDate = 10; 
          final List<SchedulingDay> schedulesPerDay = [
            schedulingDayBefore10Days,
            schedulingDayAfter10Days,
            schedulingDayAfter100Days,
          ];

          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAddOfActualDate + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(schedulingDayBefore10Days));
          expect(dates[daysToAddOfActualDate + daysToRemoveOfActualDate], equals(schedulingDayAfter100Days));
        },
      );
    },
  );
}

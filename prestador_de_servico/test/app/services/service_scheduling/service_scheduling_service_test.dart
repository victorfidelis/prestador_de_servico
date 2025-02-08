import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/services/service_scheduling/service_scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service_schedulingk/mock_service_scheduling_repository.dart';

void main() {
  late ServiceSchedulingService serviceSchedulingService;

  void setUpValues() {
    serviceSchedulingService = ServiceSchedulingService(
      onlineRepository: onlineMockServiceSchedulingRepository,
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
          when(onlineMockServiceSchedulingRepository.getDateOfFirstService())
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
          when(onlineMockServiceSchedulingRepository.getDateOfFirstService())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isLeft, isTrue);
          expect(datesEither.left is NetworkFailure, isTrue);
          expect(datesEither.left!.message, equals(failureMessage));
        },
      );

      test('''Deve retornar uma lista de datas iniciando no dia atual e terminando após 90 dias
        quando não existirem serviços''', () async {
        const failureMessage = 'Falha de teste';
        const daysToAdd = 90;

        final actualTime = DateTime.now();
        final actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);
        final finalDate = actualDate.add(const Duration(days: daysToAdd));

        when(onlineMockServiceSchedulingRepository.getDateOfFirstService())
            .thenAnswer((_) async => Either.left(NoServiceFailure(failureMessage)));
        when(onlineMockServiceSchedulingRepository.getDateOfLastService())
            .thenAnswer((_) async => Either.left(NoServiceFailure(failureMessage)));

        final datesEither = await serviceSchedulingService.getDates();

        expect(datesEither.isRight, isTrue);
        final dates = datesEither.right!;
        expect(dates.length, equals(daysToAdd + 1));
        expect(dates[0], equals(actualDate));
        expect(dates[daysToAdd], equals(finalDate));
      });

      test(
        '''Deve retornar uma lista de datas iniciando na data do primeiro serviço e 
        terminando 90 dias depois da data atual quando existirem serviços anteriores
        a data atual e não existirem serviços posteriores a 90 dias da data atual''',
        () async {
          const daysToRemoveOfActualDate = 10;
          const daysToAddOfActualDate = 10;
          const daysToAdd = 90;

          final actualTime = DateTime.now();
          final actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);

          final dateOfFirstService = actualDate.add(const Duration(days: -daysToRemoveOfActualDate));
          final dateOfLastService = actualDate.add(const Duration(days: daysToAddOfActualDate));
          final finalDate = actualDate.add(const Duration(days: daysToAdd));

          when(onlineMockServiceSchedulingRepository.getDateOfFirstService())
              .thenAnswer((_) async => Either.right(dateOfFirstService));
          when(onlineMockServiceSchedulingRepository.getDateOfLastService())
              .thenAnswer((_) async => Either.right(dateOfLastService));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAdd + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(dateOfFirstService));
          expect(dates[daysToAdd + daysToRemoveOfActualDate], equals(finalDate));
        },
      );

      test(
        '''Deve retornar uma lista de datas iniciando na data do primeiro serviço e 
        terminando na data do último serviço quando existirem serviços anteriores
        a data atual e existirem serviços posteriores a 90 dias da data atual''',
        () async {
          const daysToRemoveOfActualDate = 10;
          const daysToAddOfActualDate = 100;

          final actualTime = DateTime.now();
          final actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);

          final dateOfFirstService = actualDate.add(const Duration(days: -daysToRemoveOfActualDate));
          final dateOfLastService = actualDate.add(const Duration(days: daysToAddOfActualDate));

          when(onlineMockServiceSchedulingRepository.getDateOfFirstService())
              .thenAnswer((_) async => Either.right(dateOfFirstService));
          when(onlineMockServiceSchedulingRepository.getDateOfLastService())
              .thenAnswer((_) async => Either.right(dateOfLastService));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAddOfActualDate + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(dateOfFirstService));
          expect(dates[daysToAddOfActualDate + daysToRemoveOfActualDate], equals(dateOfLastService));
        },
      );
    },
  );
}

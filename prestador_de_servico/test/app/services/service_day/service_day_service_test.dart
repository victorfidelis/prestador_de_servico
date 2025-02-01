
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service_day/mock_service_day_repository.dart';

void main() {
  late ServiceDayService serviceDayService;

  late ServiceDay serviceDay1;

  setUpValues() {
    serviceDay1 = ServiceDay(
      id: '1',
      name: 'Dinheiro',
      dayOfWeek: 1,
      isActive: true,
    );
  }

  setUp(
    () {
      setUpMockServiceDayRepository();
      serviceDayService = ServiceDayService(
        offlineRepository: offlineMockServiceDayRepository,
        onlineRepository: onlineMockServiceDayRepository,
      );
      setUpValues();
    },
  );

  group(
    'update',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceDayRepository.update(serviceDay: serviceDay1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final updateEither = await serviceDayService.update(serviceDay: serviceDay1);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is NetworkFailure, isTrue);
          final state = (updateEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceDayRepository.update(serviceDay: serviceDay1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceDayRepository.update(serviceDay: serviceDay1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await serviceDayService.update(serviceDay: serviceDay1);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um ServiceDay quando a alteração do pagamento for feita com sucesso''',
        () async {
          when(onlineMockServiceDayRepository.update(serviceDay: serviceDay1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceDayRepository.update(serviceDay: serviceDay1)).thenAnswer((_) async => Either.right(unit));

          final insertEither = await serviceDayService.update(serviceDay: serviceDay1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is ServiceDay, isTrue);
          expect(insertEither.right, equals(serviceDay1));
        },
      );
    },
  );
}
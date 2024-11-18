
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service/service/mock_service_repository.dart';

void main() {
  late ServiceService serviceService;

  late Service service1;

  setUpValues() {
    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'testeUrlImage',
    );
  }

  setUp(
    () {
      setUpMockServiceRepository();
      serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
      );
      setUpValues();
    },
  );

  group(
    'insert',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          final state = (insertEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));
          when(offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          final state = (insertEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a gravação do Service for feita com sucesso''',
        () async {
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));
          when(offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));

          final insertEither = await serviceService.insert(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Service, isTrue);
          expect(insertEither.right, equals(service1));
        },
      );
    },
  );

  group(
    'update',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.update(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          final state = (insertEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.update(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          final state = (insertEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a gravação do Service for feita com sucesso''',
        () async {
          when(onlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.right(unit));

          final insertEither = await serviceService.update(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'delete',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.delete(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          final state = (insertEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.delete(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          final state = (insertEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a gravação do Service for feita com sucesso''',
        () async {
          when(onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.right(unit));

          final insertEither = await serviceService.delete(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Unit, isTrue);
        },
      );
    },
  );
}

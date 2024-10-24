
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service/mock_service_repository.dart';

void main() {
  late ServiceService serviceService;

  setUp(
    () {
      setUpMockServiceRepository();
      serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
      );
    },
  );

  group(
    '''Teste para o método getAll''',
    () {
      test(
        '''Ao consultar todos os serviços e o repository retornar um failure, 
    deve-se retornar um Failure pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          when(offlineMockServiceRepository.getAll()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getAllEither = await serviceService.getAll();

          expect(getAllEither.isLeft, isTrue);
          expect(getAllEither.left is Failure, isTrue);
          expect(getAllEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao consultar todos os serviços e o repository retornar um GetDatabaseFailure, 
    deve-se retornar um GetDatabaseFailure pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          when(offlineMockServiceRepository.getAll())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final getAllEither = await serviceService.getAll();

          expect(getAllEither.isLeft, isTrue);
          expect(getAllEither.left is GetDatabaseFailure, isTrue);
          expect(getAllEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao consultar todos os serviços e nenhum serviço estiver cadastrado, 
    deve-se retornar uma lista de Service vazia''',
        () async {
          final services = <Service>[];

          when(offlineMockServiceRepository.getAll()).thenAnswer((_) async => Either.right(services));

          final getAllEither = await serviceService.getAll();

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao consultar todos os serviços deve-se retornar uma lista de Service''',
        () async {
          final services = [
            Service(
              id: '1',
              serviceCategoryId: '1',
              name: 'Luzes',
              price: 49.90,
              hours: 1,
              minutes: 30,
              urlImage: 'testeUrlImage',
            ),
            Service(
              id: '2',
              serviceCategoryId: '1',
              name: 'Cabelo',
              price: 49.90,
              hours: 1,
              minutes: 30,
              urlImage: 'testeUrlImage',
            ),
          ];

          when(offlineMockServiceRepository.getAll()).thenAnswer((_) async => Either.right(services));

          final getAllEither = await serviceService.getAll();

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, services.length);
        },
      );
    },
  );

  group(
    '''Teste para o método getByServiceCategoryId''',
    () {
      test(
        '''Ao consultar todos o Services de determinado CategoryService e um Failure for retornado
        pelo repository, este Failure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          const serviceCategoryIdToFilter = '1';
          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getByEither = await serviceService.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter);

          expect(getByEither.isLeft, isTrue);
          expect(getByEither.left is Failure, isTrue);
          expect(getByEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao consultar todos o Services de determinado CategoryService e um GetDatabaseFailure for retornado
        pelo repository, este GetDatabaseFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          const serviceCategoryIdToFilter = '1';
          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final getByEither = await serviceService.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter);

          expect(getByEither.isLeft, isTrue);
          expect(getByEither.left is GetDatabaseFailure, isTrue);
          expect(getByEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao consultar todos o Services de determinado CategoryService que ainda não possui
        Services, uma lista de Services vazia deve ser retornada''',
        () async {
          final services = <Service>[];
          const serviceCategoryIdToFilter = '1';

          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter))
              .thenAnswer((_) async => Either.right(services));

          final getByEither = await serviceService.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter);

          expect(getByEither.isRight, isTrue);
          expect(getByEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao consultar todos o Services de determinado CategoryService, 
        uma lista de Services deve ser retornada''',
        () async {
          final services = <Service>[
            Service(
              id: '1',
              serviceCategoryId: '1',
              name: 'Luzes',
              price: 49.90,
              hours: 1,
              minutes: 30,
              urlImage: 'testeUrlImage',
            ),
            Service(
              id: '2',
              serviceCategoryId: '1',
              name: 'Cabelo',
              price: 49.90,
              hours: 1,
              minutes: 30,
              urlImage: 'testeUrlImage',
            ),
          ];
          const serviceCategoryIdToFilter = '1';

          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter))
              .thenAnswer((_) async => Either.right(services));

          final getByEither = await serviceService.getByServiceCategoryId(serviceCategoryId: serviceCategoryIdToFilter);

          expect(getByEither.isRight, isTrue);
          expect(getByEither.right!.length, equals(services.length));
        },
      );
    },
  );

  group(
    '''Teste para o método getNameContained''',
    () {
      test(
        '''Ao executar o getNameContained e um Failure retornar pelo repository,
        este Failure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          const valueForGetName = 'teste';

          when(offlineMockServiceRepository.getNameContained(name: valueForGetName))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getNameEither = await serviceService.getNameContained(name: valueForGetName);

          expect(getNameEither.isLeft, isTrue);
          expect(getNameEither.left is Failure, isTrue);
          expect(getNameEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o getNameContained e um GetDatabaseFailure retornar pelo repository
        este GetDatabaseFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          const valueForGetName = 'teste';

          when(offlineMockServiceRepository.getNameContained(name: valueForGetName))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final getNameEither = await serviceService.getNameContained(name: valueForGetName);

          expect(getNameEither.isLeft, isTrue);
          expect(getNameEither.left is Failure, isTrue);
          expect(getNameEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o getNameContained e nenhum Service retornar pelo repository,
        o service deve retornar uma lista vazia''',
        () async {
          const valueForGetName = 'teste';
          final services = <Service>[];

          when(offlineMockServiceRepository.getNameContained(name: valueForGetName))
              .thenAnswer((_) async => Either.right(services));

          final getNameEither = await serviceService.getNameContained(name: valueForGetName);

          expect(getNameEither.isRight, isTrue);
          expect(getNameEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o getNameContained, o service deve retornar uma lista de Service''',
        () async {
          const valueForGetName = 'teste';
          final services = <Service>[
            Service(
              id: '1',
              serviceCategoryId: '1',
              name: 'Luzes teste',
              price: 49.90,
              hours: 1,
              minutes: 30,
              urlImage: 'testeUrlImage',
            ),
            Service(
              id: '2',
              serviceCategoryId: '1',
              name: 'Cabelo teste',
              price: 49.90,
              hours: 1,
              minutes: 30,
              urlImage: 'testeUrlImage',
            ),
          ];

          when(offlineMockServiceRepository.getNameContained(name: valueForGetName))
              .thenAnswer((_) async => Either.right(services));

          final getNameEither = await serviceService.getNameContained(name: valueForGetName);

          expect(getNameEither.isRight, isTrue);
          expect(getNameEither.right!.length, equals(services.length));
        },
      );
    },
  );

  group(
    '''Testes para o método insert''',
    () {
      test(
        '''Ao executar o insert e um Failure retornar pelo online repository, este Failure 
        deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final insertEither = await serviceService.insert(service: service);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is Failure, isTrue);
          expect(insertEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o insert e um NetworkFailure retornar pelo online repository, 
        este NetworkFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: service);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          expect(insertEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o insert e um Failure retornar pelo offline repository, este Failure 
        deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(service.id));
          when(offlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final insertEither = await serviceService.insert(service: service);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is Failure, isTrue);
          expect(insertEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o insert e um GetDatabaseFailure retornar pelo offline repository, 
        este GetDatabaseFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(service.id));
          when(offlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: service);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          expect(insertEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o insert e a inserção for realizada com sucesso pelo online repository
        e pelo offline repository, um Unit deve ser retornado pelo service''',
        () async {
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(service.id));
          when(offlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(service.id));

          final insertEither = await serviceService.insert(service: service);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    '''Teste para o método update''',
    () {
      test(
        '''Ao executar o update e um Failure retornar pelo online repository, este Failure
        deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final updateEither = await serviceService.update(service: service);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is Failure, isTrue);
          expect(updateEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o update e um NetworkFailure retornar pelo online repository, 
        este NetworkFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final updateEither = await serviceService.update(service: service);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is NetworkFailure, isTrue);
          expect(updateEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o update e um Failure retornar pelo offline repository, este Failure 
        deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final updateEither = await serviceService.update(service: service);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is Failure, isTrue);
          expect(updateEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o update e um GetDatabaseFailure retornar pelo offline repository, 
        este GetDatabaseFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await serviceService.update(service: service);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          expect(updateEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o update e a inserção for realizada com sucesso pelo online repository
        e pelo offline repository, um Unit deve ser retornado pelo service''',
        () async {
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await serviceService.update(service: service);

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    '''Teste para o método delete''',
    () {
      test(
        '''Ao executar o delete e o online repository retornar um Failure, este Failure deve ser
        retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final deleteEither = await serviceService.delete(service: service);

          expect(deleteEither.isLeft, isTrue);
          expect(deleteEither.left is Failure, isTrue);
          expect(deleteEither.left!.message, equals(failureMessage));
        },
      );
      
      test(
        '''Ao executar o delete e o online repository retornar um NetworkFailure, 
        este NetworkFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final deleteEither = await serviceService.delete(service: service);

          expect(deleteEither.isLeft, isTrue);
          expect(deleteEither.left is NetworkFailure, isTrue);
          expect(deleteEither.left!.message, equals(failureMessage));
        },
      );
      
      test(
        '''Ao executar o delete e o offine repository retornar um Failure, este Failure 
        deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final deleteEither = await serviceService.delete(service: service);

          expect(deleteEither.isLeft, isTrue);
          expect(deleteEither.left is Failure, isTrue);
          expect(deleteEither.left!.message, equals(failureMessage));
        },
      );
      
      test(
        '''Ao executar o delete e o offine repository retornar um GetDatabaseFailure, este 
        GetDatabaseFailure deve ser retornado pelo service''',
        () async {
          const failureMessage = 'Falha de teste';
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final deleteEither = await serviceService.delete(service: service);

          expect(deleteEither.isLeft, isTrue);
          expect(deleteEither.left is GetDatabaseFailure, isTrue);
          expect(deleteEither.left!.message, equals(failureMessage));
        },
      );
      
      test(
        '''Ao executar o delete e o onine repository e offine repository forem executados 
        com sucesso, um Unit deve ser retornado pelo service''',
        () async {
          final service = Service(
            id: '2',
            serviceCategoryId: '1',
            name: 'Cabelo teste',
            price: 49.90,
            hours: 1,
            minutes: 30,
            urlImage: 'testeUrlImage',
          );

          when(onlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(unit));

          final deleteEither = await serviceService.delete(service: service);

          expect(deleteEither.isRight, isTrue);
          expect(deleteEither.right is Unit, isTrue);
        },
      );
    },
  );
}

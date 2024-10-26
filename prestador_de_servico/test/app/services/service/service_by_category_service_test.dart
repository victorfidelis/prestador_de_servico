import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service/services_by_category/mock_services_by_category_repository.dart';

void main() {
  late ServicesByCategoryService serviceByCategoryService;

  late ServiceCategory serviceCategory1;
  late ServiceCategory serviceCategory2;
  late ServiceCategory serviceCategory3;

  late Service service1;
  late Service service2;
  late Service service3;
  late Service service4;
  late Service service5;
  late Service service6;

  late ServicesByCategory servicesByCategory1;
  late ServicesByCategory servicesByCategory2;
  late ServicesByCategory servicesByCategory3;

  late ServicesByCategory servicesByCategoryFiltered1;
  late ServicesByCategory servicesByCategoryFiltered2;

  setUpValues() {
    serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');
    serviceCategory2 = ServiceCategory(id: '2', name: 'Manicure');
    serviceCategory3 = ServiceCategory(id: '3', name: 'Pedicure');

    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 49.90,
      hours: 1,
      minutes: 30,
      urlImage: 'testeUrlImage',
    );
    service2 = Service(
      id: '2',
      serviceCategoryId: '1',
      name: 'Chapinha',
      price: 49.90,
      hours: 1,
      minutes: 30,
      urlImage: 'testeUrlImage',
    );

    service3 = Service(
      id: '3',
      serviceCategoryId: '2',
      name: 'Francezinha',
      price: 49.90,
      hours: 1,
      minutes: 30,
      urlImage: 'testeUrlImage',
    );

    service4 = Service(
      id: '4',
      serviceCategoryId: '2',
      name: 'Limpeza',
      price: 49.90,
      hours: 1,
      minutes: 30,
      urlImage: 'testeUrlImage',
    );

    service5 = Service(
      id: '5',
      serviceCategoryId: '3',
      name: 'Francezinha',
      price: 49.90,
      hours: 1,
      minutes: 30,
      urlImage: 'testeUrlImage',
    );

    service6 = Service(
      id: '6',
      serviceCategoryId: '3',
      name: 'Limpeza',
      price: 49.90,
      hours: 1,
      minutes: 30,
      urlImage: 'testeUrlImage',
    );

    servicesByCategory1 = ServicesByCategory(
      serviceCategory: serviceCategory1,
      services: [service1, service2],
    );

    servicesByCategory2 = ServicesByCategory(
      serviceCategory: serviceCategory2,
      services: [service3, service4],
    );

    servicesByCategory3 = ServicesByCategory(
      serviceCategory: serviceCategory3,
      services: [service5, service6],
    );

    servicesByCategoryFiltered1 = ServicesByCategory(
      serviceCategory: serviceCategory1,
      services: [service2],
    );

    servicesByCategoryFiltered2 = ServicesByCategory(
      serviceCategory: serviceCategory2,
      services: [service3, service4],
    );
  }

  setUp(
    () {
      setUpMockServicesByCategoryRepository();
      serviceByCategoryService = ServicesByCategoryService(
        offlineRepository: offlineMockServicesByCategoryRepository,
      );

      setUpValues();
    },
  );

  group(
    '''Testes para o método getAll''',
    () {
      test(
        '''Ao executar o getAll e um Failure retornar do Repository, este mesmo Failure
        deve ser retornado pelo Service''',
        () async {
          const failureMessage = 'Teste de falha';
          when(serviceByCategoryService.getAll()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getAllEither = await serviceByCategoryService.getAll();

          expect(getAllEither.isLeft, isTrue);
          expect(getAllEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o getAll e nenhum registro for retornado pelo Repository, 
        uma lista vazia deve ser retornada pelo Service''',
        () async {
          final servicesByCategories = <ServicesByCategory>[];
          when(serviceByCategoryService.getAll()).thenAnswer((_) async => Either.right(servicesByCategories));

          final getAllEither = await serviceByCategoryService.getAll();

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o getAll e diversos registros forem retornados pelo Repository, 
        uma lista de ServicesByCategory deve ser retornada''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(serviceByCategoryService.getAll()).thenAnswer((_) async => Either.right(servicesByCategories));

          final getAllEither = await serviceByCategoryService.getAll();

          expect(getAllEither.isRight, isTrue);
          final servicesByCategoriesActual = getAllEither.right!;

          expect(servicesByCategoriesActual.length, equals(servicesByCategories.length));

          expect(servicesByCategoriesActual[0].serviceCategory, equals(servicesByCategories[0].serviceCategory));
          expect(servicesByCategoriesActual[0].services.length, equals(servicesByCategories[0].services.length));

          expect(servicesByCategoriesActual[1].serviceCategory, equals(servicesByCategories[1].serviceCategory));
          expect(servicesByCategoriesActual[1].services.length, equals(servicesByCategories[1].services.length));

          expect(servicesByCategoriesActual[2].serviceCategory, equals(servicesByCategories[2].serviceCategory));
          expect(servicesByCategoriesActual[2].services.length, equals(servicesByCategories[2].services.length));
        },
      );
    },
  );

  group(
    '''Testes para o método getByContainedName''',
    () {
      test(
        '''Ao executar o getByContainedName e um Failure retornar do Repository, este mesmo Failure
        deve ser retornado pelo Service''',
        () async {
          const failureMessage = 'Teste de falha';
          const nameFilter = 'Teste de falha';
          when(serviceByCategoryService.getByContainedName(nameFilter))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getAllEither = await serviceByCategoryService.getByContainedName(nameFilter);

          expect(getAllEither.isLeft, isTrue);
          expect(getAllEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o getByContainedName e nenhum registro for retornado pelo Repository, 
        uma lista vazia deve ser retornada pelo Service''',
        () async {
          final servicesByCategories = <ServicesByCategory>[];
          const nameFilter = 'Lista vazia';
          when(serviceByCategoryService.getByContainedName(nameFilter))
              .thenAnswer((_) async => Either.right(servicesByCategories));

          final getAllEither = await serviceByCategoryService.getByContainedName(nameFilter);

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o getAll e diversos registros forem retornados pelo Repository, 
        uma lista de ServicesByCategory deve ser retornada''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategoryFiltered1,
            servicesByCategoryFiltered2,
          ];
          const nameFilter = 'Lista vazia';

          when(serviceByCategoryService.getByContainedName(nameFilter)).thenAnswer((_) async => Either.right(servicesByCategories));

          final getAllEither = await serviceByCategoryService.getByContainedName(nameFilter);

          expect(getAllEither.isRight, isTrue);
          final servicesByCategoriesActual = getAllEither.right!;

          expect(servicesByCategoriesActual.length, equals(servicesByCategories.length));

          expect(servicesByCategoriesActual[0].serviceCategory, equals(servicesByCategories[0].serviceCategory));
          expect(servicesByCategoriesActual[0].services.length, equals(servicesByCategories[0].services.length));

          expect(servicesByCategoriesActual[1].serviceCategory, equals(servicesByCategories[1].serviceCategory));
          expect(servicesByCategoriesActual[1].services.length, equals(servicesByCategories[1].services.length));
        },
      );
    },
  );
}

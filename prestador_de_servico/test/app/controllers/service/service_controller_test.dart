import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service/service_state.dart';

import '../../../helpers/service/service/mock_service_repository.dart';
import '../../../helpers/service/service_category/mock_service_category_repository.dart';
import '../../../helpers/service/services_by_category/mock_services_by_category_repository.dart';

void main() {
  late ServiceController serviceController;

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

  setUpAll(
    () {
      setUpMockServiceCategoryRepository();
      setUpMockServiceRepository();
      setUpMockServicesByCategoryRepository();
      final serviceCategoryService = ServiceCategoryService(
        onlineRepository: onlineMockServiceCategoryRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
      );
      final serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
      );
      final servicesByCategoryService = ServicesByCategoryService(
        offlineRepository: offlineMockServicesByCategoryRepository,
      );
      serviceController = ServiceController(
        serviceCategoryService: serviceCategoryService,
        serviceService: serviceService,
        servicesByCategoryService: servicesByCategoryService,
      );
      setUpValues();
    },
  );

  group(
    '''Teste para o método load''',
    () {
      test(
        '''Ao executar o método load e um Failure for retornado pelo Service, o status 
        ServiceError deve ser atribuído para a controller com a mensagem de erro 
        retornada pelo serviço''',
        () async {
          const failureMessage = 'Teste de falha';

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceController.load();

          expect(serviceController.state is ServiceError, isTrue);
          final state = serviceController.state as ServiceError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o método load e nenhum registro for retornado, o status 
        ServiceLoaded deve ser retornado com uma lista vazia de ServicesByCategory''',
        () async {
          final servicesByCategories = <ServicesByCategory>[];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.load();

          expect(serviceController.state is ServiceLoaded, isTrue);
          final serviceState = serviceController.state as ServiceLoaded;
          expect(serviceState.servicesByCategory.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o método load e diversos registros forem retornados, o status 
        ServiceLoaded deve ser retornado com uma lista de ServicesByCategory''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.load();

          expect(serviceController.state is ServiceLoaded, isTrue);
          final serviceState = serviceController.state as ServiceLoaded;
          expect(serviceState.servicesByCategory.length, equals(servicesByCategories.length));
        },
      );

      test(
        '''Ao executar o método load e diversos registros forem retornados, o status 
        ServiceLoaded deve ser retornado com uma lista de ServicesByCategory com 
        os respectivos Services em cada category''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          expect(serviceController.state is ServiceLoaded, isTrue);

          final servicesByCategoriesActual = (serviceController.state as ServiceLoaded).servicesByCategory;

          expect(servicesByCategoriesActual.length, equals(servicesByCategories.length));
          expect(servicesByCategoriesActual[0].services.length, equals(servicesByCategories[0].services.length));
          expect(servicesByCategoriesActual[1].services.length, equals(servicesByCategories[1].services.length));
          expect(servicesByCategoriesActual[2].services.length, equals(servicesByCategories[2].services.length));
        },
      );
    },
  );

  group(
    '''Testes para o método filter''',
    () {
      test(
        '''Ao executar o filter e um Failure for retornado pelo Service, 
        o estado do controller deve ser alterado para ServiceError com a mensagem de 
        erro retornada''',
        () async {
          const nameFilter = 'teste sem resultado';
          const failureMessage = 'Teste de falha';

          when(offlineMockServicesByCategoryRepository.getByContainedName(nameFilter))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceController.filter(nameFilter);

          expect(serviceController.state is ServiceError, isTrue);
          final servicesState = serviceController.state as ServiceError;
          expect(servicesState.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o filter e nenhum registro retornar do Service, o estado do controller 
        deve ser alterado para ServiceFiltered com a lista das ServicesbyCategories 
        vazia''',
        () async {
          const nameFilter = 'teste sem resultado';
          final servicesByCategories = <ServicesByCategory>[];

          when(offlineMockServicesByCategoryRepository.getByContainedName(nameFilter))
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.filter(nameFilter);

          expect(serviceController.state is ServiceFiltered, isTrue);
          final serviceState = serviceController.state as ServiceFiltered;
          expect(serviceState.servicesByCategory.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o filter e diversos registros forem retornados pelo Service, o estado 
        do controller deve ser alterado para ServiceFiltered com a lista de ServicesByCategory
        consultada''',
        () async {
          const nameFilter = 'teste com resultado';
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategoryFiltered1,
            servicesByCategoryFiltered2,
          ];

          when(offlineMockServicesByCategoryRepository.getByContainedName(nameFilter))
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.filter(nameFilter);

          expect(serviceController.state is ServiceFiltered, isTrue);
          final serviceState = serviceController.state as ServiceFiltered;

          expect(serviceState.servicesByCategory.length, equals(servicesByCategories.length));

          expect(serviceState.servicesByCategory[0].serviceCategory, equals(servicesByCategories[0].serviceCategory));
          expect(serviceState.servicesByCategory[0].services.length, equals(servicesByCategories[0].services.length));

          expect(serviceState.servicesByCategory[1].serviceCategory, equals(servicesByCategories[1].serviceCategory));
          expect(serviceState.servicesByCategory[1].services.length, equals(servicesByCategories[1].services.length));
        },
      );
    },
  );

  // test(
  //   '''Ao executar um filtro por nome de categorias de serviço, o estado
  //   do controller deve ser alterado para ServiceCategoryLoaded com a lista das
  //   categorias de serviço filtradas, neste caso, uma categoria deve ser
  //   retornada''',
  //   () async {
  //     await serviceCategoryController.filter(name: serCatNameContained1Result);

  //     expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
  //     final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
  //     expect(serviceCategoryState.cards.length, equals(serCatGetNameContained1Result.length));
  //   },
  // );

  // test(
  //   '''Ao executar um filtro por nome de categorias de serviço, o estado
  //   do controller deve ser alterado para ServiceCategoryLoaded com a lista das
  //   categorias de serviço filtradas, neste caso, duas categorias devem ser
  //   retornadas''',
  //   () async {
  //     await serviceCategoryController.filter(name: serCatNameContained2Result);

  //     expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
  //     final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
  //     expect(serviceCategoryState.cards.length, equals(serCatGetNameContained2Result.length));
  //   },
  // );

  // test(
  //   '''Ao executar um filtro por nome de categorias de serviço, o estado
  //   do controller deve ser alterado para ServiceCategoryLoaded com a lista das
  //   categorias de serviço filtradas, neste caso, três categorias devem ser
  //   retornadas''',
  //   () async {
  //     await serviceCategoryController.filter(name: serCatNameContained3Result);

  //     expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
  //     final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
  //     expect(serviceCategoryState.cards.length, equals(serCatGetNameContained3Result.length));
  //   },
  // );

  // test(
  //   '''Ao deletar uma categoria de serviço, além da exclusão da categoria, o estado
  //   o controller deve ser alterado para ServiceCategoryLoaded com uma nova lista de
  //   categorias de serviço''',
  //   () async {
  //     await serviceCategoryController.delete(serviceCategory: serCatDelete);

  //     expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
  //     final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
  //     expect(serviceCategoryState.cards.length, equals(serCatGetAll.length));
  //   },
  // );

  // test(
  //   '''Ao adicionar uma categoria de serviço a lista de categorias já carregadas,
  //   a mesma deve ser inserida no topo da lista''',
  //   () async {
  //     await serviceCategoryController.load();

  //     final lenBefore = (serviceCategoryController.state as ServiceCategoryLoaded).cards.length;
  //     serviceCategoryController.addOnList(serviceCategory: serCatGeneric);
  //     final newState = (serviceCategoryController.state as ServiceCategoryLoaded);

  //     expect(newState.cards.length, equals(lenBefore + 1));
  //     expect(newState.cards[0], equals(serCatGeneric));
  //   },
  // );

  // test(
  //   '''Ao alterar uma categoria de serviço em uma lista de categorias já carregadas,
  //   a mesma deve ser alterarada no estado do controller''',
  //   () async {
  //     await serviceCategoryController.load();
  //     serviceCategoryController.addOnList(serviceCategory: serCatGeneric);

  //     final lenBefore = (serviceCategoryController.state as ServiceCategoryLoaded).cards.length;
  //     final serviceCategoryUpdate = serCatGeneric.copyWith(name: 'Test update');
  //     serviceCategoryController.updateOnList(serviceCategory: serviceCategoryUpdate);
  //     final newState = (serviceCategoryController.state as ServiceCategoryLoaded);

  //     expect(newState.cards.length, equals(lenBefore));
  //     expect(newState.cards[0], equals(serviceCategoryUpdate));
  //   },
  // );
}

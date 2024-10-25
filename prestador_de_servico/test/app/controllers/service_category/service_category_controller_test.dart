import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/service_category/service_category_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service/service_repository.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service_category/service_category_state.dart';

import '../../../helpers/service/mock_service_repository.dart';
import '../../../helpers/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryController serviceCategoryController;

  late List<ServiceCategory> serviceCategories;

  late List<Service> servicesBy1;
  late List<Service> servicesBy2;
  late List<Service> servicesBy3;

  setUpValues() {
    serviceCategories = <ServiceCategory>[
      ServiceCategory(id: '1', name: 'Cabelo'),
      ServiceCategory(id: '2', name: 'Manicure'),
      ServiceCategory(id: '3', name: 'Pedicure'),
    ];
    servicesBy1 = <Service>[
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
        name: 'Chapinha',
        price: 49.90,
        hours: 1,
        minutes: 30,
        urlImage: 'testeUrlImage',
      ),
    ];

    servicesBy2 = <Service>[
      Service(
        id: '3',
        serviceCategoryId: '2',
        name: 'Francezinha',
        price: 49.90,
        hours: 1,
        minutes: 30,
        urlImage: 'testeUrlImage',
      ),
      Service(
        id: '4',
        serviceCategoryId: '2',
        name: 'Limpeza',
        price: 49.90,
        hours: 1,
        minutes: 30,
        urlImage: 'testeUrlImage',
      ),
    ];

    servicesBy3 = <Service>[
      Service(
        id: '5',
        serviceCategoryId: '3',
        name: 'Francezinha',
        price: 49.90,
        hours: 1,
        minutes: 30,
        urlImage: 'testeUrlImage',
      ),
      Service(
        id: '6',
        serviceCategoryId: '3',
        name: 'Limpeza',
        price: 49.90,
        hours: 1,
        minutes: 30,
        urlImage: 'testeUrlImage',
      ),
    ];
  }

  setUpAll(
    () {
      setUpMockServiceCategoryRepository();
      setUpMockServiceRepository();
      final serviceCategoryService = ServiceCategoryService(
        onlineRepository: onlineMockServiceCategoryRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
      );
      final serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
      );
      serviceCategoryController = ServiceCategoryController(
        serviceCategoryService: serviceCategoryService,
        serviceService: serviceService,
      );
      setUpValues();
    },
  );

  group(
    '''Teste para o método load''',
    () {
      test(
        '''Ao executar o método load e um Failure for retornado pelo service, o status 
        ServiceCategoryError deve ser atribuído para a controller com a mensagem de erro 
        retornada pelo serviço''',
        () async {
          const failureMessage = 'Teste de falha';

          when(offlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceCategoryController.load();

          expect(serviceCategoryController.state is ServiceCategoryError, isTrue);
          final state = serviceCategoryController.state as ServiceCategoryError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o método load e um GetDatabaseFailure seja retornado pelo service, 
        o status ServiceCategoryError deve ser atribuído para a controller com a 
        mensagem de erro retornada pelo serviço''',
        () async {
          const failureMessage = 'Teste de falha de banco';

          when(offlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          await serviceCategoryController.load();

          expect(serviceCategoryController.state is ServiceCategoryError, isTrue);
          final state = serviceCategoryController.state as ServiceCategoryError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o método load e nenhum ServiceCategory for retornado, o status 
        ServiceCategoryLoaded deve ser retornado com uma lista vazia de ServicesByCategory''',
        () async {
          final servicesCategories = <ServiceCategory>[];

          when(offlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(servicesCategories));

          await serviceCategoryController.load();

          expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
          final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
          expect(serviceCategoryState.servicesByCategory.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o método load e diversos ServiceCategory forem retornados, o status 
        ServiceCategoryLoaded deve ser retornado com uma lista de ServicesByCategory''',
        () async {
          when(offlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serviceCategories));

          await serviceCategoryController.load();

          expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
          final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
          expect(serviceCategoryState.servicesByCategory.length, equals(serviceCategories.length));
        },
      );

      test(
        '''Ao executar o método load e diversos ServiceCategory forem retornados, o status 
        ServiceCategoryLoaded deve ser retornado com uma lista de ServicesByCategory com 
        os respectivos Services em cada category''',
        () async {
          when(offlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serviceCategories));
          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategories[0].id))
              .thenAnswer((_) async => Either.right(servicesBy1));
          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategories[1].id))
              .thenAnswer((_) async => Either.right(servicesBy2));
          when(offlineMockServiceRepository.getByServiceCategoryId(serviceCategoryId: serviceCategories[2].id))
              .thenAnswer((_) async => Either.right(servicesBy3));

          await serviceCategoryController.load();

          expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
          final servicesByCategories = (serviceCategoryController.state as ServiceCategoryLoaded).servicesByCategory;
          expect(servicesByCategories.length, equals(serviceCategories.length));

          expect(servicesByCategories[0].services.length, equals(servicesBy1.length));
          expect(servicesByCategories[1].services.length, equals(servicesBy2.length));
          expect(servicesByCategories[2].services.length, equals(servicesBy3.length));
        },
      );
    },
  );

  // test(
  //   '''Ao executar um filtro por nome de categorias de serviço, o estado
  //   do controller deve ser alterado para ServiceCategoryLoaded com a lista das
  //   categorias de serviço filtradas, neste caso, nenhuma categoria deve ser
  //   retornada''',
  //   () async {
  //     await serviceCategoryController.filter(name: serCatNameContainedWithoutResult);

  //     expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
  //     final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
  //     expect(serviceCategoryState.cards.length, equals(serCatGetNameContainedWithoutResult.length));
  //   },
  // );

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

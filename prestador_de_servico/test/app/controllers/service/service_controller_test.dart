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

import '../../../helpers/image/mock_image_repository.dart';
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
      imageUrl: 'testeUrlImage',
    );
    service2 = Service(
      id: '2',
      serviceCategoryId: '1',
      name: 'Chapinha',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'testeUrlImage',
    );

    service3 = Service(
      id: '3',
      serviceCategoryId: '2',
      name: 'Francezinha',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'testeUrlImage',
    );

    service4 = Service(
      id: '4',
      serviceCategoryId: '2',
      name: 'Limpeza',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'testeUrlImage',
    );

    service5 = Service(
      id: '5',
      serviceCategoryId: '3',
      name: 'Francezinha',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'testeUrlImage',
    );

    service6 = Service(
      id: '6',
      serviceCategoryId: '3',
      name: 'Limpeza',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'testeUrlImage',
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
  }

  setUp(
    () {
      setUpMockServiceCategoryRepository();
      setUpMockServiceRepository();
      setUpMockServicesByCategoryRepository();
      setUpMockImageRepository();
      final serviceCategoryService = ServiceCategoryService(
        onlineRepository: onlineMockServiceCategoryRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
      );
      final serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
        imageRepository: mockImageRepository,
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
    'load',
    () {
      test(
        '''Deve alterar o estado para ServiceError e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository.''',
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
        '''Deve alterar o estado para ServiceLoaded com uma lista de ServicesByCategory vazia
        quando nenhum ServiceCategory estiver cadastrado.''',
        () async {
          final servicesByCategories = <ServicesByCategory>[];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.load();

          expect(serviceController.state is ServiceLoaded, isTrue);
          final serviceState = serviceController.state as ServiceLoaded;
          expect(serviceState.servicesByCategories.isEmpty, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para ServiceLoaded com um lista de ServicesByCategory preenchida
        quando algum ServiceCategory estiver cadastrado.''',
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
          expect(serviceState.servicesByCategories.length, equals(servicesByCategories.length));
        },
      );

      test(
        '''Deve alterar o estado para ServiceLoaded com uma lista de ServicesByCategory, onde
        cada ServicesByCategory possui seus respectivos Services, quando tanto ServiceCategory
        quanto Service estiverem cadastrados.''',
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

          final servicesByCategoriesActual = (serviceController.state as ServiceLoaded).servicesByCategories;

          expect(servicesByCategoriesActual.length, equals(servicesByCategories.length));
          expect(servicesByCategoriesActual[0].services.length, equals(servicesByCategories[0].services.length));
          expect(servicesByCategoriesActual[1].services.length, equals(servicesByCategories[1].services.length));
          expect(servicesByCategoriesActual[2].services.length, equals(servicesByCategories[2].services.length));
        },
      );
    },
  );

  group(
    'filter',
    () {
      test(
        'Deve manter o estado quando o estado atual for diferente de ServiceLoaded',
        () async {
          serviceController.filter(textFilter: 'Cabelo');

          expect((serviceController.state is ServiceInitial), isTrue);
        },
      );

      test(
        'Deve manter o estado de ServiceLoaded quando o valor filtrado for vazio',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          serviceController.filter(textFilter: '');

          expect((serviceController.state is ServiceLoaded), isTrue);
          expect((serviceController.state is! ServiceFiltered), isTrue);
          final serviceState = (serviceController.state as ServiceLoaded);
          expect(serviceState.servicesByCategories.length, equals(servicesByCategories.length));
        },
      );

      test(
        '''Deve alterar o estado para ServiceFiltered com os dados 
        filtrados quando filtrar "u"''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          serviceController.filter(textFilter: 'u');

          expect((serviceController.state is ServiceFiltered), isTrue);
          final state = (serviceController.state as ServiceFiltered);
          expect(state.servicesByCategoriesFiltered.length, equals(2));
        },
      );

      test(
        '''Deve alterar o estado para ServiceFiltered com os dados 
        filtrados quando filtrar "cabeLo"''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          serviceController.filter(textFilter: 'cabeLo');

          expect((serviceController.state is ServiceFiltered), isTrue);
          final state = (serviceController.state as ServiceFiltered);
          expect(state.servicesByCategoriesFiltered.length, equals(1));
        },
      );

      test(
        '''Deve alterar o estado para ServiceFiltered com os dados 
        filtrados quando filtrar "Manicure"''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          serviceController.filter(textFilter: 'Manicure');

          expect((serviceController.state is ServiceFiltered), isTrue);
          final state = (serviceController.state as ServiceFiltered);
          expect(state.servicesByCategoriesFiltered.length, equals(1));
        },
      );

      test(
        '''Deve alterar o estado para ServiceFiltered com os dados 
        filtrados quando filtrar "pedicure"''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          serviceController.filter(textFilter: 'pedicure');

          expect((serviceController.state is ServiceFiltered), isTrue);
          final state = (serviceController.state as ServiceFiltered);
          expect(state.servicesByCategoriesFiltered.length, equals(1));
        },
      );

      test(
        '''Deve alterar o estado para ServiceLoaded quando filtrar com um valor 
        vazio''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory1,
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceController.load();

          serviceController.filter(textFilter: 'u');
          expect((serviceController.state is ServiceFiltered), isTrue);
          final state = (serviceController.state as ServiceFiltered);
          expect(state.servicesByCategoriesFiltered.length, equals(2));

          serviceController.filter(textFilter: '');

          expect((serviceController.state is ServiceLoaded), isTrue);
          expect((serviceController.state is! ServiceFiltered), isTrue);
          final showAllServicesState = (serviceController.state as ServiceLoaded);
          expect(showAllServicesState.servicesByCategories.length, equals(servicesByCategories.length));
        },
      );
    },
  );

  group(
    'deleteCategory',
    () {
      test(
        '''Deve alterar o estado para ServiceLoaded e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository.''',
        () async {
          const failureMessage = 'Teste de falha';
          final servicesByCategories = <ServicesByCategory>[];

          when(onlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(offlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.deleteCategory(serviceCategory: serviceCategory1);

          expect(serviceController.state is ServiceLoaded, isTrue);
          final serviceState = serviceController.state as ServiceLoaded;
          expect(serviceState.message, equals(failureMessage));
          expect(serviceState.servicesByCategories.length, equals(servicesByCategories.length));
        },
      );

      test(
        '''Deve manter o estado quando a exclusão ocorrer normalmente''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(onlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(unit));

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          final state = serviceController.state;

          await serviceController.deleteCategory(serviceCategory: serviceCategory1);

          expect(serviceController.state, equals(state));
        },
      );
    },
  );

  group(
    'deleteService',
    () {
      test(
        '''Deve alterar o estado para ServiceLoaded e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer ao excluir a imagem.''',
        () async {
          const failureMessage = 'Teste de falha';
          final servicesByCategories = <ServicesByCategory>[];

          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.deleteService(service: service1);

          expect(serviceController.state is ServiceLoaded, isTrue);
          final serviceState = serviceController.state as ServiceLoaded;
          expect(serviceState.message, equals(failureMessage));
          expect(serviceState.servicesByCategories.length, equals(servicesByCategories.length));
        },
      );

      test(
        '''Deve alterar o estado para ServiceLoaded e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer ao excluir o serviço.''',
        () async {
          const failureMessage = 'Teste de falha';
          final servicesByCategories = <ServicesByCategory>[];

          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl))
              .thenAnswer((_) async => Either.right(unit));
          when(onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(offlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceController.deleteService(service: service1);

          expect(serviceController.state is ServiceLoaded, isTrue);
          final serviceState = serviceController.state as ServiceLoaded;
          expect(serviceState.message, equals(failureMessage));
          expect(serviceState.servicesByCategories.length, equals(servicesByCategories.length));
        },
      );

      test(
        '''Deve manter o estado quando a exclusão ocorrer normalmente''',
        () async {
          final servicesByCategories = <ServicesByCategory>[
            servicesByCategory2,
            servicesByCategory3,
          ];

          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl))
              .thenAnswer((_) async => Either.right(unit));
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));

          when(offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          final state = serviceController.state;

          await serviceController.deleteService(service: service1);

          expect(serviceController.state, equals(state));
        },
      );
    },
  );
}

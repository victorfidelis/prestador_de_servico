import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/service/states/service_state.dart';

class MockServiceCategoryRepository extends Mock implements ServiceCategoryRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

class MockImageRepository extends Mock implements ImageRepository {}

class MockServicesByCategoryRepository extends Mock implements ServicesByCategoryRepository {}

void main() {
  final offlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final offlineMockServiceRepository = MockServiceRepository();
  final onlineMockServiceRepository = MockServiceRepository();
  final mockImageRepository = MockImageRepository();
  final offlineMockServicesByCategoryRepository = MockServicesByCategoryRepository();
  late ServiceViewModel serviceViewModel;

  final serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');
  final serviceCategory2 = ServiceCategory(id: '2', name: 'Manicure');
  final serviceCategory3 = ServiceCategory(id: '3', name: 'Pedicure');

  final service1 = Service(
    id: '1',
    serviceCategoryId: '1',
    name: 'Luzes',
    price: 49.90,
    hours: 1,
    minutes: 30,
    imageUrl: 'testeUrlImage',
  );
  final service2 = Service(
    id: '2',
    serviceCategoryId: '1',
    name: 'Chapinha',
    price: 49.90,
    hours: 1,
    minutes: 30,
    imageUrl: 'testeUrlImage',
  );
  final service3 = Service(
    id: '3',
    serviceCategoryId: '2',
    name: 'Francezinha',
    price: 49.90,
    hours: 1,
    minutes: 30,
    imageUrl: 'testeUrlImage',
  );
  final service4 = Service(
    id: '4',
    serviceCategoryId: '2',
    name: 'Limpeza',
    price: 49.90,
    hours: 1,
    minutes: 30,
    imageUrl: 'testeUrlImage',
  );
  final service5 = Service(
    id: '5',
    serviceCategoryId: '3',
    name: 'Francezinha',
    price: 49.90,
    hours: 1,
    minutes: 30,
    imageUrl: 'testeUrlImage',
  );
  final service6 = Service(
    id: '6',
    serviceCategoryId: '3',
    name: 'Limpeza',
    price: 49.90,
    hours: 1,
    minutes: 30,
    imageUrl: 'testeUrlImage',
  );

  final servicesByCategory1 = ServicesByCategory(
    serviceCategory: serviceCategory1,
    services: [service1, service2],
  );

  final servicesByCategory2 = ServicesByCategory(
    serviceCategory: serviceCategory2,
    services: [service3, service4],
  );

  final servicesByCategory3 = ServicesByCategory(
    serviceCategory: serviceCategory3,
    services: [service5, service6],
  );

  setUp(
    () {
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
      serviceViewModel = ServiceViewModel(
        serviceCategoryService: serviceCategoryService,
        serviceService: serviceService,
        servicesByCategoryService: servicesByCategoryService,
      );
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
          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceViewModel.load();

          expect(serviceViewModel.state is ServiceError, isTrue);
          final state = serviceViewModel.state as ServiceError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceLoaded com uma lista de ServicesByCategory vazia
        quando nenhum ServiceCategory estiver cadastrado.''',
        () async {
          final servicesByCategories = <ServicesByCategory>[];

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceViewModel.load();

          expect(serviceViewModel.state is ServiceLoaded, isTrue);
          final serviceState = serviceViewModel.state as ServiceLoaded;
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceViewModel.load();

          expect(serviceViewModel.state is ServiceLoaded, isTrue);
          final serviceState = serviceViewModel.state as ServiceLoaded;
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          expect(serviceViewModel.state is ServiceLoaded, isTrue);

          final servicesByCategoriesActual =
              (serviceViewModel.state as ServiceLoaded).servicesByCategories;

          expect(servicesByCategoriesActual.length, equals(servicesByCategories.length));
          expect(servicesByCategoriesActual[0].services.length,
              equals(servicesByCategories[0].services.length));
          expect(servicesByCategoriesActual[1].services.length,
              equals(servicesByCategories[1].services.length));
          expect(servicesByCategoriesActual[2].services.length,
              equals(servicesByCategories[2].services.length));
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
          serviceViewModel.filter(textFilter: 'Cabelo');

          expect((serviceViewModel.state is ServiceInitial), isTrue);
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          serviceViewModel.filter(textFilter: '');

          expect((serviceViewModel.state is ServiceLoaded), isTrue);
          expect((serviceViewModel.state is! ServiceFiltered), isTrue);
          final serviceState = (serviceViewModel.state as ServiceLoaded);
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          serviceViewModel.filter(textFilter: 'u');

          expect((serviceViewModel.state is ServiceFiltered), isTrue);
          final state = (serviceViewModel.state as ServiceFiltered);
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          serviceViewModel.filter(textFilter: 'cabeLo');

          expect((serviceViewModel.state is ServiceFiltered), isTrue);
          final state = (serviceViewModel.state as ServiceFiltered);
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          serviceViewModel.filter(textFilter: 'Manicure');

          expect((serviceViewModel.state is ServiceFiltered), isTrue);
          final state = (serviceViewModel.state as ServiceFiltered);
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          serviceViewModel.filter(textFilter: 'pedicure');

          expect((serviceViewModel.state is ServiceFiltered), isTrue);
          final state = (serviceViewModel.state as ServiceFiltered);
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

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));
          await serviceViewModel.load();

          serviceViewModel.filter(textFilter: 'u');
          expect((serviceViewModel.state is ServiceFiltered), isTrue);
          final state = (serviceViewModel.state as ServiceFiltered);
          expect(state.servicesByCategoriesFiltered.length, equals(2));

          serviceViewModel.filter(textFilter: '');

          expect((serviceViewModel.state is ServiceLoaded), isTrue);
          expect((serviceViewModel.state is! ServiceFiltered), isTrue);
          final showAllServicesState = (serviceViewModel.state as ServiceLoaded);
          expect(showAllServicesState.servicesByCategories.length,
              equals(servicesByCategories.length));
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

          when(() => onlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(() => offlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceViewModel.deleteCategory(serviceCategory: serviceCategory1);

          expect(serviceViewModel.state is ServiceLoaded, isTrue);
          final serviceState = serviceViewModel.state as ServiceLoaded;
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

          when(() => onlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.deleteById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(unit));

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          final state = serviceViewModel.state;

          await serviceViewModel.deleteCategory(serviceCategory: serviceCategory1);

          expect(serviceViewModel.state, equals(state));
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

          when(() => mockImageRepository.deleteImage(imageUrl: service1.imageUrl))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceViewModel.deleteService(service: service1);

          expect(serviceViewModel.state is ServiceLoaded, isTrue);
          final serviceState = serviceViewModel.state as ServiceLoaded;
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

          when(() => mockImageRepository.deleteImage(imageUrl: service1.imageUrl))
              .thenAnswer((_) async => Either.right(unit));
          when(() => onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(() => offlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          await serviceViewModel.deleteService(service: service1);

          expect(serviceViewModel.state is ServiceLoaded, isTrue);
          final serviceState = serviceViewModel.state as ServiceLoaded;
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

          when(() => mockImageRepository.deleteImage(imageUrl: service1.imageUrl))
              .thenAnswer((_) async => Either.right(unit));
          when(() => onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.right(unit));

          when(() => offlineMockServicesByCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesByCategories));

          final state = serviceViewModel.state;

          await serviceViewModel.deleteService(service: service1);

          expect(serviceViewModel.state, equals(state));
        },
      );
    },
  );
}

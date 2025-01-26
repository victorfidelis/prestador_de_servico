
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/service/show_all_services_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service/show_all_services_state.dart';

import '../../../helpers/image/mock_image_repository.dart';
import '../../../helpers/service/service/mock_service_repository.dart';

void main() {
  late ShowAllServicesController showAllServicesController;

  late ServiceCategory serviceCategory1;

  late Service service1;
  late Service service2;
  late Service service3;

  late ServicesByCategory servicesByCategory1;

  setUpValues() {
    serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');

    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Hidratação',
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
      serviceCategoryId: '1',
      name: 'Escova ',
      price: 69.90,
      hours: 1,
      minutes: 0,
      imageUrl: 'testeUrlImage',
    );

    servicesByCategory1 = ServicesByCategory(
      serviceCategory: serviceCategory1,
      services: [
        service1,
        service2,
        service3,
      ],
    );
  }

  setUp(
    () {
      setUpMockServiceRepository();
      setUpMockImageRepository();
      final serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
        imageRepository: mockImageRepository,
      );
      showAllServicesController = ShowAllServicesController(serviceService: serviceService);
      setUpValues();
      showAllServicesController.init();
    },
  );

  group(
    'setServicesByCategory',
    () {
      test(
        '''Deve alterar o estado ShowAllServicesLoaded com o objeto ServicesByCategory correspondente 
        ao passado via parâmetro.''',
        () {
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          expect(showAllServicesController.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesController.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
        },
      );
    },
  );

  group(
    'delete',
    () {
      test(
        '''Deve alterar o estado ShowAllServicesError caso ocorra algum erro na exclusão da imagem
        e o estado NÃO ESTIVER carregado.''',
        () async {
          const failureMessage = 'Falha no teste';
          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );

          await showAllServicesController.delete(service: service1);

          expect(showAllServicesController.state is ShowAllServicesError, isTrue);
          final state = (showAllServicesController.state as ShowAllServicesError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado ShowAllServicesError caso ocorra algum erro na exclusão
        e o estado NÃO ESTIVER carregado.''',
        () async {
          const failureMessage = 'Falha no teste';
          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );

          await showAllServicesController.delete(service: service1);

          expect(showAllServicesController.state is ShowAllServicesError, isTrue);
          final state = (showAllServicesController.state as ShowAllServicesError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado ShowAllServicesLoaded com a mensagem de erro caso ocorra algum 
        erro na exclusão da imagem e o estado ESTIVER carregado.''',
        () async {
          const failureMessage = 'Falha no teste';
          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          await showAllServicesController.delete(service: service1);

          expect(showAllServicesController.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesController.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado ShowAllServicesLoaded com a mensagem de erro caso ocorra algum 
        erro na exclusão e o estado ESTIVER carregado.''',
        () async {
          const failureMessage = 'Falha no teste';
          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          await showAllServicesController.delete(service: service1);

          expect(showAllServicesController.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesController.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado deve manter ShowAllServicesLoaded quando nenhum erro ocorrer.''',
        () async {
          when(mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(offlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.right(unit),
          );
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          await showAllServicesController.delete(service: service1);

          expect(showAllServicesController.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesController.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
        },
      );
    },
  );

  group(
    'filter',
    () {
      test(
        'Deve manter o estado quando o estado atual for diferente de ShowAllServicesLoaded',
        () async { 

          showAllServicesController.filter(textFilter: 'chapinha');

          expect((showAllServicesController.state is ShowAllServicesInitial), isTrue);
        },
      );

      test(
        'Deve manter o estado de ShowAllServicesLoaded quando o valor filtrado for vazio',
        () async { 
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          showAllServicesController.filter(textFilter: '');

          expect((showAllServicesController.state is ShowAllServicesLoaded), isTrue);
          expect((showAllServicesController.state is! ShowAllServicesFiltered), isTrue);
          final showAllServicesState = (showAllServicesController.state as ShowAllServicesLoaded);
          expect(showAllServicesState.servicesByCategory, equals(servicesByCategory1));
        },
      );
      
      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "h"''',
        () { 
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          showAllServicesController.filter(textFilter: 'h');

          expect((showAllServicesController.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesController.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(2));
        },
      );
      
      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "chapinHA"''',
        () { 
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          showAllServicesController.filter(textFilter: 'chapinHA');

          expect((showAllServicesController.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesController.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));
        },
      );
      
      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "hidratação"''',
        () { 
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          showAllServicesController.filter(textFilter: 'hidratação');

          expect((showAllServicesController.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesController.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));
        },
      );
      
      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "hidratacao"''',
        () { 
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);

          showAllServicesController.filter(textFilter: 'hidratacao');

          expect((showAllServicesController.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesController.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));
        },
      );
      
      test(
        '''Deve alterar o estado para ShowAllServicesLoaded quando filtrar com um valor 
        vazio''',
        () { 
          showAllServicesController.setServicesByCategory(servicesByCategory: servicesByCategory1);
          
          showAllServicesController.filter(textFilter: 'hidratacao');
          expect((showAllServicesController.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesController.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));

          showAllServicesController.filter(textFilter: '');

          expect((showAllServicesController.state is ShowAllServicesLoaded), isTrue);
          expect((showAllServicesController.state is! ShowAllServicesFiltered), isTrue);
          final showAllServicesState = (showAllServicesController.state as ShowAllServicesLoaded);
          expect(showAllServicesState.servicesByCategory, equals(servicesByCategory1));
        },
      );
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/show_all_services_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/service/states/show_all_services_state.dart';

class MockServiceRepository extends Mock implements ServiceRepository {}

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  final offlineMockServiceRepository = MockServiceRepository();
  final onlineMockServiceRepository = MockServiceRepository();
  final mockImageRepository = MockImageRepository();
  late ShowAllServicesViewModel showAllServicesViewModel;

  final serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');

  final service1 = Service(
    id: '1',
    serviceCategoryId: '1',
    name: 'Hidratação',
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
    serviceCategoryId: '1',
    name: 'Escova ',
    price: 69.90,
    hours: 1,
    minutes: 0,
    imageUrl: 'testeUrlImage',
  );

  final servicesByCategory1 = ServicesByCategory(
    serviceCategory: serviceCategory1,
    services: [
      service1,
      service2,
      service3,
    ],
  );

  setUp(
    () {
      final serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
        imageRepository: mockImageRepository,
      );
      showAllServicesViewModel = ShowAllServicesViewModel(
        serviceService: serviceService,
        servicesByCategory: servicesByCategory1,
      );
    },
  );

  group(
    'setServicesByCategory',
    () {
      test(
        '''Deve alterar o estado ShowAllServicesLoaded com o objeto ServicesByCategory correspondente 
        ao passado via parâmetro.''',
        () {
          expect(showAllServicesViewModel.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
        },
      );
    },
  );

  group(
    'delete',
    () {
      test(
        '''Deve alterar o estado ShowAllServicesLoaded com a mensagem de erro caso ocorra algum 
        erro na exclusão da imagem e o estado ESTIVER carregado.''',
        () async {
          const failureMessage = 'Falha no teste';
          when(() => mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );

          await showAllServicesViewModel.delete(service: service1);

          expect(showAllServicesViewModel.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado ShowAllServicesLoaded com a mensagem de erro caso ocorra algum 
        erro na exclusão e o estado ESTIVER carregado.''',
        () async {
          const failureMessage = 'Falha no teste';
          when(() => mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(() => onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );

          await showAllServicesViewModel.delete(service: service1);

          expect(showAllServicesViewModel.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado deve manter ShowAllServicesLoaded quando nenhum erro ocorrer.''',
        () async {
          when(() => mockImageRepository.deleteImage(imageUrl: service1.imageUrl)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(() => onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.right(unit),
          );
          when(() => offlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer(
            (_) async => Either.right(unit),
          );

          await showAllServicesViewModel.delete(service: service1);

          expect(showAllServicesViewModel.state is ShowAllServicesLoaded, isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesLoaded);
          expect(state.servicesByCategory, equals(servicesByCategory1));
        },
      );
    },
  );

  group(
    'filter',
    () {
      test(
        'Deve manter o estado de ShowAllServicesLoaded quando o valor filtrado for vazio',
        () async {
          showAllServicesViewModel.filter(textFilter: '');

          expect((showAllServicesViewModel.state is ShowAllServicesLoaded), isTrue);
          expect((showAllServicesViewModel.state is! ShowAllServicesFiltered), isTrue);
          final showAllServicesState = (showAllServicesViewModel.state as ShowAllServicesLoaded);
          expect(showAllServicesState.servicesByCategory, equals(servicesByCategory1));
        },
      );

      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "h"''',
        () {
          showAllServicesViewModel.filter(textFilter: 'h');

          expect((showAllServicesViewModel.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(2));
        },
      );

      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "chapinHA"''',
        () {
          showAllServicesViewModel.filter(textFilter: 'chapinHA');

          expect((showAllServicesViewModel.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));
        },
      );

      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "hidratação"''',
        () {
          showAllServicesViewModel.filter(textFilter: 'hidratação');

          expect((showAllServicesViewModel.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));
        },
      );

      test(
        '''Deve alterar o estado para ShowAllServicesFiltered com os dados 
        filtrados quando filtrar "hidratacao"''',
        () {
          showAllServicesViewModel.filter(textFilter: 'hidratacao');

          expect((showAllServicesViewModel.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));
        },
      );

      test(
        '''Deve alterar o estado para ShowAllServicesLoaded quando filtrar com um valor 
        vazio''',
        () {
          showAllServicesViewModel.filter(textFilter: 'hidratacao');
          expect((showAllServicesViewModel.state is ShowAllServicesFiltered), isTrue);
          final state = (showAllServicesViewModel.state as ShowAllServicesFiltered);
          expect(state.servicesByCategoryFiltered.services.length, equals(1));

          showAllServicesViewModel.filter(textFilter: '');

          expect((showAllServicesViewModel.state is ShowAllServicesLoaded), isTrue);
          expect((showAllServicesViewModel.state is! ShowAllServicesFiltered), isTrue);
          final showAllServicesState = (showAllServicesViewModel.state as ShowAllServicesLoaded);
          expect(showAllServicesState.servicesByCategory, equals(servicesByCategory1));
        },
      );
    },
  );
}

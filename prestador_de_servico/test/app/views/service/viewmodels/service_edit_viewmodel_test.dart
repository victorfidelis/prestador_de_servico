import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/service/states/service_edit_state.dart';

class MockServiceRepository extends Mock implements ServiceRepository {}

class MockImageRepository extends Mock implements ImageRepository {}

class MockOfflineImageService extends Mock implements OfflineImageService {}

void main() {
  final onlineMockServiceRepository = MockServiceRepository();
  final offlineMockServiceRepository = MockServiceRepository();
  final mockImageRepository = MockImageRepository();
  final mockOfflineImageService = MockOfflineImageService();
  late ServiceEditViewModel serviceEditViewModel;

  final serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');

  final service1 = Service(
    id: '1',
    serviceCategoryId: '1',
    name: 'Chapinha',
    price: 50.90,
    hours: 0,
    minutes: 30,
    imageUrl: '',
  );

  final serviceWithoutName = Service(
    id: '1',
    serviceCategoryId: '1',
    name: '',
    price: 50.90,
    hours: 0,
    minutes: 30,
    imageUrl: '',
  );

  final serviceWithoutPrice = Service(
    id: '1',
    serviceCategoryId: '1',
    name: 'Chapinha',
    price: 0,
    hours: 0,
    minutes: 30,
    imageUrl: '',
  );

  final serviceWithoutHoursAndMinutes = Service(
    id: '1',
    serviceCategoryId: '1',
    name: 'Chapinha',
    price: 50.90,
    hours: 0,
    minutes: 0,
    imageUrl: '',
  );

  setUp(
    () {
      ServiceService serviceService = ServiceService(
        onlineRepository: onlineMockServiceRepository,
        offlineRepository: offlineMockServiceRepository,
        imageRepository: mockImageRepository,
      );
      serviceEditViewModel = ServiceEditViewModel(
        serviceService: serviceService,
        offlineImageService: mockOfflineImageService,
      );
    },
  );

  group(
    'initInsert',
    () {
      test(
        'Deve alterar o estado para ServiceEditAdd',
        () {
          serviceEditViewModel.initInsert(serviceCategory: serviceCategory1);

          expect(serviceEditViewModel.state is ServiceEditAdd, isTrue);
        },
      );
    },
  );

  group(
    'initUpdate',
    () {
      test(
        '''Deve alterar o estado para ServiceEditUpdate e definir o Service a ser alterado''',
        () {
          serviceEditViewModel.initUpdate(serviceCategory: serviceCategory1, service: service1);

          expect(serviceEditViewModel.state is ServiceEditUpdate, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditUpdate);
          expect(state.service, equals(service1));
        },
      );
    },
  );

  group(
    'validateAndInsert',
    () {
      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem de erro 
        no campo "nameMessage" quando o campo "name" estiver vazio.''',
        () async {
          await serviceEditViewModel.validateAndInsert(service: serviceWithoutName);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem de erro 
        no campo "priceMessage" quando o campo "price" estiver vazio.''',
        () async {
          await serviceEditViewModel.validateAndInsert(service: serviceWithoutPrice);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.priceMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem de erro no campo 
        "hoursAndMinutesMessage" quando os campos "hours" e "minutes" estiverem vazios.''',
        () async {
          await serviceEditViewModel.validateAndInsert(service: serviceWithoutHoursAndMinutes);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.hoursAndMinutesMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem no campo 
        "genericMessage" quando não estiver acesso a internet.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.left((NetworkFailure(failureMessage))));

          await serviceEditViewModel.validateAndInsert(service: service1);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditSuccess com o Service inserido
        quando a inserção for válida..''',
        () async {
          when(() => onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));
          when(() => offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));

          await serviceEditViewModel.validateAndInsert(service: service1);

          expect(serviceEditViewModel.state is ServiceEditSuccess, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditSuccess);
          expect(state.service, equals(service1));
        },
      );
    },
  );

  group(
    'validateAndUpdate',
    () {
      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem de erro no 
        campo "nameMessage" quando o campo "name" estiver vazio.''',
        () async {
          await serviceEditViewModel.validateAndUpdate(service: serviceWithoutName);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem de erro 
        no campo "priceMessage" quando o campo "price" estiver vazio.''',
        () async {
          await serviceEditViewModel.validateAndUpdate(service: serviceWithoutPrice);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.priceMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem de erro no campo 
        "hoursAndMinutesMessage" quando os campos "hours" e "minutes" estiverem vazios.''',
        () async {
          await serviceEditViewModel.validateAndUpdate(service: serviceWithoutHoursAndMinutes);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.hoursAndMinutesMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditError e definir uma mensagem no campo 
        "genericMessage" quando não estiver acesso a internet.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.left((NetworkFailure(failureMessage))));

          await serviceEditViewModel.validateAndUpdate(service: service1);

          expect(serviceEditViewModel.state is ServiceEditError, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditError);
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceEditSuccess com o Service atualizado
        quando a atualização for válida.''',
        () async {
          when(() => onlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.right(unit));

          await serviceEditViewModel.validateAndUpdate(service: service1);

          expect(serviceEditViewModel.state is ServiceEditSuccess, isTrue);
          final state = (serviceEditViewModel.state as ServiceEditSuccess);
          expect(state.service, equals(service1));
        },
      );
    },
  );

  group(
    'pickImageFromGallery',
    () {
      test(
        '''Deve alterar o estado para PickImageError com a mensagem de erro
        quando uma falha ocorrer na captura de imagem.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => mockOfflineImageService.pickImageFromGallery())
              .thenAnswer((_) async => Either.left(PickImageFailure(failureMessage)));

          await serviceEditViewModel.pickImageFromGallery();

          expect(serviceEditViewModel.state is PickImageError, isTrue);
          final state = (serviceEditViewModel.state as PickImageError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para PickImageSuccess com a imagem selecionada
        quando a captura da imagem ocorrer normalmente.''',
        () async {
          final file = File('caminho da imagem selecionada');
          when(() => mockOfflineImageService.pickImageFromGallery())
              .thenAnswer((_) async => Either.right(file));

          await serviceEditViewModel.pickImageFromGallery();

          expect(serviceEditViewModel.state is PickImageSuccess, isTrue);
          final state = (serviceEditViewModel.state as PickImageSuccess);
          expect(state.imageFile, equals(file));
        },
      );
    },
  );
}

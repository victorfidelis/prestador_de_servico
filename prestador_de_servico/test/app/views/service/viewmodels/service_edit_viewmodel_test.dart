import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/service/states/service_edit_state.dart';

import '../../../../helpers/image/mock_image_repository.dart';
import '../../../../helpers/offline_image/mock_offline_image_service.dart';
import '../../../../helpers/service/service/mock_service_repository.dart';

void main() {
  late ServiceEditViewModel serviceEditViewModel;

  late ServiceCategory serviceCategory1;

  late Service service1;
  late Service serviceWithoutName;
  late Service serviceWithoutPrice;
  late Service serviceWithoutHoursAndMinutes;

  void setUpValues() {
    serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');

    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Chapinha',
      price: 50.90,
      hours: 0,
      minutes: 30,
      imageUrl: '',
    );

    serviceWithoutName = Service(
      id: '1',
      serviceCategoryId: '1',
      name: '',
      price: 50.90,
      hours: 0,
      minutes: 30,
      imageUrl: '',
    );

    serviceWithoutPrice = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Chapinha',
      price: 0,
      hours: 0,
      minutes: 30,
      imageUrl: '',
    );

    serviceWithoutHoursAndMinutes = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Chapinha',
      price: 50.90,
      hours: 0,
      minutes: 0,
      imageUrl: '',
    );
  }

  setUp(
    () {
      setUpMockServiceRepository();
      setUpMockImageRepository();
      ServiceService serviceService = ServiceService(
        onlineRepository: onlineMockServiceRepository,
        offlineRepository: offlineMockServiceRepository,
        imageRepository: mockImageRepository,
      );

      setUpMockOfflineImageService();

      serviceEditViewModel = ServiceEditViewModel(
        serviceService: serviceService,
        offlineImageService: mockOfflineImageService,
      );
      setUpValues();
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
          when(onlineMockServiceRepository.insert(service: service1))
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
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));
          when(offlineMockServiceRepository.insert(service: service1))
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
          when(onlineMockServiceRepository.update(service: service1))
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
          when(onlineMockServiceRepository.update(service: service1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: service1)).thenAnswer((_) async => Either.right(unit));

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
          when(mockOfflineImageService.pickImageFromGallery())
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
          when(mockOfflineImageService.pickImageFromGallery())
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

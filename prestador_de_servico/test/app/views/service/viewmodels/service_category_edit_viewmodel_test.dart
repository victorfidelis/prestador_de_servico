import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_category_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/service/states/service_category_edit_state.dart';

import '../../../../helpers/service/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryEditViewModel serviceCategoryEditViewModel;

  late ServiceCategory serviceCategory1;
  late ServiceCategory serviceCategoryWithoutName;

  void setUpValues() {
    serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');
    serviceCategoryWithoutName = ServiceCategory(id: '100', name: '');
  }

  setUp(
    () {
      setUpMockServiceCategoryRepository();
      ServiceCategoryService serviceCategoryService = ServiceCategoryService(
        onlineRepository: onlineMockServiceCategoryRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
      );

      serviceCategoryEditViewModel = ServiceCategoryEditViewModel(
        serviceCategoryService: serviceCategoryService,
      );
      setUpValues();
    },
  );

  group(
    'initInsert',
    () {
      test(
        'Deve alterar o estado para ServiceCategoryEditAdd',
        () {
          serviceCategoryEditViewModel.initInsert();

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditAdd, isTrue);
        },
      );
    },
  );

  group(
    'initUpdate',
    () {
      test(
        '''Deve alterar o estado para ServiceCategoryEditUpdate e definir o ServiceCategory 
        a ser alterado''',
        () {
          serviceCategoryEditViewModel.initUpdate(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditUpdate, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditUpdate);
          expect(state.serviceCategory, equals(serviceCategory1));
        },
      );
    },
  );

  group(
    'validateAndInsert',
    () {
      test(
        '''Deve alterar o estado para ServiceCategoryEditError e definir uma mensagem de erro 
        no campo "nameMessage" quando o campo "name" estiver vazio.''',
        () async {
          await serviceCategoryEditViewModel.validateAndInsert(serviceCategory: serviceCategoryWithoutName);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditError);
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceCategoryEditError e definir uma mensagem no campo 
        "genericMessagequando" quando não estiver acesso a internet.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.left((NetworkFailure(failureMessage))));

          await serviceCategoryEditViewModel.validateAndInsert(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditError);
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceCategoryEditSuccess com o ServiceCategory inserido
        quando a inserção for válida..''',
        () async {
          when(onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(serviceCategory1.id));
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(serviceCategory1.id));

          await serviceCategoryEditViewModel.validateAndInsert(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditSuccess, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditSuccess);
          expect(state.serviceCategory, equals(serviceCategory1));
        },
      );
    },
  );

  group(
    'validateAndUpdate',
    () {
      test(
        '''Deve alterar o estado para ServiceCategoryEditError e definir uma mensagem de erro no 
        campo "nameMessage" quando o campo "name" estiver vazio.''',
        () async {
          await serviceCategoryEditViewModel.validateAndUpdate(serviceCategory: serviceCategoryWithoutName);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditError);
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceCategoryEditError e definir uma mensagem no campo 
        "genericMessage" quando não estiver acesso a internet.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          await serviceCategoryEditViewModel.validateAndUpdate(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditError);
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceCategoryEditSuccess com o ServiceCategory alterado 
        quando a alteração for válida.''',
        () async {
          when(onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(unit));

          await serviceCategoryEditViewModel.validateAndUpdate(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditViewModel.state is ServiceCategoryEditSuccess, isTrue);
          final state = (serviceCategoryEditViewModel.state as ServiceCategoryEditSuccess);
          expect(state.serviceCategory, equals(serviceCategory1));
        },
      );
    },
  );
}

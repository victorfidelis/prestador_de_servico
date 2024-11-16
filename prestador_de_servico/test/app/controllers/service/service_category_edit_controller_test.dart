import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';

import '../../../helpers/service/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryEditController serviceCategoryEditController;

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

      serviceCategoryEditController = ServiceCategoryEditController(
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
          serviceCategoryEditController.initInsert();

          expect(serviceCategoryEditController.state is ServiceCategoryEditAdd, isTrue);
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
          serviceCategoryEditController.initUpdate(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditController.state is ServiceCategoryEditUpdate, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditUpdate);
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
          await serviceCategoryEditController.validateAndInsert(serviceCategory: serviceCategoryWithoutName);

          expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
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

          await serviceCategoryEditController.validateAndInsert(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
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

          await serviceCategoryEditController.validateAndInsert(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditController.state is ServiceCategoryEditSuccess, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditSuccess);
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
          await serviceCategoryEditController.validateAndUpdate(serviceCategory: serviceCategoryWithoutName);

          expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
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

          await serviceCategoryEditController.validateAndUpdate(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
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

          await serviceCategoryEditController.validateAndUpdate(serviceCategory: serviceCategory1);

          expect(serviceCategoryEditController.state is ServiceCategoryEditSuccess, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditSuccess);
          expect(state.serviceCategory, equals(serviceCategory1));
        },
      );
    },
  );
}

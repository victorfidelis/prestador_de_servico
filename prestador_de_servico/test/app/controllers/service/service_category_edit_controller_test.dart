import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/service/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryEditController serviceCategoryEditController;

  late ServiceCategory serviceCategory1;
  late ServiceCategory serviceCategoryWithoutName;

  setUpValues() {
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
      serviceCategoryEditController = ServiceCategoryEditController(serviceCategoryService: serviceCategoryService);
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
        '''Deve alterar o estado para ServiceCategoryEditUpdate.
        O estado deve conter o ServiceCategory a ser alterado.''',
        () {
          serviceCategoryEditController.initUpdate(serviceCategory: serCatGeneric);

          expect(serviceCategoryEditController.state is ServiceCategoryEditUpdate, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditUpdate);
          expect(state.serviceCategory, equals(serCatGeneric));
        },
      );
    },
  );

  group(
    'validateAndInsert',
    () {
      test(
        '''Deve alterar o estado para ServiceCategoryEditError quando o campo "name" estiver vazio.
        O estado deve ter a mensagem de erro no campo "nameMessage"''',
        () async {
          await serviceCategoryEditController.validateAndInsert(serviceCategory: serviceCategoryWithoutName);

          expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceCategoryEditError quando não estiver acesso 
        a internet. O estado deve conter uma mensagem no campo "genericMessage"''',
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
        '''Deve alterar o estado para ServiceCategoryEditSuccess quando a inserção for válida.
        O estado deve conter o ServiceCategory inserido.''',
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
        '''Deve alterar o estado para ServiceCategoryEditError quando o campo "name" estiver vazio.
        O estado deve ter a mensagem de erro no campo "nameMessage"''',
        () async {
          await serviceCategoryEditController.validateAndUpdate(serviceCategory: serviceCategoryWithoutName);

          expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
          final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve alterar o estado para ServiceCategoryEditError quando não estiver acesso 
        a internet. O estado deve conter uma mensagem no campo "genericMessage''',
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
    },
  );

  test(
    '''Deve alterar o estado para ServiceCategoryEditSuccess quando a alteração for válida.
        O estado deve conter o ServiceCategory alterado.''',
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
}

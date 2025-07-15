import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_category_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';
import 'package:prestador_de_servico/app/views/service/states/service_category_edit_state.dart';

class MockServiceCategoryRepository extends Mock implements ServiceCategoryRepository {}

void main() {
  final onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final offlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  late ServiceCategoryEditViewModel serviceCategoryEditViewModel;

  final serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');
  final serviceCategoryWithoutName = ServiceCategory(id: '100', name: '');

  setUp(
    () {
      ServiceCategoryService serviceCategoryService = ServiceCategoryService(
        onlineRepository: onlineMockServiceCategoryRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
      );

      serviceCategoryEditViewModel = ServiceCategoryEditViewModel(
        serviceCategoryService: serviceCategoryService,
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
          await serviceCategoryEditViewModel.validateAndInsert(
              serviceCategory: serviceCategoryWithoutName);

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
          when(() => onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
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
          when(() => onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(serviceCategory1.id));
          when(() => offlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
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
          await serviceCategoryEditViewModel.validateAndUpdate(
              serviceCategory: serviceCategoryWithoutName);

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
          when(() => onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
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
          when(() => onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
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

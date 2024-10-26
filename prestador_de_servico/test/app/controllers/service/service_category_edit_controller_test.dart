import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/service/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryEditController serviceCategoryEditController;

  setUpAll(
    () {
      setUpMockServiceCategoryRepository();
      ServiceCategoryService serviceCategoryService = ServiceCategoryService(
        onlineRepository: onlineMockServiceCategoryRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
      );
      serviceCategoryEditController = ServiceCategoryEditController(serviceCategoryService: serviceCategoryService);
    },
  );

  test(
    '''Ao iniciar uma inserção de uma categoria de serviço, o estado do 
    controller deve ser alterado para ServiceCategoryEditAdd''',
    () {
      serviceCategoryEditController.initInsert();

      expect(serviceCategoryEditController.state is ServiceCategoryEditAdd, isTrue);
    },
  );
  
  test(
    '''Ao iniciar uma alteração de uma categoria de serviço, o estado do 
    controller deve ser alterado para ServiceCategoryEditAdd, e este estado deve 
    conter a categoria a ser alterada''',
    () {
      serviceCategoryEditController.initUpdate(serviceCategory: serCatGeneric);

      expect(serviceCategoryEditController.state is ServiceCategoryEditUpdate, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditUpdate);
      expect(state.serviceCategory, equals(serCatGeneric));
    },
  );
  
  test(
    '''Ao tentar inserir um serviço de categoria sem informar o nome, o estado do controller
    deve ser alterado para ServiceCategoryEditError, e este estado deve conter 
    uma mensagem no campo nameMessage''',
    () async {
      await serviceCategoryEditController.validateAndInsert(serviceCategory: serCatInsertWithoutName);

      expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
      expect(state.nameMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar alterar um serviço de categoria sem informar o nome, o estado do controller
    deve ser alterado para ServiceCategoryEditError, e este estado deve conter 
    uma mensagem no campo nameMessage''',
    () async {
      await serviceCategoryEditController.validateAndUpdate(serviceCategory: serCatUpdateWithoutName);

      expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
      expect(state.nameMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar inserir um serviço de categoria sem estar conectado a internet, 
    o estado do controller deve ser alterado para ServiceCategoryEditError, e este 
    estado deve conter uma mensagem no campo genericMessage''',
    () async {
      await serviceCategoryEditController.validateAndInsert(serviceCategory: serCatNoNetworkConnection);

      expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
      expect(state.genericMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar alterar um serviço de categoria sem estar conectado a internet, 
    o estado do controller deve ser alterado para ServiceCategoryEditError, e este 
    estado deve conter uma mensagem no campo genericMessage''',
    () async {
      await serviceCategoryEditController.validateAndUpdate(serviceCategory: serCatNoNetworkConnection);

      expect(serviceCategoryEditController.state is ServiceCategoryEditError, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditError);
      expect(state.genericMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar inserir um serviço de categoria valido, o estado do controller 
    deve ser alterado para ServiceCategoryEditSuccess, e este 
    estado deve conter a categoria de servido inserida''',
    () async {
      await serviceCategoryEditController.validateAndInsert(serviceCategory: serCatInsert);

      expect(serviceCategoryEditController.state is ServiceCategoryEditSuccess, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditSuccess);
      expect(state.serviceCategory, equals(serCatInsert));
    },
  );
  
  test(
    '''Ao tentar alterar um serviço de categoria valido, o estado do controller 
    deve ser alterado para ServiceCategoryEditSuccess, e este 
    estado deve conter a categoria de servido inserida''',
    () async {
      await serviceCategoryEditController.validateAndUpdate(serviceCategory: serCatUpdate);

      expect(serviceCategoryEditController.state is ServiceCategoryEditSuccess, isTrue);
      final state = (serviceCategoryEditController.state as ServiceCategoryEditSuccess);
      expect(state.serviceCategory, equals(serCatUpdate));
    },
  );
}

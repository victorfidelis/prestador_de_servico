import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/controllers/service_category/service_category_controller.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_state.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryController serviceCategoryController;

  setUpAll(
    () {
      setUpMockServiceCategoryRepository();
      ServiceCategoryService serviceCategoryService = ServiceCategoryService(
        onlineServiceCategoryRepository: mockServiceCategoryRepository,
        offlineServiceCategoryRepository: mockServiceCategoryRepository,
      );
      serviceCategoryController = ServiceCategoryController(serviceCategoryService: serviceCategoryService);
    },
  );

  test(
    '''Ao executar o carregamento das categorias de serviço, o estado 
    do controller deve ser alterado para ServiceCategoryLoaded com a lista das 
    categorias de serviço carregadas''',
    () async {
      await serviceCategoryController.load();

      expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
      final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
      expect(serviceCategoryState.serviceCategories.length, equals(serCatGetAll.length));
    },
  );

  test(
    '''Ao executar um filtro por nome de categorias de serviço, o estado 
    do controller deve ser alterado para ServiceCategoryLoaded com a lista das 
    categorias de serviço filtradas, neste caso, nenhuma categoria deve ser 
    retornada''',
    () async {
      await serviceCategoryController.filter(name: serCatNameContainedWithoutResult);

      expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
      final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
      expect(serviceCategoryState.serviceCategories.length, equals(serCatGetNameContainedWithoutResult.length));
    },
  );

  test(
    '''Ao executar um filtro por nome de categorias de serviço, o estado 
    do controller deve ser alterado para ServiceCategoryLoaded com a lista das 
    categorias de serviço filtradas, neste caso, uma categoria deve ser 
    retornada''',
    () async {
      await serviceCategoryController.filter(name: serCatNameContained1Result);

      expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
      final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
      expect(serviceCategoryState.serviceCategories.length, equals(serCatGetNameContained1Result.length));
    },
  );

  test(
    '''Ao executar um filtro por nome de categorias de serviço, o estado 
    do controller deve ser alterado para ServiceCategoryLoaded com a lista das 
    categorias de serviço filtradas, neste caso, duas categorias devem ser 
    retornadas''',
    () async {
      await serviceCategoryController.filter(name: serCatNameContained2Result);

      expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
      final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
      expect(serviceCategoryState.serviceCategories.length, equals(serCatGetNameContained2Result.length));
    },
  );

  test(
    '''Ao executar um filtro por nome de categorias de serviço, o estado 
    do controller deve ser alterado para ServiceCategoryLoaded com a lista das 
    categorias de serviço filtradas, neste caso, três categorias devem ser 
    retornadas''',
    () async {
      await serviceCategoryController.filter(name: serCatNameContained3Result);

      expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
      final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
      expect(serviceCategoryState.serviceCategories.length, equals(serCatGetNameContained3Result.length));
    },
  );

  test(
    '''Ao deletar uma categoria de serviço, além da exclusão da categoria, o estado 
    o controller deve ser alterado para ServiceCategoryLoaded com uma nova lista de 
    categorias de serviço''',
    () async {
      await serviceCategoryController.delete(serviceCategory: serCatDelete);

      expect(serviceCategoryController.state is ServiceCategoryLoaded, isTrue);
      final serviceCategoryState = serviceCategoryController.state as ServiceCategoryLoaded;
      expect(serviceCategoryState.serviceCategories.length, equals(serCatGetAll.length));
    },
  );

  test(
    '''Ao adicionar uma categoria de serviço a lista de categorias já carregadas, 
    a mesma deve ser inserida no topo da lista''',
    () async {
      await serviceCategoryController.load();

      final lenBefore = (serviceCategoryController.state as ServiceCategoryLoaded).serviceCategories.length;
      serviceCategoryController.addOnList(serviceCategory: serCatGeneric);
      final newState = (serviceCategoryController.state as ServiceCategoryLoaded);

      expect(newState.serviceCategories.length, equals(lenBefore + 1));
      expect(newState.serviceCategories[0], equals(serCatGeneric));
    },
  );

  test(
    '''Ao alterar uma categoria de serviço em uma lista de categorias já carregadas, 
    a mesma deve ser alterarada no estado do controller''',
    () async {
      await serviceCategoryController.load();
      serviceCategoryController.addOnList(serviceCategory: serCatGeneric);

      final lenBefore = (serviceCategoryController.state as ServiceCategoryLoaded).serviceCategories.length;
      final serviceCategoryUpdate = serCatGeneric.copyWith(name: 'Test update');
      serviceCategoryController.updateOnList(serviceCategory: serviceCategoryUpdate);
      final newState = (serviceCategoryController.state as ServiceCategoryLoaded);

      expect(newState.serviceCategories.length, equals(lenBefore));
      expect(newState.serviceCategories[0], equals(serviceCategoryUpdate));
    },
  );
}

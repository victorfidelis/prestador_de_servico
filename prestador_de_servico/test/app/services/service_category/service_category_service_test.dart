import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/service_category/mock_service_category_repository.dart';

void main() {
  late ServiceCategoryService serviceCategoryService;

  setUpAll(
    () {
      setUpMockServiceCategoryRepository();
      serviceCategoryService = ServiceCategoryService(
        onlineServiceCategoryRepository: mockServiceCategoryRepository,
        offlineServiceCategoryRepository: mockServiceCategoryRepository,
      );
    },
  );

  test(
    '''Ao consultar todos as categorias de serviço, deve ser retornado uma lista de 
    categorias de serviço''',
    () async {
      final getAllEither = await serviceCategoryService.getAll();
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right!.length, equals(serCatGetAll.length));
    },
  );

  test(
    '''Ao consultar categorias de serviço por nome sem estar conectado a internet, 
    uma falha do tipo NetworkFailure deve ser retornada''',
    () async {
      final getAllEither = await serviceCategoryService.getNameContained(name: serCatNoNetworkConnection.name);
    
      expect(getAllEither.isLeft, isTrue);
      expect(getAllEither.left is NetworkFailure, isTrue);
    },
  );

  test(
    '''Ao consultar categorias de serviço por nome conectado a internet, 
   uma lista de categorias de serviço deve ser retornada de acordo com o nome passado,
   nesta cenário, uma lista vazia''',
    () async {
      final getAllEither = await serviceCategoryService.getNameContained(name: serCatNameContainedWithoutResult);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right!.length, serCatGetNameContainedWithoutResult.length);
    },
  );

  test(
    '''Ao consultar categorias de serviço por nome conectado a internet, 
   uma lista de categorias de serviço deve ser retornada de acordo com o nome passado,
   nesta cenário, uma lista com 1 categoria de serviço''',
    () async {
      final getAllEither = await serviceCategoryService.getNameContained(name: serCatNameContained1Result);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right!.length, serCatGetNameContained1Result.length);
    },
  );

  test(
    '''Ao consultar categorias de serviço por nome conectado a internet, 
   uma lista de categorias de serviço deve ser retornada de acordo com o nome passado,
   nesta cenário, uma lista com 2 categorias de serviço''',
    () async {
      final getAllEither = await serviceCategoryService.getNameContained(name: serCatNameContained2Result);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right!.length, serCatGetNameContained2Result.length);
    },
  );

  test(
    '''Ao consultar categorias de serviço por nome conectado a internet, 
   uma lista de categorias de serviço deve ser retornada de acordo com o nome passado,
   nesta cenário, uma lista com 3 categorias de serviço''',
    () async {
      final getAllEither = await serviceCategoryService.getNameContained(name: serCatNameContained3Result);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right!.length, serCatGetNameContained3Result.length);
    },
  );

  test(
    '''Ao inserir uma categoria de serviço um Either right (sucesso) deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.insert(serviceCategory: serCatInsert);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right is Unit, isTrue);
    },
  );

  test(
    '''Ao inserir uma categoria de serviço sem uma conexão com a internet um 
    Either left (falha) do tipo NetworkFailure deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.insert(serviceCategory: serCatNoNetworkConnection);
    
      expect(getAllEither.isLeft, isTrue);
      expect(getAllEither.left is NetworkFailure, isTrue);
    },
  );

  test(
    '''Ao inserir uma categoria de serviço um Either right (sucesso) deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.insert(serviceCategory: serCatInsert);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right is Unit, isTrue);
    },
  );

  test(
    '''Ao alterar uma categoria de serviço sem uma conexão com a internet um 
    Either left (falha) do tipo NetworkFailure deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.update(serviceCategory: serCatNoNetworkConnection);
    
      expect(getAllEither.isLeft, isTrue);
      expect(getAllEither.left is NetworkFailure, isTrue);
    },
  );

  test(
    '''Ao alterar uma categoria de serviço um Either right (sucesso) deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.update(serviceCategory: serCatUpdate);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right is Unit, isTrue);
    },
  );

  test(
    '''Ao deletar uma categoria de serviço sem uma conexão com a internet um 
    Either left (falha) do tipo NetworkFailure deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.delete(serviceCategory: serCatNoNetworkConnection);
    
      expect(getAllEither.isLeft, isTrue);
      expect(getAllEither.left is NetworkFailure, isTrue);
    },
  );

  test(
    '''Ao deletar uma categoria de serviço um Either right (sucesso) deve ser retornado''',
    () async {
      final getAllEither = await serviceCategoryService.delete(serviceCategory: serCatDelete);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right is Unit, isTrue);
    },
  );
}

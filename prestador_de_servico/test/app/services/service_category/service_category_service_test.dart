import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
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
   uma lista de categorias de serviço deve ser retornada de acordo com o nome passado''',
    () async {
      final getAllEither = await serviceCategoryService.getNameContained(name: serCatNameContainedWithoutResult);
    
      expect(getAllEither.isRight, isTrue);
      expect(getAllEither.right!.length, serCatGetNameContainedWithoutResult.length);
    },
  );
}

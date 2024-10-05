import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';

@GenerateNiceMocks([MockSpec<ServiceCategoryRepository>()])
import 'service_category_repository_test.mocks.dart';

void main() {
  MockServiceCategoryRepository mockServiceCategoryRepository =
      MockServiceCategoryRepository();

  ServiceCategory serviceCartegory1 =
      ServiceCategory(id: '1', name: 'Cabelo');

  ServiceCategory serviceCartegory2 =
      ServiceCategory(id: '2', name: 'Face');

  ServiceCategory serviceCartegory3 =
      ServiceCategory(id: '3', name: 'Depilação');

  setUpAll(() {
    when(mockServiceCategoryRepository.getById(id: serviceCartegory1.id))
        .thenAnswer(
      (_) async => serviceCartegory1,
    );

    when(mockServiceCategoryRepository.getById(id: serviceCartegory2.id))
        .thenAnswer(
      (_) async => serviceCartegory2,
    );

    when(mockServiceCategoryRepository.getById(id: serviceCartegory3.id))
        .thenAnswer(
      (_) async => serviceCartegory3,
    );

    when(mockServiceCategoryRepository.getNameContained(name: 'a')).thenAnswer(
      (_) async => [
        serviceCartegory1,
        serviceCartegory2,
        serviceCartegory3,
      ],
    );

    when(mockServiceCategoryRepository.getNameContained(name: 'cab'))
        .thenAnswer(
      (_) async => [
        serviceCartegory1,
      ],
    );

    when(mockServiceCategoryRepository.getNameContained(name: 'unha'))
        .thenAnswer(
      (_) async => [],
    );

    when(mockServiceCategoryRepository.insert(serviceCategory: serviceCartegory2))
        .thenAnswer(
      (_) async => serviceCartegory2.id,
    );

    when(mockServiceCategoryRepository.update(
            serviceCategory: serviceCartegory3))
        .thenAnswer(
      (_) async => true,
    );

    when(mockServiceCategoryRepository.deleteById(
            id: serviceCartegory1.id))
        .thenAnswer(
      (_) async {},
    );
  });

  test(
    '''Ao tentar capturar um categoria de serviço pelo seu id o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria consultada (teste da categoria 1)''',
    () async {
      ServiceCategory? serviceCartegory =
          await mockServiceCategoryRepository.getById(id: serviceCartegory1.id);

      expect(serviceCartegory, equals(serviceCartegory1));
    },
  );

  test(
    '''Ao tentar capturar um categoria de serviço pelo seu id o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria consultada (teste da categoria 2)''',
    () async {
      ServiceCategory? serviceCartegory =
          await mockServiceCategoryRepository.getById(id: serviceCartegory2.id);

      expect(serviceCartegory, equals(serviceCartegory2));
    },
  );

  test(
    '''Ao tentar capturar um categoria de serviço pelo seu id o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria consultada (teste da categoria 3)''',
    () async {
      ServiceCategory? serviceCartegory =
          await mockServiceCategoryRepository.getById(id: serviceCartegory3.id);

      expect(serviceCartegory, equals(serviceCartegory3));
    },
  );

  test(
    '''Ao tentar consultar categorias de serviço pelo nome o retorno deve ser 
  uma lista instâncias de ServiceCartegoryModel das categorias que contém o texto 
  consultado em seu nome (texte com valor 'a')''',
    () async {
      List<ServiceCategory> serviceCartegories =
          await mockServiceCategoryRepository.getNameContained(name: 'a');

      expect(serviceCartegories.length, equals(3));
      if (serviceCartegories.length == 3) {
        expect(serviceCartegories[0], equals(serviceCartegory1));
        expect(serviceCartegories[1], equals(serviceCartegory2));
        expect(serviceCartegories[2], equals(serviceCartegory3));
      }
    },
  );

  test(
    '''Ao tentar consultar categorias de serviço pelo nome o retorno deve ser 
  uma lista instâncias de ServiceCartegoryModel das categorias que contém o texto 
  consultado em seu nome (texte com valor 'cab')''',
    () async {
      List<ServiceCategory> serviceCartegories =
          await mockServiceCategoryRepository.getNameContained(name: 'cab');

      expect(serviceCartegories.length, equals(1));
      if (serviceCartegories.length == 1) {
        expect(serviceCartegories[0], equals(serviceCartegory1));
      }
    },
  );

  test(
    '''Ao tentar consultar categorias de serviço pelo nome o retorno deve ser 
  uma lista instâncias de ServiceCartegoryModel das categorias que contém o texto 
  consultado em seu nome (texte com valor 'unha')''',
    () async {
      List<ServiceCategory> serviceCartegories =
          await mockServiceCategoryRepository.getNameContained(name: 'unha');

      expect(serviceCartegories.length, equals(0));
    },
  );

  test(
    '''Ao tentar adicionar uma categoria de serviço o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria inserida''',
    () async {
      String? serviceCartegoryId = await mockServiceCategoryRepository.insert(
        serviceCategory: serviceCartegory2,);

      expect(serviceCartegoryId, equals(serviceCartegory2.id));
    },
  );

  test(
    '''Ao tentar alterar uma categoria de serviço o retorno deve ser 
  um valor booleano verdadeiro''',
    () async {
      await mockServiceCategoryRepository.update(
        serviceCategory: serviceCartegory3,);
    },
  );

  test(
    '''Ao tentar deletar uma categoria de serviço pelo seu id o retorno deve ser 
  um valor booleano verdadeiro''',
    () async {
      await mockServiceCategoryRepository.deleteById(
        id: serviceCartegory1.id,);
    },
  );
}

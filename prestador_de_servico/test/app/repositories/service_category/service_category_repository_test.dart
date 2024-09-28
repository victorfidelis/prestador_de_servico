import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';

@GenerateNiceMocks([MockSpec<ServiceCategoryRepository>()])
import 'service_category_repository_test.mocks.dart';

void main() {
  MockServiceCategoryRepository mockServiceCategoryRepository =
      MockServiceCategoryRepository();

  ServiceCartegoryModel serviceCartegory1 =
      ServiceCartegoryModel(id: 1, name: 'Cabelo');

  ServiceCartegoryModel serviceCartegory2 =
      ServiceCartegoryModel(id: 2, name: 'Face');

  ServiceCartegoryModel serviceCartegory3 =
      ServiceCartegoryModel(id: 3, name: 'Depilação');

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

    when(mockServiceCategoryRepository.add(serviceCategory: serviceCartegory2))
        .thenAnswer(
      (_) async => serviceCartegory2,
    );

    when(mockServiceCategoryRepository.update(
            serviceCategory: serviceCartegory3))
        .thenAnswer(
      (_) async => true,
    );

    when(mockServiceCategoryRepository.deleteById(
            serviceCategory: serviceCartegory1))
        .thenAnswer(
      (_) async => true,
    );
  });

  test(
    '''Ao tentar capturar um categoria de serviço pelo seu id o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria consultada (teste da categoria 1)''',
    () async {
      ServiceCartegoryModel? serviceCartegory =
          await mockServiceCategoryRepository.getById(id: serviceCartegory1.id);

      expect(serviceCartegory, equals(serviceCartegory1));
    },
  );

  test(
    '''Ao tentar capturar um categoria de serviço pelo seu id o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria consultada (teste da categoria 2)''',
    () async {
      ServiceCartegoryModel? serviceCartegory =
          await mockServiceCategoryRepository.getById(id: serviceCartegory2.id);

      expect(serviceCartegory, equals(serviceCartegory2));
    },
  );

  test(
    '''Ao tentar capturar um categoria de serviço pelo seu id o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria consultada (teste da categoria 3)''',
    () async {
      ServiceCartegoryModel? serviceCartegory =
          await mockServiceCategoryRepository.getById(id: serviceCartegory3.id);

      expect(serviceCartegory, equals(serviceCartegory3));
    },
  );

  test(
    '''Ao tentar consultar categorias de serviço pelo nome o retorno deve ser 
  uma lista instâncias de ServiceCartegoryModel das categorias que contém o texto 
  consultado em seu nome (texte com valor 'a')''',
    () async {
      List<ServiceCartegoryModel> servicesCartegory =
          await mockServiceCategoryRepository.getNameContained(name: 'a');

      expect(servicesCartegory.length, equals(3));
      if (servicesCartegory.length == 3) {
        expect(servicesCartegory[0], equals(serviceCartegory1));
        expect(servicesCartegory[1], equals(serviceCartegory2));
        expect(servicesCartegory[2], equals(serviceCartegory3));
      }
    },
  );

  test(
    '''Ao tentar consultar categorias de serviço pelo nome o retorno deve ser 
  uma lista instâncias de ServiceCartegoryModel das categorias que contém o texto 
  consultado em seu nome (texte com valor 'cab')''',
    () async {
      List<ServiceCartegoryModel> servicesCartegory =
          await mockServiceCategoryRepository.getNameContained(name: 'cab');

      expect(servicesCartegory.length, equals(1));
      if (servicesCartegory.length == 1) {
        expect(servicesCartegory[0], equals(serviceCartegory1));
      }
    },
  );

  test(
    '''Ao tentar consultar categorias de serviço pelo nome o retorno deve ser 
  uma lista instâncias de ServiceCartegoryModel das categorias que contém o texto 
  consultado em seu nome (texte com valor 'unha')''',
    () async {
      List<ServiceCartegoryModel> servicesCartegory =
          await mockServiceCategoryRepository.getNameContained(name: 'unha');

      expect(servicesCartegory.length, equals(0));
    },
  );

  test(
    '''Ao tentar adicionar uma categoria de serviço o retorno deve ser 
  uma instância de ServiceCartegoryModel da categoria inserida''',
    () async {
      ServiceCartegoryModel? serviceCartegory = await mockServiceCategoryRepository.add(
        serviceCategory: serviceCartegory2,);

      expect(serviceCartegory, equals(serviceCartegory2));
    },
  );

  test(
    '''Ao tentar alterar uma categoria de serviço o retorno deve ser 
  um valor booleano verdadeiro''',
    () async {
      bool isUpdated = await mockServiceCategoryRepository.update(
        serviceCategory: serviceCartegory3,);

      expect(isUpdated, isTrue);
    },
  );

  test(
    '''Ao tentar deletar uma categoria de serviço pelo seu id o retorno deve ser 
  um valor booleano verdadeiro''',
    () async {
      bool isDeleted = await mockServiceCategoryRepository.deleteById(
        serviceCategory: serviceCartegory1,);

      expect(isDeleted, isTrue);
    },
  );
}

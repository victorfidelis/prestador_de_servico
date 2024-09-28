import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/sqflite_service_category_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group(
    'Testes referente a classe ProductRepositorySqflite. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      late SqfliteServiceCategoryRepository serviceCategoryRepository;
      late ServiceCategoryModel serviceCartegory1 = ServiceCategoryModel(
        id: '1',
        name: 'Cabelo',
      );
      late ServiceCategoryModel serviceCartegory2 = ServiceCategoryModel(
        id: '2',
        name: 'Depilação',
      );

      setUpAll(() async {
        sqfliteFfiInit();
        DatabaseFactory databaseFactory = databaseFactoryFfi;
        Database database =
            await databaseFactory.openDatabase(inMemoryDatabasePath);
        await SqfliteConfig().setupDatabase(database);

        serviceCategoryRepository =
            SqfliteServiceCategoryRepository(database: database);
      });

      tearDownAll(() {
        SqfliteConfig().disposeDatabase();
      });

      test(
          '''A primeira consulta de categorias de serviços deve retornar uma lista vazia''',
          () async {
        List<ServiceCategoryModel> serviceCategories =
            await serviceCategoryRepository.getAll();
        expect(serviceCategories.isEmpty, isTrue);
      });

      test(
          '''Ao adicionar uma categoria de serviço deve-se retornar o id da categoria 
      adicionada''', () async {
        String? serviceCategoryId = await serviceCategoryRepository.add(
            serviceCategory: serviceCartegory1);
        expect(serviceCategoryId != null, equals(true));
        expect(serviceCategoryId, equals(serviceCartegory1.id));
      });

      test(
        '''Após a adição, a consulta de categorias de serviço
         deve retornar uma lista com 1 categoria de serviço''',
        () async {
          List<ServiceCategoryModel> serviceCategories =
              await serviceCategoryRepository.getAll();
          expect(serviceCategories.length, equals(1));
          if (serviceCategories.length == 1) {
            expect(serviceCategories[0], equals(serviceCartegory1));
          }
        },
      );

      test(
        '''O update de uma categoria de serviço deve deve alterar a cateoria 
      em questão no banco de dados''',
        () async {
          serviceCartegory1 = serviceCartegory1.copyWith(name: 'Face');
          bool isUpdated = await serviceCategoryRepository.update(
            serviceCategory: serviceCartegory1,
          );

          expect(isUpdated, isTrue);
          List<ServiceCategoryModel> serviceCategories =
              await serviceCategoryRepository.getAll();
          expect(serviceCategories.length, equals(1));
          expect(serviceCategories[0], equals(serviceCartegory1));
        },
      );

      test(
        '''Após mais uma adição, a consulta de categprias de serviço
         deve retornar uma lista com 2 categorias de serviços''',
        () async {
          String? serviceCategoryId = await serviceCategoryRepository.add(
            serviceCategory: serviceCartegory2,
          );
          expect(serviceCategoryId, equals(serviceCartegory2.id));
          List<ServiceCategoryModel> serviceCartegories =
              await serviceCategoryRepository.getAll();
          expect(serviceCartegories.length, equals(2));
          expect(serviceCartegories[0], equals(serviceCartegory1));
          expect(serviceCartegories[1], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao consultar uma categoria se serviço pelo seu id a respectiva categorita 
        de serviço deve ser retornada''',
        () async {
          ServiceCategoryModel serviceCategory = await serviceCategoryRepository.getById(
            id: serviceCartegory1.id,
          );
          expect(serviceCategory, equals(serviceCartegory1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "fac", deve retornar apenas 
          1 categoria de serviço, sendo a serviceCategory1''',
        () async {
          List<ServiceCategoryModel> serviceCartegories =
              await serviceCategoryRepository.getNameContained(name: 'fac');
          expect(serviceCartegories.length, equals(1));
          expect(serviceCartegories[0], equals(serviceCartegory1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "depilaç", deve retornar apenas 
          1 categoria de serviço, sendo a serviceCategory2''',
        () async {
          List<ServiceCategoryModel> serviceCartegories =
              await serviceCategoryRepository.getNameContained(name: 'depilaç');
          expect(serviceCartegories.length, equals(1));
          expect(serviceCartegories[0], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "a", deve retornar 2 categorias de 
        serviço, a primeira sendo a serviceCategory1 e a segunda a serviceCategory2''',
        () async {
          List<ServiceCategoryModel> serviceCartegories =
              await serviceCategoryRepository.getNameContained(name: 'a');
          expect(serviceCartegories.length, equals(2));
          expect(serviceCartegories[0], equals(serviceCartegory1));
          expect(serviceCartegories[1], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "cabelo", não deve retornar
        nenhuma categoria de serviço''',
        () async {
          List<ServiceCategoryModel> serviceCartegories =
              await serviceCategoryRepository.getNameContained(
            name: 'cabelo',
          );
          expect(serviceCartegories.length, equals(0));
        },
      );

      test(
        '''Após deletar uma categoria de serviço, a consulta de categorias de serviço
        não deve retornar a mesma''',
        () async {
          bool isDeleted = await serviceCategoryRepository.deleteById(id: serviceCartegory1.id);
          expect(isDeleted, isTrue);
          List<ServiceCategoryModel> serviceCategories = await serviceCategoryRepository.getAll();
          expect(serviceCategories.length, equals(1));
          expect(serviceCategories[0], equals(serviceCartegory2));
        },
      );
    },
  );
}

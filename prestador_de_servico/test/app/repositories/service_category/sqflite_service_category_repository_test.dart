import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/sqflite_service_category_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group(
    'Testes referente a classe SqfliteServiceCategoryRepository. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      late SqfliteServiceCategoryRepository serviceCategoryRepository;
      late ServiceCategory serviceCartegory1 = ServiceCategory(
        id: '1',
        name: 'Cabelo',
      );
      late ServiceCategory serviceCartegory2 = ServiceCategory(
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
        List<ServiceCategory> serviceCategories =
            await serviceCategoryRepository.getAll();
        expect(serviceCategories.isEmpty, isTrue);
      });

      test(
          '''Ao adicionar uma categoria de serviço deve-se retornar o id da categoria 
      adicionada''', () async {
        String serviceCategoryId = await serviceCategoryRepository.insert(
            serviceCategory: serviceCartegory1);

        expect(serviceCategoryId, equals(serviceCartegory1.id));
      });

      test(
        '''Após a adição, a consulta de categorias de serviço
         deve retornar uma lista com 1 categoria de serviço''',
        () async {
          List<ServiceCategory> serviceCategories =
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
          await serviceCategoryRepository.update(
            serviceCategory: serviceCartegory1,
          );

          List<ServiceCategory> serviceCategories =
              await serviceCategoryRepository.getAll();
          expect(serviceCategories.length, equals(1));
          expect(serviceCategories[0], equals(serviceCartegory1));
        },
      );

      test(
        '''Após mais uma adição, a consulta de categprias de serviço
         deve retornar uma lista com 2 categorias de serviços''',
        () async {
          String serviceCategoryId = await serviceCategoryRepository.insert(
            serviceCategory: serviceCartegory2,
          );

          expect(serviceCategoryId, equals(serviceCartegory2.id));
          
          List<ServiceCategory> serviceCartegories =
              await serviceCategoryRepository.getAll();
          expect(serviceCartegories.length, equals(2));
          expect(serviceCartegories[0], equals(serviceCartegory1));
          expect(serviceCartegories[1], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao consultar uma categoria de serviço pelo seu id a respectiva categoria 
        de serviço deve ser retornada''',
        () async {
          ServiceCategory serviceCategory = await serviceCategoryRepository.getById(
            id: serviceCartegory1.id,
          );
          expect(serviceCategory, equals(serviceCartegory1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "fac", deve retornar apenas 
          1 categoria de serviço, sendo a serviceCategory1''',
        () async {
          List<ServiceCategory> serviceCartegories =
              await serviceCategoryRepository.getNameContained(name: 'fac');
          expect(serviceCartegories.length, equals(1));
          expect(serviceCartegories[0], equals(serviceCartegory1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "depilaç", deve retornar apenas 
          1 categoria de serviço, sendo a serviceCategory2''',
        () async {
          List<ServiceCategory> serviceCartegories =
              await serviceCategoryRepository.getNameContained(name: 'depilaç');
          expect(serviceCartegories.length, equals(1));
          expect(serviceCartegories[0], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "a", deve retornar 2 categorias de 
        serviço, a primeira sendo a serviceCategory1 e a segunda a serviceCategory2''',
        () async {
          List<ServiceCategory> serviceCartegories =
              await serviceCategoryRepository.getNameContained(name: 'a');
          expect(serviceCartegories.length, equals(2));
          expect(serviceCartegories[0], equals(serviceCartegory1));
          expect(serviceCartegories[1], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao efetuar uma busca por nome passando "cabelo", não deve retornar
        nenhuma categoria de serviço''',
        () async {
          List<ServiceCategory> serviceCartegories =
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
          await serviceCategoryRepository.deleteById(id: serviceCartegory1.id);

          List<ServiceCategory> serviceCategories = await serviceCategoryRepository.getAll();
          expect(serviceCategories.length, equals(1));
          expect(serviceCategories[0], equals(serviceCartegory2));
        },
      );
    },
  );
}

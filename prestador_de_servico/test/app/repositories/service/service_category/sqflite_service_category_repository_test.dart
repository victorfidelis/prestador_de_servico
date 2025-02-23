import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/sqflite_service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
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
        Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
        await SqfliteConfig().setupDatabase(database);

        serviceCategoryRepository = SqfliteServiceCategoryRepository(database: database);
      },);

      tearDownAll(() {
        SqfliteConfig().disposeDatabase();
      },);

      test('''A primeira consulta de categorias de serviços deve retornar uma lista vazia''', () async {
        final getEither = await serviceCategoryRepository.getAll();

        expect(getEither.isRight, isTrue);
        expect(getEither.right!.isEmpty, isTrue);
      },);

      test('''Ao adicionar uma categoria de serviço deve-se retornar o id da categoria 
      adicionada''', () async {
        final insertEither = await serviceCategoryRepository.insert(serviceCategory: serviceCartegory1);

        expect(insertEither.isRight, isTrue);
        expect(insertEither.right!, equals(serviceCartegory1.id));
      },);

      test(
        '''Após a adição, a consulta de categorias de serviço
         deve retornar uma lista com 1 categoria de serviço''',
        () async {
          final getEither = await serviceCategoryRepository.getAll();

          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(1));
          expect(getEither.right![0], equals(serviceCartegory1));
        },
      );

      test(
        '''O update de uma categoria de serviço deve deve alterar a cateoria 
      em questão no banco de dados''',
        () async {
          serviceCartegory1 = serviceCartegory1.copyWith(name: 'Face');
          await serviceCategoryRepository.update(
            serviceCategory: serviceCartegory1
          );

          final updateEither = await serviceCategoryRepository.getAll();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right!.length, equals(1));
          expect(updateEither.right![0], equals(serviceCartegory1));
        },
      );

      test(
        '''Após mais uma adição, a consulta de categprias de serviço
         deve retornar uma lista com 2 categorias de serviços''',
        () async {
          final insertEither = await serviceCategoryRepository.insert(
            serviceCategory: serviceCartegory2
          );

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right, equals(serviceCartegory2.id));

          final getEither = await serviceCategoryRepository.getAll();

          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(2));
          expect(getEither.right![0], equals(serviceCartegory1));
          expect(getEither.right![1], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao consultar uma categoria de serviço pelo seu id a respectiva categoria 
        de serviço deve ser retornada''',
        () async {
          final getEither = await serviceCategoryRepository.getById(
            id: serviceCartegory1.id
          );

          expect(getEither.isRight, isTrue);
          expect(getEither.right, equals(serviceCartegory1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "fac", deve retornar apenas 
          1 categoria de serviço, sendo a serviceCategory1''',
        () async {
          final getEither = await serviceCategoryRepository.getNameContained(name: 'fac');
          
          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(1));
          expect(getEither.right![0], equals(serviceCartegory1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "depilaç", deve retornar apenas 
          1 categoria de serviço, sendo a serviceCategory2''',
        () async {
          final getEither = await serviceCategoryRepository.getNameContained(name: 'depilaç');
          
          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(1));
          expect(getEither.right![0], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "a", deve retornar 2 categorias de 
        serviço, a primeira sendo a serviceCategory1 e a segunda a serviceCategory2''',
        () async {
          final getEither = await serviceCategoryRepository.getNameContained(name: 'a');
          
          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(2));
          expect(getEither.right![0], equals(serviceCartegory1));
          expect(getEither.right![1], equals(serviceCartegory2));
        },
      );

      test(
        '''Ao efetuar uma busca por nome passando "cabelo", não deve retornar
        nenhuma categoria de serviço''',
        () async {
          final getEither = await serviceCategoryRepository.getNameContained(
            name: 'cabelo'
          );
          
          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(0));
        },
      );

      test(
        '''Após deletar uma categoria de serviço, a consulta de categorias de serviço
        não deve retornar a mesma''',
        () async {
          await serviceCategoryRepository.deleteById(id: serviceCartegory1.id);

          final getEither = await serviceCategoryRepository.getAll();
          
          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(1));
          expect(getEither.right![0], equals(serviceCartegory2));
        },
      );
    },
  );
}

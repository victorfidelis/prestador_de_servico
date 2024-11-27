import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/repositories/service/service/sqflite_service_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group(
    'Testes referente a classe SqfliteServiceRepository. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      late SqfliteServiceRepository serviceRepository;
      late Service service1 = Service(
        id: '1',
        serviceCategoryId: '1',
        name: 'Luzes',
        price: 80.90,
        hours: 1,
        minutes: 30,
        imageUrl: 'image1.com.br/image1/jpg',
      );
      late Service service2 = Service(
        id: '2',
        serviceCategoryId: '1',
        name: 'Escova',
        price: 80.90,
        hours: 1,
        minutes: 30,
        imageUrl: 'image1.com.br/image2/jpg',
      );
      late Service service3 = Service(
        id: '3',
        serviceCategoryId: '2',
        name: 'Massagem',
        price: 80.90,
        hours: 1,
        minutes: 30,
        imageUrl: 'image1.com.br/image3/jpg',
      );

      setUpAll(() async {
        sqfliteFfiInit();
        DatabaseFactory databaseFactory = databaseFactoryFfi;
        Database database =
            await databaseFactory.openDatabase(inMemoryDatabasePath);
        await SqfliteConfig().setupDatabase(database);

        serviceRepository = SqfliteServiceRepository(database: database);
      });

      tearDownAll(() {
        SqfliteConfig().disposeDatabase();
      });

      test(
        '''A primeira consulta de serviços deve retornar uma lista vazia''',
        () async {
          final getAllEither = await serviceRepository.getAll();
          
          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao adicionar um serviço deve-se retornar o id do serviço 
      adicionado''',
        () async {
          final insertEither = await serviceRepository.insert(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right, equals(service1.id));
        },
      );

      test(
        '''Após a adição, a consulta de serviço
         deve retornar uma lista com 1 serviço''',
        () async {
          final getAllEither = await serviceRepository.getAll();

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, equals(1));
          expect(getAllEither.right![0], equals(service1));
        },
      );

      test(
        '''O update de um serviço deve deve alterar o serviço 
      em questão no banco de dados''',
        () async {
          service1 = service1.copyWith(name: 'Luzes cabelo curto');
          final updateEither = await serviceRepository.update(service: service1);
          
          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);

          final getAllEither = await serviceRepository.getAll();
          
          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, equals(1));
          expect(getAllEither.right![0], equals(service1));
        },
      );

      test(
        '''Após mais uma adição, a consulta de serviços
         deve retornar uma lista com 2 serviços''',
        () async {
          final insertEither = await serviceRepository.insert(service: service2);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right, equals(service2.id));
          
          final getAllEither = await serviceRepository.getAll();
          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, equals(2));
          expect(getAllEither.right![0], equals(service1));
          expect(getAllEither.right![1], equals(service2));
        },
      );

      test(
        '''Após mais uma adição, a consulta de serviços
         deve retornar uma lista com 3 serviços''',
        () async {
          final insertEither = await serviceRepository.insert(service: service3);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right, equals(service3.id));
          
          final getAllEither = await serviceRepository.getAll();

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, equals(3));
          expect(getAllEither.right![0], equals(service1));
          expect(getAllEither.right![1], equals(service2));
          expect(getAllEither.right![2], equals(service3));
        },
      );

      test(
        '''Ao consultar serviços pelo id de sua categoria, os serviços 
        referente a esta categoria deverão ser retornados, 
        neste caso, os serviços da categoria 1''',
        () async {
          final getByEither = await serviceRepository.getByServiceCategoryId(serviceCategoryId: '1');
          
          expect(getByEither.isRight, isTrue);
          expect(getByEither.right!.length, equals(2));
          expect(getByEither.right![0], equals(service1));
          expect(getByEither.right![1], equals(service2));
        },
      );
      
      test(
        '''Ao consultar serviços pelo id de sua categoria, os serviços 
        referente a esta categoria deverão ser retornados, 
        neste caso, os serviços da categoria 2''',
        () async {
          final getByEither = await serviceRepository.getByServiceCategoryId(serviceCategoryId: '2');
          
          expect(getByEither.isRight, isTrue);
          expect(getByEither.right!.length, equals(1));
          expect(getByEither.right![0], equals(service3));
        },
      );

      test(
        '''Ao consultar um serviço pelo seu id o respectivo 
        serviço deve ser retornado''',
        () async {
          final getByEither = await serviceRepository.getById(id: service1.id);
          
          expect(getByEither.isRight, isTrue);
          expect(getByEither.right, equals(service1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "curto", deve retornar apenas 
          1 serviço, sendo o service1''',
        () async {
          final getNameEither = await serviceRepository.getNameContained(name: 'curto');
          
          expect(getNameEither.isRight, isTrue);
          expect(getNameEither.right!.length, equals(1));
          expect(getNameEither.right![0], equals(service1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "escov", deve retornar apenas 
          1 serviço, sendo o service2''',
        () async {
          final getNameEither = await serviceRepository.getNameContained(name: 'escov');
              
          expect(getNameEither.isRight, isTrue);
          expect(getNameEither.right!.length, equals(1));
          expect(getNameEither.right![0], equals(service2));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "e", deve retornar 3  
        serviços, o primeiro sendo a service1, o segundo o service2 e o 
        terceiro o service3''',
        () async {
          final getNameEither = await serviceRepository.getNameContained(name: 'e');
          
          expect(getNameEither.isRight, isTrue);
          expect(getNameEither.right!.length, equals(3));
          expect(getNameEither.right![0], equals(service1));
          expect(getNameEither.right![1], equals(service2));
          expect(getNameEither.right![2], equals(service3));
        },
      );

      test(
        '''Ao efetuar uma busca por nome passando "manicure", não deve retornar
        nenhum serviço''',
        () async {
          final getNameEither = await serviceRepository.getNameContained(name: 'manicure');
          
          expect(getNameEither.isRight, isTrue);
          expect(getNameEither.right!.length, equals(0));
        },
      );

      test(
        '''Após deletar um serviço, a consulta de serviço
        não deve retornar o mesmo''',
        () async {
          await serviceRepository.deleteById(id: service1.id);

          final getAllEither = await serviceRepository.getAll();
          
          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, equals(2));
          expect(getAllEither.right![0], equals(service2));
          expect(getAllEither.right![1], equals(service3));
        },
      );

      test(
        '''Após deletar um serviço, a verificação se o mesmo existe deve retornar false''',
        () async {
          final existsEither = await serviceRepository.existsById(id: service1.id);

          expect(existsEither.isRight, isTrue);
          expect(existsEither.right, isFalse);
        },
      );

      test(
        '''A verificação de um serviço que existe deve retornar true''',
        () async {
          final existsEither = await serviceRepository.existsById(id: service2.id);

          expect(existsEither.isRight, isTrue);
          expect(existsEither.right, isTrue);
        },
      );
    },
  );
}

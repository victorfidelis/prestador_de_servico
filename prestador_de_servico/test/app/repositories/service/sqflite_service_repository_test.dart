import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/repositories/service/sqflite_service_repository.dart';
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
        urlImage: 'image1.com.br/image1/jpg',
      );
      late Service service2 = Service(
        id: '2',
        serviceCategoryId: '1',
        name: 'Escova',
        price: 80.90,
        hours: 1,
        minutes: 30,
        urlImage: 'image1.com.br/image2/jpg',
      );
      late Service service3 = Service(
        id: '3',
        serviceCategoryId: '2',
        name: 'Massagem',
        price: 80.90,
        hours: 1,
        minutes: 30,
        urlImage: 'image1.com.br/image3/jpg',
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
          List<Service> services = await serviceRepository.getAll();
          expect(services.isEmpty, isTrue);
        },
      );

      test(
        '''Ao adicionar um serviço deve-se retornar o id do serviço 
      adicionado''',
        () async {
          String serviceCategoryId =
              await serviceRepository.insert(service: service1);

          expect(serviceCategoryId, equals(service1.id));
        },
      );

      test(
        '''Após a adição, a consulta de serviço
         deve retornar uma lista com 1 serviço''',
        () async {
          List<Service> services =
              await serviceRepository.getAll();
          expect(services.length, equals(1));
          if (services.length == 1) {
            expect(services[0], equals(service1));
          }
        },
      );

      test(
        '''O update de um serviço deve deve alterar o serviço 
      em questão no banco de dados''',
        () async {
          service1 = service1.copyWith(name: 'Luzes cabelo curto');
          await serviceRepository.update(
            service: service1,
          );

          List<Service> services =
              await serviceRepository.getAll();
          expect(services.length, equals(1));
          expect(services[0], equals(service1));
        },
      );

      test(
        '''Após mais uma adição, a consulta de serviços
         deve retornar uma lista com 2 serviços''',
        () async {
          String serviceId = await serviceRepository.insert(
            service: service2,
          );

          expect(serviceId, equals(service2.id));
          
          List<Service> services =
              await serviceRepository.getAll();
          expect(services.length, equals(2));
          expect(services[0], equals(service1));
          expect(services[1], equals(service2));
        },
      );

      test(
        '''Após mais uma adição, a consulta de serviços
         deve retornar uma lista com 3 serviços''',
        () async {
          String serviceId = await serviceRepository.insert(
            service: service3,
          );

          expect(serviceId, equals(service3.id));
          
          List<Service> services =
              await serviceRepository.getAll();
          expect(services.length, equals(3));
          expect(services[0], equals(service1));
          expect(services[1], equals(service2));
          expect(services[2], equals(service3));
        },
      );

      test(
        '''Ao consultar serviços pelo id de sua categoria, os serviços 
        referente a esta categoria deverão ser retornados, 
        neste caso, os serviços da categoria 1''',
        () async {
          List<Service> services = await serviceRepository.getByServiceCategoryId(
            serviceCategoryId: '1',
          );
          expect(services.length, equals(2));
          expect(services[0], equals(service1));
          expect(services[1], equals(service2));
        },
      );
      
      test(
        '''Ao consultar serviços pelo id de sua categoria, os serviços 
        referente a esta categoria deverão ser retornados, 
        neste caso, os serviços da categoria 2''',
        () async {
          List<Service> services = await serviceRepository.getByServiceCategoryId(
            serviceCategoryId: '2',
          );
          expect(services.length, equals(1));
          expect(services[0], equals(service3));
        },
      );

      test(
        '''Ao consultar um serviço pelo seu id o respectivo 
        serviço deve ser retornado''',
        () async {
          Service service = await serviceRepository.getById(
            id: service1.id,
          );
          expect(service, equals(service1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "curto", deve retornar apenas 
          1 serviço, sendo o service1''',
        () async {
          List<Service> services =
              await serviceRepository.getNameContained(name: 'curto');
          expect(services.length, equals(1));
          expect(services[0], equals(service1));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "escov", deve retornar apenas 
          1 serviço, sendo o service2''',
        () async {
          List<Service> services =
              await serviceRepository.getNameContained(name: 'escov');
          expect(services.length, equals(1));
          expect(services[0], equals(service2));
        },
      );

      test(
        '''Ao efetuar uma busca de por nome passando "e", deve retornar 3  
        serviços, o primeiro sendo a service1, o segundo o service2 e o 
        terceiro o service3''',
        () async {
          List<Service> services =
              await serviceRepository.getNameContained(name: 'e');
          expect(services.length, equals(3));
          expect(services[0], equals(service1));
          expect(services[1], equals(service2));
          expect(services[2], equals(service3));
        },
      );

      test(
        '''Ao efetuar uma busca por nome passando "manicure", não deve retornar
        nenhum serviço''',
        () async {
          List<Service> services =
              await serviceRepository.getNameContained(
            name: 'manicure',
          );
          expect(services.length, equals(0));
        },
      );

      test(
        '''Após deletar um serviço, a consulta de serviço
        não deve retornar o mesmo''',
        () async {
          await serviceRepository.deleteById(id: service1.id);

          List<Service> services = await serviceRepository.getAll();
          expect(services.length, equals(2));
          expect(services[0], equals(service2));
          expect(services[1], equals(service3));
        },
      );

      test(
        '''Após deletar um serviço, a verificação se o mesmo existe deve retornar false''',
        () async {
          bool exists = await serviceRepository.existsById(id: service1.id);

          expect(exists, isFalse);
        },
      );

      test(
        '''A verificação de um serviço que existe deve retornar true''',
        () async {
          bool exists = await serviceRepository.existsById(id: service2.id);

          expect(exists, isTrue);
        },
      );
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/repositories/service/service/sqflite_service_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/sqflite_service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/sqflite_services_by_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late SqfliteServiceRepository serviceRepository;
  late SqfliteServiceCategoryRepository serviceCategoryRepository;
  late SqfliteServicesByCategoryRepository servicesByCategoryRepository;

  late ServiceCategory serviceCategory1;
  late ServiceCategory serviceCategory2;

  late Service service1;
  late Service service2;
  late Service service3;

  late List<ServicesByCategory> servicesByCategories;

  setUpValues() {
    serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');
    serviceCategory2 = ServiceCategory(id: '2', name: 'Corpo');

    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 80.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'image1.com.br/image1/jpg',
    );
    service2 = Service(
      id: '2',
      serviceCategoryId: '1',
      name: 'Escova',
      price: 80.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'image1.com.br/image2/jpg',
    );
    service3 = Service(
      id: '3',
      serviceCategoryId: '2',
      name: 'Massagem',
      price: 80.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'image1.com.br/image3/jpg',
    );

    final servicesByCategory1 = ServicesByCategory(
      serviceCategory: serviceCategory1,
      services: [service1, service2],
    );

    final servicesByCategory2 = ServicesByCategory(
      serviceCategory: serviceCategory2,
      services: [service3],
    );

    servicesByCategories = [servicesByCategory1, servicesByCategory2];
  }

  insertData() async {
    await serviceCategoryRepository.insert(serviceCategory: serviceCategory1);
    await serviceCategoryRepository.insert(serviceCategory: serviceCategory2);

    await serviceRepository.insert(service: service1);
    await serviceRepository.insert(service: service2);
    await serviceRepository.insert(service: service3);
  }

  setUp(() async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await SqfliteConfig().setupDatabase(database);

    serviceRepository = SqfliteServiceRepository(database: database);
    serviceCategoryRepository = SqfliteServiceCategoryRepository(database: database);
    servicesByCategoryRepository = SqfliteServicesByCategoryRepository(database: database);

    setUpValues();
    await insertData();
  });

  tearDown(() {
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    databaseFactory.deleteDatabase(inMemoryDatabasePath);
    SqfliteConfig().disposeDatabase();
  });

  group(
    '''Testes referente a classe SqfliteServiceRepository.''',
    () {
      test(
        '''Ao executar o getAll uma lista de ServicesByCategory deve ser retornada''',
        () async {
          final getAllEither = await servicesByCategoryRepository.getAll();

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, servicesByCategories.length);

          expect(getAllEither.right![0].serviceCategory, equals(servicesByCategories[0].serviceCategory));
          expect(getAllEither.right![0].services.length, equals(servicesByCategories[0].services.length));
       
          expect(getAllEither.right![1].serviceCategory, equals(servicesByCategories[1].serviceCategory));
          expect(getAllEither.right![1].services.length, equals(servicesByCategories[1].services.length));
        },
      );

      test(
        '''Ao executar o getByContainedName com um nome sem nenhum corresponência uma lista 
        vazia de ServicesByCategory deve ser retornada''',
        () async {
          final getAllEither = await servicesByCategoryRepository.getByContainedName('teste sem resultado');

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.isEmpty, isTrue);
        },
      );

      test(
        '''Ao executar o getByContainedName uma lista de ServicesByCategory deve ser 
        retornada''',
        () async {
          const numberOfServicesByCategory = 1;
          const numberOfServices = 1;
          final getAllEither = await servicesByCategoryRepository.getByContainedName('luz');

          expect(getAllEither.isRight, isTrue);
          expect(getAllEither.right!.length, numberOfServicesByCategory);

          expect(getAllEither.right![0].serviceCategory, equals(serviceCategory1));
          expect(getAllEither.right![0].services.length, equals(numberOfServices));
          expect(getAllEither.right![0].services[0], equals(service1));
       },
      );
    },
  );
}

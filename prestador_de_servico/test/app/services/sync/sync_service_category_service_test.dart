import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class MockSyncRepository extends Mock implements SyncRepository {}

class MockServiceCategoryRepository extends Mock implements ServiceCategoryRepository {}

void main() {
  final mockSyncRepository = MockSyncRepository();
  final offlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final syncServiceCategoryService = SyncServiceCategoryService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockServiceCategoryRepository,
    onlineRepository: onlineMockServiceCategoryRepository,
  );

  late Sync syncEmpty;
  late Sync syncServiceCategory;

  late ServiceCategory serviceCategory1;
  late ServiceCategory serviceCategory2;
  late ServiceCategory serviceCategory3;
  late ServiceCategory serviceCategory4;
  late ServiceCategory serviceCategory5Deleted;

  late ServiceCategory serviceCategoryLowestDate;
  late ServiceCategory serviceCategoryIntermediateDate;
  late ServiceCategory serviceCategoryBiggestDate;

  late List<ServiceCategory> serviceCategoriesGetAll;
  late List<ServiceCategory> serviceCategoriesGetSync;
  late List<ServiceCategory> serviceCategoriesGetHasDate;

  setUpValues() {
    syncEmpty = Sync();
    syncServiceCategory = Sync(dateSyncServiceCategory: DateTime(2024, 10, 10));

    serviceCategory1 = ServiceCategory(id: '1', name: 'Cabelo');
    serviceCategory2 = ServiceCategory(id: '2', name: 'Manicure');
    serviceCategory3 = ServiceCategory(id: '3', name: 'Pedicure');
    serviceCategory4 = ServiceCategory(id: '4', name: 'Luzes');
    serviceCategory5Deleted = ServiceCategory(id: '4', name: 'Luzes', isDeleted: true);

    serviceCategoryLowestDate =
        ServiceCategory(id: '1', name: 'Cabelo', syncDate: DateTime(2024, 11, 5));
    serviceCategoryIntermediateDate =
        ServiceCategory(id: '2', name: 'Manicure', syncDate: DateTime(2024, 11, 10));
    serviceCategoryBiggestDate =
        ServiceCategory(id: '3', name: 'Pedicure', syncDate: DateTime(2024, 11, 15));

    serviceCategoriesGetAll = [
      serviceCategory1,
      serviceCategory2,
      serviceCategory3,
      serviceCategory4,
      serviceCategory5Deleted,
    ];

    serviceCategoriesGetSync = [
      serviceCategory3,
      serviceCategory4,
    ];

    serviceCategoriesGetHasDate = [
      serviceCategoryLowestDate,
      serviceCategoryIntermediateDate,
      serviceCategoryBiggestDate,
    ];
  }

  setUp(
    () {
      setUpValues();
      registerFallbackValue(syncEmpty);
      registerFallbackValue(serviceCategory1);
    },
  );

  group(
    'loadSyncInfo',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.get())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final loadEither = await syncServiceCategoryService.loadSyncInfo();

          expect(loadEither.isLeft, isTrue);
          expect(loadEither.left is GetDatabaseFailure, isTrue);
          final state = (loadEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" sem dados em "dateSyncServiceCategories"
        quando não houver sincronizações de ServiceCategory anteriores''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncEmpty));

          final loadEither = await syncServiceCategoryService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncServiceCategoryService.sync.dateSyncServiceCategory, isNull);
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" com dados em "dateSyncServiceCategories"
        quando houver sincronizações de ServiceCategory anteriores''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncServiceCategory));

          final loadEither = await syncServiceCategoryService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncServiceCategoryService.sync.dateSyncServiceCategory,
              equals(syncServiceCategory.dateSyncServiceCategory));
        },
      );
    },
  );

  group(
    'loadUnsynced',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e não tiver 
        sincronização de ServiceCategory anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncServiceCategoryService.sync = syncEmpty;
          when(() => onlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncServiceCategoryService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e tiver 
        sincronização de ServiceCategory anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncServiceCategoryService.sync = syncServiceCategory;
          when(() => onlineMockServiceCategoryRepository.getUnsync(
                  dateLastSync: syncServiceCategory.dateSyncServiceCategory!))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncServiceCategoryService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "serviceCategoriesToSync" com todos os
        ServiceCategory cadastrados quando não tiver sincronização de ServiceCategory 
        anterior''',
        () async {
          syncServiceCategoryService.sync = syncEmpty;
          when(() => onlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceCategoriesGetAll));

          final loadUnsyncedEither = await syncServiceCategoryService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncServiceCategoryService.serviceCategoriesToSync.length,
            equals(serviceCategoriesGetAll.length),
          );
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "serviceCategoriesToSync" com os 
        ServiceCategory que precisam ser sincronizados quando tiver alguma sincronização 
        de ServiceCategory anterior''',
        () async {
          syncServiceCategoryService.sync = syncServiceCategory;
          when(() => onlineMockServiceCategoryRepository.getUnsync(
                  dateLastSync: syncServiceCategory.dateSyncServiceCategory!))
              .thenAnswer((_) async => Either.right(serviceCategoriesGetSync));

          final loadUnsyncedEither = await syncServiceCategoryService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncServiceCategoryService.serviceCategoriesToSync.length,
            equals(serviceCategoriesGetSync.length),
          );
        },
      );
    },
  );

  group(
    'syncServiceCategory',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline na 
        verificação da existência do ServiceCategory''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceCategoryRepository.existsById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        inserção do ServiceCategory''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceCategoryRepository.existsById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        alteração do ServiceCategory''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceCategoryRepository.existsById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        exclusão do ServiceCategory''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceCategoryRepository.deleteById(id: serviceCategory5Deleted.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory5Deleted);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de um ServiceCategory for feita com sucesso''',
        () async {
          when(() => offlineMockServiceCategoryRepository.existsById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(serviceCategory1.id));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a alteração de um ServiceCategory for feita com sucesso''',
        () async {
          when(() => offlineMockServiceCategoryRepository.existsById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory1))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a exclusão de um ServiceCategory for feitas com sucesso''',
        () async {
          when(() => offlineMockServiceCategoryRepository.deleteById(id: serviceCategory5Deleted.id))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither =
              await syncServiceCategoryService.syncServiceCategory(serviceCategory5Deleted);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'syncUnsynced',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer algum erro no banco offline''',
        () async {
          syncServiceCategoryService.serviceCategoriesToSync = serviceCategoriesGetAll;
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceCategoryRepository.existsById(id: serviceCategory1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (uncyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit''',
        () async {
          syncServiceCategoryService.serviceCategoriesToSync = serviceCategoriesGetAll;
          when(() => offlineMockServiceCategoryRepository.deleteById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockServiceCategoryRepository.insert(
                  serviceCategory: any(named: 'serviceCategory')))
              .thenAnswer((_) async => Either.right(serviceCategory1.id));
          when(() => offlineMockServiceCategoryRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceCategoryRepository.update(
                  serviceCategory: any(named: 'serviceCategory')))
              .thenAnswer((_) async => Either.right(unit));

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isRight, isTrue);
          expect(uncyncedEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'getMaxSyncDate',
    () {
      test(
        '''Deve retornar um erro quando o campo "serviceCategoriesToSync" estiver vazio''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [];

          expect(() => syncServiceCategoryService.getMaxSyncDate(), throwsA(isA<Error>()));
        },
      );

      test(
        '''Deve retornar a data de "serviceCategoryBiggestDate"''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
            serviceCategoryIntermediateDate,
            serviceCategoryBiggestDate,
          ];

          final maxSyncDate = syncServiceCategoryService.getMaxSyncDate();

          expect(maxSyncDate, serviceCategoryBiggestDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "serviceCategoryIntermediateDate"''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryIntermediateDate,
            serviceCategoryLowestDate,
          ];

          final maxSyncDate = syncServiceCategoryService.getMaxSyncDate();

          expect(maxSyncDate, serviceCategoryIntermediateDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "serviceCategoryLowestDate"''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
          ];

          final maxSyncDate = syncServiceCategoryService.getMaxSyncDate();

          expect(maxSyncDate, serviceCategoryLowestDate.syncDate);
        },
      );
    },
  );

  group(
    'updateSyncDate',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline ao 
        verificar a existência de sincronizações anteriores''',
        () async {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
            serviceCategoryIntermediateDate,
            serviceCategoryBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline ao 
        inserir uma data de sincronização''',
        () async {
          syncServiceCategoryService.sync = syncEmpty;
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
            serviceCategoryIntermediateDate,
            serviceCategoryBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(() => mockSyncRepository.insert(sync: any(named: 'sync')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline ao 
        alterar uma data de sincronização''',
        () async {
          syncServiceCategoryService.sync = syncEmpty;
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
            serviceCategoryIntermediateDate,
            serviceCategoryBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updateServiceCategory(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o serviceCategoriesToSync estiver vazio''',
        () async {
          syncServiceCategoryService.serviceCategoriesToSync = [];

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncServiceCategoryService.sync = syncEmpty;
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
            serviceCategoryIntermediateDate,
            serviceCategoryBiggestDate,
          ];

          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(() => mockSyncRepository.insert(sync: any(named: 'sync')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a atualização de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncServiceCategoryService.sync = syncEmpty;
          syncServiceCategoryService.serviceCategoriesToSync = [
            serviceCategoryLowestDate,
            serviceCategoryIntermediateDate,
            serviceCategoryBiggestDate,
          ];

          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updateServiceCategory(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'synchronize',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline 
        ao consultar os dados de sincronização''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.get())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is GetDatabaseFailure, isTrue);
          expect((syncEither.left as GetDatabaseFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet ao consultar os
        ServiceCategory a serem sincronizados''',
        () async {
          const failureMessage = '';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is NetworkFailure, isTrue);
          expect((syncEither.left as NetworkFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline ao 
        verificar se o ServiceCategory existe''',
        () async {
          const failureMessage = 'Falha syncUnsynced';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceCategoriesGetAll));
          when(() => offlineMockServiceCategoryRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline ao 
        verificar existe alguma sincronização anterior''',
        () async {
          const failureMessage = 'Falha updateSyncDate';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceCategoriesGetHasDate));
          when(() => offlineMockServiceCategoryRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceCategoryRepository.update(
                  serviceCategory: any(named: 'serviceCategory')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => mockSyncRepository.exists())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a sincronização for realizada com sucesso''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceCategoryRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceCategoriesGetHasDate));
          when(() => offlineMockServiceCategoryRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceCategoryRepository.update(
                  serviceCategory: any(named: 'serviceCategory')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updateServiceCategory(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right is Unit, isTrue);
        },
      );
    },
  );
}

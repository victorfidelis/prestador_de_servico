import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service/service/mock_service_repository.dart';
import '../../../helpers/sync/mock_sync_repository.dart';

void main() {
  late SyncServiceService syncServiceService;

  late Sync syncEmpty;
  late Sync syncService;

  late Service service1;
  late Service service2;
  late Service service3;
  late Service service4;
  late Service service5Deleted;
  
  late Service serviceLowestDate;
  late Service serviceIntermediateDate;
  late Service serviceBiggestDate;
  
  late List<Service> servicesGetAll;
  late List<Service> servicesGetSync;
  late List<Service> servicesGetHasDate;

  void setUpValues() {
    syncEmpty = Sync();
    syncService = Sync(dateSyncService: DateTime(2024, 10, 10));

    service1 = Service(id: '1', serviceCategoryId: '1', name: 'Luzes', price: 80, hours: 1, minutes: 15, imageUrl: 'imageurlluzes.jpg');
    service2 = Service(id: '2', serviceCategoryId: '1', name: 'Chapinha', price: 40, hours: 0, minutes: 35, imageUrl: 'imageurlchapinha.jpg');
    service3 = Service(id: '3', serviceCategoryId: '1', name: 'Escova', price: 40, hours: 0, minutes: 45, imageUrl: 'imageurlescova.jpg');
    service4 = Service(id: '4', serviceCategoryId: '1', name: 'Platinado', price: 50, hours: 1, minutes: 40, imageUrl: 'imageurlplatinado.jpg');
    service5Deleted = Service(id: '4', serviceCategoryId: '1', name: 'Degradê', price: 30, hours: 0, minutes: 45, imageUrl: 'imageurldegrade.jpg', isDeleted: true);
  
    serviceLowestDate = Service(id: '1', serviceCategoryId: '1', name: 'Luzes', price: 80, hours: 1, minutes: 15, imageUrl: 'imageurlluzes.jpg', syncDate: DateTime(2024, 11, 5));
    serviceIntermediateDate = Service(id: '2', serviceCategoryId: '1', name: 'Chapinha', price: 40, hours: 0, minutes: 35, imageUrl: 'imageurlchapinha.jpg', syncDate: DateTime(2024, 11, 10));
    serviceBiggestDate = Service(id: '3', serviceCategoryId: '1', name: 'Escova', price: 40, hours: 0, minutes: 45, imageUrl: 'imageurlescova.jpg', syncDate: DateTime(2024, 11, 15));
    
    servicesGetAll = [
      service1,
      service2,
      service3,
      service4,
      service5Deleted,
    ];

    servicesGetSync = [
      service3,
      service4,
    ];

    servicesGetHasDate = [
      serviceLowestDate,
      serviceIntermediateDate,
      serviceBiggestDate,
    ];
  }

  setUp(() {
      setUpMockSyncRepository();
      setUpMockServiceRepository();
      syncServiceService = SyncServiceService(
        syncRepository: mockSyncRepository,
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
      );
      setUpValues();
    },
  );

  group(
    'loadSyncInfo',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final loadEither = await syncServiceService.loadSyncInfo();

          expect(loadEither.isLeft, isTrue);
          expect(loadEither.left is GetDatabaseFailure, isTrue);
          final state = (loadEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" sem dados em "dateSyncServices"
        quando não houver sincronizações de ServiceCategory anteriores''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncEmpty));

          final loadEither = await syncServiceService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncServiceService.sync.dateSyncService, isNull);
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" com dados em "dateSyncServices"
        quando houver sincronizações de Service anteriores''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncService));

          final loadEither = await syncServiceService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncServiceService.sync.dateSyncService,
              equals(syncService.dateSyncService));
        },
      );
    },
  );

  group(
    'loadUnsynced',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e não tiver 
        sincronização de Service anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncServiceService.sync = syncEmpty;
          when(onlineMockServiceRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncServiceService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e tiver 
        sincronização de Service anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncServiceService.sync = syncService;
          when(onlineMockServiceRepository.getUnsync(
                  dateLastSync: syncService.dateSyncService))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncServiceService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "servicesToSync" com todos os
        Service cadastrados quando não tiver sincronização de Service anterior''',
        () async {
          syncServiceService.sync = syncEmpty;
          when(onlineMockServiceRepository.getAll())
              .thenAnswer((_) async => Either.right(servicesGetAll));

          final loadUnsyncedEither = await syncServiceService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncServiceService.servicesToSync.length,
            equals(servicesGetAll.length),
          );
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "servicesToSync" com os 
        Service que precisam ser sincronizados quando tiver alguma sincronização 
        de Service anterior''',
        () async {
          syncServiceService.sync = syncService;
          when(onlineMockServiceRepository.getUnsync(
                  dateLastSync: syncService.dateSyncService))
              .thenAnswer((_) async => Either.right(servicesGetSync));

          final loadUnsyncedEither = await syncServiceService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncServiceService.servicesToSync.length,
            equals(servicesGetSync.length),
          );
        },
      );
    },
  );

  group(
    'syncService',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline na 
        verificação da existência do Service''',
        () async {
          const failureMessage = 'Teste de falha';
          when(offlineMockServiceRepository.existsById(id: service1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceService.syncService(service1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        inserção do Service''',
        () async {
          const failureMessage = 'Teste de falha';
          when(offlineMockServiceRepository.existsById(id: service1.id))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceService.syncService(service1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        alteração do Service''',
        () async {
          const failureMessage = 'Teste de falha';
          when(offlineMockServiceRepository.existsById(id: service1.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceService.syncService(service1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        exclusão do Service''',
        () async {
          const failureMessage = 'Teste de falha';
          when(offlineMockServiceRepository.deleteById(id: service5Deleted.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceService.syncService(service5Deleted);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de um Service for feita com sucesso''',
        () async {
          when(offlineMockServiceRepository.existsById(id: service1.id))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));

          final unsyncedEither = await syncServiceService.syncService(service1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a alteração de um Service for feita com sucesso''',
        () async {
          when(offlineMockServiceRepository.existsById(id: service1.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncServiceService.syncService(service1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a exclusão de um Service for feitas com sucesso''',
        () async {
          when(offlineMockServiceRepository.deleteById(id: service5Deleted.id))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncServiceService.syncService(service5Deleted);

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
          syncServiceService.servicesToSync = servicesGetAll;
          const failureMessage = 'Teste de falha';
          when(offlineMockServiceRepository.existsById(id: service1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final uncyncedEither = await syncServiceService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (uncyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit''',
        () async {
          syncServiceService.servicesToSync = servicesGetAll;
          when(offlineMockServiceRepository.deleteById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceRepository.insert(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(service1.id));
          when(offlineMockServiceRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));

          final uncyncedEither = await syncServiceService.syncUnsynced();

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
        '''Deve retornar um erro quando o campo "servicesToSync" estiver vazio''',
        () {
          syncServiceService.servicesToSync = [];

          expect(() => syncServiceService.getMaxSyncDate(), throwsA(isA<Error>()));
        },
      );

      test(
        '''Deve retornar a data de "serviceBiggestDate"''',
        () {
          syncServiceService.servicesToSync = [
            serviceLowestDate,
            serviceIntermediateDate,
            serviceBiggestDate,
          ];

          final maxSyncDate = syncServiceService.getMaxSyncDate();

          expect(maxSyncDate, serviceBiggestDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "serviceIntermediateDate"''',
        () {
          syncServiceService.servicesToSync = [
            serviceIntermediateDate,
            serviceLowestDate,
          ];

          final maxSyncDate = syncServiceService.getMaxSyncDate();

          expect(maxSyncDate, serviceIntermediateDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "serviceLowestDate"''',
        () {
          syncServiceService.servicesToSync = [
            serviceLowestDate,
          ];

          final maxSyncDate = syncServiceService.getMaxSyncDate();

          expect(maxSyncDate, serviceLowestDate.syncDate);
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
          syncServiceService.servicesToSync = [
            serviceLowestDate,
            serviceIntermediateDate,
            serviceBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceService.updateSyncDate();

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
          syncServiceService.sync = syncEmpty;
          syncServiceService.servicesToSync = [
            serviceLowestDate,
            serviceIntermediateDate,
            serviceBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(mockSyncRepository.insert(sync: anyNamed('sync')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceService.updateSyncDate();

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
          syncServiceService.sync = syncEmpty;
          syncServiceService.servicesToSync = [
            serviceLowestDate,
            serviceIntermediateDate,
            serviceBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.updateService(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o servicesToSync estiver vazio''',
        () async {
          syncServiceService.servicesToSync = [];

          final updateEither = await syncServiceService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncServiceService.sync = syncEmpty;
          syncServiceService.servicesToSync = [
            serviceLowestDate,
            serviceIntermediateDate,
            serviceBiggestDate,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(mockSyncRepository.insert(sync: anyNamed('sync'))).thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a atualização de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncServiceService.sync = syncEmpty;
          syncServiceService.servicesToSync = [
            serviceLowestDate,
            serviceIntermediateDate,
            serviceBiggestDate,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.updateService(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceService.updateSyncDate();

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
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceService.synchronize();

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
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final syncEither = await syncServiceService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is NetworkFailure, isTrue);
          expect((syncEither.left as NetworkFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline ao 
        verificar se o Service existe''',
        () async {
          const failureMessage = 'Falha syncUnsynced';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceRepository.getAll()).thenAnswer((_) async => Either.right(servicesGetAll));
          when(offlineMockServiceRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceService.synchronize();

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
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceRepository.getAll()).thenAnswer((_) async => Either.right(servicesGetHasDate));
          when(offlineMockServiceRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a sincronização for realizada com sucesso''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceRepository.getAll()).thenAnswer((_) async => Either.right(servicesGetHasDate));
          when(offlineMockServiceRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceRepository.update(service: anyNamed('service')))
              .thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.updateService(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final syncEither = await syncServiceService.synchronize();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right is Unit, isTrue);
        },
      );
    },
  );
}
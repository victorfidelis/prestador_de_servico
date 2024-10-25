import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/constants/sync_constants.dart';
import '../../../helpers/service_category/mock_service_category_repository.dart';
import '../../../helpers/sync/mock_sync_repository.dart';

void main() {
  late SyncServiceCategoryService syncServiceCategoryService;

  setUp(
    () {
      setUpMockSyncRepository();
      setUpMockServiceCategoryRepository();
      syncServiceCategoryService = SyncServiceCategoryService(
        syncRepository: mockSyncRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
        onlineRepository: onlineMockServiceCategoryRepository,
      );
    },
  );

  group(
    'Testes do método loadSyncInfo',
    () {
      test(
        '''Ao consultar executar o loadSyncInfo, retornar um Failure''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure('Erro de teste')));

          final loadEither = await syncServiceCategoryService.loadSyncInfo();

          expect(loadEither.isLeft, isTrue);
          expect(loadEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao consultar executar o loadSyncInfo, alterar o campo sync do 
    syncService para o dado que retornar do repository. Neste caso, retornar
    um sync vazio''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(emptySync));

          await syncServiceCategoryService.loadSyncInfo();

          expect(syncServiceCategoryService.sync, equals(emptySync));
        },
      );

      test(
        '''Ao consultar executar o loadSyncInfo, alterar o campo sync do 
    syncService para o dado que retornar do repository. Neste caso, retornar 
    um sync com data de sincronização do ServiceCategory''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncServiceCategoryData));

          await syncServiceCategoryService.loadSyncInfo();

          expect(syncServiceCategoryService.sync, equals(syncServiceCategoryData));
        },
      );

      test(
        '''Ao consultar executar o loadSyncInfo, alterar o campo sync do 
    syncService para o dado que retornar do repository. Neste caso, retornar 
    um sync com data de sincronização do Service''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncServiceData));

          await syncServiceCategoryService.loadSyncInfo();

          expect(syncServiceCategoryService.sync, equals(syncServiceData));
        },
      );

      test(
        '''Ao consultar executar o loadSyncInfo, alterar o campo sync do 
    syncService para o dado que retornar do repository. Neste caso, retornar 
    um sync com todas as datas''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncBothData));

          await syncServiceCategoryService.loadSyncInfo();

          expect(syncServiceCategoryService.sync, equals(syncBothData));
        },
      );
    },
  );

  group(
    'Teste do método loadUnsynced',
    () {
      test(
        '''Ao consultar executar o loadUnsynced, retornar um Failure''',
        () async {
          syncServiceCategoryService.sync = emptySync;
          syncServiceCategoryService.serviceCategoriesToSync = [];
          when(offlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          final unsyncedEither = await syncServiceCategoryService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao consultar executar o loadUnsynced, carregar a lista serviceCategoriesToSync
        com todos os ServicesCategories''',
        () async {
          syncServiceCategoryService.sync = emptySync;
          syncServiceCategoryService.serviceCategoriesToSync = [];
          when(offlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serCatGetAll));

          await syncServiceCategoryService.loadUnsynced();

          expect(syncServiceCategoryService.serviceCategoriesToSync.isNotEmpty, isTrue);
        },
      );

      test(
        '''Ao consultar executar o loadUnsynced, retornar um Failure''',
        () async {
          syncServiceCategoryService.sync = syncServiceCategoryData;
          syncServiceCategoryService.serviceCategoriesToSync = [];
          when(onlineMockServiceCategoryRepository.getUnsync(dateLastSync: syncServiceCategoryData.dateSyncServiceCategories))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          final uncyncedEither = await syncServiceCategoryService.loadUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao consultar executar o loadUnsynced, carregar a lista serviceCategoriesToSync
        com apenas os dados alterados após a data da última sincronização''',
        () async {
          syncServiceCategoryService.sync = syncServiceCategoryData;
          syncServiceCategoryService.serviceCategoriesToSync = [];
          when(onlineMockServiceCategoryRepository.getUnsync(dateLastSync: anyNamed('dateLastSync')))
              .thenAnswer((_) async => Either.right(serCatGetUnsync));

          await syncServiceCategoryService.loadUnsynced();

          expect(syncServiceCategoryService.serviceCategoriesToSync.isNotEmpty, isTrue);
        },
      );
    },
  );

  group(
    'Testes do método syncServiceCategory',
    () {
      test(
        '''Ao executar o syncServiceCategory para deletar um ServiceCategory,
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatIsDeleted);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncServiceCategory para inserir um ServiceCategory, 
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatGeneric))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatGeneric.id))
              .thenAnswer((_) async => Either.right(false));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatGeneric);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncServiceCategory para alterar um ServiceCategory, 
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatGeneric))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatGeneric.id))
              .thenAnswer((_) async => Either.right(true));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatGeneric);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncServiceCategory, 
        retornar um Failure devido a um erro no existsById''',
        () async {
          when(offlineMockServiceCategoryRepository.existsById(id: serCatGeneric.id))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatGeneric);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncServiceCategory para deletar um ServiceCategory,
        retornar um Unit''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatIsDeleted);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Ao executar o syncServiceCategory para inserir um ServiceCategory,
        retornar um Unit''',
        () async {
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatGeneric))
              .thenAnswer((_) async => Either.right(serCatGeneric.id));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatGeneric.id))
              .thenAnswer((_) async => Either.right(false));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatGeneric);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Ao executar o syncServiceCategory para alterar um ServiceCategory,
        retornar um Unit''',
        () async {
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatGeneric))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatGeneric.id))
              .thenAnswer((_) async => Either.right(true));

          final unsyncedEither = await syncServiceCategoryService.syncServiceCategory(serCatGeneric);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'Testes do método syncUnsynced',
    () {
      test(
        '''Ao executar o syncUnsynced e um erro ocorrer em deleteById, 
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatInsert.id))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatInsert))
              .thenAnswer((_) async => Either.right(serCatInsert.id));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatUpdate.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatUpdate))
              .thenAnswer((_) async => Either.right(unit));

          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatIsDeleted,
            serCatInsert,
            serCatUpdate,
          ];

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncUnsynced e um erro ocorrer em insert, 
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatInsert.id))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatInsert))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatUpdate.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatUpdate))
              .thenAnswer((_) async => Either.right(unit));

          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatIsDeleted,
            serCatInsert,
            serCatUpdate,
          ];

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncUnsynced e um erro ocorrer em update, 
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatInsert.id))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatInsert))
              .thenAnswer((_) async => Either.right(serCatInsert.id));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatUpdate.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatUpdate))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatIsDeleted,
            serCatInsert,
            serCatUpdate,
          ];

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncUnsynced e um erro ocorrer em existsById, 
        retornar um Failure''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatInsert))
              .thenAnswer((_) async => Either.right(serCatInsert.id));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatUpdate.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatUpdate))
              .thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatIsDeleted,
            serCatInsert,
            serCatUpdate,
          ];

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is Failure, isTrue);
        },
      );

      test(
        '''Ao executar o syncUnsynced e nenhum erro ocorrer, 
        retornar um Unit''',
        () async {
          when(offlineMockServiceCategoryRepository.deleteById(id: serCatIsDeleted.id))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(false));
          when(offlineMockServiceCategoryRepository.insert(serviceCategory: serCatInsert))
              .thenAnswer((_) async => Either.right(serCatInsert.id));
          when(offlineMockServiceCategoryRepository.existsById(id: serCatUpdate.id))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: serCatUpdate))
              .thenAnswer((_) async => Either.right(unit));

          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatIsDeleted,
            serCatInsert,
            serCatUpdate,
          ];

          final uncyncedEither = await syncServiceCategoryService.syncUnsynced();

          expect(uncyncedEither.isRight, isTrue);
          expect(uncyncedEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'Testes do método getMaxSyncDate',
    () {
      test(
        '''Ao executar getMaxSyncDate com o serviceCategoriesToSync vazio, retornar
        um erro''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [];

          expect(() => syncServiceCategoryService.getMaxSyncDate(), throwsA(isA<Error>()));
        },
      );

      test(
        '''Ao executar getMaxSyncDate capturar a maior data dentre 
        serviceCategoriesToSync, neste caso 17/10/2024''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
            serCatSync20241017,
          ];

          final maxSyncDate = syncServiceCategoryService.getMaxSyncDate();

          expect(maxSyncDate, serCatSync20241017.syncDate);
        },
      );

      test(
        '''Ao executar getMaxSyncDate capturar a maior data dentre 
        serviceCategoriesToSync, neste caso 16/10/2024''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
          ];

          final maxSyncDate = syncServiceCategoryService.getMaxSyncDate();

          expect(maxSyncDate, serCatSync20241016.syncDate);
        },
      );

      test(
        '''Ao executar getMaxSyncDate capturar a maior data dentre 
        serviceCategoriesToSync, neste caso 15/10/2024''',
        () {
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
          ];

          final maxSyncDate = syncServiceCategoryService.getMaxSyncDate();

          expect(maxSyncDate, serCatSync20241015.syncDate);
        },
      );
    },
  );

  group(
    'Testes do método updateSyncDate',
    () {
      test(
        '''Ao executar o updateSyncDate e uma falha ocorrer em exists esta falha 
        deve ser retornada''',
        () async {
          syncServiceCategoryService.sync = Sync();
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
            serCatSync20241017,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.left(NetworkFailure('Falha de teste')));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is NetworkFailure, isTrue);
        },
      );

      test(
        '''Ao executar o updateSyncDate sem serviceCatories em serviceCategoriesToSync
        um Unit deve ser retornado''',
        () async {
          syncServiceCategoryService.sync = Sync();
          syncServiceCategoryService.serviceCategoriesToSync = [];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.left(Failure('Falha de teste')));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Ao executar o updateSyncDate com serviceCatories em serviceCategoriesToSync
        e uma falha ocorrer no insert esta falha deve ser retornada''',
        () async {
          syncServiceCategoryService.sync = Sync();
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
            serCatSync20241017,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(mockSyncRepository.insert(sync: anyNamed('sync')))
              .thenAnswer((_) async => Either.left(NetworkFailure('Falha de teste')));
          when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is NetworkFailure, isTrue);
        },
      );

      test(
        '''Ao executar o updateSyncDate com serviceCatories em serviceCategoriesToSync
        e uma falha ocorrer no update esta falha deve ser retornada''',
        () async {
          syncServiceCategoryService.sync = Sync();
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
            serCatSync20241017,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.insert(sync: anyNamed('sync'))).thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.left(NetworkFailure('Falha de teste')));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is NetworkFailure, isTrue);
        },
      );

      test(
        '''Ao executar o updateSyncDate com serviceCatories em serviceCategoriesToSync
        e o insert ocorrer normalmente um Unit deve ser retornado''',
        () async {
          syncServiceCategoryService.sync = Sync();
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
            serCatSync20241017,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(mockSyncRepository.insert(sync: anyNamed('sync'))).thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.left(NetworkFailure('Falha de teste')));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Ao executar o updateSyncDate com serviceCatories em serviceCategoriesToSync
        e o update ocorrer normalmente um Unit deve ser retornado''',
        () async {
          syncServiceCategoryService.sync = Sync();
          syncServiceCategoryService.serviceCategoriesToSync = [
            serCatSync20241015,
            serCatSync20241016,
            serCatSync20241017,
          ];

          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.insert(sync: anyNamed('sync')))
              .thenAnswer((_) async => Either.left(NetworkFailure('Falha de teste')));
          when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceCategoryService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'Testes do método synchronize',
    () {
      test(
        '''Ao executar o synchronize e uma falha ocorrer em loadSyncInfo, esta falha deve
        ser retornada''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o synchronize e uma falha ocorrer em loadUnsynced, esta falha deve
        ser retornada''',
        () async {
          const failureMessage = 'Falha loadUnsynced';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o synchronize e uma falha ocorrer em syncUnsynced, esta falha deve
        ser retornada''',
        () async {
          const failureMessage = 'Falha syncUnsynced';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serCatGetAll));
          when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o synchronize e uma falha ocorrer em updateSyncDate, esta falha deve
        ser retornada''',
        () async {
          const failureMessage = 'Falha updateSyncDate';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serCatGetAllHasDate));
          when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: anyNamed('serviceCategory')))
              .thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Ao executar o synchronize e nenhuma falha ocorrer, um Unit deve ser 
        retornado''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serCatGetAllHasDate));
          when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: anyNamed('serviceCategory')))
              .thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final syncEither = await syncServiceCategoryService.synchronize();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right is Unit, isTrue);
        },
      );
    },
  );
}

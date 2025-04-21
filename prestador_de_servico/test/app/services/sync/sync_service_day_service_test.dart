import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_day_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class MockSyncRepository extends Mock implements SyncRepository {}

class MockServiceDayRepository extends Mock implements ServiceDayRepository {}

void main() {
  final mockSyncRepository = MockSyncRepository();
  final offlineMockServiceDayRepository = MockServiceDayRepository();
  final onlineMockServiceDayRepository = MockServiceDayRepository();
  final syncServiceDayService = SyncServiceDayService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockServiceDayRepository,
    onlineRepository: onlineMockServiceDayRepository,
  );

  late Sync syncEmpty;
  late Sync syncServiceDay;

  late ServiceDay serviceDay1;
  late ServiceDay serviceDay2;
  late ServiceDay serviceDay3;
  late ServiceDay serviceDay4;
  late ServiceDay serviceDay5;
  late ServiceDay serviceDay6;
  late ServiceDay serviceDay7;
  late ServiceDay serviceDay5Deleted;

  late ServiceDay serviceDayLowestDate;
  late ServiceDay serviceDayIntermediateDate;
  late ServiceDay serviceDayBiggestDate;

  late List<ServiceDay> serviceDaysGetAll;
  late List<ServiceDay> serviceDaysGetSync;
  late List<ServiceDay> serviceDaysGetHasDate;

  void setUpValues() {
    syncEmpty = Sync();
    syncServiceDay = Sync(dateSyncServiceDay: DateTime(2024, 10, 10));

    serviceDay1 = ServiceDay(
        id: '1',
        dayOfWeek: 1,
        name: 'Domingo',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);
    serviceDay2 = ServiceDay(
        id: '2',
        dayOfWeek: 2,
        name: 'Segunda-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);
    serviceDay3 = ServiceDay(
        id: '3',
        dayOfWeek: 3,
        name: 'Terça-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);
    serviceDay4 = ServiceDay(
        id: '4',
        dayOfWeek: 4,
        name: 'Quarta-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);
    serviceDay5 = ServiceDay(
        id: '5',
        dayOfWeek: 5,
        name: 'Quinta-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);
    serviceDay6 = ServiceDay(
        id: '6',
        dayOfWeek: 6,
        name: 'Sexta-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);
    serviceDay7 = ServiceDay(
        id: '7',
        dayOfWeek: 7,
        name: 'Sábado',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0);

    serviceDay5Deleted = ServiceDay(
        id: '5',
        dayOfWeek: 5,
        name: 'Quinta-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0,
        isDeleted: true);

    serviceDayLowestDate = ServiceDay(
        id: '3',
        dayOfWeek: 3,
        name: 'Terça-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0,
        syncDate: DateTime(2024, 11, 5));
    serviceDayIntermediateDate = ServiceDay(
        id: '4',
        dayOfWeek: 4,
        name: 'Quarta-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0,
        syncDate: DateTime(2024, 11, 10));
    serviceDayBiggestDate = ServiceDay(
        id: '5',
        dayOfWeek: 5,
        name: 'Quinta-feira',
        isActive: true,
        openingHour: 0,
        openingMinute: 0,
        closingHour: 0,
        closingMinute: 0,
        syncDate: DateTime(2024, 11, 15));

    serviceDaysGetAll = [
      serviceDay1,
      serviceDay2,
      serviceDay3,
      serviceDay4,
      serviceDay5,
      serviceDay6,
      serviceDay7,
    ];

    serviceDaysGetSync = [
      serviceDay3,
      serviceDay4,
    ];

    serviceDaysGetHasDate = [
      serviceDayLowestDate,
      serviceDayIntermediateDate,
      serviceDayBiggestDate,
    ];
  }

  setUp(
    () {
      setUpValues();
      registerFallbackValue(serviceDay1);
      registerFallbackValue(syncEmpty);
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

          final loadEither = await syncServiceDayService.loadSyncInfo();

          expect(loadEither.isLeft, isTrue);
          expect(loadEither.left is GetDatabaseFailure, isTrue);
          final state = (loadEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" sem dados em "dateSyncServiceDay"
        quando não houver sincronizações de ServiceDay anteriores''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncEmpty));

          final loadEither = await syncServiceDayService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncServiceDayService.sync.dateSyncServiceDay, isNull);
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" com dados em "dateSyncServiceDays"
        quando houver sincronizações de ServiceDay anteriores''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncServiceDay));

          final loadEither = await syncServiceDayService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncServiceDayService.sync.dateSyncServiceDay,
              equals(syncServiceDay.dateSyncServiceDay));
        },
      );
    },
  );

  group(
    'loadUnsynced',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e não tiver 
        sincronização de ServiceDay anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncServiceDayService.sync = syncEmpty;
          when(() => onlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncServiceDayService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e tiver 
        sincronização de ServiceDay anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncServiceDayService.sync = syncServiceDay;
          when(() => onlineMockServiceDayRepository.getUnsync(
                  dateLastSync: syncServiceDay.dateSyncServiceDay!))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncServiceDayService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "serviceDaysToSync" com todos os
        ServiceDay cadastrados quando não tiver sincronização de ServiceDay anterior''',
        () async {
          syncServiceDayService.sync = syncEmpty;
          when(() => onlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceDaysGetAll));

          final loadUnsyncedEither = await syncServiceDayService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncServiceDayService.serviceDaysToSync.length,
            equals(serviceDaysGetAll.length),
          );
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "serviceDaysToSync" com os 
        ServiceDay que precisam ser sincronizados quando tiver alguma sincronização 
        de ServiceDay anterior''',
        () async {
          syncServiceDayService.sync = syncServiceDay;
          when(() => onlineMockServiceDayRepository.getUnsync(
                  dateLastSync: syncServiceDay.dateSyncServiceDay!))
              .thenAnswer((_) async => Either.right(serviceDaysGetSync));

          final loadUnsyncedEither = await syncServiceDayService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncServiceDayService.serviceDaysToSync.length,
            equals(serviceDaysGetSync.length),
          );
        },
      );
    },
  );

  group(
    'syncServiceDay',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline na 
        verificação da existência do ServiceDay''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceDayRepository.existsById(id: serviceDay1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        inserção do ServiceDay''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceDayRepository.existsById(id: serviceDay1.id))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockServiceDayRepository.insert(serviceDay: serviceDay1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        alteração do ServiceDay''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceDayRepository.existsById(id: serviceDay1.id))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceDayRepository.update(serviceDay: serviceDay1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        exclusão do ServiceDay''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceDayRepository.deleteById(id: serviceDay5Deleted.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay5Deleted);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de um ServiceDay for feita com sucesso''',
        () async {
          when(() => offlineMockServiceDayRepository.existsById(id: serviceDay1.id))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockServiceDayRepository.insert(serviceDay: serviceDay1))
              .thenAnswer((_) async => Either.right(serviceDay1.id));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a alteração de um ServiceDay for feita com sucesso''',
        () async {
          when(() => offlineMockServiceDayRepository.existsById(id: serviceDay1.id))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceDayRepository.update(serviceDay: serviceDay1))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a exclusão de um ServiceDay for feita com sucesso''',
        () async {
          when(() => offlineMockServiceDayRepository.deleteById(id: serviceDay5Deleted.id))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncServiceDayService.syncServiceDay(serviceDay5Deleted);

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
          syncServiceDayService.serviceDaysToSync = serviceDaysGetAll;
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceDayRepository.existsById(id: serviceDay1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final uncyncedEither = await syncServiceDayService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (uncyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit''',
        () async {
          syncServiceDayService.serviceDaysToSync = serviceDaysGetAll;
          when(() => offlineMockServiceDayRepository.deleteById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceDayRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockServiceDayRepository.insert(serviceDay: any(named: 'serviceDay')))
              .thenAnswer((_) async => Either.right(serviceDay1.id));
          when(() => offlineMockServiceDayRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceDayRepository.update(serviceDay: any(named: 'serviceDay')))
              .thenAnswer((_) async => Either.right(unit));

          final uncyncedEither = await syncServiceDayService.syncUnsynced();

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
        '''Deve retornar um erro quando o campo "serviceDaysToSync" estiver vazio''',
        () {
          syncServiceDayService.serviceDaysToSync = [];

          expect(() => syncServiceDayService.getMaxSyncDate(), throwsA(isA<Error>()));
        },
      );

      test(
        '''Deve retornar a data de "serviceDayBiggestDate"''',
        () {
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
            serviceDayIntermediateDate,
            serviceDayBiggestDate,
          ];

          final maxSyncDate = syncServiceDayService.getMaxSyncDate();

          expect(maxSyncDate, serviceDayBiggestDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "serviceDayIntermediateDate"''',
        () {
          syncServiceDayService.serviceDaysToSync = [
            serviceDayIntermediateDate,
            serviceDayLowestDate,
          ];

          final maxSyncDate = syncServiceDayService.getMaxSyncDate();

          expect(maxSyncDate, serviceDayIntermediateDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "serviceDayLowestDate"''',
        () {
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
          ];

          final maxSyncDate = syncServiceDayService.getMaxSyncDate();

          expect(maxSyncDate, serviceDayLowestDate.syncDate);
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
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
            serviceDayIntermediateDate,
            serviceDayBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceDayService.updateSyncDate();

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
          syncServiceDayService.sync = syncEmpty;
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
            serviceDayIntermediateDate,
            serviceDayBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(() => mockSyncRepository.insert(sync: any(named: 'sync')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceDayService.updateSyncDate();

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
          syncServiceDayService.sync = syncEmpty;
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
            serviceDayIntermediateDate,
            serviceDayBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updateServiceDay(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncServiceDayService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o serviceDaysToSync estiver vazio''',
        () async {
          syncServiceDayService.serviceDaysToSync = [];

          final updateEither = await syncServiceDayService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncServiceDayService.sync = syncEmpty;
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
            serviceDayIntermediateDate,
            serviceDayBiggestDate,
          ];

          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(() => mockSyncRepository.insert(sync: any(named: 'sync')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceDayService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a atualização de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncServiceDayService.sync = syncEmpty;
          syncServiceDayService.serviceDaysToSync = [
            serviceDayLowestDate,
            serviceDayIntermediateDate,
            serviceDayBiggestDate,
          ];

          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updateServiceDay(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncServiceDayService.updateSyncDate();

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

          final syncEither = await syncServiceDayService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is GetDatabaseFailure, isTrue);
          expect((syncEither.left as GetDatabaseFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet ao consultar os
        ServiceDay a serem sincronizados''',
        () async {
          const failureMessage = '';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final syncEither = await syncServiceDayService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is NetworkFailure, isTrue);
          expect((syncEither.left as NetworkFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline ao 
        verificar se o ServiceDay existe''',
        () async {
          const failureMessage = 'Falha syncUnsynced';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceDaysGetAll));
          when(() => offlineMockServiceDayRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceDayService.synchronize();

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
          when(() => onlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceDaysGetHasDate));
          when(() => offlineMockServiceDayRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceDayRepository.update(serviceDay: any(named: 'serviceDay')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => mockSyncRepository.exists())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncServiceDayService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a sincronização for realizada com sucesso''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceDaysGetHasDate));
          when(() => offlineMockServiceDayRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockServiceDayRepository.update(serviceDay: any(named: 'serviceDay')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updateServiceDay(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final syncEither = await syncServiceDayService.synchronize();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right is Unit, isTrue);
        },
      );
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/sync/sync_payment_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class MockSyncRepository extends Mock implements SyncRepository {}

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  final mockSyncRepository = MockSyncRepository();
  final offlineMockPaymentRepository = MockPaymentRepository();
  final onlineMockPaymentRepository = MockPaymentRepository();
  final syncPaymentService = SyncPaymentService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockPaymentRepository,
    onlineRepository: onlineMockPaymentRepository,
  );

  late Sync syncEmpty;
  late Sync syncPayment;

  late Payment payment1;
  late Payment payment2;
  late Payment payment3;
  late Payment payment4;
  late Payment payment5;
  late Payment payment6;
  late Payment payment5Deleted;

  late Payment paymentLowestDate;
  late Payment paymentIntermediateDate;
  late Payment paymentBiggestDate;

  late List<Payment> paymentsGetAll;
  late List<Payment> paymentsGetSync;
  late List<Payment> paymentsGetHasDate;

  void setUpValues() {
    syncEmpty = Sync();
    syncPayment = Sync(dateSyncPayment: DateTime(2024, 10, 10));

    payment1 = Payment(
        id: '1', paymentType: PaymentType.money, name: 'Dinheito', isActive: true, urlIcon: '');
    payment2 =
        Payment(id: '2', paymentType: PaymentType.pix, name: 'Pix', isActive: true, urlIcon: '');
    payment3 = Payment(
        id: '3',
        paymentType: PaymentType.debitCard,
        name: 'Cartão de débito',
        isActive: true,
        urlIcon: '');
    payment4 = Payment(
        id: '4',
        paymentType: PaymentType.creditCard,
        name: 'Cartão de crédito',
        isActive: true,
        urlIcon: '');
    payment5 = Payment(
        id: '5', paymentType: PaymentType.ticket, name: 'Vale', isActive: true, urlIcon: '');
    payment6 = Payment(
        id: '6', paymentType: PaymentType.other, name: 'Outros', isActive: true, urlIcon: '');

    payment5Deleted = Payment(
        id: '5',
        paymentType: PaymentType.ticket,
        name: 'Vale',
        isActive: true,
        urlIcon: '',
        isDeleted: true);

    paymentLowestDate = Payment(
        id: '3',
        paymentType: PaymentType.debitCard,
        name: 'Cartão de débito',
        isActive: true,
        urlIcon: '',
        syncDate: DateTime(2024, 11, 5));
    paymentIntermediateDate = Payment(
        id: '4',
        paymentType: PaymentType.creditCard,
        name: 'Cartão de crédito',
        isActive: true,
        urlIcon: '',
        syncDate: DateTime(2024, 11, 10));
    paymentBiggestDate = Payment(
        id: '5',
        paymentType: PaymentType.ticket,
        name: 'Vale',
        isActive: true,
        urlIcon: '',
        syncDate: DateTime(2024, 11, 15));

    paymentsGetAll = [
      payment1,
      payment2,
      payment3,
      payment4,
      payment5,
      payment6,
    ];

    paymentsGetSync = [
      payment3,
      payment4,
    ];

    paymentsGetHasDate = [
      paymentLowestDate,
      paymentIntermediateDate,
      paymentBiggestDate,
    ];
  }

  setUp(() {
    setUpValues();
    registerFallbackValue(syncEmpty);
    registerFallbackValue(payment1);
  });

  group(
    'loadSyncInfo',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.get())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final loadEither = await syncPaymentService.loadSyncInfo();

          expect(loadEither.isLeft, isTrue);
          expect(loadEither.left is GetDatabaseFailure, isTrue);
          final state = (loadEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" sem dados em "dateSyncPayment"
        quando não houver sincronizações de Payment anteriores''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncEmpty));

          final loadEither = await syncPaymentService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncPaymentService.sync.dateSyncPayment, isNull);
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "sync" com dados em "dateSyncPayments"
        quando houver sincronizações de Payment anteriores''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(syncPayment));

          final loadEither = await syncPaymentService.loadSyncInfo();

          expect(loadEither.isRight, isTrue);
          expect(loadEither.right is Unit, isTrue);
          expect(syncPaymentService.sync.dateSyncPayment, equals(syncPayment.dateSyncPayment));
        },
      );
    },
  );

  group(
    'loadUnsynced',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e não tiver 
        sincronização de Payment anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncPaymentService.sync = syncEmpty;
          when(() => onlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncPaymentService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet e tiver 
        sincronização de Payment anterior''',
        () async {
          const failureMessage = 'Teste de falha';
          syncPaymentService.sync = syncPayment;
          when(() =>
                  onlineMockPaymentRepository.getUnsync(dateLastSync: syncPayment.dateSyncPayment!))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final unsyncedEither = await syncPaymentService.loadUnsynced();

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is NetworkFailure, isTrue);
          final state = (unsyncedEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "paymentsToSync" com todos os
        Payment cadastrados quando não tiver sincronização de Payment anterior''',
        () async {
          syncPaymentService.sync = syncEmpty;
          when(() => onlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(paymentsGetAll));

          final loadUnsyncedEither = await syncPaymentService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncPaymentService.paymentsToSync.length,
            equals(paymentsGetAll.length),
          );
        },
      );

      test(
        '''Deve retornar um Unit e carregar o campo "paymentsToSync" com os 
        Payment que precisam ser sincronizados quando tiver alguma sincronização 
        de Payment anterior''',
        () async {
          syncPaymentService.sync = syncPayment;
          when(() =>
                  onlineMockPaymentRepository.getUnsync(dateLastSync: syncPayment.dateSyncPayment!))
              .thenAnswer((_) async => Either.right(paymentsGetSync));

          final loadUnsyncedEither = await syncPaymentService.loadUnsynced();

          expect(loadUnsyncedEither.isRight, isTrue);
          expect(loadUnsyncedEither.right is Unit, isTrue);
          expect(
            syncPaymentService.paymentsToSync.length,
            equals(paymentsGetSync.length),
          );
        },
      );
    },
  );

  group(
    'syncPayment',
    () {
      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline na 
        verificação da existência do Payment''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockPaymentRepository.existsById(id: payment1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncPaymentService.syncPayment(payment1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        inserção do Payment''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockPaymentRepository.existsById(id: payment1.id))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockPaymentRepository.insert(payment: payment1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncPaymentService.syncPayment(payment1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        alteração do Payment''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockPaymentRepository.existsById(id: payment1.id))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncPaymentService.syncPayment(payment1);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer um erro no banco offline na 
        exclusão do Payment''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockPaymentRepository.deleteById(id: payment5Deleted.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final unsyncedEither = await syncPaymentService.syncPayment(payment5Deleted);

          expect(unsyncedEither.isLeft, isTrue);
          expect(unsyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (unsyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de um Payment for feita com sucesso''',
        () async {
          when(() => offlineMockPaymentRepository.existsById(id: payment1.id))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockPaymentRepository.insert(payment: payment1))
              .thenAnswer((_) async => Either.right(payment1.id));

          final unsyncedEither = await syncPaymentService.syncPayment(payment1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a alteração de um Payment for feita com sucesso''',
        () async {
          when(() => offlineMockPaymentRepository.existsById(id: payment1.id))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncPaymentService.syncPayment(payment1);

          expect(unsyncedEither.isRight, isTrue);
          expect(unsyncedEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a exclusão de um Payment for feita com sucesso''',
        () async {
          when(() => offlineMockPaymentRepository.deleteById(id: payment5Deleted.id))
              .thenAnswer((_) async => Either.right(unit));

          final unsyncedEither = await syncPaymentService.syncPayment(payment5Deleted);

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
          syncPaymentService.paymentsToSync = paymentsGetAll;
          const failureMessage = 'Teste de falha';
          when(() => offlineMockPaymentRepository.existsById(id: payment1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final uncyncedEither = await syncPaymentService.syncUnsynced();

          expect(uncyncedEither.isLeft, isTrue);
          expect(uncyncedEither.left is GetDatabaseFailure, isTrue);
          final state = (uncyncedEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit''',
        () async {
          syncPaymentService.paymentsToSync = paymentsGetAll;
          when(() => offlineMockPaymentRepository.deleteById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockPaymentRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(false));
          when(() => offlineMockPaymentRepository.insert(payment: any(named: 'payment')))
              .thenAnswer((_) async => Either.right(payment1.id));
          when(() => offlineMockPaymentRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockPaymentRepository.update(payment: any(named: 'payment')))
              .thenAnswer((_) async => Either.right(unit));

          final uncyncedEither = await syncPaymentService.syncUnsynced();

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
        '''Deve retornar um erro quando o campo "paymentsToSync" estiver vazio''',
        () {
          syncPaymentService.paymentsToSync = [];

          expect(() => syncPaymentService.getMaxSyncDate(), throwsA(isA<Error>()));
        },
      );

      test(
        '''Deve retornar a data de "paymentBiggestDate"''',
        () {
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
            paymentIntermediateDate,
            paymentBiggestDate,
          ];

          final maxSyncDate = syncPaymentService.getMaxSyncDate();

          expect(maxSyncDate, paymentBiggestDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "paymentIntermediateDate"''',
        () {
          syncPaymentService.paymentsToSync = [
            paymentIntermediateDate,
            paymentLowestDate,
          ];

          final maxSyncDate = syncPaymentService.getMaxSyncDate();

          expect(maxSyncDate, paymentIntermediateDate.syncDate);
        },
      );

      test(
        '''Deve retornar a data de "paymentLowestDate"''',
        () {
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
          ];

          final maxSyncDate = syncPaymentService.getMaxSyncDate();

          expect(maxSyncDate, paymentLowestDate.syncDate);
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
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
            paymentIntermediateDate,
            paymentBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncPaymentService.updateSyncDate();

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
          syncPaymentService.sync = syncEmpty;
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
            paymentIntermediateDate,
            paymentBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(() => mockSyncRepository.insert(sync: any<Sync>(named: 'sync')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncPaymentService.updateSyncDate();

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
          syncPaymentService.sync = syncEmpty;
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
            paymentIntermediateDate,
            paymentBiggestDate,
          ];
          const failureMessage = 'Teste de falha';
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updatePayment(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await syncPaymentService.updateSyncDate();

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o paymentsToSync estiver vazio''',
        () async {
          syncPaymentService.paymentsToSync = [];

          final updateEither = await syncPaymentService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a inserção de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncPaymentService.sync = syncEmpty;
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
            paymentIntermediateDate,
            paymentBiggestDate,
          ];

          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(false));
          when(() => mockSyncRepository.insert(sync: any(named: 'sync')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncPaymentService.updateSyncDate();

          expect(updateEither.isRight, isTrue);
          expect(updateEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a atualização de uma nova data de sincronização for
        feita com sucesso''',
        () async {
          syncPaymentService.sync = syncEmpty;
          syncPaymentService.paymentsToSync = [
            paymentLowestDate,
            paymentIntermediateDate,
            paymentBiggestDate,
          ];

          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updatePayment(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final updateEither = await syncPaymentService.updateSyncDate();

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

          final syncEither = await syncPaymentService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is GetDatabaseFailure, isTrue);
          expect((syncEither.left as GetDatabaseFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet ao consultar os
        Payment a serem sincronizados''',
        () async {
          const failureMessage = '';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final syncEither = await syncPaymentService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is NetworkFailure, isTrue);
          expect((syncEither.left as NetworkFailure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline ao 
        verificar se o Payment existe''',
        () async {
          const failureMessage = 'Falha syncUnsynced';
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(paymentsGetAll));
          when(() => offlineMockPaymentRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncPaymentService.synchronize();

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
          when(() => onlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(paymentsGetHasDate));
          when(() => offlineMockPaymentRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockPaymentRepository.update(payment: any(named: 'payment')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => mockSyncRepository.exists())
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final syncEither = await syncPaymentService.synchronize();

          expect(syncEither.isLeft, isTrue);
          expect(syncEither.left is Failure, isTrue);
          expect((syncEither.left as Failure).message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a sincronização for realizada com sucesso''',
        () async {
          when(() => mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(() => onlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(paymentsGetHasDate));
          when(() => offlineMockPaymentRepository.existsById(id: any(named: 'id')))
              .thenAnswer((_) async => Either.right(true));
          when(() => offlineMockPaymentRepository.update(payment: any(named: 'payment')))
              .thenAnswer((_) async => Either.right(unit));
          when(() => mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(() => mockSyncRepository.updatePayment(syncDate: any(named: 'syncDate')))
              .thenAnswer((_) async => Either.right(unit));

          final syncEither = await syncPaymentService.synchronize();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right is Unit, isTrue);
        },
      );
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/sync/sqflite_sync_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either_extensions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group(
    'Testes referente a classe SqfliteSyncRepository. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      late SqfliteSyncRepository syncRepository;
      late Sync sync = Sync();

      setUpAll(
        () async {
          sqfliteFfiInit();
          DatabaseFactory databaseFactory = databaseFactoryFfi;
          Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
          await SqfliteConfig().setupDatabase(database);

          syncRepository = SqfliteSyncRepository(database: database);
        },
      );

      tearDownAll(() {
        SqfliteConfig().disposeDatabase();
      });

      test(
        '''A primeira consulta de sincronização deve retornar uma instância Sync 
          sem nenhuma sincronização''',
        () async {
          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.existsSyncDateServiceCategories, isFalse);
          expect(syncEither.right!.existsSyncDateServices, isFalse);
          expect(syncEither.right!.existsSyncDatePayments, isFalse);
          expect(syncEither.right!.existsSyncDateServiceDays, isFalse);
        },
      );

      test(
        '''Ao inserir a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncServiceCategory: DateTime(2024, 10, 5));
          await syncRepository.insert(sync: sync);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncServiceCategory, equals(sync.dateSyncServiceCategory));
          expect(syncEither.right!.existsSyncDateServices, isFalse);
          expect(syncEither.right!.existsSyncDatePayments, isFalse);
          expect(syncEither.right!.existsSyncDateServiceDays, isFalse);
        },
      );

      test(
        '''Ao atualizar a sincronização de serviço o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncService: DateTime(2024, 10, 6));
          await syncRepository.updateService(syncDate: sync.dateSyncService!);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncService, equals(sync.dateSyncService));
        },
      );

      test(
        '''Ao atualizar a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncServiceCategory: DateTime(2024, 10, 7));
          await syncRepository.updateServiceCategory(syncDate: sync.dateSyncServiceCategory!);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncServiceCategory, equals(sync.dateSyncServiceCategory));
        },
      );

      test(
        '''Ao atualizar a sincronização de pagamento o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncPayment: DateTime(2024, 10, 15));
          await syncRepository.updatePayment(syncDate: sync.dateSyncPayment!);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncPayment, equals(sync.dateSyncPayment));
        },
      );

      test(
        '''Ao atualizar a sincronização de dias de atendimento o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncServiceDay: DateTime(2024, 10, 20));
          await syncRepository.updateServiceDay(syncDate: sync.dateSyncServiceDay!);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncServiceDay, equals(sync.dateSyncServiceDay));
        },
      );
    },
  );
}

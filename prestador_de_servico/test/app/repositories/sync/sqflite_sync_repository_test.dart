import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/sync/sqflite_sync_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
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
        },
      );

      test(
        '''Ao inserir a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncServiceCategories: DateTime(2024, 10, 5));
          await syncRepository.insert(sync: sync);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncServiceCategories, equals(sync.dateSyncServiceCategories));
          expect(syncEither.right!.existsSyncDateServices, isFalse);
        },
      );

      test(
        '''Ao atualizar a sincronização de serviço o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncServices: DateTime(2024, 10, 6));
          await syncRepository.updateService(syncDate: sync.dateSyncServices!);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncServices, equals(sync.dateSyncServices));
        },
      );

      test(
        '''Ao atualizar a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''',
        () async {
          sync = sync.copyWith(dateSyncServiceCategories: DateTime(2024, 10, 7));
          await syncRepository.updateServiceCategory(syncDate: sync.dateSyncServiceCategories!);

          final syncEither = await syncRepository.get();

          expect(syncEither.isRight, isTrue);
          expect(syncEither.right!.dateSyncServiceCategories, equals(sync.dateSyncServiceCategories));
        },
      );
    },
  );
}

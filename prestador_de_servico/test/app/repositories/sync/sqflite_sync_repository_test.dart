import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/sync/sqflite_sync_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group(
    'Testes referente a classe SqfliteSyncRepository. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      late SqfliteSyncRepository syncRepository;
      late Sync sync = Sync();

      setUpAll(() async {
        sqfliteFfiInit();
        DatabaseFactory databaseFactory = databaseFactoryFfi;
        Database database =
            await databaseFactory.openDatabase(inMemoryDatabasePath);
        await SqfliteConfig().setupDatabase(database);

        syncRepository = SqfliteSyncRepository(database: database);
      });

      tearDownAll(() {
        SqfliteConfig().disposeDatabase();
      });

      test(
          '''A primeira consulta de sincronização deve retornar uma instância Sync com
           valores nulos''', () async {
        Sync returnSync = await syncRepository.get();
        expect(returnSync.dateSyncServiceCategories, isNull);
        expect(returnSync.dateSyncService, isNull);
      });

      test(
          '''Ao inserir a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''', () async {
        sync = sync.copyWith(dateSyncServiceCategories: DateTime(2024, 10, 5));
        await syncRepository.insert(sync: sync);
        
        Sync returnSync = await syncRepository.get();
        expect(returnSync.dateSyncServiceCategories, equals(sync.dateSyncServiceCategories));
        expect(returnSync.dateSyncService, isNull);
      });

      test(
          '''Ao inserir a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''', () async {
        sync = sync.copyWith(dateSyncServiceCategories: DateTime(2024, 10, 5));
        await syncRepository.insert(sync: sync);
        
        Sync returnSync = await syncRepository.get();
        expect(returnSync.dateSyncServiceCategories, equals(sync.dateSyncServiceCategories));
      });

      test(
          '''Ao atualizar a sincronização de serviço o mesmo deve ser 
          retornado na consulta de sincronização''', () async {
        sync = sync.copyWith(dateSyncService: DateTime(2024, 10, 6));
        await syncRepository.updateService(dateSync: sync.dateSyncService!);
        
        Sync returnSync = await syncRepository.get();
        expect(returnSync.dateSyncService, equals(sync.dateSyncService));
      });

      test(
          '''Ao atualizar a sincronização de categoria de serviço o mesmo deve ser 
          retornado na consulta de sincronização''', () async {
        sync = sync.copyWith(dateSyncServiceCategories: DateTime(2024, 10, 7));
        await syncRepository.updateServiceCategory(dateSync: sync.dateSyncServiceCategories!);
        
        Sync returnSync = await syncRepository.get();
        expect(returnSync.dateSyncServiceCategories, equals(sync.dateSyncServiceCategories));
      });
    },
  );
}

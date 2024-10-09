import 'package:prestador_de_servico/app/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/models/sync/sync_adapter.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteSyncRepository implements SyncRepository {
  Database? database;
  String syncControlTable = '';

  SqfliteSyncRepository({this.database});

  Future<void> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    database ??= await sqfliteConfig.getDatabase();
    if (syncControlTable.isEmpty) {
      syncControlTable = sqfliteConfig.syncControl;
    }
  }
  
  @override
  Future<Sync> get() async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "syn_con.dateSyncServiceCategories, "
        "syn_con.dateSyncService "
        "FROM "
        "$syncControlTable syn_con";

    List<Map> syncMap = await database!.rawQuery(selectCommand);

    if (syncMap.isEmpty) {
      return Sync();
    }

    return SyncAdapter.fromSqflite(map: syncMap[0]);
  }

  @override
  Future<void> insert({required Sync sync}) async {
    await _initDatabase();

    String insert = ''
        'INSERT INTO $syncControlTable '
        '(dateSyncServiceCategories, dateSyncService) '
        'VALUES (?, ?)';
    List params = [
      sync.dateSyncServiceCategories?.millisecondsSinceEpoch ?? 0,
      sync.dateSyncService?.millisecondsSinceEpoch ?? 0,
    ];
    await database!.rawInsert(insert, params);
  }

  @override
  Future<void> updateServiceCategory({required DateTime syncDate}) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $syncControlTable '
        'SET '
        'dateSyncServiceCategories = ?';
    List params = [syncDate.millisecondsSinceEpoch];
    await database!.rawUpdate(updateText, params);
  }

  @override
  Future<void> updateService({required DateTime syncDate}) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $syncControlTable '
        'SET '
        'dateSyncService = ?';
    List params = [syncDate.millisecondsSinceEpoch];
    await database!.rawUpdate(updateText, params);
  }
}
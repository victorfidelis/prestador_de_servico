import 'dart:io';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/models/sync/sync_adapter.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteSyncRepository implements SyncRepository {
  Database? database;
  String syncControlTable = '';

  SqfliteSyncRepository({this.database});

  Future<Either<Failure, Unit>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database ??= await sqfliteConfig.getDatabase();
      if (syncControlTable.isEmpty) {
        syncControlTable = sqfliteConfig.syncControl;
      }
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar banco de dados local: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar arquivo de banco de dados local: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, Sync>> get() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "syn_con.dateSyncServiceCategory, "
        "syn_con.dateSyncService, "
        "syn_con.dateSyncPayment, "
        "syn_con.dateSyncServiceDay "
        "FROM "
        "$syncControlTable syn_con";

    try {
      final syncMap = await database!.rawQuery(selectCommand);
      if (syncMap.isEmpty) {
        return Either.right(Sync());
      }
      final sync = SyncAdapter.fromSqflite(map: syncMap[0]);
      return Either.right(sync);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, bool>> exists() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "1 verify "
        "FROM "
        "$syncControlTable syn_con";

    try {
      final syncMap = await database!.rawQuery(selectCommand);
      return Either.right(syncMap.isNotEmpty);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insert({required Sync sync}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String insert = ''
        'INSERT INTO $syncControlTable '
        '(dateSyncServiceCategory, dateSyncService, dateSyncPayment, dateSyncServiceDay) '
        'VALUES (?, ?, ?, ?)';
    List params = [
      sync.dateSyncServiceCategory?.millisecondsSinceEpoch ?? 0,
      sync.dateSyncService?.millisecondsSinceEpoch ?? 0,
      sync.dateSyncPayment?.millisecondsSinceEpoch ?? 0,
      sync.dateSyncServiceDay?.millisecondsSinceEpoch ?? 0,
    ];

    try {
      await database!.rawInsert(insert, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao gravar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao gravar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateServiceCategory({required DateTime syncDate}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $syncControlTable '
        'SET '
        'dateSyncServiceCategory = ?';
    List params = [syncDate.millisecondsSinceEpoch];

    try {
      await database!.rawUpdate(updateText, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateService({required DateTime syncDate}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $syncControlTable '
        'SET '
        'dateSyncService = ?';
    List params = [syncDate.millisecondsSinceEpoch];

    try {
      await database!.rawUpdate(updateText, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: ${e.message})'));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> updatePayment({required DateTime syncDate}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $syncControlTable '
        'SET '
        'dateSyncPayment = ?';
    List params = [syncDate.millisecondsSinceEpoch];

    try {
      await database!.rawUpdate(updateText, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: ${e.message})'));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> updateServiceDay({required DateTime syncDate}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $syncControlTable '
        'SET '
        'dateSyncServiceDay = ?';
    List params = [syncDate.millisecondsSinceEpoch];

    try {
      await database!.rawUpdate(updateText, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao atualizar dados locais: ${e.message})'));
    }
  }
}

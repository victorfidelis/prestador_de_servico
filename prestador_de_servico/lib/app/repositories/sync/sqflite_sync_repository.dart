import 'dart:io';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/models/sync/sync_adapter.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
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
        "syn_con.dateSyncServiceCategories, "
        "syn_con.dateSyncService "
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
        '(dateSyncServiceCategories, dateSyncService) '
        'VALUES (?, ?)';
    List params = [
      sync.dateSyncServiceCategories?.millisecondsSinceEpoch ?? 0,
      sync.dateSyncServices?.millisecondsSinceEpoch ?? 0,
    ];

    try {
      await database!.rawInsert(insert, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
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
        'dateSyncServiceCategories = ?';
    List params = [syncDate.millisecondsSinceEpoch];

    try {
      await database!.rawUpdate(updateText, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
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
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }
}

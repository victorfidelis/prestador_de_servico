
import 'dart:io';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:sqflite/sqlite_api.dart';

class SqfliteServiceDayRepository implements ServiceDayRepository {
  Database? database;
  String serviceDaysTable = '';

  SqfliteServiceDayRepository({this.database});

  Future<Either<Failure, Unit>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database ??= await sqfliteConfig.getDatabase();
      if (serviceDaysTable.isEmpty) {
        serviceDaysTable = sqfliteConfig.serviceDays;
      }
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar banco de dados local: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar arquivo de banco de dados local: ${e.message}'));
    }
  }
  
  @override
  Future<Either<Failure, List<ServiceDay>>> getAll() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "day.id, "
        "day.name, "
        "day.dayOfWeek, "
        "day.isActive, "
        "day.nameWithoutDiacritic "
        "FROM "
        "$serviceDaysTable day";

    try {
      final serviceDaysMap = await database!.rawQuery(selectCommand);
      final serviceDays = serviceDaysMap.map((serviceDay) => ServiceDayAdapter.fromSqflite(map: serviceDay)).toList();
      return Either.right(serviceDays);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required ServiceDay serviceDay}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $serviceDaysTable '
        'SET '
        'name = ?, '
        'dayOfWeek = ?, '
        'isActive = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      serviceDay.name.trim(),
      serviceDay.dayOfWeek,
      serviceDay.isActive ? 1 : 0,
      serviceDay.nameWithoutDiacritics,
      serviceDay.id,
    ];

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
  Future<Either<Failure, Unit>> deleteById({required String id}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String deleteText = ''
        'DELETE FROM '
        '$serviceDaysTable '
        'WHERE '
        'id = ?';
    final params = [id];

    try {
      await database!.rawDelete(deleteText, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao apagar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao apagar dados locais: ${e.message})'));
    }
  }
  
  @override
  Future<Either<Failure, String>> insert({required ServiceDay serviceDay}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String insert = ""
        "INSERT INTO $serviceDaysTable "
        "("
        "id, "
        "name, "
        "dayOfWeek, "
        "isActive, "
        "nameWithoutDiacritic "
        ") "
        "VALUES (?, ?, ?, ?, ?)";

    final params = [
      serviceDay.id,
      serviceDay.name.trim(),
      serviceDay.dayOfWeek,
      serviceDay.isActive,
      serviceDay.nameWithoutDiacritics.trim(),
    ];

    try {
      await database!.rawInsert(insert, params);
      return Either.right(serviceDay.id);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: ${e.message})'));
    }
  }
  
  @override
  Future<Either<Failure, List<ServiceDay>>> getUnsync({required DateTime dateLastSync}) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> existsById({required String id}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "pay.id "
        "FROM "
        "$serviceDaysTable pay "
        "WHERE "
        "pay.id = ?";

    final params = [id];

    try {
      final serviceDayMap = await database!.rawQuery(selectCommand, params);
      return Either.right(serviceDayMap.isNotEmpty);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }
}


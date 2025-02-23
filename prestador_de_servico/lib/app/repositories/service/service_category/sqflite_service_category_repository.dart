import 'dart:io';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_adapter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteServiceCategoryRepository implements ServiceCategoryRepository {
  Database? database;
  String serviceCategoriesTable = '';

  SqfliteServiceCategoryRepository({this.database});

  Future<Either<Failure, Unit>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database ??= await sqfliteConfig.getDatabase();
      if (serviceCategoriesTable.isEmpty) {
        serviceCategoriesTable = sqfliteConfig.serviceCategories;
      }
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar banco de dados local: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar arquivo de banco de dados local: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getAll() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser_cat.id, "
        "ser_cat.name, "
        "ser_cat.nameWithoutDiacritic "
        "FROM "
        "$serviceCategoriesTable ser_cat";

    try {
      final map = await database!.rawQuery(selectCommand);
      final serviceCartegories =
          map.map((serviceCategory) => ServiceCartegoryAdapter.fromSqflite(serviceCategory)).toList();
      return Either.right(serviceCartegories);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> getById({required String id}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser_cat.id, "
        "ser_cat.name, "
        "ser_cat.nameWithoutDiacritic "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "WHERE "
        "ser_cat.id = ?";
    List params = [id];

    try {
      final map = await database!.rawQuery(selectCommand, params);
      final serviceCartegory = ServiceCartegoryAdapter.fromSqflite(map[0]);
      return Either.right(serviceCartegory);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getNameContained({required String name}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String nameWithoutDiacritic = replaceDiacritic(name).trim().toUpperCase();
    String selectCommand = ""
        "SELECT "
        "ser_cat.id, "
        "ser_cat.name, "
        "ser_cat.nameWithoutDiacritic "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "WHERE "
        "trim(upper(ser_cat.nameWithoutDiacritic)) LIKE '%$nameWithoutDiacritic%'";

    try {
      final map = await database!.rawQuery(selectCommand);
      final serviceCartegories =
          map.map((serviceCategory) => ServiceCartegoryAdapter.fromSqflite(serviceCategory)).toList();
      return Either.right(serviceCartegories);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getUnsync({required DateTime dateLastSync}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> insert({required ServiceCategory serviceCategory}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String insert = ''
        'INSERT INTO $serviceCategoriesTable '
        '(id, name, nameWithoutDiacritic) '
        'VALUES (?, ?, ?)';
    List params = [
      serviceCategory.id,
      serviceCategory.name.trim(),
      serviceCategory.nameWithoutDiacritics.trim(),
    ];

    try {
      await database!.rawInsert(insert, params);
      return Either.right(serviceCategory.id);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required ServiceCategory serviceCategory}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $serviceCategoriesTable '
        'SET '
        'name = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';
    List params = [
      serviceCategory.name.trim(),
      serviceCategory.nameWithoutDiacritics.trim(),
      serviceCategory.id,
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

    String deleteTextMold = ''
        'DELETE FROM '
        '$serviceCategoriesTable '
        'WHERE '
        'id = ?';
    List params = [id];

    try {
      await database!.rawDelete(deleteTextMold, params);
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao apagar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao apagar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, bool>> existsById({required String id}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser_cat.id "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "WHERE "
        "ser_cat.id = ?";
    List params = [id];

    try {
      final map = await database!.rawQuery(selectCommand, params);
      return Either.right(map.isNotEmpty);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }
}

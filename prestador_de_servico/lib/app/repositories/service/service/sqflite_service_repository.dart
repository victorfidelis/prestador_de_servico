import 'dart:io';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_converter.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteServiceRepository implements ServiceRepository {
  Database? database;
  String servicesTable = '';

  SqfliteServiceRepository({this.database});

  Future<Either<Failure, Unit>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database ??= await sqfliteConfig.getDatabase();
      if (servicesTable.isEmpty) {
        servicesTable = sqfliteConfig.services;
      }
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar banco de dados local: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar arquivo de banco de dados local: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getAll() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser";

    try {
      final servicesMap = await database!.rawQuery(selectCommand);
      final services = servicesMap.map((service) => ServiceConverter.fromSqflite(map: service)).toList();
      return Either.right(services);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getByServiceCategoryId({required String serviceCategoryId}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser "
        "WHERE ser.serviceCategoryId = ?";

    try {
      final params = [serviceCategoryId];
      final servicesMap = await database!.rawQuery(selectCommand, params);
      final services = servicesMap.map((service) => ServiceConverter.fromSqflite(map: service)).toList();
      return Either.right(services);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Service>> getById({required String id}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser "
        "WHERE ser.id = ?";

    try {
      final params = [id];
      final serviceMap = await database!.rawQuery(selectCommand, params);
      final service = ServiceConverter.fromSqflite(map: serviceMap[0]);
      return Either.right(service);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getNameContained({required String name}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String nameWithoutDiacritic = replaceDiacritic(name).trim().toUpperCase();

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser "
        "WHERE "
        "trim(upper(ser.nameWithoutDiacritic)) LIKE '%$nameWithoutDiacritic%'";

    try {
      final serviceMap = await database!.rawQuery(selectCommand);
      final services = serviceMap.map((service) => ServiceConverter.fromSqflite(map: service)).toList();
      return Either.right(services);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getUnsync({required DateTime dateLastSync}) async {
    return Either.left(Failure('Método não desenvolvido'));
  }

  @override
  Future<Either<Failure, String>> insert({required Service service}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String insert = ""
        "INSERT INTO $servicesTable "
        "("
        "id, "
        "serviceCategoryId, "
        "name, "
        "price, "
        "hours, "
        "minutes, "
        "urlImage, "
        "nameWithoutDiacritic"
        ") "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    final params = [
      service.id,
      service.serviceCategoryId,
      service.name.trim(),
      service.price,
      service.hours,
      service.minutes,
      service.imageUrl.trim(),
      service.nameWithoutDiacritics.trim(),
    ];

    try {
      await database!.rawInsert(insert, params);
      return Either.right(service.id);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required Service service}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $servicesTable '
        'SET '
        'serviceCategoryId = ?, '
        'name = ?, '
        'price = ?, '
        'hours = ?, '
        'minutes = ?, '
        'urlImage = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      service.serviceCategoryId.trim(),
      service.name.trim(),
      service.price,
      service.hours,
      service.minutes,
      service.imageUrl.trim(),
      service.nameWithoutDiacritics.trim(),
      service.id,
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
        '$servicesTable '
        'WHERE '
        'id = ?';
    final params = [id];

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
  Future<Either<Failure, Unit>> deleteByCategoryId(String serviceCategoryId) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    } 

    String deleteTextMold = ''
        'DELETE FROM '
        '$servicesTable '
        'WHERE '
        'serviceCategoryId = ?';
    final params = [serviceCategoryId];

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
        "ser.id "
        "FROM "
        "$servicesTable ser "
        "WHERE "
        "ser.id = ?";

    final params = [id];

    try {
      final serviceMap = await database!.rawQuery(selectCommand, params);
      return Either.right(serviceMap.isNotEmpty);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }
}

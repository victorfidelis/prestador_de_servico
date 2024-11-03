import 'dart:io';

import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteServicesByCategoryRepository implements ServicesByCategoryRepository {
  Database? database;
  String servicesTable = '';
  String serviceCategoriesTable = '';

  SqfliteServicesByCategoryRepository({this.database});

  Future<Either<Failure, Unit>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database ??= await sqfliteConfig.getDatabase();
      if (servicesTable.isEmpty) {
        servicesTable = sqfliteConfig.services;
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
  Future<Either<Failure, List<ServicesByCategory>>> getAll() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "ser_cat.id serviceCategoryId, "
        "ser_cat.name serviceCategoryName, "
        "ser.id serviceId, "
        "ser.name serviceName, "
        "ser.price servicePrice, "
        "ser.hours serviceHours, "
        "ser.minutes serviceMinutes, "
        "ser.urlImage serviceUrlImage "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "LEFT JOIN $servicesTable ser on ser_cat.id = ser.serviceCategoryId";

    try {
      final servicesMap = await database!.rawQuery(selectCommand);
      final services = ServicesByCategoryAdapter.fromListSqflite(servicesMap);
      return Either.right(services);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, List<ServicesByCategory>>> getByContainedName(String name) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String nameWithoutDiacritic = replaceDiacritic(name).trim().toUpperCase();

    String selectCommand = ""
        "SELECT "
        "ser_cat.id serviceCategoryId, "
        "ser_cat.name serviceCategoryName, "
        "ser.id serviceId, "
        "ser.name serviceName, "
        "ser.price servicePrice, "
        "ser.hours serviceHours, "
        "ser.minutes serviceMinutes, "
        "ser.urlImage serviceUrlImage "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "LEFT JOIN $servicesTable ser on ser_cat.id = ser.serviceCategoryId "
        "WHERE "
        "trim(upper(ser_cat.nameWithoutDiacritic)) LIKE '%$nameWithoutDiacritic%' "
        "OR trim(upper(ser.nameWithoutDiacritic)) LIKE '%$nameWithoutDiacritic%'";

    try {
      final servicesMap = await database!.rawQuery(selectCommand);
      final services = ServicesByCategoryAdapter.fromListSqflite(servicesMap);
      return Either.right(services);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }
}
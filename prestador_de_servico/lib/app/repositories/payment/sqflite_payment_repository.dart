
import 'dart:io';

import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/models/payment/payment_converter.dart';
import 'package:prestador_de_servico/app/repositories/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';
import 'package:sqflite/sqlite_api.dart';

class SqflitePaymentRepository implements PaymentRepository {
  Database? database;
  String paymentsTable = '';

  SqflitePaymentRepository({this.database});

  Future<Either<Failure, Unit>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database ??= await sqfliteConfig.getDatabase();
      if (paymentsTable.isEmpty) {
        paymentsTable = sqfliteConfig.payments;
      }
      return Either.right(unit);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar banco de dados local: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao acessar arquivo de banco de dados local: ${e.message}'));
    }
  }
  
  @override
  Future<Either<Failure, List<Payment>>> getAll() async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String selectCommand = ""
        "SELECT "
        "pay.id, "
        "pay.paymentType, "
        "pay.name, "
        "pay.urlIcon, "
        "pay.isActive, "
        "pay.nameWithoutDiacritic "
        "FROM "
        "$paymentsTable pay";

    try {
      final paymentsMap = await database!.rawQuery(selectCommand);
      final payments = paymentsMap.map((payment) => PaymentConverter.fromSqflite(map: payment)).toList();
      return Either.right(payments);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required Payment payment}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String updateText = ''
        'UPDATE $paymentsTable '
        'SET '
        'paymentType = ?, '
        'name = ?, '
        'urlIcon = ?, '
        'isActive = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      payment.paymentType.index,
      payment.name.trim(),
      payment.urlIcon,
      payment.isActive ? 1 : 0,
      payment.nameWithoutDiacritics,
      payment.id,
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
        '$paymentsTable '
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
  Future<Either<Failure, String>> insert({required Payment payment}) async {
    final getDbEither = await _initDatabase();
    if (getDbEither.isLeft) {
      return Either.left(getDbEither.left);
    }

    String insert = ""
        "INSERT INTO $paymentsTable "
        "("
        "id, "
        "paymentType, "
        "name, "
        "urlIcon, "
        "isActive, "
        "nameWithoutDiacritic "
        ") "
        "VALUES (?, ?, ?, ?, ?, ?)";

    final params = [
      payment.id,
      payment.paymentType.index,
      payment.name.trim(),
      payment.urlIcon.trim(),
      payment.isActive,
      payment.nameWithoutDiacritics.trim(),
    ];

    try {
      await database!.rawInsert(insert, params);
      return Either.right(payment.id);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao inserir dados locais: ${e.message})'));
    }
  }
  
  @override
  Future<Either<Failure, List<Payment>>> getUnsync({required DateTime dateLastSync}) {
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
        "$paymentsTable pay "
        "WHERE "
        "pay.id = ?";

    final params = [id];

    try {
      final paymentMap = await database!.rawQuery(selectCommand, params);
      return Either.right(paymentMap.isNotEmpty);
    } on DatabaseException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Either.left(GetDatabaseFailure('Falha ao capturar dados locais: ${e.message})'));
    }
  }
}


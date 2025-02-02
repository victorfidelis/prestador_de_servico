import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/sync/sqflite_sync_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class SyncRepository {

  factory SyncRepository.create() {
    return SqfliteSyncRepository();
  }

  Future<Either<Failure, Sync>> get(); 
  Future<Either<Failure, bool>> exists();
  Future<Either<Failure, Unit>> insert({required Sync sync}); 
  Future<Either<Failure, Unit>> updateServiceCategory({required DateTime syncDate}); 
  Future<Either<Failure, Unit>> updateService({required DateTime syncDate}); 
  Future<Either<Failure, Unit>> updatePayment({required DateTime syncDate}); 
  Future<Either<Failure, Unit>> updateServiceDay({required DateTime syncDate});
}
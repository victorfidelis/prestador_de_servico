
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/repositories/service/service/firebase_service_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/sqflite_service_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class ServiceRepository {

  factory ServiceRepository.createOffline() {
    return SqfliteServiceRepository();
  }

  factory ServiceRepository.createOnline() {
    return FirebaseServiceRepository();
  }

  Future<Either<Failure, List<Service>>> getAll();
  Future<Either<Failure, List<Service>>> getByServiceCategoryId({required String serviceCategoryId});
  Future<Either<Failure, Service>> getById({required String id});
  Future<Either<Failure, List<Service>>> getNameContained({required String name});
  Future<Either<Failure, List<Service>>> getUnsync({required DateTime dateLastSync});
  Future<Either<Failure, String>> insert({required Service service});
  Future<Either<Failure, Unit>> update({required Service service});
  Future<Either<Failure, Unit>> deleteById({required String id});
  Future<Either<Failure, Unit>> deleteByCategoryId(String serviceCategoryId);
  Future<Either<Failure, bool>> existsById({required String id});
}
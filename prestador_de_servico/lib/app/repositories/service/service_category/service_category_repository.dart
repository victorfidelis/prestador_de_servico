import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/firebase_service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/sqflite_service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class ServiceCategoryRepository {

  factory ServiceCategoryRepository.createOnline() {
    return FirebaseServiceCategoryRepository();
  }
  factory ServiceCategoryRepository.createOffline() {
    return SqfliteServiceCategoryRepository();
  }

  Future<Either<Failure, List<ServiceCategory>>> getAll();
  Future<Either<Failure, ServiceCategory>> getById({required String id});
  Future<Either<Failure, List<ServiceCategory>>> getNameContained({required String name});
  Future<Either<Failure, List<ServiceCategory>>> getUnsync({required DateTime dateLastSync});
  Future<Either<Failure, String>> insert({required ServiceCategory serviceCategory});
  Future<Either<Failure, Unit>> update({required ServiceCategory serviceCategory});
  Future<Either<Failure, Unit>> deleteById({required String id});
  Future<Either<Failure, bool>> existsById({required String id});
  Future<Either<Failure, List<ServiceCategory>>> getAllWithServices();
}

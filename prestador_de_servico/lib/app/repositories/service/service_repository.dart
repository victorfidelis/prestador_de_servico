
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class ServiceRepository {

  Future<Either<Failure, List<Service>>> getAll();
  Future<Either<Failure, List<Service>>> getByServiceCategoryId({required String serviceCategoryId});
  Future<Either<Failure, Service>> getById({required String id});
  Future<Either<Failure, List<Service>>> getNameContained({required String name});
  Future<Either<Failure, List<Service>>> getUnsync({required DateTime dateLastSync});
  Future<Either<Failure, String>> insert({required Service service});
  Future<Either<Failure, Unit>> update({required Service service});
  Future<Either<Failure, Unit>> deleteById({required String id});
  Future<Either<Failure, bool>> existsById({required String id});
}
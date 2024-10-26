import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/sqflite_services_by_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class ServicesByCategoryRepository {

  factory ServicesByCategoryRepository.createOffline() {
    return SqfliteServicesByCategoryRepository();
  }

  Future<Either<Failure, List<ServicesByCategory>>> getAll();
  Future<Either<Failure, List<ServicesByCategory>>> getByContainedName(String name);
}
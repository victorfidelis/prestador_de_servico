import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class SqfliteServicesByCategoryRepository implements ServicesByCategoryRepository {
  @override
  Future<Either<Failure, List<ServicesByCategory>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ServicesByCategory>>> getByContainedName(String name) {
    // TODO: implement getByContainedName
    throw UnimplementedError();
  }
}
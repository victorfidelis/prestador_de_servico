import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class ServicesByCategoryService {
  final ServicesByCategoryRepository offlineRepository;
  
  ServicesByCategoryService({required this.offlineRepository});

  Future<Either<Failure, List<ServicesByCategory>>> getAll() async {
    return offlineRepository.getAll();
  }

  Future<Either<Failure, List<ServicesByCategory>>> getByContainedName(String name) async {
    return offlineRepository.getByContainedName(name);
  }
}
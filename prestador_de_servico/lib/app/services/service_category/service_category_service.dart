import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class ServiceCategoryService {
  final ServiceCategoryRepository offlineRepository;
  final ServiceCategoryRepository onlineRepository;

  ServiceCategoryService({
    required this.offlineRepository,
    required this.onlineRepository,
  });

  Future<Either<Failure, List<ServiceCategory>>> getAll() async {
    return await offlineRepository.getAll();
  }

  Future<Either<Failure, List<ServiceCategory>>> getNameContained({required String name}) async {
    return await offlineRepository.getNameContained(name: name);
  }

  Future<Either<Failure, Unit>> insert({required ServiceCategory serviceCategory}) async {
    final onlineInsertEither = await onlineRepository.insert(serviceCategory: serviceCategory);
    if (onlineInsertEither.isLeft) {
      return Either.left(onlineInsertEither.left);
    }

    serviceCategory = serviceCategory.copyWith(id: onlineInsertEither.right);
    final offlineInsertEither = await offlineRepository.insert(serviceCategory: serviceCategory);
    if (offlineInsertEither.isLeft) {
      return Either.left(offlineInsertEither.left);
    }

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> update({required ServiceCategory serviceCategory}) async {
    final onlineUpdateEither = await onlineRepository.update(serviceCategory: serviceCategory);
    if (onlineUpdateEither.isLeft) {
      return Either.left(onlineUpdateEither.left);
    }

    return await offlineRepository.update(serviceCategory: serviceCategory);
  }

  Future<Either<Failure, Unit>> delete({required ServiceCategory serviceCategory}) async {
    final onlineDeleteEither = await onlineRepository.deleteById(id: serviceCategory.id);
    if (onlineDeleteEither.isLeft) {
      return Either.left(onlineDeleteEither.left);
    }

    return await offlineRepository.deleteById(id: serviceCategory.id);
  }
}

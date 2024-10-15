import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class ServiceCategoryService {
  final ServiceCategoryRepository onlineServiceCategoryRepository;
  final ServiceCategoryRepository offlineServiceCategoryRepository;

  ServiceCategoryService({
    required this.onlineServiceCategoryRepository,
    required this.offlineServiceCategoryRepository,
  });

  Future<Either<Failure, List<ServiceCategory>>> getAll() async {
    return await offlineServiceCategoryRepository.getAll();
  }

  Future<Either<Failure, List<ServiceCategory>>> getNameContained({required String name}) async {
    return await offlineServiceCategoryRepository.getNameContained(name: name);
  }

  Future<Either<Failure, Unit>> insert({required ServiceCategory serviceCategory}) async {
    final onlineInsertEither = await onlineServiceCategoryRepository.insert(serviceCategory: serviceCategory);
    if (onlineInsertEither.isLeft) {
      return Either.left(onlineInsertEither.left);
    }

    serviceCategory = serviceCategory.copyWith(id: onlineInsertEither.right);
    final offlineInsertEither = await offlineServiceCategoryRepository.insert(serviceCategory: serviceCategory);
    if (offlineInsertEither.isLeft) {
      return Either.left(offlineInsertEither.left);
    }

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> update({required ServiceCategory serviceCategory}) async {
    final onlineUpdateEither = await onlineServiceCategoryRepository.update(serviceCategory: serviceCategory);
    if (onlineUpdateEither.isLeft) {
      return Either.left(onlineUpdateEither.left);
    }

    return await offlineServiceCategoryRepository.update(serviceCategory: serviceCategory);
  }

  Future<Either<Failure, Unit>> delete({required ServiceCategory serviceCategory}) async {
    final onlineDeleteEither = await onlineServiceCategoryRepository.deleteById(id: serviceCategory.id);
    if (onlineDeleteEither.isLeft) {
      return Either.left(onlineDeleteEither.left);
    }

    return await offlineServiceCategoryRepository.deleteById(id: serviceCategory.id);
  }
}

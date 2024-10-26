import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class ServiceService {
  ServiceRepository offlineRepository;
  ServiceRepository onlineRepository;

  ServiceService({
    required this.offlineRepository,
    required this.onlineRepository,
  });

  Future<Either<Failure, List<Service>>> getAll() async {
    return await offlineRepository.getAll();
  }

  Future<Either<Failure, List<Service>>> getByServiceCategoryId({required String serviceCategoryId}) async {
    return await offlineRepository.getByServiceCategoryId(serviceCategoryId: serviceCategoryId);
  }

  Future<Either<Failure, List<Service>>> getNameContained({required String name}) async {
    return await offlineRepository.getNameContained(name: name);
  }

  Future<Either<Failure, Unit>> insert({required Service service}) async {
    final insertOnlineEither = await onlineRepository.insert(service: service);
    if (insertOnlineEither.isLeft) {
      return Either.left(insertOnlineEither.left);
    } 

    service = service.copyWith(id: insertOnlineEither.right);
    final insertOfflineEither = await offlineRepository.insert(service: service);
    if (insertOfflineEither.isLeft) {
      return Either.left(insertOfflineEither.left);
    } 

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> update({required Service service}) async {
    final insertOnlineEither = await onlineRepository.update(service: service);
    if (insertOnlineEither.isLeft) {
      return Either.left(insertOnlineEither.left);
    } 

    return await offlineRepository.update(service: service);
  }
  
  Future<Either<Failure, Unit>> delete({required Service service}) async {
    final deleteOnlineEither = await onlineRepository.deleteById(id: service.id);
    if (deleteOnlineEither.isLeft) {
      return Either.left(deleteOnlineEither.left);
    }

    return await offlineRepository.deleteById(id: service.id);
  }
}

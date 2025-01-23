import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/network/network_helpers.dart';

class ServiceService {
  ServiceRepository offlineRepository;
  ServiceRepository onlineRepository;
  ImageRepository imageRepository;
  final NetworkHelpers networkHelpers = NetworkHelpers();

  ServiceService({
    required this.offlineRepository,
    required this.onlineRepository,
    required this.imageRepository,
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

  Future<Either<Failure, Service>> insert({required Service service}) async {
    final insertOnlineEither = await onlineRepository.insert(service: service);
    if (insertOnlineEither.isLeft) {
      return Either.left(insertOnlineEither.left);
    }

    service = service.copyWith(id: insertOnlineEither.right);
    final insertOfflineEither = await offlineRepository.insert(service: service);
    if (insertOfflineEither.isLeft) {
      return Either.left(insertOfflineEither.left);
    }

    // É necessário primeiro inserir o Service depois inserir a imagem
    // Após isso, atualizar o Service com a imagem inserida
    if (service.imageFile != null) { 
      final updateEither = await update(service: service);
      if (updateEither.isLeft) {
        return Either.left(updateEither.left);
      }
      service = updateEither.right!;
    }

    return Either.right(service);
  }

  Future<Either<Failure, Service>> update({required Service service}) async {
    if (service.imageFile != null) {
      final uploadImageEither =
          await imageRepository.uploadImage(imageFileName: service.imageName, imageFile: service.imageFile!);
      if (uploadImageEither.isLeft) {
        return Either.left(uploadImageEither.left);
      }
      service = service.copyWith(urlImage: uploadImageEither.right);
    }

    final insertOnlineEither = await onlineRepository.update(service: service);
    if (insertOnlineEither.isLeft) {
      return Either.left(insertOnlineEither.left);
    }

    final updateEither = await offlineRepository.update(service: service);
    if (updateEither.isLeft) {
      return Either.left(updateEither.left);
    }

    return Either.right(service);
  }

  Future<Either<Failure, Unit>> delete({required Service service}) async {
    if (service.imageUrl.isNotEmpty) {
      final deleteImageEither = await imageRepository.deleteImage(imageUrl: service.imageUrl);
      if (deleteImageEither.isLeft && deleteImageEither.left is! ImageNotFoundFailure ) {
        return Either.left(deleteImageEither.left!);
      }
    }

    final deleteOnlineEither = await onlineRepository.deleteById(id: service.id);
    if (deleteOnlineEither.isLeft) {
      return Either.left(deleteOnlineEither.left);
    }

    return await offlineRepository.deleteById(id: service.id);
  }
}

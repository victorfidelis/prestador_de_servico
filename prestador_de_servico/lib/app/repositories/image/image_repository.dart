import 'dart:io';

import 'package:prestador_de_servico/app/repositories/image/firebase_image_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

abstract class ImageRepository {

  factory ImageRepository.create() {
    return FirebaseImageRepository();
  }

  Future<Either<Failure, String>> uploadImage({required String imageFileName, required File imageFile});
  Future<Either<Failure, Unit>> deleteImage({required String imageUrl});
}
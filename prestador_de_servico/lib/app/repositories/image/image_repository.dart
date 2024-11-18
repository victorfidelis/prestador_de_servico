import 'dart:io';

import 'package:prestador_de_servico/app/repositories/image/firebase_image_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class ImageRepository {

  factory ImageRepository.create() {
    return FirebaseImageRepository();
  }

  Future<Either<Failure, String>> uploadImage(String imageFileName, File imageFile);
  Future<Either<Failure, Unit>> deleteImage(String imageUrl); 
}
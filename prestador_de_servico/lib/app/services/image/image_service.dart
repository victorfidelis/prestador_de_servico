
import 'dart:io';

import 'package:prestador_de_servico/app/services/image/image_service_impl.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class ImageService {
  factory ImageService.create() {
    return ImageServiceImpl();
  }

  Future<Either<Failure, File>> pickImageFromGallery();
}

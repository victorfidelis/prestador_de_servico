
import 'dart:io';

import 'package:prestador_de_servico/app/services/offline_image/offline_image_service_impl.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class OfflineImageService {
  factory OfflineImageService.create() {
    return OfflineImageServiceImpl();
  }

  Future<Either<Failure, File>> pickImageFromGallery();
}

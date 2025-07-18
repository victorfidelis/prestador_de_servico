import 'dart:io';

import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class OfflineImageServiceImpl implements OfflineImageService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<Either<Failure, File>> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return Either.right(File(image.path));
      } else {
        return Either.left(PickImageFailure('Nenhuma imagem foi selecionada.'));
      }
    } catch (e) {
      return Either.left(PickImageFailure('Erro ao acessar a galeria: $e'));
    }
  }
}

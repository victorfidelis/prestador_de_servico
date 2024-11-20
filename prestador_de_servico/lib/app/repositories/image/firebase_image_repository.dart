import 'dart:io';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImageRepository implements ImageRepository {
  final _storage = FirebaseStorage.instance;
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, Unit>> deleteImage({required String imageUrl}) async {
    try {
      final imageRef = _storage.refFromURL(imageUrl);
      await imageRef.delete();
      return Either.right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'storage/invalid-url' || e.code == 'storage/object-not-found') {
        return Either.left(UploadImageFailure('Imagem não encontrada'));
      } else if (e.code == 'storage/unauthorized') {
        return Either.left(UploadImageFailure('Usuário não autorizado a deletar imagem'));
      } else if (e.code == 'storage/canceled') {
        return Either.left(UploadImageFailure('Exclusão de imagem cancelada'));
      } else {
        return Either.left(UploadImageFailure('Falha ao deletar imagem'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage({
    required String imageFileName,
    required File imageFile,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    final imageRef = _storage.ref().child(imageFileName);
    try {
      final uploadTask = await imageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return Either.right(imageUrl);
    } on FirebaseException catch (e) {
      if (e.code == 'storage/unauthorized') {
        return Either.left(UploadImageFailure('Usuário não autorizado a salvar imagem'));
      } else if (e.code == 'storage/canceled') {
        return Either.left(UploadImageFailure('Gravação de imagem cancelada'));
      } else {
        return Either.left(UploadImageFailure('Falha ao gravar imagem'));
      }
    }
  }
}

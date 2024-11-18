import 'dart:io';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImageRepository implements ImageRepository {
  final storage = FirebaseStorage.instance;

  @override
  Future<Either<Failure, Unit>> deleteImage(String imageUrl) async {
    try{
      final imageRef = storage.refFromURL(imageUrl);
      await imageRef.delete();
      return Either.right(unit);
    } on FirebaseException catch(e) {
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
  Future<Either<Failure, String>> uploadImage(String imageFileName, File imageFile) async {
    final imageRef = storage.ref().child(imageFileName);
    try{
      await imageRef.putFile(imageFile);
      final imageUrl = await imageRef.getDownloadURL();
      return Either.right(imageUrl);
    } on FirebaseException catch(e) {
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

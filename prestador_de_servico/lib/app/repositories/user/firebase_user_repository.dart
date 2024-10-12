import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user_adapter.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class FirebaseUserRepository implements UserRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<Either<Failure, String>> insert({required User user}) async {
    try {
      DocumentReference docRef =
          await usersCollection.add(UserAdapter.toFirebaseMap(user: user));
      DocumentSnapshot docSnap = await docRef.get();
      return Either.right(docSnap.id);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a interner'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getById({required String id}) async {
    try {
      DocumentSnapshot docSnap = await usersCollection.doc(id).get();
      User user = UserAdapter.fromDocumentSnapshot(doc: docSnap);
      return Either.right(user);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a interner'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getByEmail({required String email}) async {
    try {
      QuerySnapshot querySnap =
          await usersCollection.where('email', isEqualTo: email).limit(1).get();

      if (querySnap.docs.isEmpty) {
        return Either.left(UserNotFoundFailure('Usuário não encontrado'));
      } else {
        User user = UserAdapter.fromDocumentSnapshot(doc: querySnap.docs[0]);
        return Either.right(user);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteById({required String id}) async {
    try {
      await usersCollection.doc(id).delete();
      return Either.right(unit);
    } on FirebaseException catch(e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a interner'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required User user}) async {
    try {
      await usersCollection
          .doc(user.id)
          .update(UserAdapter.toFirebaseMap(user: user));
      return Either.right(unit);
    } on FirebaseException catch(e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a interner'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
}

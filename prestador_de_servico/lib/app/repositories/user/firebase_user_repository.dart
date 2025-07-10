import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user_converter.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class FirebaseUserRepository implements UserRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, String>> insert({required User user}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }
    
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentReference docRef =
          await usersCollection.add(UserConverter.toFirebaseMap(user: user));
      DocumentSnapshot docSnap = await docRef.get();
      return Either.right(docSnap.id);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getById({required String id}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot docSnap = await usersCollection.doc(id).get();
      User user = UserConverter.fromDocumentSnapshot(doc: docSnap);
      return Either.right(user);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getByEmail({required String email}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }
    
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnap =
          await usersCollection.where('email', isEqualTo: email).limit(1).get();

      if (querySnap.docs.isEmpty) {
        return Either.left(UserNotFoundFailure('Usuário não encontrado'));
      } else {
        User user = UserConverter.fromDocumentSnapshot(doc: querySnap.docs[0]);
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
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }
    
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      await usersCollection.doc(id).delete();
      return Either.right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required User user}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }
    
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      await usersCollection
          .doc(user.id)
          .update(UserConverter.toFirebaseMap(user: user));
      return Either.right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<User>>> getClients() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final querySnap = await usersCollection.where('isAdmin', isEqualTo: false).get(); 
      final clients = querySnap.docs.map((doc) => UserConverter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(clients);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
}

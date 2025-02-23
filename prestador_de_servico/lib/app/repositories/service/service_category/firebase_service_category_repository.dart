import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_adapter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class FirebaseServiceCategoryRepository implements ServiceCategoryRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, List<ServiceCategory>>> getAll() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final colletion = FirebaseFirestore.instance.collection('serviceCategories');
      final querySnap = await colletion.where('isDeleted', isEqualTo: false).get();
      final serviceCategories = querySnap.docs.map((doc) => ServiceCartegoryAdapter.fromFirebase(doc)).toList();
      return Either.right(serviceCategories);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> getById({required String id}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final collection = FirebaseFirestore.instance.collection('serviceCategories');
      final docSnap = await collection.doc(id).get();
      final serviceCartegory = ServiceCartegoryAdapter.fromFirebase(docSnap);
      return Either.right(serviceCartegory);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getNameContained({required String name}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    final serviceCategoriesEither = await getAll();
    if (serviceCategoriesEither.isLeft) {
      return Either.left(serviceCategoriesEither.left);
    }

    final serviceCategories = serviceCategoriesEither.right!.where((serviceCategory) {
      String upperName = serviceCategory.name.trim().toUpperCase();
      String upperNameSearch = serviceCategory.name.trim().toUpperCase();
      return upperName.contains(upperNameSearch);
    }).toList();

    return Either.right(serviceCategories);
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getUnsync({required DateTime dateLastSync}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final collection = FirebaseFirestore.instance.collection('serviceCategories');
      final timestampLastSync = Timestamp.fromDate(dateLastSync);
      final querySnap = await collection.where('dateSync', isGreaterThan: timestampLastSync).get();
      final serviceCategories = querySnap.docs.map((doc) => ServiceCartegoryAdapter.fromFirebase(doc)).toList();
      return Either.right(serviceCategories);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> insert({required ServiceCategory serviceCategory}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final collection = FirebaseFirestore.instance.collection('serviceCategories');
      final docRef = await collection.add(ServiceCartegoryAdapter.toFirebaseMap(serviceCategory));
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
  Future<Either<Failure, Unit>> update({required ServiceCategory serviceCategory}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final collection = FirebaseFirestore.instance.collection('serviceCategories');
      await collection.doc(serviceCategory.id).update(ServiceCartegoryAdapter.toFirebaseMap(serviceCategory));
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
  Future<Either<Failure, Unit>> deleteById({required String id}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final collection = FirebaseFirestore.instance.collection('serviceCategories');
      final doc = collection.doc(id);
      var serviceCategory = ServiceCartegoryAdapter.fromFirebase(await doc.get());
      serviceCategory = serviceCategory.copyWith(isDeleted: true);
      await doc.update(ServiceCartegoryAdapter.toFirebaseMap(serviceCategory));
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
  Future<Either<Failure, bool>> existsById({required String id}) {
    throw UnimplementedError();
  }
}

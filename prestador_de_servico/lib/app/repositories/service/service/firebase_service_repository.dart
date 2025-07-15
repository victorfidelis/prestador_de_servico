import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_converter.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class FirebaseServiceRepository implements ServiceRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, List<Service>>> getAll() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      QuerySnapshot snapServices = await servicesCollection.where('isDeleted', isEqualTo: false).get();
      List<Service> services = snapServices.docs.map((doc) => ServiceConverter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(services);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getByServiceCategoryId({required String serviceCategoryId}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      QuerySnapshot snapServices = await servicesCollection
          .where('isDeleted', isEqualTo: false)
          .where('serviceCategoryId', isEqualTo: serviceCategoryId)
          .get();
      final services = snapServices.docs.map((doc) => ServiceConverter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(services);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Service>> getById({required String id}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      DocumentSnapshot docSnap = await servicesCollection.doc(id).get();
      Service service = ServiceConverter.fromDocumentSnapshot(doc: docSnap);
      return Either.right(service);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getNameContained({required String name}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    final servicesEither = await getAll();
    if (servicesEither.isLeft) {
      return Either.left(servicesEither.left);
    }

    final services = servicesEither.right!.where((service) {
      String upperName = service.name.trim().toUpperCase();
      String upperNameSearch = service.name.trim().toUpperCase();
      return upperName.contains(upperNameSearch);
    }).toList();
    return Either.right(services);
  }

  @override
  Future<Either<Failure, List<Service>>> getUnsync({required DateTime dateLastSync}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      final timestampLastSync = Timestamp.fromDate(dateLastSync);
      final snapService = await servicesCollection.where('dateSync', isGreaterThan: timestampLastSync).get();
      final services = snapService.docs.map((doc) => ServiceConverter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(services);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> insert({required Service service}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      final docRef = await servicesCollection.add(
        ServiceConverter.toFirebaseMap(
          service: service,
        ),
      );
      final docSnap = await docRef.get();
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
  Future<Either<Failure, Unit>> update({required Service service}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      await servicesCollection.doc(service.id).update(ServiceConverter.toFirebaseMap(service: service));
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
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      final doc = servicesCollection.doc(id);
      await doc.update({'isDeleted': true});
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
  Future<Either<Failure, Unit>> deleteByCategoryId(String serviceCategoryId) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final servicesCollection = FirebaseFirestore.instance.collection('services');
      final batch = FirebaseFirestore.instance.batch();

      final snapServices = await servicesCollection.where('serviceCategoryId', isEqualTo: serviceCategoryId).get();
      for (final doc in snapServices.docs) {
        batch.update(doc.reference, {'isDeleted': true});
      }

      await batch.commit();

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
    return Future.value(Either.left(Failure('Método não desenvolvido')));
  }
}

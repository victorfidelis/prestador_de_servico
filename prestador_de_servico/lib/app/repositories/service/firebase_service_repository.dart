import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service/service_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

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
      List<Service> services = snapServices.docs.map((doc) => ServiceAdapter.fromDocumentSnapshot(doc: doc)).toList();
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
      final services = snapServices.docs.map((doc) => ServiceAdapter.fromDocumentSnapshot(doc: doc)).toList();
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
      Service service = ServiceAdapter.fromDocumentSnapshot(doc: docSnap);
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
      final services = snapService.docs.map((doc) => ServiceAdapter.fromDocumentSnapshot(doc: doc)).toList();
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
        ServiceAdapter.toFirebaseMap(
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
      await servicesCollection.doc(service.id).update(ServiceAdapter.toFirebaseMap(service: service));
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
      var service = ServiceAdapter.fromDocumentSnapshot(doc: await doc.get());
      service = service.copyWith(isDeleted: true);
      await doc.update(ServiceAdapter.toFirebaseMap(service: service));
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class FirebaseServiceDayRepository implements ServiceDayRepository {
  final _firebaseInitializer = FirebaseInitializer();
  
  @override
  Future<Either<Failure, List<ServiceDay>>> getAll() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceDaysCollection = FirebaseFirestore.instance.collection('serviceDays');
      QuerySnapshot snapServiceDays = await serviceDaysCollection.where('isDeleted', isEqualTo: false).get();
      List<ServiceDay> serviceDays = snapServiceDays.docs.map((doc) => ServiceDayAdapter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(serviceDays);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required ServiceDay serviceDay}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceDaysCollection = FirebaseFirestore.instance.collection('serviceDays');
      await serviceDaysCollection.doc(serviceDay.id).update(ServiceDayAdapter.toFirebaseMap(serviceDay: serviceDay));
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
  Future<Either<Failure, Unit>> deleteById({required String id}) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, String>> insert({required ServiceDay serviceDay}) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<ServiceDay>>> getUnsync({required DateTime dateLastSync}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceDaysCollection = FirebaseFirestore.instance.collection('serviceDays');
      final timestampLastSync = Timestamp.fromDate(dateLastSync);
      final snapServiceDay = await serviceDaysCollection.where('dateSync', isGreaterThan: timestampLastSync).get();
      final serviceDays = snapServiceDay.docs.map((doc) => ServiceDayAdapter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(serviceDays);
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
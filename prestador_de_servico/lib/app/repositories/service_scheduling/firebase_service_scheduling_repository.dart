import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service_scheduling/service_scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class FirebaseServiceSchedulingRepository implements ServiceSchedulingRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, List<ServiceScheduling>>> getAllByDay({required DateTime dateTime}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    final startDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final endDate = startDate.add(const Duration(days: 1));

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
          .where('startDateAndTime', isGreaterThanOrEqualTo: startDate)
          .where('startDateAndTime', isLessThan: endDate)
          .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingAdapter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(serviceSchedules);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ServiceScheduling>>> getAllByUserId({required String userId}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
          .where('user.id', isEqualTo: userId)
          .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingAdapter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(serviceSchedules);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
  @override
  Future<Either<Failure, DateTime>> getDateOfFirstService() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
          .orderBy('startDateAndTime', descending: false)
          .limit(1)
          .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingAdapter.fromDocumentSnapshot(doc: doc)).toList();
      
      if (serviceSchedules.isEmpty) {
        return Either.left(NoServiceFailure('Nenhum serviço criado'));
      }
      return Either.right(serviceSchedules[0].startDateAndTime);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
  @override
  Future<Either<Failure, DateTime>> getDateOfLastService() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
          .orderBy('endDateAndTime', descending: true)
          .limit(1)
          .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingAdapter.fromDocumentSnapshot(doc: doc)).toList();
      
      if (serviceSchedules.isEmpty) {
        return Either.left(NoServiceFailure('Nenhum serviço criado'));
      }
      return Either.right(serviceSchedules[0].endDateAndTime);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
}

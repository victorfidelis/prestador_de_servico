import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day_converter.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling_converter.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class FirebaseSchedulingRepository implements SchedulingRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, List<ServiceScheduling>>> getAllServicesByDay({required DateTime dateTime}) async {
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
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromDocumentSnapshot(doc: doc)).toList();
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
  Future<Either<Failure, List<ServiceScheduling>>> getAllServicesByUserId({required String userId}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection.where('user.id', isEqualTo: userId).get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromDocumentSnapshot(doc: doc)).toList();
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
  Future<Either<Failure, List<SchedulingDay>>> getDaysWithService() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final schedulesPerDayCollection = FirebaseFirestore.instance.collection('schedulesPerDay');
      QuerySnapshot snapSchedulesPerDay = await schedulesPerDayCollection.get();
      List<SchedulingDay> schedulesPerDay =
          snapSchedulesPerDay.docs.map((doc) => SchedulingDayConverter.fromDocumentSnapshot(doc: doc)).toList();

      return Either.right(schedulesPerDay);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<ServiceScheduling>>> getPendingProviderSchedules() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection.where('serviceStatusCode', isEqualTo: 1).get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromDocumentSnapshot(doc: doc)).toList();
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
  Future<Either<Failure, List<ServiceScheduling>>> getPendingPaymentSchedules() async{
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
      .where('serviceStatusCode', whereIn: ServiceStatus.servicePerformStatusCodes)
      .where('isPaid', isEqualTo: false)
      .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(serviceSchedules);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
}

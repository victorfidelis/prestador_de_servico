import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day_converter.dart';
import 'package:prestador_de_servico/app/models/service/service_converter.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_image.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_image_converter.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling_converter.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class FirebaseSchedulingRepository implements SchedulingRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, ServiceScheduling>> getScheduling({required String schedulingId}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('serviceSchedules').doc(schedulingId);
      final scheduling = await docRef.get();
      return Either.right(ServiceSchedulingConverter.fromFirebaseDoc(doc: scheduling));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ServiceScheduling>>> getAllSchedulesByDay({required DateTime dateTime}) async {
    final startDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final endDate = startDate.add(const Duration(days: 1));

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
          .where('startDateAndTime', isGreaterThanOrEqualTo: startDate)
          .where('startDateAndTime', isLessThan: endDate)
          .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromFirebaseDoc(doc: doc)).toList();
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
  Future<Either<Failure, List<ServiceScheduling>>> getAllSchedulesByUserId({required String userId}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection.where('user.id', isEqualTo: userId).get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromFirebaseDoc(doc: doc)).toList();
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
  Future<Either<Failure, List<SchedulingDay>>> getDaysWithSchedules() async {
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
      QuerySnapshot snapServiceSchedules =
          await serviceSchedulesCollection.where('serviceStatusCode', isEqualTo: 1).get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromFirebaseDoc(doc: doc)).toList();
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
  Future<Either<Failure, List<ServiceScheduling>>> getPendingPaymentSchedules() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      QuerySnapshot snapServiceSchedules = await serviceSchedulesCollection
          .where('serviceStatusCode', isEqualTo: ServiceStatus.servicePerformCode)
          .where('isPaid', isEqualTo: false)
          .get();
      List<ServiceScheduling> serviceSchedules =
          snapServiceSchedules.docs.map((doc) => ServiceSchedulingConverter.fromFirebaseDoc(doc: doc)).toList();
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
  Future<Either<Failure, Unit>> editDateOfScheduling({
    required String schedulingId,
    required DateTime startDateAndTime,
    required DateTime endDateAndTime,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      final docRef = serviceSchedulesCollection.doc(schedulingId);

      final snapshot = await docRef.get();
      final map = snapshot.data() as Map<String, dynamic>;
      final DateTime oldStartDateAndTime = (map['startDateAndTime'] as Timestamp).toDate();
      final DateTime oldEndDateAndTime = (map['endDateAndTime'] as Timestamp).toDate();

      await removeSchedulingPerDay(oldStartDateAndTime);
      await addSchedulingPerDay(startDateAndTime);

      await docRef.update(ServiceSchedulingConverter.toEditDateAndTimeFirebaseMap(
        startDateAndTime: startDateAndTime,
        endDateAndTime: endDateAndTime,
        oldStartDateAndTime: oldStartDateAndTime,
        oldEndDateAndTime: oldEndDateAndTime,
      ));

      return Either.right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  Future<void> removeSchedulingPerDay(DateTime date) async {
    final String schedulesPerDayId = Formatters.formatDateISO8601(date);
    final schedulesPerDayCollection = FirebaseFirestore.instance.collection('schedulesPerDay');
    final docRef = schedulesPerDayCollection.doc(schedulesPerDayId);

    final snapshot = await docRef.get();
    final map = snapshot.data() as Map<String, dynamic>;
    int numberOfServices = (map['numberOfServices'] as int);
    numberOfServices -= 1;
    final bool hasService = numberOfServices > 0;

    await docRef.update({
      'hasService': hasService,
      'numberOfServices': numberOfServices,
    });
  }

  Future<void> addSchedulingPerDay(DateTime date) async {
    final String schedulesPerDayId = Formatters.formatDateISO8601(date);
    final schedulesPerDayCollection = FirebaseFirestore.instance.collection('schedulesPerDay');
    final docRef = schedulesPerDayCollection.doc(schedulesPerDayId);

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final map = snapshot.data() as Map<String, dynamic>;
      int numberOfServices = (map['numberOfServices'] as int);
      numberOfServices += 1;
      await docRef.update({
        'hasService': true,
        'numberOfServices': numberOfServices,
      });
    } else {
      await schedulesPerDayCollection.doc(schedulesPerDayId).set(
        {
          'hasService': true,
          'numberOfServices': 1,
        },
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> editServicesAndPrices({
    required String schedulingId,
    required double totalRate,
    required double totalDiscount,
    required double totalPrice,
    required List<ScheduledService> scheduledServices,
    required DateTime newEndDate,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final serviceSchedulesCollection = FirebaseFirestore.instance.collection('serviceSchedules');
      final docRef = serviceSchedulesCollection.doc(schedulingId);

      await docRef.update(
        ServiceSchedulingConverter.toEditServiceAndPricesFirebaseMap(
          totalRate: totalRate,
          totalDiscount: totalDiscount,
          totalPrice: totalPrice,
          scheduledServices: scheduledServices,
          newEndDate: newEndDate,
        ),
      );

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
  Future<Either<Failure, List<ServiceScheduling>>> getConflicts({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    var startDateTimestamp = Timestamp.fromDate(startDate);
    var endDateTimestamp = Timestamp.fromDate(endDate);

    try {
      final collection = FirebaseFirestore.instance.collection('serviceSchedules');

      final docs = await collection
          .where("startDateAndTime", isLessThan: endDateTimestamp)
          .where("endDateAndTime", isGreaterThan: startDateTimestamp)
          .get();

      var schedules = docs.docs.map((schedule) => ServiceSchedulingConverter.fromFirebaseDoc(doc: schedule)).toList();

      return Either.right(schedules);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> changeStatus({
    required String schedulingId,
    required int statusCode,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final statusRef = FirebaseFirestore.instance.collection('schedulingStatus').doc(statusCode.toString());
      final status = await statusRef.get();

      final docRef = FirebaseFirestore.instance.collection('serviceSchedules').doc(schedulingId);
      await docRef.update({
        'serviceStatusCode': statusCode,
        'serviceStatusName': status['name'],
      });

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
  Future<Either<Failure, Unit>> receivePayment({
    required String schedulingId,
    required double totalPaid,
    required bool isPaid,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('serviceSchedules').doc(schedulingId);
      await docRef.update({
        'isPaid': isPaid,
        'totalPaid': totalPaid,
      });

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
  Future<Either<Failure, Unit>> addOrEditReview({
    required String schedulingId,
    required int review,
    required String reviewDetails,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('serviceSchedules').doc(schedulingId);
      await docRef.update({
        'review': review,
        'reviewDetails': reviewDetails,
      });

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
  Future<Either<Failure, Unit>> addImage({required String schedulingId, required ServiceImage serviceImage}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('serviceSchedules').doc(schedulingId);
      final docSnap = await docRef.get();
      List<dynamic> existingImages = docSnap.get('images') ?? [];

      List<Map<String, dynamic>> imagesToSend = [];
      for (var item in existingImages) {
        if (item is Map<String, dynamic>) {
          imagesToSend.add(item);
        }
      }

      imagesToSend.add(ServiceImageConverter.toMap(serviceImage));

      await docRef.update({'images': imagesToSend});

      return Either.right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
}

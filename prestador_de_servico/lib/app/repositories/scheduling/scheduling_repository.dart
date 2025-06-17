import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/firebase_scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class SchedulingRepository {
  factory SchedulingRepository.createOnline() {
    return FirebaseSchedulingRepository();
  }

  Future<Either<Failure, Scheduling>> getScheduling({required String schedulingId});
  Future<Either<Failure, List<Scheduling>>> getAllSchedulesByDay(
      {required DateTime dateTime});
  Future<Either<Failure, List<Scheduling>>> getAllSchedulesByUserId(
      {required String userId});
  Future<Either<Failure, List<SchedulingDay>>> getDaysWithSchedules();
  Future<Either<Failure, List<Scheduling>>> getPendingProviderSchedules();
  Future<Either<Failure, List<Scheduling>>> getPendingPaymentSchedules();
  Future<Either<Failure, Unit>> editDateOfScheduling({
    required String schedulingId,
    required DateTime startDateAndTime,
    required DateTime endDateAndTime,
  });
  Future<Either<Failure, Unit>> editServicesAndPrices({
    required String schedulingId,
    required double totalRate,
    required double totalDiscount,
    required double totalPrice,
    required List<ScheduledService> scheduledServices,
    required DateTime newEndDate,
  });
  Future<Either<Failure, List<Scheduling>>> getConflicts({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<Either<Failure, Unit>> changeStatus({
    required String schedulingId,
    required int statusCode,
  });
  Future<Either<Failure, Unit>> receivePayment({
    required String schedulingId,
    required double totalPaid,
    required bool isPaid,
  });
  Future<Either<Failure, Unit>> addOrEditReview({
    required String schedulingId,
    required int review,
    required String reviewDetails,
  });
  Future<Either<Failure, Unit>> addImage({
    required String schedulingId,
    required String imageUrl,
    });
}

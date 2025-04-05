import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/firebase_scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class SchedulingRepository {
  factory SchedulingRepository.createOnline() {
    return FirebaseSchedulingRepository();
  }

  Future<Either<Failure, ServiceScheduling>> getScheduling({required String schedulingId});
  Future<Either<Failure, List<ServiceScheduling>>> getAllSchedulesByDay(
      {required DateTime dateTime});
  Future<Either<Failure, List<ServiceScheduling>>> getAllSchedulesByUserId(
      {required String userId});
  Future<Either<Failure, List<SchedulingDay>>> getDaysWithSchedules();
  Future<Either<Failure, List<ServiceScheduling>>> getPendingProviderSchedules();
  Future<Either<Failure, List<ServiceScheduling>>> getPendingPaymentSchedules();
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
  Future<Either<Failure, List<ServiceScheduling>>> getConflicts({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<Either<Failure, Unit>> changeStatus({
    required String schedulingId,
    required int statusCode,
  });
}

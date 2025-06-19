import 'dart:io';

import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class SchedulingService {
  final SchedulingRepository onlineRepository;
  final ImageRepository imageRepository;
  final daysToAdd = 90;

  SchedulingService({required this.onlineRepository, required this.imageRepository});

  Future<Either<Failure, Scheduling>> getScheduling({required String schedulingId}) async {
    final getEither = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    var scheduling = getEither.right!;
    if (!scheduling.serviceStatus.isPending()) {
      return Either.right(scheduling);
    }

    final conflictsEither = await onlineRepository.getConflicts(
      startDate: scheduling.startDateAndTime,
      endDate: scheduling.endDateAndTime,
    );
    if (conflictsEither.isLeft) {
      return Either.left(conflictsEither.left);
    }

    var schedules = conflictsEither.right!;
    schedules.removeWhere((schedule) => schedule.id == schedulingId);
    scheduling = scheduling.copyWith(
        conflictScheduing: schedules.isNotEmpty, schedulingUnavailable: isUnavailable(schedules));

    return Either.right(scheduling);
  }

  bool isUnavailable(List<Scheduling> schedules) {
    return schedules.where((s) => s.serviceStatus.isAccept()).isNotEmpty;
  }

  Future<Either<Failure, List<Scheduling>>> getAllServicesByDay({
    required DateTime dateTime,
  }) async {
    final getEither = await onlineRepository.getAllSchedulesByDay(dateTime: dateTime);
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    return Either.right(flagServicesWithConflictAndUnavailability(getEither.right!));
  }

  List<Scheduling> flagServicesWithConflictAndUnavailability(List<Scheduling> servicesSchedules) {
    for (int i = 0; i < servicesSchedules.length; i++) {
      final scheduling = servicesSchedules[i];
      if (!scheduling.serviceStatus.isPending()) {
        continue;
      }

      final listOfConflicts = servicesSchedules
          .where(
            (s) => (s.id != scheduling.id &&
                s.serviceStatus.causesConflict() &&
                s.startDateAndTime.compareTo(scheduling.endDateAndTime) <= 0 &&
                s.endDateAndTime.compareTo(scheduling.startDateAndTime) >= 0),
          )
          .toList();
      final conflictScheduing = listOfConflicts.isNotEmpty;

      final listOfUnavailable = servicesSchedules
          .where(
            (s) => (s.id != scheduling.id &&
                s.serviceStatus.isAccept() &&
                s.startDateAndTime.compareTo(scheduling.endDateAndTime) <= 0 &&
                s.endDateAndTime.compareTo(scheduling.startDateAndTime) >= 0),
          )
          .toList();
      final schedulingUnavailable = listOfUnavailable.isNotEmpty;
      servicesSchedules[i] = servicesSchedules[i].copyWith(
        conflictScheduing: conflictScheduing,
        schedulingUnavailable: schedulingUnavailable,
      );
    }

    return servicesSchedules;
  }

  Future<Either<Failure, List<Scheduling>>> getAllServicesByUserId({required String userId}) async {
    return await onlineRepository.getAllSchedulesByUserId(userId: userId);
  }

  Future<Either<Failure, List<SchedulingDay>>> getDates(DateTime selectedDay) async {
    final daysEither = await onlineRepository.getDaysWithSchedules();
    if (daysEither.isLeft) {
      return Either.left(daysEither.left);
    }

    final List<SchedulingDay> daysWithService = daysEither.right!;

    DateTime initialDate = extractFirstDate(daysWithService: daysWithService);
    DateTime finalDate = extractLastDate(daysWithService: daysWithService);

    return Either.right(
      getDatesFromInterval(
        daysWithService: daysWithService,
        selectedDay: selectedDay,
        firstDate: initialDate,
        lastDate: finalDate,
      ),
    );
  }

  DateTime extractFirstDate({required List<SchedulingDay> daysWithService}) {
    final actualDate = DateTime.now();
    DateTime initialDate;

    if (daysWithService.isEmpty) {
      initialDate = actualDate;
    } else {
      initialDate = daysWithService[0].date;
    }

    if (initialDate.compareTo(actualDate) > 0) {
      initialDate = actualDate;
    }

    initialDate = DateTime(initialDate.year, initialDate.month, initialDate.day);

    return initialDate;
  }

  DateTime extractLastDate({required List<SchedulingDay> daysWithService}) {
    final minimumFinalDate = DateTime.now().add(Duration(days: daysToAdd));
    DateTime finalDate;

    if (daysWithService.isEmpty) {
      finalDate = minimumFinalDate;
    } else {
      finalDate = daysWithService[daysWithService.length - 1].date;
    }

    if (finalDate.compareTo(minimumFinalDate) < 0) {
      finalDate = minimumFinalDate;
    }

    finalDate = DateTime(finalDate.year, finalDate.month, finalDate.day);

    return finalDate;
  }

  List<SchedulingDay> getDatesFromInterval({
    required List<SchedulingDay> daysWithService,
    required DateTime selectedDay,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    List<SchedulingDay> dates = [];

    final daysDifference = lastDate.difference(firstDate).inDays;
    for (int i = 0; i <= daysDifference; i++) {
      final date = firstDate.add(Duration(days: i));
      SchedulingDay schedulingDay;

      final index = daysWithService.indexWhere((d) => d.date == date);
      if (index < 0) {
        schedulingDay = SchedulingDay(
          date: date,
          isSelected: false,
          hasService: false,
          isToday: false,
          numberOfServices: 0,
        );
      } else {
        schedulingDay = daysWithService[index];
      }

      if (date.year == selectedDay.year && date.month == selectedDay.month && date.day == selectedDay.day) {
        schedulingDay = schedulingDay.copyWith(isSelected: true, isToday: true);
      }

      dates.add(schedulingDay);
    }

    return dates;
  }

  Future<Either<Failure, List<SchedulesByDay>>> getPendingProviderSchedules() async {
    final pendingProviderEither = await onlineRepository.getPendingProviderSchedules();
    if (pendingProviderEither.isLeft) {
      return Either.left(pendingProviderEither.left);
    }

    return Either.right(groupSchedulesByDay(pendingProviderEither.right!));
  }

  Future<Either<Failure, List<SchedulesByDay>>> getPendingPaymentSchedules() async {
    final pendingPaymentEither = await onlineRepository.getPendingPaymentSchedules();
    if (pendingPaymentEither.isLeft) {
      return Either.left(pendingPaymentEither.left);
    }

    return Either.right(groupSchedulesByDay(pendingPaymentEither.right!));
  }

  List<SchedulesByDay> groupSchedulesByDay(List<Scheduling> schedules) {
    schedules.sort((s1, s2) => s1.startDateAndTime.compareTo(s2.startDateAndTime));
    List<SchedulesByDay> schedulesByDays = [];
    for (Scheduling scheduling in schedules) {
      final day = DateTime(
        scheduling.startDateAndTime.year,
        scheduling.startDateAndTime.month,
        scheduling.startDateAndTime.day,
      );
      var index = schedulesByDays.indexWhere((s) => s.day == day);
      if (index == -1) {
        schedulesByDays.add(SchedulesByDay(day: day, schedules: []));
        index = schedulesByDays.length - 1;
      }
      schedulesByDays[index].schedules.add(scheduling);
    }
    return schedulesByDays;
  }

  Future<Either<Failure, Unit>> editDateOfScheduling({
    required String schedulingId,
    required DateTime startDateAndTime,
    required DateTime endDateAndTime,
  }) async {
    return await onlineRepository.editDateOfScheduling(
      schedulingId: schedulingId,
      startDateAndTime: startDateAndTime,
      endDateAndTime: endDateAndTime,
    );
  }

  Future<Either<Failure, Unit>> editServicesAndPricesOfScheduling({
    required String schedulingId,
    required double totalRate,
    required double totalDiscount,
    required double totalPrice,
    required List<ScheduledService> scheduledServices,
    required DateTime newEndDate,
  }) async {
    return await onlineRepository.editServicesAndPrices(
      schedulingId: schedulingId,
      totalRate: totalRate,
      totalDiscount: totalDiscount,
      totalPrice: totalPrice,
      scheduledServices: scheduledServices,
      newEndDate: newEndDate,
    );
  }

  DateTime calculateEndDate(List<ScheduledService> services, DateTime startDate) {
    int durationInMinutes = calculateDurationOfServiceInMinutes(services);
    return startDate.add(Duration(minutes: durationInMinutes));
  }

  int calculateDurationOfServiceInMinutes(List<ScheduledService> services) {
    int minutes = 0;
    services = services.where((service) => !service.removed).toList();
    for (Service service in services) {
      minutes += service.minutes;
      minutes += (service.hours * 60);
    }
    return minutes;
  }

  Future<Either<Failure, Unit>> confirmScheduling({required String schedulingId}) async {
    final either = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (either.isLeft) {
      return Either.left(either.left);
    }

    if (!either.right!.serviceStatus.isPending()) {
      return Either.left(Failure('Status do agendamento inválido.'));
    }

    return await onlineRepository.changeStatus(
      schedulingId: schedulingId,
      statusCode: ServiceStatus.confirmCode,
    );
  }

  Future<Either<Failure, Unit>> denyScheduling({required String schedulingId}) async {
    final either = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (either.isLeft) {
      return Either.left(either.left);
    }

    if (!either.right!.serviceStatus.isPending()) {
      return Either.left(Failure('Status do agendamento inválido.'));
    }

    return await onlineRepository.changeStatus(
      schedulingId: schedulingId,
      statusCode: ServiceStatus.deniedCode,
    );
  }

  Future<Either<Failure, Unit>> requestChangeScheduling({required String schedulingId}) async {
    final either = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (either.isLeft) {
      return Either.left(either.left);
    }

    if (!either.right!.serviceStatus.isPendingProvider()) {
      return Either.left(Failure('Status do agendamento inválido.'));
    }

    return await onlineRepository.changeStatus(
      schedulingId: schedulingId,
      statusCode: ServiceStatus.pendingClientCode,
    );
  }

  Future<Either<Failure, Unit>> cancelScheduling({required String schedulingId}) async {
    final either = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (either.isLeft) {
      return Either.left(either.left);
    }

    if (!either.right!.serviceStatus.allowCancel()) {
      return Either.left(Failure('Status do agendamento inválido.'));
    }

    return await onlineRepository.changeStatus(
      schedulingId: schedulingId,
      statusCode: ServiceStatus.canceledByProviderCode,
    );
  }

  Future<Either<Failure, Unit>> schedulingInService({required String schedulingId}) async {
    final either = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (either.isLeft) {
      return Either.left(either.left);
    }

    if (!either.right!.serviceStatus.isConfirm()) {
      return Either.left(Failure('Status do agendamento inválido.'));
    }

    return await onlineRepository.changeStatus(
      schedulingId: schedulingId,
      statusCode: ServiceStatus.inServiceCode,
    );
  }

  Future<Either<Failure, Unit>> performScheduling({required String schedulingId}) async {
    final either = await onlineRepository.getScheduling(schedulingId: schedulingId);
    if (either.isLeft) {
      return Either.left(either.left);
    }

    if (!either.right!.serviceStatus.isInService()) {
      return Either.left(Failure('Status do agendamento inválido.'));
    }

    return await onlineRepository.changeStatus(
      schedulingId: schedulingId,
      statusCode: ServiceStatus.servicePerformCode,
    );
  }

  Future<Either<Failure, Unit>> receivePayment({
    required String schedulingId,
    required double totalPaid,
    required bool isPaid,
  }) async {
    return onlineRepository.receivePayment(
      schedulingId: schedulingId,
      totalPaid: totalPaid,
      isPaid: isPaid,
    );
  }

  Future<Either<Failure, Unit>> addOrEditReview({
    required String schedulingId,
    required int review,
    required String reviewDetails,
  }) async {
    return await onlineRepository.addOrEditReview(
      schedulingId: schedulingId,
      review: review,
      reviewDetails: reviewDetails,
    );
  }

  Future<Either<Failure, String>> addImage({
    required String schedulingId,
    required File imageFile,
  }) async {
    final imageName = 'images/scheduling/$schedulingId/${DateTime.now().millisecondsSinceEpoch}.png';
    final uploadImageEither = await imageRepository.uploadImage(imageFileName: imageName, imageFile: imageFile);
    if (uploadImageEither.isLeft) {
      return Either.left(uploadImageEither.left);
    }
    final imageUrl = uploadImageEither.right!;
    final addImageEither =
        await onlineRepository.addImage(schedulingId: schedulingId, imageUrl: imageUrl);

    if (addImageEither.isLeft) {
      return Either.left(addImageEither.left!);
    } else {
      return Either.right(imageUrl);
    }
  }
  
  Future<Either<Failure, String>> removeImage({
    required String schedulingId,
    required String imageUrl,
  }) async {
    final deleteImageEither = await imageRepository.deleteImage(imageUrl: imageUrl);
    if (deleteImageEither.isLeft && deleteImageEither.left is! ImageNotFoundFailure ) {
      return Either.left(deleteImageEither.left!);
    }

    final removeImageEither =
        await onlineRepository.removeImage(schedulingId: schedulingId, imageUrl: imageUrl);

    if (removeImageEither.isLeft) {
      return Either.left(removeImageEither.left!);
    } else {
      return Either.right(imageUrl);
    }
  }
}

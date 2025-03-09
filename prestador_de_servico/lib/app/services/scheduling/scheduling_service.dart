import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class SchedulingService {
  final SchedulingRepository onlineRepository;
  final daysToAdd = 90;

  SchedulingService({required this.onlineRepository});

  Future<Either<Failure, List<ServiceScheduling>>> getAllServicesByDay(
      {required DateTime dateTime}) async {
    final getEither =
        await onlineRepository.getAllServicesByDay(dateTime: dateTime);
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    return Either.right(
        flagServicesWithConflictAndUnavailability(getEither.right!));
  }

  List<ServiceScheduling> flagServicesWithConflictAndUnavailability(
      List<ServiceScheduling> servicesSchedules) {
    for (int i = 0; i < servicesSchedules.length; i++) {
      final scheduling = servicesSchedules[i];
      if (!scheduling.serviceStatus.isPendingStatus()) {
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
                s.serviceStatus.isAcceptStatus() &&
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

  Future<Either<Failure, List<ServiceScheduling>>> getAllServicesByUserId(
      {required String userId}) async {
    return await onlineRepository.getAllServicesByUserId(userId: userId);
  }

  Future<Either<Failure, List<SchedulingDay>>> getDates(DateTime selectedDay) async {
    final daysEither = await onlineRepository.getDaysWithService();
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

    initialDate =
        DateTime(initialDate.year, initialDate.month, initialDate.day);

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

      if (date.year == selectedDay.year &&
          date.month == selectedDay.month &&
          date.day == selectedDay.day) {
        schedulingDay = schedulingDay.copyWith(isSelected: true, isToday: true);
      }

      dates.add(schedulingDay);
    }

    return dates;
  }

  Future<Either<Failure, List<SchedulesByDay>>>
      getPendingProviderSchedules() async {
    final pendingProviderEither =
        await onlineRepository.getPendingProviderSchedules();
    if (pendingProviderEither.isLeft) {
      return Either.left(pendingProviderEither.left);
    }

    return Either.right(groupSchedulesByDay(pendingProviderEither.right!));
  }

  Future<Either<Failure, List<SchedulesByDay>>>
      getPendingPaymentSchedules() async {
    final pendingPaymentEither =
        await onlineRepository.getPendingPaymentSchedules();
    if (pendingPaymentEither.isLeft) {
      return Either.left(pendingPaymentEither.left);
    }

    return Either.right(groupSchedulesByDay(pendingPaymentEither.right!));
  }

  List<SchedulesByDay> groupSchedulesByDay(
      List<ServiceScheduling> serviceSchedules) {
    serviceSchedules
        .sort((s1, s2) => s1.startDateAndTime.compareTo(s2.startDateAndTime));
    List<SchedulesByDay> schedulesByDays = [];
    for (ServiceScheduling serviceScheduling in serviceSchedules) {
      final day = DateTime(
        serviceScheduling.startDateAndTime.year,
        serviceScheduling.startDateAndTime.month,
        serviceScheduling.startDateAndTime.day,
      );
      var index = schedulesByDays.indexWhere((s) => s.day == day);
      if (index == -1) {
        schedulesByDays.add(SchedulesByDay(day: day, serviceSchedules: []));
        index = schedulesByDays.length - 1;
      }
      schedulesByDays[index].serviceSchedules.add(serviceScheduling);
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
}

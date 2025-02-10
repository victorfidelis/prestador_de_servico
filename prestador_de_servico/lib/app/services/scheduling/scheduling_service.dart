import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class SchedulingService {
  final SchedulingRepository onlineRepository;
  final daysToAdd = 90;

  SchedulingService({required this.onlineRepository});

  Future<Either<Failure, List<ServiceScheduling>>> getAllServicesByDay({required DateTime dateTime}) async {
    return await onlineRepository.getAllServicesByDay(dateTime: dateTime);
  }

  Future<Either<Failure, List<ServiceScheduling>>> getAllServicesByUserId({required String userId}) async {
    return await onlineRepository.getAllServicesByUserId(userId: userId);
  }

  Future<Either<Failure, List<SchedulingDay>>> getDates() async {
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
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    List<SchedulingDay> dates = [];
    DateTime actualDate = DateTime.now();

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

      if (date.year == actualDate.year && date.month == actualDate.month && date.day == actualDate.day) {
        schedulingDay = schedulingDay.copyWith(isSelected: true, isToday: true);
      }

      dates.add(schedulingDay);
    }

    return dates;
  }
}

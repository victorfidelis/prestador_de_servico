import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/repositories/service_scheduling/service_scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class ServiceSchedulingService {
  final ServiceSchedulingRepository onlineRepository;
  final daysToAdd = 90;

  ServiceSchedulingService({required this.onlineRepository});

  Future<Either<Failure, List<ServiceScheduling>>> getAllByDay({required DateTime dateTime}) async {
    return await onlineRepository.getAllByDay(dateTime: dateTime);
  }

  Future<Either<Failure, List<ServiceScheduling>>> getAllByUserId({required String userId}) async {
    return await onlineRepository.getAllByUserId(userId: userId);
  }

  Future<Either<Failure, List<DateTime>>> getDates() async {
    final initialDateEither = await getFirstDate();
    if (initialDateEither.isLeft) {
      return Either.left(initialDateEither.left);
    }
    final initialDate = initialDateEither.right!;

    final finalDateEither = await getLastDate();
    if (finalDateEither.isLeft) {
      return Either.left(finalDateEither.left);
    }
    final finalDate = finalDateEither.right!;

    return Either.right(getDatesFromInterval(
      firstDate: initialDate,
      lastDate: finalDate,
    ));
  }

  Future<Either<Failure, DateTime>> getFirstDate() async {
    final firstDateEither = await onlineRepository.getDateOfFirstService();

    if (firstDateEither.isLeft && firstDateEither.left is! NoServiceFailure) {
      return Either.left(firstDateEither.left);
    }

    final actualDate = DateTime.now();
    DateTime initialDate;

    if (firstDateEither.isLeft) {
      initialDate = actualDate;
    } else {
      initialDate = firstDateEither.right!;
    }

    if (initialDate.compareTo(actualDate) > 0) {
      initialDate = actualDate;
    }

    initialDate = DateTime(initialDate.year, initialDate.month, initialDate.day);

    return Either.right(initialDate);
  }

  Future<Either<Failure, DateTime>> getLastDate() async {
    final lastDateEither = await onlineRepository.getDateOfLastService();

    if (lastDateEither.isLeft && lastDateEither.left is! NoServiceFailure) {
      return Either.left(lastDateEither.left);
    }

    final minimumFinalDate = DateTime.now().add(Duration(days: daysToAdd));
    DateTime finalDate;

    if (lastDateEither.isLeft) {
      finalDate = minimumFinalDate;
    } else {
      finalDate = lastDateEither.right!;
    }

    if (finalDate.compareTo(minimumFinalDate) < 0) {
      finalDate = minimumFinalDate;
    }

    finalDate = DateTime(finalDate.year, finalDate.month, finalDate.day);

    return Either.right(finalDate);
  }

  List<DateTime> getDatesFromInterval({
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    List<DateTime> dates = [];

    final daysDifference = lastDate.difference(firstDate).inDays;
    for (int i = 0; i <= daysDifference; i++) {
      final date = firstDate.add(Duration(days: i));
      dates.add(date);
    }

    return dates;
  }
}

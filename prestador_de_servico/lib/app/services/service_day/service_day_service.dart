import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/utils/network/network_helpers.dart';

class ServiceDayService {
  ServiceDayRepository offlineRepository;
  ServiceDayRepository onlineRepository;
  final NetworkHelpers networkHelpers = NetworkHelpers();

  ServiceDayService({
    required this.offlineRepository,
    required this.onlineRepository,
  });

  Future<Either<Failure, List<ServiceDay>>> getAll() async {
    return await offlineRepository.getAll();
  }


  Future<Either<Failure, ServiceDay>> update({required ServiceDay serviceDay}) async {
    final updateOnlineEither = await onlineRepository.update(serviceDay: serviceDay);
    if (updateOnlineEither.isLeft) {
      return Either.left(updateOnlineEither.left);
    }

    final updateEither = await offlineRepository.update(serviceDay: serviceDay);
    if (updateEither.isLeft) {
      return Either.left(updateEither.left);
    }

    return Either.right(serviceDay);
  }
}
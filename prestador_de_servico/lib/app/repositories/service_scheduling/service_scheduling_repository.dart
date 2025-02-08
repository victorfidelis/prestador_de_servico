import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/repositories/service_scheduling/firebase_service_scheduling_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class ServiceSchedulingRepository {

  factory ServiceSchedulingRepository.createOnline() {
    return FirebaseServiceSchedulingRepository();
  }

  Future<Either<Failure, List<ServiceScheduling>>> getAllByDay({required DateTime dateTime});
  Future<Either<Failure, List<ServiceScheduling>>> getAllByUserId({required String userId});
  Future<Either<Failure, DateTime>> getDateOfFirstService();
  Future<Either<Failure, DateTime>> getDateOfLastService();
}
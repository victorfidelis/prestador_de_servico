
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/repositories/service_day/firebase_service_day_repository.dart';
import 'package:prestador_de_servico/app/repositories/service_day/sqlflite_service_day_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class ServiceDayRepository {

  factory ServiceDayRepository.createOffline() {
    return SqfliteServiceDayRepository();
  }

  factory ServiceDayRepository.createOnline() {
    return FirebaseServiceDayRepository();
  }

  Future<Either<Failure, List<ServiceDay>>> getAll();
  Future<Either<Failure, List<ServiceDay>>> getUnsync({required DateTime dateLastSync});
  Future<Either<Failure, String>> insert({required ServiceDay serviceDay});
  Future<Either<Failure, Unit>> update({required ServiceDay serviceDay});
  Future<Either<Failure, Unit>> deleteById({required String id});
  Future<Either<Failure, bool>> existsById({required String id});
}


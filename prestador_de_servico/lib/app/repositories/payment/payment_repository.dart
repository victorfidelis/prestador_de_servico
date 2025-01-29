
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<Payment>>> getAll();
  Future<Either<Failure, Unit>> update({required Payment payment});
  Future<Either<Failure, Unit>> deleteById({required String id});
}



import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/repositories/payment/firebase_payment_repository.dart';
import 'package:prestador_de_servico/app/repositories/payment/sqflite_payment_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class PaymentRepository {

  factory PaymentRepository.createOffline() {
    return SqflitePaymentRepository();
  }

  factory PaymentRepository.createOnline() {
    return FirebasePaymentRepository();
  }

  Future<Either<Failure, List<Payment>>> getAll();
  Future<Either<Failure, List<Payment>>> getUnsync({required DateTime dateLastSync});
  Future<Either<Failure, String>> insert({required Payment payment});
  Future<Either<Failure, Unit>> update({required Payment payment});
  Future<Either<Failure, Unit>> deleteById({required String id});
  Future<Either<Failure, bool>> existsById({required String id});
}


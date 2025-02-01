import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/network/network_helpers.dart';

class PaymentService {
  PaymentRepository offlineRepository;
  PaymentRepository onlineRepository;
  final NetworkHelpers networkHelpers = NetworkHelpers();

  PaymentService({
    required this.offlineRepository,
    required this.onlineRepository,
  });

  Future<Either<Failure, List<Payment>>> getAll() async {
    return await offlineRepository.getAll();
  }


  Future<Either<Failure, Payment>> update({required Payment payment}) async {
    final updateOnlineEither = await onlineRepository.update(payment: payment);
    if (updateOnlineEither.isLeft) {
      return Either.left(updateOnlineEither.left);
    }

    final updateEither = await offlineRepository.update(payment: payment);
    if (updateEither.isLeft) {
      return Either.left(updateEither.left);
    }

    return Either.right(payment);
  }
}
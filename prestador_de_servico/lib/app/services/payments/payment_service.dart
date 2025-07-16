import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';
import 'package:prestador_de_servico/app/shared/utils/network/network_helpers.dart';

class PaymentService {
  PaymentRepository offlineRepository;
  PaymentRepository onlineRepository;
  final NetworkHelpers networkHelpers = NetworkHelpers();

  PaymentService({
    required this.offlineRepository,
    required this.onlineRepository,
  });

  Future<Either<Failure, List<Payment>>> getAll() async {
    final paymentEither = await offlineRepository.getAll();
    if (paymentEither.isLeft) {
      return Either.left(paymentEither.left);
    }
    final payments = paymentEither.right!;

    payments.sort((p1, p2) {
      if (p1.paymentType.index > p2.paymentType.index) {
        return 1;
      }
      if (p1.paymentType.index < p2.paymentType.index) {
        return -1;
      }
      return 0;
    });

    return Either.right(payments);
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

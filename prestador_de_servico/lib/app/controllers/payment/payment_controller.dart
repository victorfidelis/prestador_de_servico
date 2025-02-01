import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/payment/payment_state.dart';

class PaymentController extends ChangeNotifier {
  final PaymentService paymentService;

  PaymentState _state = PaymentInitial();
  PaymentState get state => _state;
  void _emitState(PaymentState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(PaymentState currentState) {
    _state = currentState;
  }

  PaymentController({required this.paymentService});

  Future<void> load() async {
    _emitState(PaymentLoading());

    final getAllEither = await paymentService.getAll();
    if (getAllEither.isLeft) {
      _emitState(PaymentError(getAllEither.left!.message));
      return;
    }

    _emitState(PaymentLoaded(payments: getAllEither.right!));
  }

  Future<void> update({required Payment payment}) async {
    if (_state is! PaymentLoaded) {
      return;
    }

    final updateEither = await paymentService.update(payment: payment);
    if (updateEither.isRight) {
      final payments = (_state as PaymentLoaded).payments;
      final paymentIndex = payments.indexWhere((p) => p.id == payment.id);
      payments[paymentIndex] = payment;
      _changeState(PaymentLoaded(payments: payments));
      return;
    }

    final getAllEither = await paymentService.getAll();
    if (getAllEither.isLeft) {
      _emitState(PaymentError(updateEither.left!.message));
      return;
    }

    _emitState(PaymentLoaded(
      payments: getAllEither.right!,
      message: updateEither.left!.message,
    ));
  }
}

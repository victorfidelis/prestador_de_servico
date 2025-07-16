import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentService paymentService;
  List<Payment> payments = [];

  bool paymentLoading = false;

  String? errorMessage;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);

  PaymentViewModel({required this.paymentService});

  @override
  void dispose() {
    notificationMessage.dispose();
    super.dispose();
  }
  
  bool get hasError => errorMessage != null;

  void _setPaymentLoading(bool value) {
    paymentLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // É necessário para garantir o ValueNotifier vai notificar os ouvintes
    notificationMessage.value = value;
  }

  Future<void> load() async {
    _setPaymentLoading(true);

    final getAllEither = await paymentService.getAll();
    if (getAllEither.isLeft) {
      errorMessage = getAllEither.left!.message;
    } else {
      payments = getAllEither.right!;
    }

    _setPaymentLoading(false);
  }

  Future<void> update({required Payment payment}) async {
    if (paymentLoading) {
      return;
    }

    final updateEither = await paymentService.update(payment: payment);
    if (updateEither.isRight) {
      final paymentIndex = payments.indexWhere((p) => p.id == payment.id);
      payments[paymentIndex] = payment;
      return;
    }

    _setNotificationMessage(updateEither.left!.message);
    final getAllEither = await paymentService.getAll();
    if (getAllEither.isLeft) {
      errorMessage = updateEither.left!.message;
    } else {
      payments = getAllEither.right!;
    }

    notifyListeners();
  }
}

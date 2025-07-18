import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class PaymentSchedulingViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  final Scheduling scheduling;

  bool paymentLoading = false;

  final valueToPayController = TextEditingController();
  double valueToPay = 0;
  
  ValueNotifier<bool> paymentSuccess = ValueNotifier(false);
  ValueNotifier<String?> notificationMessage = ValueNotifier(null); 
  
  ValueNotifier<String?> valueToPayError = ValueNotifier(null);

  PaymentSchedulingViewModel({
    required this.schedulingService,
    required this.scheduling,
  });

  void _setPaymentLoading(bool value) {
    paymentLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // Necessário para garantir que o ValueNotifier notifique os ouvintes
    notificationMessage.value = value;
  }

  setValueToPay() {
    var valueToPay = valueToPayController.text.trim().replaceAll(',', '.');
    if (valueToPay.isEmpty) {
      valueToPay = '0';
    }
    this.valueToPay = double.parse(valueToPay);
  }

  bool validate() {
    _clearErrors();
    bool isValid = true; 

    if (valueToPay <= 0) {
      valueToPayError.value = 'Valor inválido';
      isValid = false;
    }

    return isValid;
  }

  Future<void> receivePayment() async {
    _setPaymentLoading(true);

    final totalPaid = scheduling.totalPaid + valueToPay;
    final isPaid = (totalPaid >= scheduling.totalPriceCalculated);

    final either = await schedulingService.receivePayment(
      schedulingId: scheduling.id,
      totalPaid: totalPaid,
      isPaid: isPaid,
    );

    if (either.isLeft) {
      _setNotificationMessage(either.left!.message);
    } else {
      _setNotificationMessage('Pagamento recebido com sucesso!');
      paymentSuccess.value = true;
    }

    _setPaymentLoading(false);
  } 

  _clearErrors() {
    valueToPayError.value = null;
  }
}

import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/payment_scheduling_state.dart';

class PaymentSchedulingViewModel extends ChangeNotifier {
  PaymentSchedulingViewModel({
    required this.schedulingService,
    required this.scheduling,
  });

  final SchedulingService schedulingService;
  final Scheduling scheduling;

  double valueToPay = 0;
  ValueNotifier<String?> valueToPayError = ValueNotifier(null);

  PaymentSchedulingState _state = PaymentInitial();
  PaymentSchedulingState get state => _state;
  void _emitState(PaymentSchedulingState currentState) {
    _state = currentState;
    notifyListeners();
  }

  setValueToPay(double value) {
    valueToPay = value;
  }

  bool validate() {
    bool isValid = true;
    if (valueToPay <= 0) {
      valueToPayError.value = 'Valor inválido';
      isValid = false;
    }
    return isValid;
  }

  Future<void> receivePayment() async {
    _emitState(PaymentLoading());

    final totalPaid = scheduling.totalPaid + valueToPay;
    final isPaid = (totalPaid >= scheduling.totalPriceCalculated);

    final either = await schedulingService.receivePayment(
      schedulingId: scheduling.id,
      totalPaid: totalPaid,
      isPaid: isPaid,
    ); 

    if (either.isLeft) {
      _emitState(PaymentError(message: either.left!.message));
    } else {
      _emitState(PaymentSuccess());
    }
  }
}

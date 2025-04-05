import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/payment_scheduling_state.dart';

class PaymentSchedulingViewModel extends ChangeNotifier {
  
  PaymentSchedulingState _state = PaymentInitial();
  PaymentSchedulingState get state => _state;
  void _emitState(PaymentSchedulingState currentState) {
    _state = currentState;
    notifyListeners();
  }  
}
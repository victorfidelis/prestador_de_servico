

import 'package:prestador_de_servico/app/models/payment/payment.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentLoaded extends PaymentState {
  final List<Payment> payments;
  final String message;

  PaymentLoaded({required this.payments, this.message = ''});
}

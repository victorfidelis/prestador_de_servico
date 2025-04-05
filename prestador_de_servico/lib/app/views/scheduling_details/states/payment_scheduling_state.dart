abstract class PaymentSchedulingState {}

class PaymentInitial extends PaymentSchedulingState {}

class PaymentLoading extends PaymentSchedulingState {}

class PaymentError extends PaymentSchedulingState { 
  final String message;

  PaymentError({required this.message});
}

class PaymentSuccess extends PaymentSchedulingState {}
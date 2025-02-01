

import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';

import 'mock_payment_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<PaymentRepository>()])

late MockPaymentRepository offlineMockPaymentRepository;
late MockPaymentRepository onlineMockPaymentRepository;
void setUpMockPaymentRepository() {
  offlineMockPaymentRepository = MockPaymentRepository();
  onlineMockPaymentRepository = MockPaymentRepository();
}


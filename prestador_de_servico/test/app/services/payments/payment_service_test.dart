import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/payment/mock_payment_repository.dart';

void main() {
  late PaymentService paymentService;

  late Payment payment1;

  setUpValues() {
    payment1 = Payment(
      id: '1',
      paymentType: PaymentType.money,
      name: 'Dinheiro',
      urlIcon: '',
      isActive: true,
    );
  }

  setUp(
    () {
      setUpMockPaymentRepository();
      paymentService = PaymentService(
        offlineRepository: offlineMockPaymentRepository,
        onlineRepository: onlineMockPaymentRepository,
      );
      setUpValues();
    },
  );

  group(
    'update',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final updateEither = await paymentService.update(payment: payment1);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is NetworkFailure, isTrue);
          final state = (updateEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockPaymentRepository.update(payment: payment1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final updateEither = await paymentService.update(payment: payment1);

          expect(updateEither.isLeft, isTrue);
          expect(updateEither.left is GetDatabaseFailure, isTrue);
          final state = (updateEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Payment quando a alteração do pagamento for feita com sucesso''',
        () async {
          when(onlineMockPaymentRepository.update(payment: payment1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockPaymentRepository.update(payment: payment1)).thenAnswer((_) async => Either.right(unit));

          final insertEither = await paymentService.update(payment: payment1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Payment, isTrue);
          expect(insertEither.right, equals(payment1));
        },
      );
    },
  );
}

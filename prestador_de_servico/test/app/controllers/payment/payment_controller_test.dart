import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/payment/payment_controller.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/payment/payment_state.dart';

import '../../../helpers/payment/mock_payment_repository.dart';

void main() {
  late PaymentController paymentController;

  late Payment payment1;
  late Payment payment2;
  late Payment payment3;
  late Payment payment4;
  late Payment payment5;
  late Payment payment6;
  
  late Payment payment1Disable;

  setUpValues() {
    payment1 = Payment(
      id: '1',
      paymentType: PaymentType.money,
      name: 'Dinheiro',
      urlIcon: '',
      isActive: true,
    );
    payment2 = Payment(
      id: '2',
      paymentType: PaymentType.pix,
      name: 'Pix',
      urlIcon: '',
      isActive: true,
    );
    payment3 = Payment(
      id: '3',
      paymentType: PaymentType.creditCard,
      name: 'Cartão de crédito',
      urlIcon: '',
      isActive: true,
    );
    payment4 = Payment(
      id: '4',
      paymentType: PaymentType.debitCard,
      name: 'Cartão de débito',
      urlIcon: '',
      isActive: true,
    );
    payment5 = Payment(
      id: '5',
      paymentType: PaymentType.ticket,
      name: 'Vale',
      urlIcon: '',
      isActive: true,
    );
    payment6 = Payment(
      id: '6',
      paymentType: PaymentType.other,
      name: 'Outro',
      urlIcon: '',
      isActive: true,
    );
    
    payment1Disable = Payment(
      id: '1',
      paymentType: PaymentType.money,
      name: 'Dinheiro',
      urlIcon: '',
      isActive: false,
    );
  }

  setUp(
    () {
      setUpMockPaymentRepository();
      final PaymentService paymentService = PaymentService(
        offlineRepository: offlineMockPaymentRepository,
        onlineRepository: onlineMockPaymentRepository,
      );
      paymentController = PaymentController(paymentService: paymentService);
      setUpValues();
    },
  );

  
  group(
    'load',
    () {
      test(
        '''Deve alterar o estado para PaymentError e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await paymentController.load();

          expect(paymentController.state is PaymentError, isTrue);
          final state = paymentController.state as PaymentError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para PaymentLoaded com uma lista de Payment vazia
        quando nenhum Payment estiver configurado.''',
        () async {
          final payments = <Payment>[];

          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));

          await paymentController.load();

          expect(paymentController.state is PaymentLoaded, isTrue);
          final paymentState = paymentController.state as PaymentLoaded;
          expect(paymentState.payments.isEmpty, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para PaymentLoaded com um lista de Payment preenchida
        quando algum Payment estiver cadastrado.''',
        () async {
          final payments = <Payment>[
            payment1,
            payment2,
            payment3,
            payment4,
            payment5,
            payment6,
          ];

          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));

          await paymentController.load();

          expect(paymentController.state is PaymentLoaded, isTrue);
          final paymentState = paymentController.state as PaymentLoaded;
          expect(paymentState.payments.length, equals(payments.length));
        },
      );
    },
  );

  group(
    'update',
    () {
      test(
        '''Deve manter o estado atual caso o mesmo nao seja Paymentloaded''',
        () async {
          await paymentController.update(payment: payment1);

          expect(paymentController.state is PaymentInitial, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para PaymentLoaded e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository.''',
        () async {
          const failureMessage = 'Teste de falha';
          
          final payments = <Payment>[
            payment1,
            payment2,
            payment3,
            payment4,
            payment5,
            payment6,
          ];
          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));
          await paymentController.load();

          when(onlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(offlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
            
          await paymentController.update(payment: payment1);

          expect(paymentController.state is PaymentLoaded, isTrue);
          final state = paymentController.state as PaymentLoaded;
          expect(state.payments.length, equals(payments.length));
          expect(state.message, equals(failureMessage));
        },
      );
      
      test(
        '''Deve alterar o estado para PaymentError e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository do update e na consulta.''',
        () async {
          const failureMessageUpdate = 'Teste de falha update';
          const failureMessageGetAll = 'Teste de falha get all';          
          final payments = <Payment>[
            payment1,
            payment2,
            payment3,
            payment4,
            payment5,
            payment6,
          ];
          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));
          await paymentController.load();

          when(onlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(Failure(failureMessageUpdate)));
          when(offlineMockPaymentRepository.update(payment: payment1))
              .thenAnswer((_) async => Either.left(Failure(failureMessageUpdate)));

          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessageGetAll)));
            
          await paymentController.update(payment: payment1);

          expect(paymentController.state is PaymentError, isTrue);
          final state = paymentController.state as PaymentError;
          expect(state.message, equals(failureMessageUpdate));
        },
      );
      
      test(
        '''Deve alterar o Payment corresponte no estado atual''',
        () async {        
          final payments = <Payment>[
            payment1,
            payment2,
            payment3,
            payment4,
            payment5,
            payment6,
          ];
          when(offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));
          await paymentController.load();

          when(onlineMockPaymentRepository.update(payment: payment1Disable))
              .thenAnswer((_) async => Either.right(unit));
          when(offlineMockPaymentRepository.update(payment: payment1Disable))
              .thenAnswer((_) async => Either.right(unit));
            
          await paymentController.update(payment: payment1Disable);

          expect(paymentController.state is PaymentLoaded, isTrue);
          final state = (paymentController.state as PaymentLoaded);
          expect(state.payments[0] == payment1, isFalse);
          expect(state.payments[0] == payment1Disable, isTrue);
        },
      );
      
    }
  );
}

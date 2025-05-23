import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/views/payment/viewmodels/payment_viewmodel.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/payment/states/payment_state.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  final offlineMockPaymentRepository = MockPaymentRepository();
  final onlineMockPaymentRepository = MockPaymentRepository();
  late PaymentViewModel paymentViewModel;
  late Payment payment1;
  late Payment payment2;
  late Payment payment3;
  late Payment payment4;
  late Payment payment5;
  late Payment payment6;

  late Payment payment1Disable;

  setUp(
    () {
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
      final paymentService = PaymentService(
        offlineRepository: offlineMockPaymentRepository,
        onlineRepository: onlineMockPaymentRepository,
      );
      paymentViewModel = PaymentViewModel(paymentService: paymentService);
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
          when(() => offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await paymentViewModel.load();

          expect(paymentViewModel.state is PaymentError, isTrue);
          final state = paymentViewModel.state as PaymentError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para PaymentLoaded com uma lista de Payment vazia
        quando nenhum Payment estiver configurado.''',
        () async {
          final payments = <Payment>[];

          when(() => offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));

          await paymentViewModel.load();

          expect(paymentViewModel.state is PaymentLoaded, isTrue);
          final paymentState = paymentViewModel.state as PaymentLoaded;
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

          when(() => offlineMockPaymentRepository.getAll())
              .thenAnswer((_) async => Either.right(payments));

          await paymentViewModel.load();

          expect(paymentViewModel.state is PaymentLoaded, isTrue);
          final paymentState = paymentViewModel.state as PaymentLoaded;
          expect(paymentState.payments.length, equals(payments.length));
        },
      );
    },
  );

  group('update', () {
    test(
      '''Deve manter o estado atual caso o mesmo nao seja Paymentloaded''',
      () async {
        await paymentViewModel.update(payment: payment1);

        expect(paymentViewModel.state is PaymentInitial, isTrue);
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
        when(() => offlineMockPaymentRepository.getAll())
            .thenAnswer((_) async => Either.right(payments));
        await paymentViewModel.load();

        when(() => onlineMockPaymentRepository.update(payment: payment1))
            .thenAnswer((_) async => Either.left(Failure(failureMessage)));
        when(() => offlineMockPaymentRepository.update(payment: payment1))
            .thenAnswer((_) async => Either.left(Failure(failureMessage)));

        await paymentViewModel.update(payment: payment1);

        expect(paymentViewModel.state is PaymentLoaded, isTrue);
        final state = paymentViewModel.state as PaymentLoaded;
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
        when(() => offlineMockPaymentRepository.getAll())
            .thenAnswer((_) async => Either.right(payments));
        await paymentViewModel.load();

        when(() => onlineMockPaymentRepository.update(payment: payment1))
            .thenAnswer((_) async => Either.left(Failure(failureMessageUpdate)));
        when(() => offlineMockPaymentRepository.update(payment: payment1))
            .thenAnswer((_) async => Either.left(Failure(failureMessageUpdate)));

        when(() => offlineMockPaymentRepository.getAll())
            .thenAnswer((_) async => Either.left(Failure(failureMessageGetAll)));

        await paymentViewModel.update(payment: payment1);

        expect(paymentViewModel.state is PaymentError, isTrue);
        final state = paymentViewModel.state as PaymentError;
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
        when(() => offlineMockPaymentRepository.getAll())
            .thenAnswer((_) async => Either.right(payments));
        await paymentViewModel.load();

        when(() => onlineMockPaymentRepository.update(payment: payment1Disable))
            .thenAnswer((_) async => Either.right(unit));
        when(() => offlineMockPaymentRepository.update(payment: payment1Disable))
            .thenAnswer((_) async => Either.right(unit));

        await paymentViewModel.update(payment: payment1Disable);

        expect(paymentViewModel.state is PaymentLoaded, isTrue);
        final state = (paymentViewModel.state as PaymentLoaded);
        expect(state.payments[0] == payment1, isFalse);
        expect(state.payments[0] == payment1Disable, isTrue);
      },
    );
  });
}

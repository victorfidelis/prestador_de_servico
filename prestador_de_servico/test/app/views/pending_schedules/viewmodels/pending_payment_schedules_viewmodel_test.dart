import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_payment_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';

import '../../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late PendingPaymentSchedulesViewModel pendingPaymentSchedulesViewModel;

  void setUpValues() {
    pendingPaymentSchedulesViewModel = PendingPaymentSchedulesViewModel(
      schedulingService: SchedulingService(
        onlineRepository: onlineMockSchedulingRepository,
      ),
    );
  }

  setUp(() {
    setUpMockServiceSchedulingRepository();
    setUpValues();
  });

  group(
    'load',
    () {
      test(
        '''Deve alterar o estado para PendingPaymentError quando um erro for retornado
      pelo service''',
        () async {
          const failureMessage = 'Teste de falha';

          when(onlineMockSchedulingRepository.getPendingPaymentSchedules())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await pendingPaymentSchedulesViewModel.load();

          expect(pendingPaymentSchedulesViewModel.state is PendingError, isTrue);
          final state = (pendingPaymentSchedulesViewModel.state as PendingError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para PendingPaymentLoaded quando o service retornar os dados''',
        () async {
          final List<ServiceScheduling> serviceSchedules = [];

          when(onlineMockSchedulingRepository.getPendingPaymentSchedules())
              .thenAnswer((_) async => Either.right(serviceSchedules));

          await pendingPaymentSchedulesViewModel.load();

          expect(pendingPaymentSchedulesViewModel.state is PendingLoaded, isTrue);
        },
      );
    },
  );

  group(
    'exit',
    () {
      test(
        '''Deve alterar o estado para PendingPaymentInitial''',
        () {
          pendingPaymentSchedulesViewModel.exit();

          expect(pendingPaymentSchedulesViewModel.state is PendingInitial, isTrue);
        },
      );
    },
  );
}

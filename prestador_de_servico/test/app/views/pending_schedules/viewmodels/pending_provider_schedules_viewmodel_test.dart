
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_provider_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';

import '../../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  
  late PendingProviderSchedulesViewModel pendingProviderSchedulesViewModel;

  void setUpValues() {
    pendingProviderSchedulesViewModel = PendingProviderSchedulesViewModel(
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
        '''Deve alterar o estado para PendingProviderError quando um erro for retornado
      pelo service''',
        () async {
          const failureMessage = 'Teste de falha';

          when(onlineMockSchedulingRepository.getPendingProviderSchedules())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await pendingProviderSchedulesViewModel.load();

          expect(pendingProviderSchedulesViewModel.state is PendingError, isTrue);
          final state = (pendingProviderSchedulesViewModel.state as PendingError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para PendingProviderLoaded quando o service retornar os dados''',
        () async {
          final List<ServiceScheduling> serviceSchedules = [];

          when(onlineMockSchedulingRepository.getPendingProviderSchedules())
              .thenAnswer((_) async => Either.right(serviceSchedules));

          await pendingProviderSchedulesViewModel.load();

          expect(pendingProviderSchedulesViewModel.state is PendingLoaded, isTrue);
        },
      );
    },
  );
  
  group(
    'exit',
    () {
      test(
        '''Deve alterar o estado para PendingProviderInitial''',
        () {
          pendingProviderSchedulesViewModel.exit();

          expect(pendingProviderSchedulesViewModel.state is PendingInitial, isTrue);
        },
      );
    },
  );
}
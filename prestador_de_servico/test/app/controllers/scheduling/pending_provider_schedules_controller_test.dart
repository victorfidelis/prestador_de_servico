
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/pending_provider_schedules_controller.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/pending_provider_schedules_state.dart';

import '../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  
  late PendingProviderSchedulesController pendingProviderSchedulesController;

  void setUpValues() {
    pendingProviderSchedulesController = PendingProviderSchedulesController(
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

          await pendingProviderSchedulesController.load();

          expect(pendingProviderSchedulesController.state is PendingProviderError, isTrue);
          final state = (pendingProviderSchedulesController.state as PendingProviderError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para PendingProviderLoaded quando o service retornar os dados''',
        () async {
          final List<ServiceScheduling> serviceSchedules = [];

          when(onlineMockSchedulingRepository.getPendingProviderSchedules())
              .thenAnswer((_) async => Either.right(serviceSchedules));

          await pendingProviderSchedulesController.load();

          expect(pendingProviderSchedulesController.state is PendingProviderLoaded, isTrue);
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
          pendingProviderSchedulesController.exit();

          expect(pendingProviderSchedulesController.state is PendingProviderInitial, isTrue);
        },
      );
    },
  );
}
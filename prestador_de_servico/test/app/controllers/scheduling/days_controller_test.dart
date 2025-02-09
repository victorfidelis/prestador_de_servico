import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/days_controller.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/days_state.dart';

import '../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late DaysController daysController;

  void setUpValues() {
    daysController = DaysController(
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
        '''Deve alterar o estado para DaysError quando um erro for retornado
      pelo service''',
        () async {
          const failureMessage = 'Teste de falha';

          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await daysController.load();

          expect(daysController.state is DaysError, isTrue);
          final state = (daysController.state as DaysError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para DaysLoaded quando o service retornar os dados''',
        () async {
          final List<SchedulingDay> schedulesPerDay = [];

          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          await daysController.load();

          expect(daysController.state is DaysLoaded, isTrue);
        },
      );
    },
  );

  group(
    'exit',
    () {
      test(
        '''Deve alterar o estado para DaysInitial''',
        () {
          daysController.exit();

          expect(daysController.state is DaysInitial, isTrue);
        },
      );
    },
  );
}

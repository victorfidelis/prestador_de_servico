import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/days_viewmodel.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/days_state.dart';

import '../../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late DaysViewModel daysViewModel;
  DateTime actualDate = DateTime.now();

  void setUpValues() {
    daysViewModel = DaysViewModel(
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

          when(onlineMockSchedulingRepository.getDaysWithSchedules())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await daysViewModel.load(actualDate);

          expect(daysViewModel.state is DaysError, isTrue);
          final state = (daysViewModel.state as DaysError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para DaysLoaded quando o service retornar os dados''',
        () async {
          final List<SchedulingDay> schedulesPerDay = [];

          when(onlineMockSchedulingRepository.getDaysWithSchedules())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          await daysViewModel.load(actualDate);

          expect(daysViewModel.state is DaysLoaded, isTrue);
        },
      );
    },
  );
}

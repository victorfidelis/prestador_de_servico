import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/scheduling/service_scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/states/scheduling/service_scheduling_state.dart';

import '../../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  
  late ServiceSchedulingViewModel serviceSchedulingViewModel;

  void setUpValues() {
    serviceSchedulingViewModel = ServiceSchedulingViewModel(
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
        '''Deve alterar o estado para ServiceSchedulingError quando um erro for retornado
      pelo service''',
        () async {
          const failureMessage = 'Teste de falha';

          when(onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: anyNamed('dateTime')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceSchedulingViewModel.load(dateTime: DateTime.now());

          expect(serviceSchedulingViewModel.state is ServiceSchedulingError, isTrue);
          final state = (serviceSchedulingViewModel.state as ServiceSchedulingError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceSchedulingLoaded quando o service retornar os dados''',
        () async {
          final List<ServiceScheduling> serviceSchedules = [];

          when(onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: anyNamed('dateTime')))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          await serviceSchedulingViewModel.load(dateTime: DateTime.now());

          expect(serviceSchedulingViewModel.state is ServiceSchedulingLoaded, isTrue);
        },
      );
    },
  );
  
  group(
    'exit',
    () {
      test(
        '''Deve alterar o estado para ServiceSchedulingInitial''',
        () {
          serviceSchedulingViewModel.exit();

          expect(serviceSchedulingViewModel.state is ServiceSchedulingInitial, isTrue);
        },
      );
    },
  );
}
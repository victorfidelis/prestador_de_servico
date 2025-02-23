import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/service_scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/service_scheduling_state.dart';

import '../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  
  late ServiceSchedulingViewModel serviceSchedulingController;

  void setUpValues() {
    serviceSchedulingController = ServiceSchedulingViewModel(
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

          when(onlineMockSchedulingRepository.getAllServicesByDay(dateTime: anyNamed('dateTime')))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceSchedulingController.load(dateTime: DateTime.now());

          expect(serviceSchedulingController.state is ServiceSchedulingError, isTrue);
          final state = (serviceSchedulingController.state as ServiceSchedulingError);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceSchedulingLoaded quando o service retornar os dados''',
        () async {
          final List<ServiceScheduling> serviceSchedules = [];

          when(onlineMockSchedulingRepository.getAllServicesByDay(dateTime: anyNamed('dateTime')))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          await serviceSchedulingController.load(dateTime: DateTime.now());

          expect(serviceSchedulingController.state is ServiceSchedulingLoaded, isTrue);
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
          serviceSchedulingController.exit();

          expect(serviceSchedulingController.state is ServiceSchedulingInitial, isTrue);
        },
      );
    },
  );
}
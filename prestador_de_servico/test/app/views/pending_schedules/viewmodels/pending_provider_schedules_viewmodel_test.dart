import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_provider_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';

class MockSchedulingRepository extends Mock implements SchedulingRepository {}
class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  final onlineMockSchedulingRepository = MockSchedulingRepository();
  final mockImageRepository = MockImageRepository();
  late PendingProviderSchedulesViewModel pendingProviderSchedulesViewModel;

  setUp(() {
    pendingProviderSchedulesViewModel = PendingProviderSchedulesViewModel(
      schedulingService: SchedulingService(
        onlineRepository: onlineMockSchedulingRepository,
        imageRepository: mockImageRepository,
      ),
    );
  });

  group(
    'load',
    () {
      test(
        '''Deve alterar o estado para PendingProviderError quando um erro for retornado
      pelo service''',
        () async {
          const failureMessage = 'Teste de falha';

          when(() => onlineMockSchedulingRepository.getPendingProviderSchedules())
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
          final List<Scheduling> serviceSchedules = [];

          when(() => onlineMockSchedulingRepository.getPendingProviderSchedules())
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

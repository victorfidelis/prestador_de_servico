import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_payment_schedules_viewmodel.dart';
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
  late PendingPaymentSchedulesViewModel pendingPaymentSchedulesViewModel;

  setUp(() {
    pendingPaymentSchedulesViewModel = PendingPaymentSchedulesViewModel(
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
        '''Deve alterar o estado para PendingPaymentError quando um erro for retornado
      pelo service''',
        () async {
          const failureMessage = 'Teste de falha';

          when(() => onlineMockSchedulingRepository.getPendingPaymentSchedules())
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
          final List<Scheduling> serviceSchedules = [];

          when(() => onlineMockSchedulingRepository.getPendingPaymentSchedules())
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

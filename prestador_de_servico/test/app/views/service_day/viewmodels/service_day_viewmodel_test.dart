import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/views/service_day/viewmodels/service_day_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/service_day/states/service_day_state.dart';

class MockServiceDayRepository extends Mock implements ServiceDayRepository {}

void main() {
  final offlineMockServiceDayRepository = MockServiceDayRepository();
  final onlineMockServiceDayRepository = MockServiceDayRepository();
  late ServiceDayViewModel serviceDayViewModel;

  final serviceDay1 = ServiceDay(
    id: '1',
    name: 'Domingo',
    dayOfWeek: 1,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay2 = ServiceDay(
    id: '2',
    name: 'Segunda-feira',
    dayOfWeek: 2,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay3 = ServiceDay(
    id: '3',
    name: 'Terça-feira',
    dayOfWeek: 3,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay4 = ServiceDay(
    id: '4',
    name: 'Quarta-feira',
    dayOfWeek: 4,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay5 = ServiceDay(
    id: '5',
    name: 'Quinta-feira',
    dayOfWeek: 5,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay6 = ServiceDay(
    id: '6',
    name: 'Sexta-feira',
    dayOfWeek: 6,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay7 = ServiceDay(
    id: '7',
    name: 'Sábado',
    dayOfWeek: 7,
    isActive: true,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );
  final serviceDay1Disable = ServiceDay(
    id: '1',
    name: 'Dinheiro',
    dayOfWeek: 1,
    isActive: false,
    openingHour: 0,
    openingMinute: 0,
    closingHour: 0,
    closingMinute: 0,
  );

  setUp(
    () {
      final ServiceDayService serviceDayService = ServiceDayService(
        offlineRepository: offlineMockServiceDayRepository,
        onlineRepository: onlineMockServiceDayRepository,
      );
      serviceDayViewModel = ServiceDayViewModel(serviceDayService: serviceDayService);
    },
  );

  group(
    'load',
    () {
      test(
        '''Deve alterar o estado para ServiceDayError e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository.''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => offlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          await serviceDayViewModel.load();

          expect(serviceDayViewModel.state is ServiceDayError, isTrue);
          final state = serviceDayViewModel.state as ServiceDayError;
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve alterar o estado para ServiceDayLoaded com uma lista de ServiceDay vazia
        quando nenhum ServiceDay estiver configurado.''',
        () async {
          final serviceDays = <ServiceDay>[];

          when(() => offlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceDays));

          await serviceDayViewModel.load();

          expect(serviceDayViewModel.state is ServiceDayLoaded, isTrue);
          final serviceDayState = serviceDayViewModel.state as ServiceDayLoaded;
          expect(serviceDayState.serviceDays.isEmpty, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para ServiceDayLoaded com um lista de ServiceDay preenchida
        quando algum ServiceDay estiver cadastrado.''',
        () async {
          final serviceDays = <ServiceDay>[
            serviceDay1,
            serviceDay2,
            serviceDay3,
            serviceDay4,
            serviceDay5,
            serviceDay6,
            serviceDay7,
          ];

          when(() => offlineMockServiceDayRepository.getAll())
              .thenAnswer((_) async => Either.right(serviceDays));

          await serviceDayViewModel.load();

          expect(serviceDayViewModel.state is ServiceDayLoaded, isTrue);
          final serviceState = serviceDayViewModel.state as ServiceDayLoaded;
          expect(serviceState.serviceDays.length, equals(serviceDays.length));
        },
      );
    },
  );

  group('update', () {
    test(
      '''Deve manter o estado atual caso o mesmo nao seja ServiceDayloaded''',
      () async {
        await serviceDayViewModel.update(serviceDay: serviceDay1);

        expect(serviceDayViewModel.state is ServiceDayInitial, isTrue);
      },
    );

    test(
      '''Deve alterar o estado para ServiceDayLoaded e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository.''',
      () async {
        const failureMessage = 'Teste de falha';

        final serviceDays = <ServiceDay>[
          serviceDay1,
          serviceDay2,
          serviceDay3,
          serviceDay4,
          serviceDay5,
          serviceDay6,
          serviceDay7,
        ];
        when(() => offlineMockServiceDayRepository.getAll())
            .thenAnswer((_) async => Either.right(serviceDays));
        await serviceDayViewModel.load();

        when(() => onlineMockServiceDayRepository.update(serviceDay: serviceDay1))
            .thenAnswer((_) async => Either.left(Failure(failureMessage)));
        when(() => offlineMockServiceDayRepository.update(serviceDay: serviceDay1))
            .thenAnswer((_) async => Either.left(Failure(failureMessage)));

        await serviceDayViewModel.update(serviceDay: serviceDay1);

        expect(serviceDayViewModel.state is ServiceDayLoaded, isTrue);
        final state = serviceDayViewModel.state as ServiceDayLoaded;
        expect(state.serviceDays.length, equals(serviceDays.length));
        expect(state.message, equals(failureMessage));
      },
    );

    test(
      '''Deve alterar o estado para ServiceDayError e definir uma mensagem de erro no campo 
        "message" quando um erro ocorrer no Service/Repository do update e na consulta.''',
      () async {
        const failureMessageUpdate = 'Teste de falha update';
        const failureMessageGetAll = 'Teste de falha get all';
        final serviceDays = <ServiceDay>[
          serviceDay1,
          serviceDay2,
          serviceDay3,
          serviceDay4,
          serviceDay5,
          serviceDay6,
          serviceDay7,
        ];
        when(() => offlineMockServiceDayRepository.getAll())
            .thenAnswer((_) async => Either.right(serviceDays));
        await serviceDayViewModel.load();

        when(() => onlineMockServiceDayRepository.update(serviceDay: serviceDay1))
            .thenAnswer((_) async => Either.left(Failure(failureMessageUpdate)));
        when(() => offlineMockServiceDayRepository.update(serviceDay: serviceDay1))
            .thenAnswer((_) async => Either.left(Failure(failureMessageUpdate)));

        when(() => offlineMockServiceDayRepository.getAll())
            .thenAnswer((_) async => Either.left(Failure(failureMessageGetAll)));

        await serviceDayViewModel.update(serviceDay: serviceDay1);

        expect(serviceDayViewModel.state is ServiceDayError, isTrue);
        final state = serviceDayViewModel.state as ServiceDayError;
        expect(state.message, equals(failureMessageUpdate));
      },
    );

    test(
      '''Deve alterar o ServiceDay corresponte no estado atual''',
      () async {
        final serviceDays = <ServiceDay>[
          serviceDay1,
          serviceDay2,
          serviceDay3,
          serviceDay4,
          serviceDay5,
          serviceDay6,
          serviceDay7,
        ];
        when(() => offlineMockServiceDayRepository.getAll())
            .thenAnswer((_) async => Either.right(serviceDays));
        await serviceDayViewModel.load();

        when(() => onlineMockServiceDayRepository.update(serviceDay: serviceDay1Disable))
            .thenAnswer((_) async => Either.right(unit));
        when(() => offlineMockServiceDayRepository.update(serviceDay: serviceDay1Disable))
            .thenAnswer((_) async => Either.right(unit));

        await serviceDayViewModel.update(serviceDay: serviceDay1Disable);

        expect(serviceDayViewModel.state is ServiceDayLoaded, isTrue);
        final state = (serviceDayViewModel.state as ServiceDayLoaded);
        expect(state.serviceDays[0] == serviceDay1, isFalse);
        expect(state.serviceDays[0] == serviceDay1Disable, isTrue);
      },
    );
  });
}

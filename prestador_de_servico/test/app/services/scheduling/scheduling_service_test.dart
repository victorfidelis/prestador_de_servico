import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import '../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late DateTime actualDate;

  late SchedulingService schedulingService;

  late ScheduledService service1;
  late ScheduledService service2;
  late ScheduledService service3;

  late ServiceScheduling serviceScheduling08as09;
  late ServiceScheduling serviceScheduling09as11;
  late ServiceScheduling serviceScheduling10as12;
  late ServiceScheduling serviceScheduling13as15confirm;
  late ServiceScheduling serviceScheduling14as16;

  late ServiceScheduling serviceSchedulingDay1das08as09;
  late ServiceScheduling serviceSchedulingDay2das08as09;
  late ServiceScheduling serviceSchedulingDay2das09as11;
  late ServiceScheduling serviceSchedulingDay3das08as09;
  late ServiceScheduling serviceSchedulingDay3das09as11;

  late SchedulingDay schedulingDayBefore10Days;
  late SchedulingDay schedulingDayAfter10Days;
  late SchedulingDay schedulingDayAfter100Days;

  void setUpValues() {
    final actualTime = DateTime.now();
    actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);
    final creationDate = actualTime.add(const Duration(days: -30));

    schedulingService = SchedulingService(
      onlineRepository: onlineMockSchedulingRepository,
    );
    service1 = ScheduledService(
      scheduledServiceId: 1,
      id: '1',
      serviceCategoryId: '1',
      name: 'Corte cabelo',
      price: 50,
      hours: 1,
      minutes: 0,
      imageUrl: '',
      isAdditional: false,
      removed: false,
    );

    service2 = ScheduledService(
      scheduledServiceId: 2,
      id: '2',
      serviceCategoryId: '1',
      name: 'Moicano',
      price: 70,
      hours: 1,
      minutes: 0,
      imageUrl: '',
      isAdditional: false,
      removed: false,
    );

    service3 = ScheduledService(
      scheduledServiceId: 3,
      id: '3',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 50,
      hours: 1,
      minutes: 0,
      imageUrl: '',
      isAdditional: false,
      removed: false,
    );

    serviceScheduling08as09 = ServiceScheduling(
      id: '1',
      user: User(name: 'Lucas', surname: 'Silva'),
      services: [service1],
      serviceStatus: ServiceStatus(
        code: ServiceStatus.pendingProvider,
        name: 'Pendente prestador',
      ),
      startDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 8, 0),
      endDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 9, 0),
      totalDiscount: 0,
      totalPrice: service1.price,
      totalPaid: 0,
      totalRate: 0,
      creationDate: creationDate,
    );

    serviceScheduling09as11 = ServiceScheduling(
      id: '2',
      user: User(name: 'Victor', surname: 'Silva'),
      services: [service1, service2],
      serviceStatus: ServiceStatus(code: 1, name: 'Pendente prestador'),
      startDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 9, 0),
      endDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 11, 0),
      totalDiscount: 0,
      totalPrice: service1.price + service2.price,
      totalPaid: 0,
      totalRate: 0,
      creationDate: creationDate,
    );

    serviceScheduling10as12 = ServiceScheduling(
      id: '3',
      user: User(name: 'Bruno', surname: 'Santos'),
      services: [service1, service3],
      serviceStatus: ServiceStatus(code: 1, name: 'Pendente prestador'),
      startDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 10, 0),
      endDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 12, 0),
      totalDiscount: 0,
      totalPrice: service1.price + service2.price,
      totalPaid: 0,
      totalRate: 0,
      creationDate: creationDate,
    );

    serviceScheduling13as15confirm = ServiceScheduling(
      id: '4',
      user: User(name: 'Bruno', surname: 'Santos'),
      services: [service1, service3],
      serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
      startDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 13, 0),
      endDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 15, 0),
      totalDiscount: 0,
      totalPrice: service1.price + service3.price,
      totalPaid: 0,
      totalRate: 0,
      creationDate: creationDate,
    );

    serviceScheduling14as16 = ServiceScheduling(
      id: '5',
      user: User(name: 'Luciano', surname: 'Vieira'),
      services: [service1, service3],
      serviceStatus: ServiceStatus(code: 1, name: 'Pendente prestador'),
      startDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 14, 0),
      endDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 16, 0),
      totalDiscount: 0,
      totalPrice: service1.price + service3.price,
      totalPaid: 0,
      totalRate: 0,
      creationDate: creationDate,
    );

    schedulingDayBefore10Days = SchedulingDay(
      date: actualDate.add(const Duration(days: -10)),
      isSelected: false,
      hasService: true,
      isToday: false,
      numberOfServices: 1,
    );
    schedulingDayAfter10Days = SchedulingDay(
      date: actualDate.add(const Duration(days: 10)),
      isSelected: false,
      hasService: true,
      isToday: false,
      numberOfServices: 1,
    );
    schedulingDayAfter100Days = SchedulingDay(
      date: actualDate.add(const Duration(days: 100)),
      isSelected: false,
      hasService: true,
      isToday: false,
      numberOfServices: 1,
    );

    serviceSchedulingDay1das08as09 = serviceScheduling08as09.copyWith();
    serviceSchedulingDay2das08as09 = serviceScheduling08as09.copyWith(
      startDateAndTime: serviceScheduling08as09.startDateAndTime.add(const Duration(days: 1)),
      endDateAndTime: serviceScheduling08as09.endDateAndTime.add(const Duration(days: 1)),
    );
    serviceSchedulingDay2das09as11 = serviceScheduling09as11.copyWith(
      startDateAndTime: serviceScheduling09as11.startDateAndTime.add(const Duration(days: 1)),
      endDateAndTime: serviceScheduling09as11.endDateAndTime.add(const Duration(days: 1)),
    );
    serviceSchedulingDay3das08as09 = serviceScheduling08as09.copyWith(
      startDateAndTime: serviceScheduling08as09.startDateAndTime.add(const Duration(days: 2)),
      endDateAndTime: serviceScheduling08as09.endDateAndTime.add(const Duration(days: 2)),
    );
    serviceSchedulingDay3das09as11 = serviceScheduling09as11.copyWith(
      startDateAndTime: serviceScheduling09as11.startDateAndTime.add(const Duration(days: 2)),
      endDateAndTime: serviceScheduling09as11.endDateAndTime.add(const Duration(days: 2)),
    );
  }

  setUp(() {
    setUpMockServiceSchedulingRepository();
    setUpValues();
  });

  group(
    'getServiceScheduling',
    () {
      test(
        '''Deve retornar um Failure caso uma falha ocorra na busca''',
        () async {
          const failureMessage = 'Mensagem de falha';

          when(onlineMockSchedulingRepository.getScheduling(
            schedulingId: serviceScheduling08as09.id,
          )).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getEither = await schedulingService.getServiceScheduling(
              serviceSchedulingId: serviceScheduling08as09.id);

          expect(getEither.isLeft, isTrue);
          expect(getEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Failure caso uma falha ocorra na busca de conflitos''',
        () async {
          const failureMessage = 'Mensagem de falha';

          when(onlineMockSchedulingRepository.getScheduling(
            schedulingId: serviceScheduling08as09.id,
          )).thenAnswer((_) async => Either.right(serviceScheduling08as09));
          when(onlineMockSchedulingRepository.getConflicts(
            startDate: serviceScheduling08as09.startDateAndTime,
            endDate: serviceScheduling08as09.endDateAndTime,
          )).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getEither = await schedulingService.getServiceScheduling(
              serviceSchedulingId: serviceScheduling08as09.id);

          expect(getEither.isLeft, isTrue);
          expect(getEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um ServiceScheduling com conflito de horário 
        quando houver conflito de horário''',
        () async {
          final serviceScheduling = serviceScheduling09as11.copyWith();

          when(onlineMockSchedulingRepository.getScheduling(
            schedulingId: serviceScheduling.id,
          )).thenAnswer((_) async => Either.right(serviceScheduling));
          when(onlineMockSchedulingRepository.getConflicts(
            startDate: serviceScheduling.startDateAndTime,
            endDate: serviceScheduling.endDateAndTime,
          )).thenAnswer((_) async => Either.right([serviceScheduling10as12]));

          final getEither = await schedulingService.getServiceScheduling(
              serviceSchedulingId: serviceScheduling.id);

          expect(getEither.isRight, isTrue);
          final serviceSchedulingReturn = getEither.right!;

          expect(serviceSchedulingReturn.conflictScheduing, isTrue);
          expect(serviceSchedulingReturn.schedulingUnavailable, isFalse);
        },
      );

      test('''Deve retornar um ServiceScheduling com conflite e indiponibilida caso 
      a consulta retorne algum serviço em conflito com status confirmado''', () async {
        final serviceScheduling = serviceScheduling09as11.copyWith();
        final serviceSchedulingUnavailable = serviceScheduling10as12.copyWith(
          serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
        );

        when(onlineMockSchedulingRepository.getScheduling(
          schedulingId: serviceScheduling.id,
        )).thenAnswer((_) async => Either.right(serviceScheduling));
        when(onlineMockSchedulingRepository.getConflicts(
          startDate: serviceScheduling.startDateAndTime,
          endDate: serviceScheduling.endDateAndTime,
        )).thenAnswer((_) async => Either.right([serviceSchedulingUnavailable]));

        final getEither =
            await schedulingService.getServiceScheduling(serviceSchedulingId: serviceScheduling.id);

        expect(getEither.isRight, isTrue);
        final serviceSchedulingReturn = getEither.right!;

        expect(serviceSchedulingReturn.conflictScheduing, isTrue);
        expect(serviceSchedulingReturn.schedulingUnavailable, isTrue);
      });

      test('''Deve retornar um ServiceScheduling sem conflito de horário''', () async {
        final serviceScheduling = serviceScheduling09as11.copyWith();

        when(onlineMockSchedulingRepository.getScheduling(
          schedulingId: serviceScheduling.id,
        )).thenAnswer((_) async => Either.right(serviceScheduling));
        when(onlineMockSchedulingRepository.getConflicts(
          startDate: serviceScheduling.startDateAndTime,
          endDate: serviceScheduling.endDateAndTime,
        )).thenAnswer((_) async => Either.right([]));

        final getEither =
            await schedulingService.getServiceScheduling(serviceSchedulingId: serviceScheduling.id);

        expect(getEither.isRight, isTrue);
        final serviceSchedulingReturn = getEither.right!;

        expect(serviceSchedulingReturn.conflictScheduing, isFalse);
        expect(serviceSchedulingReturn.schedulingUnavailable, isFalse);
      });

      test('''Deve retornar um ServiceScheduling sem conflito de horário caso o serviço 
      em questão já esteja confirmado''', () async {
        final serviceScheduling = serviceScheduling09as11.copyWith(
          serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
        );

        when(onlineMockSchedulingRepository.getScheduling(
          schedulingId: serviceScheduling.id,
        )).thenAnswer((_) async => Either.right(serviceScheduling));
        when(onlineMockSchedulingRepository.getConflicts(
          startDate: serviceScheduling.startDateAndTime,
          endDate: serviceScheduling.endDateAndTime,
        )).thenAnswer((_) async => Either.right([serviceScheduling10as12]));

        final getEither =
            await schedulingService.getServiceScheduling(serviceSchedulingId: serviceScheduling.id);

        expect(getEither.isRight, isTrue);
        final serviceSchedulingReturn = getEither.right!;

        expect(serviceSchedulingReturn.conflictScheduing, isFalse);
        expect(serviceSchedulingReturn.schedulingUnavailable, isFalse);
      });
    },
  );

  group(
    'getAllServicesByDay',
    () {
      test(
        '''Deve retornar um Failure caso algum erro ocorra no repository''',
        () async {
          const failureMessage = 'Mensagem de falha';
          final dateToConsult = DateTime(actualDate.year, actualDate.month, actualDate.day);
          when(onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getEither = await schedulingService.getAllServicesByDay(dateTime: dateToConsult);

          expect(getEither.isLeft, isTrue);
          expect(getEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar uma lista de ServiceScheduling caso nenhum erro ocorra no repository''',
        () async {
          final dateToConsult = DateTime(actualDate.year, actualDate.month, actualDate.day);
          final serviceSchedules = [
            serviceScheduling08as09,
            serviceScheduling09as11,
            serviceScheduling13as15confirm,
          ];
          when(onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          final getEither = await schedulingService.getAllServicesByDay(dateTime: dateToConsult);

          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(serviceSchedules.length));
        },
      );

      test(
        '''Deve retornar uma lista de ServiceScheduling apontando conflitos de horas 
        quando houver conflitos de horas''',
        () async {
          final dateToConsult = DateTime(actualDate.year, actualDate.month, actualDate.day);

          final serviceSchedules = [
            serviceScheduling08as09,
            serviceScheduling09as11,
            serviceScheduling10as12,
            serviceScheduling13as15confirm,
          ];

          when(onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          final getEither = await schedulingService.getAllServicesByDay(dateTime: dateToConsult);

          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(serviceSchedules.length));
          expect(getEither.right![1].conflictScheduing, isTrue);
          expect(getEither.right![2].conflictScheduing, isTrue);
        },
      );

      test(
        '''Deve retornar uma lista de ServiceScheduling apontando indiponibilidade de horas 
        quando houver indiponibilidade de horas''',
        () async {
          final dateToConsult = DateTime(actualDate.year, actualDate.month, actualDate.day);

          final serviceSchedules = [
            serviceScheduling08as09,
            serviceScheduling09as11,
            serviceScheduling13as15confirm,
            serviceScheduling14as16
          ];

          when(onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          final getEither = await schedulingService.getAllServicesByDay(dateTime: dateToConsult);

          expect(getEither.isRight, isTrue);
          expect(getEither.right!.length, equals(serviceSchedules.length));
          expect(getEither.right![2].schedulingUnavailable, isFalse);
          expect(getEither.right![3].schedulingUnavailable, isTrue);
        },
      );
    },
  );

  group(
    'getDates',
    () {
      test(
        'Deve retorno um Failure caso algum erro ocorra no repository',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockSchedulingRepository.getDaysWithSchedules())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final datesEither = await schedulingService.getDates(actualDate);

          expect(datesEither.isLeft, isTrue);
          expect(datesEither.left!.message, equals(failureMessage));
        },
      );

      test(
        'Deve retorno um NetworkFailure caso não tenha acesso a internet',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockSchedulingRepository.getDaysWithSchedules())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final datesEither = await schedulingService.getDates(actualDate);

          expect(datesEither.isLeft, isTrue);
          expect(datesEither.left is NetworkFailure, isTrue);
          expect(datesEither.left!.message, equals(failureMessage));
        },
      );

      test('''Deve retornar uma lista de datas iniciando no dia atual e terminando após 90 dias
        quando não existirem serviços''', () async {
        const daysToAdd = 90;
        final List<SchedulingDay> schedulesPerDay = [];

        final finalDate = actualDate.add(const Duration(days: daysToAdd));

        when(onlineMockSchedulingRepository.getDaysWithSchedules())
            .thenAnswer((_) async => Either.right(schedulesPerDay));

        final datesEither = await schedulingService.getDates(actualDate);

        expect(datesEither.isRight, isTrue);
        final dates = datesEither.right!;
        expect(dates.length, equals(daysToAdd + 1));
        expect(dates[0].date, equals(actualDate));
        expect(dates[daysToAdd].date, equals(finalDate));
      });

      test(
        '''Deve retornar uma lista de datas iniciando na data do primeiro serviço e 
        terminando 90 dias depois da data atual quando existirem serviços anteriores
        a data atual e não existirem serviços posteriores a 90 dias da data atual''',
        () async {
          const daysToAdd = 90;
          const daysToRemoveOfActualDate = 10;

          final List<SchedulingDay> schedulesPerDay = [
            schedulingDayBefore10Days,
            schedulingDayAfter10Days,
          ];

          final finalDate = actualDate.add(const Duration(days: daysToAdd));

          when(onlineMockSchedulingRepository.getDaysWithSchedules())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          final datesEither = await schedulingService.getDates(actualDate);

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAdd + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(schedulingDayBefore10Days));
          expect(dates[daysToAdd + daysToRemoveOfActualDate].date, equals(finalDate));
        },
      );

      test(
        '''Deve retornar uma lista de datas iniciando na data do primeiro serviço e 
        terminando na data do último serviço quando existirem serviços anteriores
        a data atual e existirem serviços posteriores a 90 dias da data atual''',
        () async {
          const daysToAddOfActualDate = 100;
          const daysToRemoveOfActualDate = 10;
          final List<SchedulingDay> schedulesPerDay = [
            schedulingDayBefore10Days,
            schedulingDayAfter10Days,
            schedulingDayAfter100Days,
          ];

          when(onlineMockSchedulingRepository.getDaysWithSchedules())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          final datesEither = await schedulingService.getDates(actualDate);

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAddOfActualDate + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(schedulingDayBefore10Days));
          expect(dates[daysToAddOfActualDate + daysToRemoveOfActualDate],
              equals(schedulingDayAfter100Days));
        },
      );
    },
  );

  group(
    'getPendingProviderSchedules',
    () {
      test(
        '''Deve retornar um Failure quando algum erro ocorrer no repository''',
        () async {
          const failureMessage = 'Falha de teste';

          when(onlineMockSchedulingRepository.getPendingProviderSchedules()).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );

          final pendingProviderEither = await schedulingService.getPendingProviderSchedules();

          expect(pendingProviderEither.isLeft, isTrue);
          expect(pendingProviderEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar uma lista de SchedulesByDay vazia quando não houver pendências''',
        () async {
          final List<ServiceScheduling> servicesSchedules = [];

          when(onlineMockSchedulingRepository.getPendingProviderSchedules()).thenAnswer(
            (_) async => Either.right(servicesSchedules),
          );

          final pendingProviderEither = await schedulingService.getPendingProviderSchedules();

          expect(pendingProviderEither.isRight, isTrue);
          final schedulesByDaysReturns = pendingProviderEither.right!;

          expect(schedulesByDaysReturns.length, equals(0));
        },
      );

      test(
        '''Deve retornar uma lista de SchedulesByDay''',
        () async {
          final List<ServiceScheduling> servicesSchedules = [
            serviceSchedulingDay1das08as09,
            serviceSchedulingDay2das08as09,
            serviceSchedulingDay2das09as11,
            serviceSchedulingDay3das08as09,
            serviceSchedulingDay3das09as11,
          ];

          DateTime day1 = DateTime(
            actualDate.year,
            actualDate.month,
            actualDate.day,
          );
          DateTime day2 = day1.add(const Duration(days: 1));
          DateTime day3 = day1.add(const Duration(days: 2));

          final List<SchedulesByDay> schedulesByDays = [
            SchedulesByDay(day: day1, serviceSchedules: [serviceSchedulingDay1das08as09]),
            SchedulesByDay(
              day: day2,
              serviceSchedules: [serviceSchedulingDay2das08as09, serviceSchedulingDay2das09as11],
            ),
            SchedulesByDay(
              day: day3,
              serviceSchedules: [serviceSchedulingDay3das08as09, serviceSchedulingDay3das09as11],
            ),
          ];

          when(onlineMockSchedulingRepository.getPendingProviderSchedules()).thenAnswer(
            (_) async => Either.right(servicesSchedules),
          );

          final pendingProviderEither = await schedulingService.getPendingProviderSchedules();

          expect(pendingProviderEither.isRight, isTrue);
          final schedulesByDaysReturns = pendingProviderEither.right!;

          expect(schedulesByDaysReturns.length, equals(schedulesByDays.length));
          expect(schedulesByDaysReturns[1].day, schedulesByDays[1].day);
          expect(
            schedulesByDaysReturns[1].serviceSchedules.length,
            schedulesByDays[1].serviceSchedules.length,
          );
        },
      );
    },
  );

  group(
    'getPendingPaymentSchedules',
    () {
      test(
        '''Deve retornar um Failure quando algum erro ocorrer no repository''',
        () async {
          const failureMessage = 'Falha de teste';

          when(onlineMockSchedulingRepository.getPendingPaymentSchedules()).thenAnswer(
            (_) async => Either.left(Failure(failureMessage)),
          );

          final pendingPaymentEither = await schedulingService.getPendingPaymentSchedules();

          expect(pendingPaymentEither.isLeft, isTrue);
          expect(pendingPaymentEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar uma lista de SchedulesByDay vazia quando não houver pendências''',
        () async {
          final List<ServiceScheduling> servicesSchedules = [];

          when(onlineMockSchedulingRepository.getPendingPaymentSchedules()).thenAnswer(
            (_) async => Either.right(servicesSchedules),
          );

          final pendingPaymentEither = await schedulingService.getPendingPaymentSchedules();

          expect(pendingPaymentEither.isRight, isTrue);
          final schedulesByDaysReturns = pendingPaymentEither.right!;

          expect(schedulesByDaysReturns.length, equals(0));
        },
      );

      test(
        '''Deve retornar uma lista de SchedulesByDay''',
        () async {
          final List<ServiceScheduling> servicesSchedules = [
            serviceSchedulingDay1das08as09,
            serviceSchedulingDay2das08as09,
            serviceSchedulingDay2das09as11,
            serviceSchedulingDay3das08as09,
            serviceSchedulingDay3das09as11,
          ];

          DateTime day1 = DateTime(
            actualDate.year,
            actualDate.month,
            actualDate.day,
          );
          DateTime day2 = day1.add(const Duration(days: 1));
          DateTime day3 = day1.add(const Duration(days: 2));

          final List<SchedulesByDay> schedulesByDays = [
            SchedulesByDay(day: day1, serviceSchedules: [serviceSchedulingDay1das08as09]),
            SchedulesByDay(
              day: day2,
              serviceSchedules: [serviceSchedulingDay2das08as09, serviceSchedulingDay2das09as11],
            ),
            SchedulesByDay(
              day: day3,
              serviceSchedules: [serviceSchedulingDay3das08as09, serviceSchedulingDay3das09as11],
            ),
          ];

          when(onlineMockSchedulingRepository.getPendingPaymentSchedules()).thenAnswer(
            (_) async => Either.right(servicesSchedules),
          );

          final pendingPaymentEither = await schedulingService.getPendingPaymentSchedules();

          expect(pendingPaymentEither.isRight, isTrue);
          final schedulesByDaysReturns = pendingPaymentEither.right!;

          expect(schedulesByDaysReturns.length, equals(schedulesByDays.length));
          expect(schedulesByDaysReturns[1].day, schedulesByDays[1].day);
          expect(
            schedulesByDaysReturns[1].serviceSchedules.length,
            schedulesByDays[1].serviceSchedules.length,
          );
        },
      );
    },
  );

  group(
    'confirmScheduling',
    () {
      test(
        '''Deve retornar um Failure quando o status atual não for pendente''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
              serviceStatus: ServiceStatus(code: ServiceStatus.confirmCode, name: 'Confirmado'));

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          final either = await schedulingService.confirmScheduling(schedulingId: scheduling.id);

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for pendente''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingProvider,
              name: 'Pendente Prestador',
            ),
          );

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          when(onlineMockSchedulingRepository.changeStatus(
            schedulingId: scheduling.id,
            statusCode: ServiceStatus.confirmCode,
          )).thenAnswer((_) async => Either.right(unit));

          final either = await schedulingService.confirmScheduling(schedulingId: scheduling.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'denyScheduling',
    () {
      test(
        '''Deve retornar um Failure quando o status atual não for pendente''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
              serviceStatus: ServiceStatus(code: ServiceStatus.deniedCode, name: 'Negado'));

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          final either = await schedulingService.denyScheduling(schedulingId: scheduling.id);

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for pendente''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingProvider,
              name: 'Pendente Prestador',
            ),
          );

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          when(onlineMockSchedulingRepository.changeStatus(
            schedulingId: scheduling.id,
            statusCode: ServiceStatus.deniedCode,
          )).thenAnswer((_) async => Either.right(unit));

          final either = await schedulingService.denyScheduling(schedulingId: scheduling.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'requestChangeScheduling',
    () {
      test(
        '''Deve retornar um Failure quando o status atual não for pendente''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
              serviceStatus: ServiceStatus(
            code: ServiceStatus.deniedCode,
            name: 'Nagado',
          ));

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          final either = await schedulingService.requestChangeScheduling(
            schedulingId: scheduling.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for pendente prestador''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingProvider,
              name: 'Pendente Prestador',
            ),
          );

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          when(onlineMockSchedulingRepository.changeStatus(
            schedulingId: scheduling.id,
            statusCode: ServiceStatus.pendingClientCode,
          )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.requestChangeScheduling(schedulingId: scheduling.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'cancelScheduling',
    () {
      test(
        '''Deve retornar um Failure quando o status atual não permitir cancelamento''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
              serviceStatus: ServiceStatus(
            code: ServiceStatus.deniedCode,
            name: 'Nagado',
          ));

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          final either = await schedulingService.cancelScheduling(
            schedulingId: scheduling.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual permitir cancelamento''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingClientCode,
              name: 'Pendente Cliente',
            ),
          );

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          when(onlineMockSchedulingRepository.changeStatus(
            schedulingId: scheduling.id,
            statusCode: ServiceStatus.canceledByProviderCode,
          )).thenAnswer((_) async => Either.right(unit));

          final either = await schedulingService.cancelScheduling(schedulingId: scheduling.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'schedulingInAttendence',
    () {
      test(
        '''Deve retornar um Failure quando o status atual não seja "Confirmado"''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
              serviceStatus: ServiceStatus(
            code: ServiceStatus.pendingClientCode,
            name: 'Pendente cliente',
          ));

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          final either = await schedulingService.schedulingInService(
            schedulingId: scheduling.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for "Confirmado"''',
        () async {
          final scheduling = serviceScheduling08as09.copyWith(
            serviceStatus: ServiceStatus(
              code: ServiceStatus.confirmCode,
              name: 'Confirmado',
            ),
          );

          when(onlineMockSchedulingRepository.getScheduling(schedulingId: scheduling.id))
              .thenAnswer((_) async => Either.right(scheduling));

          when(onlineMockSchedulingRepository.changeStatus(
            schedulingId: scheduling.id,
            statusCode: ServiceStatus.inServiceCode,
          )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.schedulingInService(schedulingId: scheduling.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );
}

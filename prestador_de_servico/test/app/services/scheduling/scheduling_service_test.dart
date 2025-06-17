import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class MockSchedulingRepository extends Mock implements SchedulingRepository {}
class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  final onlineMockSchedulingRepository = MockSchedulingRepository();
  final mockImageRepository = MockImageRepository();
  final schedulingService = SchedulingService(
    onlineRepository: onlineMockSchedulingRepository,
    imageRepository: mockImageRepository,
  );

  final actualDateTime = DateTime.now();
  final actualDate = DateTime(actualDateTime.year, actualDateTime.month, actualDateTime.day);

  final service1 = ScheduledService(
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

  final service2 = ScheduledService(
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

  final service3 = ScheduledService(
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

  final serviceScheduling = Scheduling(
    id: '1',
    user: User(name: 'Lucas', surname: 'Silva'),
    services: [service1, service2, service3],
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
    creationDate: actualDate.add(const Duration(days: -30)),
  );

  group(
    'getServiceScheduling',
    () {
      test(
        '''Deve retornar um Failure caso uma falha ocorra na busca''',
        () async {
          const failureMessage = 'Mensagem de falha';
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

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
          final serviceSchedulingTest = serviceScheduling.copyWith();

          when(() => onlineMockSchedulingRepository.getScheduling(
                schedulingId: serviceSchedulingTest.id,
              )).thenAnswer((_) async => Either.right(serviceSchedulingTest));
          when(() => onlineMockSchedulingRepository.getConflicts(
                startDate: serviceSchedulingTest.startDateAndTime,
                endDate: serviceSchedulingTest.endDateAndTime,
              )).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getEither = await schedulingService.getServiceScheduling(
              serviceSchedulingId: serviceSchedulingTest.id);

          expect(getEither.isLeft, isTrue);
          expect(getEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um ServiceScheduling com conflito de horário 
        quando houver conflito de horário''',
        () async {
          final serviceScheduling09as11 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
          );
          final serviceScheduling10as12 = serviceScheduling.copyWith(
            id: '2',
            startDateAndTime: actualDate.copyWith(hour: 10, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 12, minute: 0),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                schedulingId: serviceScheduling09as11.id,
              )).thenAnswer((_) async => Either.right(serviceScheduling09as11));
          when(() => onlineMockSchedulingRepository.getConflicts(
                startDate: serviceScheduling09as11.startDateAndTime,
                endDate: serviceScheduling09as11.endDateAndTime,
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
        final serviceScheduling09as11 = serviceScheduling.copyWith(
          id: '1',
          startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
        );
        final serviceSchedulingUnavailable = serviceScheduling.copyWith(
          id: '2',
          startDateAndTime: actualDate.copyWith(hour: 10, minute: 0),
          endDateAndTime: actualDate.copyWith(hour: 12, minute: 0),
          serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
        );

        when(() => onlineMockSchedulingRepository.getScheduling(
              schedulingId: serviceScheduling09as11.id,
            )).thenAnswer((_) async => Either.right(serviceScheduling09as11));
        when(() => onlineMockSchedulingRepository.getConflicts(
              startDate: serviceScheduling09as11.startDateAndTime,
              endDate: serviceScheduling09as11.endDateAndTime,
            )).thenAnswer((_) async => Either.right([serviceSchedulingUnavailable]));

        final getEither = await schedulingService.getServiceScheduling(
            serviceSchedulingId: serviceScheduling09as11.id);

        expect(getEither.isRight, isTrue);
        expect(getEither.right!.conflictScheduing, isTrue);
        expect(getEither.right!.schedulingUnavailable, isTrue);
      });

      test('''Deve retornar um ServiceScheduling sem conflito de horário''', () async {
        final serviceScheduling09as11 = serviceScheduling.copyWith(
          id: '1',
          startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
        );

        when(() => onlineMockSchedulingRepository.getScheduling(
              schedulingId: serviceScheduling09as11.id,
            )).thenAnswer((_) async => Either.right(serviceScheduling09as11));
        when(() => onlineMockSchedulingRepository.getConflicts(
              startDate: serviceScheduling09as11.startDateAndTime,
              endDate: serviceScheduling09as11.endDateAndTime,
            )).thenAnswer((_) async => Either.right([]));

        final getEither = await schedulingService.getServiceScheduling(
            serviceSchedulingId: serviceScheduling09as11.id);

        expect(getEither.isRight, isTrue);
        expect(getEither.right!.conflictScheduing, isFalse);
        expect(getEither.right!.schedulingUnavailable, isFalse);
      });

      test('''Deve retornar um ServiceScheduling sem conflito de horário caso o serviço 
      em questão já esteja confirmado''', () async {
        final serviceScheduling09as11 = serviceScheduling.copyWith(
          id: '1',
          startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
          serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
        );
        final serviceScheduling10as12 = serviceScheduling.copyWith(
          id: '2',
          startDateAndTime: actualDate.copyWith(hour: 10, minute: 0),
          endDateAndTime: actualDate.copyWith(hour: 12, minute: 0),
        );

        when(() => onlineMockSchedulingRepository.getScheduling(
              schedulingId: serviceScheduling09as11.id,
            )).thenAnswer((_) async => Either.right(serviceScheduling09as11));
        when(() => onlineMockSchedulingRepository.getConflicts(
              startDate: serviceScheduling09as11.startDateAndTime,
              endDate: serviceScheduling09as11.endDateAndTime,
            )).thenAnswer((_) async => Either.right([serviceScheduling10as12]));

        final getEither = await schedulingService.getServiceScheduling(
            serviceSchedulingId: serviceScheduling09as11.id);

        expect(getEither.isRight, isTrue);
        expect(getEither.right!.conflictScheduing, isFalse);
        expect(getEither.right!.schedulingUnavailable, isFalse);
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
          when(() => onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getEither = await schedulingService.getAllServicesByDay(dateTime: dateToConsult);

          expect(getEither.isLeft, isTrue);
          expect(getEither.left!.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar uma lista de ServiceScheduling caso nenhum erro ocorra no repository''',
        () async {
          final dateToConsult = actualDate;
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          );
          final serviceScheduling09as11 = serviceScheduling.copyWith(
            id: '2',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
          );
          final serviceScheduling13as15confirm = serviceScheduling.copyWith(
            id: '3',
            startDateAndTime: actualDate.copyWith(hour: 13, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 15, minute: 0),
            serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
          );
          final serviceSchedules = [
            serviceScheduling08as09,
            serviceScheduling09as11,
            serviceScheduling13as15confirm,
          ];
          when(() => onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
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
          final dateToConsult = actualDate;
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          );
          final serviceScheduling09as11 = serviceScheduling.copyWith(
            id: '2',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
          );
          final serviceScheduling10as12 = serviceScheduling.copyWith(
            id: '3',
            startDateAndTime: actualDate.copyWith(hour: 10, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 12, minute: 0),
          );
          final serviceScheduling13as15confirm = serviceScheduling.copyWith(
            id: '4',
            startDateAndTime: actualDate.copyWith(hour: 13, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 15, minute: 0),
            serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
          );

          final serviceSchedules = [
            serviceScheduling08as09,
            serviceScheduling09as11,
            serviceScheduling10as12,
            serviceScheduling13as15confirm,
          ];

          when(() => onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
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
          final dateToConsult = actualDate;
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          );
          final serviceScheduling09as11 = serviceScheduling.copyWith(
            id: '2',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0),
          );
          final serviceScheduling13as15confirm = serviceScheduling.copyWith(
            id: '3',
            startDateAndTime: actualDate.copyWith(hour: 13, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 15, minute: 0),
            serviceStatus: ServiceStatus(code: 3, name: 'Confirmado'),
          );
          final serviceScheduling14as16 = serviceScheduling.copyWith(
            id: '4',
            startDateAndTime: actualDate.copyWith(hour: 14, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 16, minute: 0),
          );
          final serviceSchedules = [
            serviceScheduling08as09,
            serviceScheduling09as11,
            serviceScheduling13as15confirm,
            serviceScheduling14as16
          ];

          when(() => onlineMockSchedulingRepository.getAllSchedulesByDay(dateTime: dateToConsult))
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
          when(() => onlineMockSchedulingRepository.getDaysWithSchedules())
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
          when(() => onlineMockSchedulingRepository.getDaysWithSchedules())
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

        when(() => onlineMockSchedulingRepository.getDaysWithSchedules())
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

          final schedulingDayBefore10Days = SchedulingDay(
            date: actualDate.add(const Duration(days: -10)),
            isSelected: false,
            hasService: true,
            isToday: false,
            numberOfServices: 1,
          );
          final schedulingDayAfter10Days = SchedulingDay(
            date: actualDate.add(const Duration(days: 10)),
            isSelected: false,
            hasService: true,
            isToday: false,
            numberOfServices: 1,
          );

          final List<SchedulingDay> schedulesPerDay = [
            schedulingDayBefore10Days,
            schedulingDayAfter10Days,
          ];

          final finalDate = actualDate.add(const Duration(days: daysToAdd));

          when(() => onlineMockSchedulingRepository.getDaysWithSchedules())
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
          final schedulingDayBefore10Days = SchedulingDay(
            date: actualDate.add(const Duration(days: -10)),
            isSelected: false,
            hasService: true,
            isToday: false,
            numberOfServices: 1,
          );
          final schedulingDayAfter10Days = SchedulingDay(
            date: actualDate.add(const Duration(days: 10)),
            isSelected: false,
            hasService: true,
            isToday: false,
            numberOfServices: 1,
          );
          final schedulingDayAfter100Days = SchedulingDay(
            date: actualDate.add(const Duration(days: 100)),
            isSelected: false,
            hasService: true,
            isToday: false,
            numberOfServices: 1,
          );

          final List<SchedulingDay> schedulesPerDay = [
            schedulingDayBefore10Days,
            schedulingDayAfter10Days,
            schedulingDayAfter100Days,
          ];

          when(() => onlineMockSchedulingRepository.getDaysWithSchedules())
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

          when(() => onlineMockSchedulingRepository.getPendingProviderSchedules()).thenAnswer(
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
          final List<Scheduling> servicesSchedules = [];

          when(() => onlineMockSchedulingRepository.getPendingProviderSchedules()).thenAnswer(
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
          final serviceSchedulingDay1das08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          );
          final serviceSchedulingDay2das08as09 = serviceScheduling.copyWith(
            id: '2',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0).add(const Duration(days: 1)),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 1)),
          );
          final serviceSchedulingDay2das09as11 = serviceScheduling.copyWith(
            id: '3',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 1)),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0).add(const Duration(days: 1)),
          );
          final serviceSchedulingDay3das08as09 = serviceScheduling.copyWith(
            id: '4',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0).add(const Duration(days: 2)),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 2)),
          );
          final serviceSchedulingDay3das09as11 = serviceScheduling.copyWith(
            id: '5',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 2)),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0).add(const Duration(days: 2)),
          );

          final List<Scheduling> servicesSchedules = [
            serviceSchedulingDay1das08as09,
            serviceSchedulingDay2das08as09,
            serviceSchedulingDay2das09as11,
            serviceSchedulingDay3das08as09,
            serviceSchedulingDay3das09as11,
          ];

          DateTime day1 = actualDate;
          DateTime day2 = actualDate.add(const Duration(days: 1));
          DateTime day3 = actualDate.add(const Duration(days: 2));

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

          when(() => onlineMockSchedulingRepository.getPendingProviderSchedules()).thenAnswer(
            (_) async => Either.right(servicesSchedules),
          );

          final either = await schedulingService.getPendingProviderSchedules();

          expect(either.isRight, isTrue);
          expect(either.right!.length, equals(schedulesByDays.length));
          expect(either.right![1].day, schedulesByDays[1].day);
          expect(
            either.right![1].serviceSchedules.length,
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

          when(() => onlineMockSchedulingRepository.getPendingPaymentSchedules()).thenAnswer(
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
          final List<Scheduling> servicesSchedules = [];

          when(() => onlineMockSchedulingRepository.getPendingPaymentSchedules()).thenAnswer(
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
          final serviceSchedulingDay1das08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
          );
          final serviceSchedulingDay2das08as09 = serviceScheduling.copyWith(
            id: '2',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0).add(const Duration(days: 1)),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 1)),
          );
          final serviceSchedulingDay2das09as11 = serviceScheduling.copyWith(
            id: '3',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 1)),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0).add(const Duration(days: 1)),
          );
          final serviceSchedulingDay3das08as09 = serviceScheduling.copyWith(
            id: '4',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0).add(const Duration(days: 2)),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 2)),
          );
          final serviceSchedulingDay3das09as11 = serviceScheduling.copyWith(
            id: '5',
            startDateAndTime: actualDate.copyWith(hour: 9, minute: 0).add(const Duration(days: 2)),
            endDateAndTime: actualDate.copyWith(hour: 11, minute: 0).add(const Duration(days: 2)),
          );

          final List<Scheduling> servicesSchedules = [
            serviceSchedulingDay1das08as09,
            serviceSchedulingDay2das08as09,
            serviceSchedulingDay2das09as11,
            serviceSchedulingDay3das08as09,
            serviceSchedulingDay3das09as11,
          ];

          DateTime day1 = actualDate;
          DateTime day2 = actualDate.add(const Duration(days: 1));
          DateTime day3 = actualDate.add(const Duration(days: 2));

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

          when(() => onlineMockSchedulingRepository.getPendingPaymentSchedules()).thenAnswer(
            (_) async => Either.right(servicesSchedules),
          );

          final either = await schedulingService.getPendingPaymentSchedules();

          expect(either.isRight, isTrue);
          expect(either.right!.length, equals(schedulesByDays.length));
          expect(either.right![1].day, schedulesByDays[1].day);
          expect(
            either.right![1].serviceSchedules.length,
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
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(code: ServiceStatus.confirmCode, name: 'Confirmado'),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          final either =
              await schedulingService.confirmScheduling(schedulingId: serviceScheduling08as09.id);

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for pendente''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingProvider,
              name: 'Pendente Prestador',
            ),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          when(() => onlineMockSchedulingRepository.changeStatus(
                schedulingId: serviceScheduling08as09.id,
                statusCode: ServiceStatus.confirmCode,
              )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.confirmScheduling(schedulingId: serviceScheduling08as09.id);

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
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(code: ServiceStatus.deniedCode, name: 'Negado'),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          final either =
              await schedulingService.denyScheduling(schedulingId: serviceScheduling08as09.id);

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for pendente''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingProvider,
              name: 'Pendente Prestador',
            ),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          when(() => onlineMockSchedulingRepository.changeStatus(
                schedulingId: serviceScheduling08as09.id,
                statusCode: ServiceStatus.deniedCode,
              )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.denyScheduling(schedulingId: serviceScheduling08as09.id);

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
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(code: ServiceStatus.deniedCode, name: 'Negado'),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          final either = await schedulingService.requestChangeScheduling(
            schedulingId: serviceScheduling08as09.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for pendente prestador''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingProvider,
              name: 'Pendente Prestador',
            ),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          when(() => onlineMockSchedulingRepository.changeStatus(
                schedulingId: serviceScheduling08as09.id,
                statusCode: ServiceStatus.pendingClientCode,
              )).thenAnswer((_) async => Either.right(unit));

          final either = await schedulingService.requestChangeScheduling(
              schedulingId: serviceScheduling08as09.id);

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
          final serviceScheduling08as09 = serviceScheduling.copyWith(
              id: '1',
              startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
              endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
              serviceStatus: ServiceStatus(
                code: ServiceStatus.deniedCode,
                name: 'Negado',
              ));

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          final either = await schedulingService.cancelScheduling(
            schedulingId: serviceScheduling08as09.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual permitir cancelamento''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(
              code: ServiceStatus.pendingClientCode,
              name: 'Pendente Cliente',
            ),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          when(() => onlineMockSchedulingRepository.changeStatus(
                schedulingId: serviceScheduling08as09.id,
                statusCode: ServiceStatus.canceledByProviderCode,
              )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.cancelScheduling(schedulingId: serviceScheduling08as09.id);

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
        '''Deve retornar um Failure quando o status atual não for "Confirmado"''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
              id: '1',
              startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
              endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
              serviceStatus: ServiceStatus(
                code: ServiceStatus.pendingClientCode,
                name: 'Pendente cliente',
              ));

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          final either = await schedulingService.schedulingInService(
            schedulingId: serviceScheduling08as09.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for "Confirmado"''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(code: ServiceStatus.confirmCode, name: 'Confirmado'),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          when(() => onlineMockSchedulingRepository.changeStatus(
                schedulingId: serviceScheduling08as09.id,
                statusCode: ServiceStatus.inServiceCode,
              )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.schedulingInService(schedulingId: serviceScheduling08as09.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'performScheduling',
    () {
      test(
        '''Deve retornar um Failure quando o status atual não for "Em atendimento"''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
              id: '1',
              startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
              endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
              serviceStatus: ServiceStatus(code: ServiceStatus.confirmCode, name: 'Confirmado'));

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          final either = await schedulingService.performScheduling(
            schedulingId: serviceScheduling08as09.id,
          );

          expect(either.isLeft, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando o status atual for "Confirmado"''',
        () async {
          final serviceScheduling08as09 = serviceScheduling.copyWith(
            id: '1',
            startDateAndTime: actualDate.copyWith(hour: 8, minute: 0),
            endDateAndTime: actualDate.copyWith(hour: 9, minute: 0),
            serviceStatus: ServiceStatus(code: ServiceStatus.inServiceCode, name: 'Em atendimento'),
          );

          when(() => onlineMockSchedulingRepository.getScheduling(
                  schedulingId: serviceScheduling08as09.id))
              .thenAnswer((_) async => Either.right(serviceScheduling08as09));

          when(() => onlineMockSchedulingRepository.changeStatus(
                schedulingId: serviceScheduling08as09.id,
                statusCode: ServiceStatus.servicePerformCode,
              )).thenAnswer((_) async => Either.right(unit));

          final either =
              await schedulingService.performScheduling(schedulingId: serviceScheduling08as09.id);

          expect(either.isRight, isTrue);
          expect(either.right is Unit, isTrue);
        },
      );
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late DateTime actualDate;

  late SchedulingService serviceSchedulingService;

  late Service service1;
  late Service service2;
  late Service service3;

  late ServiceScheduling serviceScheduling08as09;
  late ServiceScheduling serviceScheduling09as11;
  late ServiceScheduling serviceScheduling10as12;
  late ServiceScheduling serviceScheduling13as15confirm;
  late ServiceScheduling serviceScheduling14as16;

  late SchedulingDay schedulingDayBefore10Days;
  late SchedulingDay schedulingDayAfter10Days;
  late SchedulingDay schedulingDayAfter100Days;

  void setUpValues() {
    final actualTime = DateTime.now();
    actualDate = DateTime(actualTime.year, actualTime.month, actualTime.day);

    serviceSchedulingService = SchedulingService(
      onlineRepository: onlineMockSchedulingRepository,
    );
    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Corte cabelo',
      price: 50,
      hours: 1,
      minutes: 0,
      imageUrl: '',
    );

    service2 = Service(
      id: '2',
      serviceCategoryId: '1',
      name: 'Moicano',
      price: 70,
      hours: 1,
      minutes: 0,
      imageUrl: '',
    );

    service3 = Service(
      id: '3',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 50,
      hours: 1,
      minutes: 0,
      imageUrl: '',
    );

    serviceScheduling08as09 = ServiceScheduling(
      id: '1',
      user: User(name: 'Lucas', surname: 'Silva'),
      services: [service1],
      serviceStatus: ServiceStatus(code: 1, name: 'Pendente prestador'),
      startDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 8, 0),
      endDateAndTime: DateTime(actualDate.year, actualDate.month, actualDate.day, 9, 0),
      totalDiscount: 0,
      totalPrice: service1.price,
      totalPaid: 0,
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
  }

  setUp(() {
    setUpMockServiceSchedulingRepository();
    setUpValues();
  });

  group(
    'getAllServicesByDay',
    () {
      test(
        '''Deve retornar um Failure caso algum erro ocorra no repository''',
        () async {
          const failureMessage = 'Mensagem de falha';
          final dateToConsult = DateTime(actualDate.year, actualDate.month, actualDate.day);
          when(onlineMockSchedulingRepository.getAllServicesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final getEither = await serviceSchedulingService.getAllServicesByDay(dateTime: dateToConsult);

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
          when(onlineMockSchedulingRepository.getAllServicesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          final getEither = await serviceSchedulingService.getAllServicesByDay(dateTime: dateToConsult);

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

          when(onlineMockSchedulingRepository.getAllServicesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          final getEither = await serviceSchedulingService.getAllServicesByDay(dateTime: dateToConsult);

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

          when(onlineMockSchedulingRepository.getAllServicesByDay(dateTime: dateToConsult))
              .thenAnswer((_) async => Either.right(serviceSchedules));

          final getEither = await serviceSchedulingService.getAllServicesByDay(dateTime: dateToConsult);

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
          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isLeft, isTrue);
          expect(datesEither.left!.message, equals(failureMessage));
        },
      );

      test(
        'Deve retorno um NetworkFailure caso não tenha acesso a internet',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final datesEither = await serviceSchedulingService.getDates();

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

        when(onlineMockSchedulingRepository.getDaysWithService())
            .thenAnswer((_) async => Either.right(schedulesPerDay));

        final datesEither = await serviceSchedulingService.getDates();

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

          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          final datesEither = await serviceSchedulingService.getDates();

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

          when(onlineMockSchedulingRepository.getDaysWithService())
              .thenAnswer((_) async => Either.right(schedulesPerDay));

          final datesEither = await serviceSchedulingService.getDates();

          expect(datesEither.isRight, isTrue);
          final dates = datesEither.right!;
          expect(dates.length, equals(daysToAddOfActualDate + daysToRemoveOfActualDate + 1));
          expect(dates[0], equals(schedulingDayBefore10Days));
          expect(dates[daysToAddOfActualDate + daysToRemoveOfActualDate], equals(schedulingDayAfter100Days));
        },
      );
    },
  );
}

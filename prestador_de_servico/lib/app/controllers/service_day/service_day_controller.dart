

import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/service_day/service_day_state.dart';

class ServiceDayController extends ChangeNotifier {
  final ServiceDayService serviceDayService;

  ServiceDayState _state = ServiceDayInitial();
  ServiceDayState get state => _state;
  void _emitState(ServiceDayState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(ServiceDayState currentState) {
    _state = currentState;
  }

  ServiceDayController({required this.serviceDayService});

  Future<void> load() async {
    _emitState(ServiceDayLoading());

    final getAllEither = await serviceDayService.getAll();
    if (getAllEither.isLeft) {
      _emitState(ServiceDayError(getAllEither.left!.message));
      return;
    }

    _emitState(ServiceDayLoaded(serviceDays: getAllEither.right!));
  }

  Future<void> update({required ServiceDay serviceDay}) async {
    if (_state is! ServiceDayLoaded) {
      return;
    }

    final updateEither = await serviceDayService.update(serviceDay: serviceDay);
    if (updateEither.isRight) {
      final serviceDays = (_state as ServiceDayLoaded).serviceDays;
      final serviceDayIndex = serviceDays.indexWhere((s) => s.id == serviceDay.id);
      serviceDays[serviceDayIndex] = serviceDay;
      _changeState(ServiceDayLoaded(serviceDays: serviceDays));
      return;
    }

    final getAllEither = await serviceDayService.getAll();
    if (getAllEither.isLeft) {
      _emitState(ServiceDayError(updateEither.left!.message));
      return;
    }

    _emitState(ServiceDayLoaded(
      serviceDays: getAllEither.right!,
      message: updateEither.left!.message,
    ));
  }
}

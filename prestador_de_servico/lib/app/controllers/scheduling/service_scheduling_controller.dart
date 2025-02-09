import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/service_scheduling_state.dart';

class ServiceSchedulingController extends ChangeNotifier {
  final SchedulingService schedulingService;

  ServiceSchedulingState _state = ServiceSchedulingInitial();
  ServiceSchedulingState get state => _state;
  void _emitState(ServiceSchedulingState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(ServiceSchedulingState currentState) {
    _state = currentState;
  }

  ServiceSchedulingController({required this.schedulingService}); 

  Future<void> load({required DateTime dateTime}) async {
    _emitState(ServiceSchedulingLoading());

    final servicesSchedulesEither = await schedulingService.getAllServicesByDay(dateTime: dateTime);
    if (servicesSchedulesEither.isLeft) {
      _emitState(ServiceSchedulingError(servicesSchedulesEither.left!.message));
    } else {
      _emitState(ServiceSchedulingLoaded(serviceSchedules: servicesSchedulesEither.right!));
    }
  }

  void exit() {
    _changeState(ServiceSchedulingInitial());
  }
}

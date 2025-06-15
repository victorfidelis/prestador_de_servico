import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/states/scheduling/service_scheduling_state.dart';

class ServiceSchedulingViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  bool _dispose = false;

  ServiceSchedulingState _state = ServiceSchedulingInitial();
  ServiceSchedulingState get state => _state;
  void _emitState(ServiceSchedulingState currentState) {
    _state = currentState;
    if (!_dispose) notifyListeners();
  }

  void _changeState(ServiceSchedulingState currentState) {
    _state = currentState;
  }

  @override void dispose() {
    _dispose = true;
    super.dispose();
  }

  ServiceSchedulingViewModel({required this.schedulingService}); 

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

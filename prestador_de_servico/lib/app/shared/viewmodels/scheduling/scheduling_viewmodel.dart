import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/states/scheduling/scheduling_state.dart';

class SchedulingViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  bool _dispose = false;

  SchedulingState _state = SchedulingInitial();
  SchedulingState get state => _state;
  void _emitState(SchedulingState currentState) {
    _state = currentState;
    if (!_dispose) notifyListeners();
  }

  void _changeState(SchedulingState currentState) {
    _state = currentState;
  }

  @override void dispose() {
    _dispose = true;
    super.dispose();
  }

  SchedulingViewModel({required this.schedulingService}); 

  Future<void> load({required DateTime dateTime}) async {
    _emitState(SchedulingLoading());

    final servicesSchedulesEither = await schedulingService.getAllServicesByDay(dateTime: dateTime);
    if (servicesSchedulesEither.isLeft) {
      _emitState(SchedulingError(servicesSchedulesEither.left!.message));
    } else {
      _emitState(SchedulingLoaded(schedules: servicesSchedulesEither.right!));
    }
  }

  void exit() {
    _changeState(SchedulingInitial());
  }
}

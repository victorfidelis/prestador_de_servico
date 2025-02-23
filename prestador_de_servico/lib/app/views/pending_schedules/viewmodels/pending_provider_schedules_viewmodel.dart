import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';

class PendingProviderSchedulesViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;

  PendingSchedulesState _state = PendingInitial();
  PendingSchedulesState get state => _state;
  void _emitState(PendingSchedulesState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(PendingSchedulesState currentState) {
    _state = currentState;
  }

  PendingProviderSchedulesViewModel({required this.schedulingService});

  Future<void> load() async {
    _emitState(PendingLoading());

    final pendingProviderSchedulesEither = await schedulingService.getPendingProviderSchedules();
    if (pendingProviderSchedulesEither.isLeft) {
      _emitState(PendingError(pendingProviderSchedulesEither.left!.message));
    } else {
      _emitState(PendingLoaded(schedulesByDays: pendingProviderSchedulesEither.right!));
    }
  }
  
  void exit() {
    _changeState(PendingInitial());
  }
}

import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/pending_provider_schedules/states/pending_provider_schedules_state.dart';

class PendingProviderSchedulesViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;

  PendingProviderSchedulesState _state = PendingProviderInitial();
  PendingProviderSchedulesState get state => _state;
  void _emitState(PendingProviderSchedulesState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(PendingProviderSchedulesState currentState) {
    _state = currentState;
  }

  PendingProviderSchedulesViewModel({required this.schedulingService});

  Future<void> load() async {
    _emitState(PendingProviderLoading());

    final pendingProviderSchedulesEither = await schedulingService.getPendingProviderSchedules();
    if (pendingProviderSchedulesEither.isLeft) {
      _emitState(PendingProviderError(pendingProviderSchedulesEither.left!.message));
    } else {
      _emitState(PendingProviderLoaded(schedulesByDays: pendingProviderSchedulesEither.right!));
    }
  }
  
  void exit() {
    _changeState(PendingProviderInitial());
  }
}

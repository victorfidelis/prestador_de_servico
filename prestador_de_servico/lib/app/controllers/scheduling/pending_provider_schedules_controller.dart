import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extensions.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/pending_provider_schedules_state.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/service_scheduling_state.dart';

class PendingProviderSchedulesController extends ChangeNotifier {
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

  PendingProviderSchedulesController({required this.schedulingService});

  Future<void> load() async {
    _emitState(PendingProviderLoading());

    final pendingProviderSchedulesEither = await schedulingService.getPendingProviderSchedules();
    if (pendingProviderSchedulesEither.isLeft) {
      _emitState(PendingProviderError(pendingProviderSchedulesEither.left!.message));
    } else {
      _emitState(PendingProviderLoaded(serviceSchedules: pendingProviderSchedulesEither.right!));
    }
  }
  
  void exit() {
    _changeState(PendingProviderInitial());
  }
}

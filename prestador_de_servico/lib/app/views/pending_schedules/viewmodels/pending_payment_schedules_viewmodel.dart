import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';

class PendingPaymentSchedulesViewModel extends ChangeNotifier {
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

  PendingPaymentSchedulesViewModel({required this.schedulingService});

  Future<void> load() async {
    _emitState(PendingLoading());

    final pendingPaymentSchedulesEither = await schedulingService.getPendingPaymentSchedules();
    if (pendingPaymentSchedulesEither.isLeft) {
      _emitState(PendingError(pendingPaymentSchedulesEither.left!.message));
    } else {
      _emitState(PendingLoaded(schedulesByDays: pendingPaymentSchedulesEither.right!));
    }
  }
  
  void exit() {
    _changeState(PendingInitial());
  }
}

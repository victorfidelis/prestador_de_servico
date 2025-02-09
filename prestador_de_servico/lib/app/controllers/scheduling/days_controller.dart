import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/days_state.dart';

class DaysController extends ChangeNotifier {
  final SchedulingService schedulingService;

  DaysState _state = DaysInitial();
  DaysState get state => _state;
  void _emitState(DaysState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(DaysState currentState) {
    _state = currentState;
  }

  DaysController({required this.schedulingService}); 

  Future<void> load() async {
    _emitState(DaysLoading());
    final daysEither = await schedulingService.getDates();
    if (daysEither.isLeft) {
      _emitState(DaysError(daysEither.left!.message));
    } else {
      _emitState(DaysLoaded(dates: daysEither.right!));
    }
  } 

  void exit() {
    _changeState(DaysInitial());
  }
}
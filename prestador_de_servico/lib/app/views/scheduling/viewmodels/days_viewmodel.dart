import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/days_state.dart';

class DaysViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;

  DaysState _state = DaysInitial();
  DaysState get state => _state;
  void _emitState(DaysState currentState) {
    _state = currentState;
    notifyListeners();
  }

  DaysViewModel({required this.schedulingService});

  Future<void> load(DateTime selectedDay) async {
    TypeView typeView = TypeView.main;
    if (state is DaysLoaded) {
      typeView = (state as DaysLoaded).typeView;
    }

    _emitState(DaysLoading());
    final daysEither = await schedulingService.getDates(selectedDay);
    if (daysEither.isLeft) {
      _emitState(DaysError(daysEither.left!.message));
    } else {
      _emitState(DaysLoaded(dates: daysEither.right!, typeView: typeView));
    }
  }

  void changeTypeView(TypeView typeView) {
    if (state is! DaysLoaded) {
      return;
    }

    final newState = (state as DaysLoaded).copyWith(typeView: typeView);

    _emitState(newState);
  }

  void changeSelectedDay(DateTime date) {
    if (state is! DaysLoaded) {
      return;
    }

    final dates = (state as DaysLoaded).dates;

    final int indexForCurrentDate = dates.indexWhere((d) => d.date == date);
    final int indexForOldDate = dates.indexWhere((d) => d.isSelected);

    dates[indexForCurrentDate] = dates[indexForCurrentDate].copyWith(isSelected: true);

    if (indexForCurrentDate != indexForOldDate && indexForOldDate >= 0) {
      dates[indexForOldDate] = dates[indexForOldDate].copyWith(isSelected: false);
    }
  }
}

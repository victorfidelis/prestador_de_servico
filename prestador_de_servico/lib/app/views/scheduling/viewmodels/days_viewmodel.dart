import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/type_view.dart';

class DaysViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  final ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());
  List<SchedulingDay> schedulesPerDay = [];
  TypeView typeView = TypeView.main;

  bool daysLoading = false;

  String? errorMessage;

  DaysViewModel({required this.schedulingService});

  bool get hasError => errorMessage != null;

  void _setDaysLoading(bool value) {
    daysLoading = value;
    notifyListeners();
  }

  Future<void> load() async {
    _setDaysLoading(true);

    final daysEither = await schedulingService.getDates(selectedDay.value);
    if (daysEither.isLeft) {
      errorMessage = daysEither.left!.message;
    } else {
      schedulesPerDay = daysEither.right!;
    }

    _setDaysLoading(false);
  }

  void changeTypeView(TypeView typeView) {
    if (daysLoading) {
      return;
    }

    this.typeView = typeView;
    notifyListeners();
  }

  void changeSelectedDay(DateTime date) {
    if (daysLoading || selectedDay.value == date) {
      return;
    }

    selectedDay.value = date;

    final int indexForCurrentDate = schedulesPerDay.indexWhere((d) => d.date == date);
    final int indexForOldDate = schedulesPerDay.indexWhere((d) => d.isSelected);

    schedulesPerDay[indexForCurrentDate] = schedulesPerDay[indexForCurrentDate].copyWith(isSelected: true);

    if (indexForCurrentDate != indexForOldDate && indexForOldDate >= 0) {
      schedulesPerDay[indexForOldDate] = schedulesPerDay[indexForOldDate].copyWith(isSelected: false);
    }
  }

  void changeToToday() {
    final actualDateTime = DateTime.now();
    selectedDay.value = DateTime(actualDateTime.year, actualDateTime.month, actualDateTime.day);
  }
}

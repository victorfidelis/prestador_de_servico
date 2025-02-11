import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';

class SchedulingDayList extends ChangeNotifier {
  final List<SchedulingDay> value;

  SchedulingDayList({required this.value});

  void changeSelectedDay(DateTime date) {
    
    final oldSelectedIndex = value.indexWhere((s) => s.isSelected);
    if (oldSelectedIndex >= 0) {
      value[oldSelectedIndex] = value[oldSelectedIndex].copyWith(isSelected: false);
    }

    final newSelectedIndex = value.indexWhere((s) => s.date == date);
    if (newSelectedIndex >= 0) {
      value[newSelectedIndex] = value[newSelectedIndex].copyWith(isSelected: true);
    }
    
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class PendingProviderSchedulesViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  List<SchedulesByDay> schedulesByDays = [];

  bool pendingLoading = false;

  String? errorMessage;

  PendingProviderSchedulesViewModel({required this.schedulingService});

  bool get hasError => errorMessage != null;

  void _setPendingLoading(bool value) {
    pendingLoading = value;
    notifyListeners();
  }

  Future<void> load() async {
    _clearError();
    _setPendingLoading(true);

    final pendingProviderEither = await schedulingService.getPendingProviderSchedules();
    if (pendingProviderEither.isLeft) {
      errorMessage = pendingProviderEither.left!.message;
    } else {
      schedulesByDays = pendingProviderEither.right!;
    }

    _setPendingLoading(false);
  } 

  void _clearError() {
    errorMessage = null;
  }
}

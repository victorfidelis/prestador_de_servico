import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class PendingPaymentSchedulesViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  List<SchedulesByDay> schedulesByDays = [];

  bool pendingLoading = false;

  String? errorMessage;

  PendingPaymentSchedulesViewModel({required this.schedulingService});

  bool get hasError => errorMessage != null;

  void _setPendingLoading(bool value) {
    pendingLoading = value;
    notifyListeners();
  }

  Future<void> load() async {
    _clearErrors();
    _setPendingLoading(true);

    final pendingPaymentEither = await schedulingService.getPendingPaymentSchedules();
    if (pendingPaymentEither.isLeft) {
      errorMessage = pendingPaymentEither.left!.message;
    } else {
      schedulesByDays = pendingPaymentEither.right!;
    }

    _setPendingLoading(false);
  }

  void _clearErrors() {
    errorMessage = null;
  }
}

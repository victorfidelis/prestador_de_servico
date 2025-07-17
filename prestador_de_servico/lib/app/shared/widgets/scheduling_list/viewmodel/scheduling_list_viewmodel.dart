import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class SchedulingListViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  List<Scheduling> schedules = [];
  
  bool schedulesLoading = false;

  String? errorMessage;

  SchedulingListViewModel({required this.schedulingService}); 
  
  bool get hasError => errorMessage != null;

  void _setSchedulesLoading(bool value) {
    schedulesLoading = value;
    notifyListeners();
  }


  Future<void> load({required DateTime dateTime}) async {
    _clearErrors();
    _setSchedulesLoading(true);

    final servicesSchedulesEither = await schedulingService.getAllServicesByDay(dateTime: dateTime);
    if (servicesSchedulesEither.isLeft) {
      errorMessage = servicesSchedulesEither.left!.message;
    } else {
      schedules = servicesSchedulesEither.right!;
    }

    _setSchedulesLoading(false);
  }

  void _clearErrors() {
    errorMessage = null;
  }
}

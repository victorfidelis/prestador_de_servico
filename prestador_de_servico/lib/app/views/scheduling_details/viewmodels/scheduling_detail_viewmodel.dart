import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';

class SchedulingDetailViewModel extends ChangeNotifier {
  ServiceScheduling serviceScheduling;
  
  SchedulingDetailViewModel({required this.serviceScheduling});
  
  void changeDateAndTime({
    required DateTime startDateAndTime,
    required DateTime endDateAndTime,
  }) {
    serviceScheduling = serviceScheduling.copyWith(
      oldStartDateAndTime: serviceScheduling.startDateAndTime,
      oldEndDateAndTime: serviceScheduling.endDateAndTime,
      startDateAndTime: startDateAndTime,
      endDateAndTime: endDateAndTime,
    );

    notifyListeners();
  }
}

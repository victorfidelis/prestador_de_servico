import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';

class SchedulingDetailViewModel extends ChangeNotifier {
  SchedulingService schedulingService;
  ServiceScheduling serviceScheduling;
  bool hasChange = false;

  SchedulingDetailViewModel({
    required this.serviceScheduling,
    required this.schedulingService,
  });

  SchedulingDetailState _state = SchedulingDetailInitial();
  SchedulingDetailState get state => _state;
  void _emitState(SchedulingDetailState currentState) {
    _state = currentState;
    notifyListeners();
  }

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
    hasChange = true;

    notifyListeners();
  }

  void changeServiceScheduling({
    required ServiceScheduling serviceScheduling,
  }) async {
    _emitState(SchedulingDetailLoading());

    final getEither =
        await schedulingService.getServiceScheduling(serviceSchedulingId: serviceScheduling.id);

    if (getEither.isLeft) {
      _emitState(SchedulingDetailError(message: getEither.left!.message));
    } else {
      serviceScheduling = getEither.right!;
      _emitState(SchedulingDetailLoaded());
    }
  }
}

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

  Future<void> onChangeScheduling() async {
    hasChange = true;
    await refreshServiceScheduling();
  }

  Future<void> refreshServiceScheduling() async {
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

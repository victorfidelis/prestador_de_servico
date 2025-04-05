import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';

class SchedulingDetailViewModel extends ChangeNotifier {
  SchedulingService schedulingService;
  ServiceScheduling scheduling;
  bool hasChange = false;

  SchedulingDetailViewModel({
    required this.scheduling,
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
        await schedulingService.getServiceScheduling(serviceSchedulingId: scheduling.id);

    if (getEither.isLeft) {
      _emitState(SchedulingDetailError(message: getEither.left!.message));
    } else {
      scheduling = getEither.right!;
      _emitState(SchedulingDetailLoaded());
    }
  }

  Future<void> confirmScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.confirmScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshServiceScheduling();
    }
  }

  Future<void> denyScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.denyScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshServiceScheduling();
    }
  }

  Future<void> requestChangeScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.requestChangeScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshServiceScheduling();
    }
  }
}

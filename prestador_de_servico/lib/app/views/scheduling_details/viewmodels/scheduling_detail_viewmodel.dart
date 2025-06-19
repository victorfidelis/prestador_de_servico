import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';

class SchedulingDetailViewModel extends ChangeNotifier {
  SchedulingService schedulingService;
  Scheduling scheduling;
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
    await refreshScheduling();
  }

  Future<void> refreshScheduling() async {
    _emitState(SchedulingDetailLoading());

    final getEither =
        await schedulingService.getScheduling(schedulingId: scheduling.id);

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
      await refreshScheduling();
    }
  }

  Future<void> denyScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.denyScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> requestChangeScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.requestChangeScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> cancelScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.cancelScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> schedulingInService() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.schedulingInService(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> performScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.performScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> reviewScheduling({
    required int review,
    required String reviewDetails,
  }) async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.addOrEditReview(
      schedulingId: scheduling.id,
      review: review,
      reviewDetails: reviewDetails,
    );

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      await refreshScheduling();
    }
  }

  
}

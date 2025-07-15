import 'package:flutter/widgets.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/edit_date_and_time_state.dart';

class EditDateAndTimeViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  int serviceTimeInMinutes = 0;

  late String schedulingId;
  ValueNotifier<DateTime?> schedulingDate = ValueNotifier(null);
  ValueNotifier<String?> schedulingDateError = ValueNotifier(null);
  String startTime = '';
  ValueNotifier<String?> startTimeError = ValueNotifier(null);
  ValueNotifier<String> endTime = ValueNotifier('');
  ValueNotifier<String?> endTimeError = ValueNotifier(null);

  EditDateAndTimeState _state = EditDateAndTimeInitial();
  EditDateAndTimeState get state => _state;
  void _emitState(EditDateAndTimeState currentState) {
    _state = currentState;
    notifyListeners();
  }

  EditDateAndTimeViewModel({required this.schedulingService});

  DateTime? get startDateAndTime {
    if (schedulingDate.value == null || !DataConverter.isTime(startTime)) {
      return null;
    }
    return DataConverter.concatDateAndHours(
      schedulingDate.value!,
      startTime,
    );
  }
  DateTime? get endDateAndTime {
    if (schedulingDate.value == null || !DataConverter.isTime(endTime.value)) {
      return null;
    }
    return DataConverter.concatDateAndHours(
      schedulingDate.value!,
      endTime.value,
    );
  }

  void setServiceTime(int serviceTimeInMinutes) {
    this.serviceTimeInMinutes = serviceTimeInMinutes;
  }

  void setSchedulingDate(DateTime schedulingDate) {
    this.schedulingDate.value = schedulingDate;
    schedulingDateError.value = null;
  }

  void setStartTime(String startTime) {
    this.startTime = startTime;
    startTimeError.value = null;
    setEndTime();
  }

  void setEndTime() {
    endTime.value = DataConverter.addMinutes(startTime, serviceTimeInMinutes);
    endTimeError.value = null;
  }

  void setSchedulingId(String schedulingId) {
    this.schedulingId = schedulingId;
  }

  bool validate() {
    bool isValid = true;
    if (schedulingDate.value == null) {
      schedulingDateError.value = 'Adicionar a data';
      isValid = false;
    }
    if (!DataConverter.isTime(startTime)) {
      startTimeError.value = 'Adicionar hora';
      isValid = false;
    }
    if (!DataConverter.isTime(endTime.value)) {
      endTimeError.value = 'Adicionar hora';
      isValid = false;
    }
    return isValid;
  }

  Future<void> save() async {
    _emitState(EditDateAndTimeLoading());

    final editEither = await schedulingService.editDateOfScheduling(
      schedulingId: schedulingId,
      startDateAndTime: startDateAndTime!,
      endDateAndTime: endDateAndTime!,
    );

    if (editEither.isLeft) {
      _emitState(EditDateAndTimeError(message: editEither.left!.message));
    } else {
      _emitState(EditDateAndTimeUpdateSuccess());
    }
  }
}

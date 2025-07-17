import 'package:flutter/widgets.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';

class EditDateAndTimeViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  final Scheduling scheduling;
  
  bool editLoading = false;

  final TextEditingController dateController = TextEditingController();
  ValueNotifier<DateTime?> schedulingDate = ValueNotifier(null);
  final TextEditingController startTimeController = TextEditingController();
  ValueNotifier<String> endTime = ValueNotifier('');

  ValueNotifier<bool> editSuccessful = ValueNotifier(false);
  ValueNotifier<String?> notificationMessage = ValueNotifier(null); 

  ValueNotifier<String?> schedulingDateError = ValueNotifier(null);
  ValueNotifier<String?> startTimeError = ValueNotifier(null);

  EditDateAndTimeViewModel({required this.schedulingService, required this.scheduling});

  @override
  void dispose() {
    dateController.dispose();
    startTimeController.dispose();
    super.dispose();
  }
  
  DateTime? get _startDateAndTime {
    if (schedulingDate.value == null || !DataConverter.isTime(startTimeController.text)) {
      return null;
    }
    return DataConverter.concatDateAndHours(
      schedulingDate.value!,
      startTimeController.text,
    );
  }

  DateTime? get _endDateAndTime {
    if (schedulingDate.value == null || !DataConverter.isTime(endTime.value)) {
      return null;
    }
    return DataConverter.concatDateAndHours(
      schedulingDate.value!,
      endTime.value,
    );
  }

  void _setEditLoading(bool value) {
    editLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // É necessário para garantir o ValueNotifier vai notificar os ouvintes
    notificationMessage.value = value;
  }

  void setSchedulingDate(DateTime schedulingDate) {
    schedulingDateError.value = null;
    dateController.text = DataConverter.defaultFormatDate(schedulingDate);
    this.schedulingDate.value = schedulingDate;
  }

  void setEndTime() {
    endTime.value = DataConverter.addMinutes(startTimeController.text, scheduling.serviceTime);
  }

  Future<void> save() async {
    _setEditLoading(true);

    final editEither = await schedulingService.editDateOfScheduling(
      schedulingId: scheduling.id,
      startDateAndTime: _startDateAndTime!,
      endDateAndTime: _endDateAndTime!,
    );

    if (editEither.isLeft) {
      _setNotificationMessage(editEither.left!.message);
    } else {
      _setNotificationMessage('Horário atualizado com sucesso');
      editSuccessful.value = true;
    }

    _setEditLoading(false);
  }

  bool validate() {
    _clearErrors();
    bool isValid = true;

    if (schedulingDate.value == null) {
      schedulingDateError.value = 'Adicionar a data';
      isValid = false;
    }
    if (!DataConverter.isTime(startTimeController.text)) {
      startTimeError.value = 'Adicionar hora';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  } 

  void _clearErrors() {
    schedulingDateError.value = null;
    startTimeError.value = null;
  }
}

abstract class EditDateAndTimeState {}

class EditDateAndTimeInitial extends EditDateAndTimeState {}

class EditDateAndTimeLoading extends EditDateAndTimeState {}

class EditDateAndTimeUpdateSuccess extends EditDateAndTimeState {
  EditDateAndTimeUpdateSuccess();
}

class EditDateAndTimeError extends EditDateAndTimeState {
  final String message;

  EditDateAndTimeError({required this.message});
}

class DateValidadeError extends EditDateAndTimeState {
  final String? message;
  DateValidadeError({this.message});
}


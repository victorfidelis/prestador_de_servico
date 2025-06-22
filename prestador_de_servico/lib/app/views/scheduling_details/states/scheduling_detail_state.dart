abstract class SchedulingDetailState {}

class SchedulingDetailInitial extends SchedulingDetailState {}

class SchedulingDetailLoaded extends SchedulingDetailState {
  final String? message;
  SchedulingDetailLoaded({this.message});
}

class SchedulingDetailLoading extends SchedulingDetailState {}

class SchedulingDetailSuccess extends SchedulingDetailState {}

class SchedulingDetailError extends SchedulingDetailState {
  final String message;

  SchedulingDetailError({required this.message});
}

class ServiceImagesLoaded extends SchedulingDetailState {
  final String? message;
  ServiceImagesLoaded({this.message});
}

class ServiceImagesLoading extends SchedulingDetailState {}

class ServiceImagesError extends SchedulingDetailError {
  ServiceImagesError({required super.message});
}

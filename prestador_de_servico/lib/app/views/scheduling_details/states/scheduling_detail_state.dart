abstract class SchedulingDetailState {}

class SchedulingDetailInitial extends SchedulingDetailState {}

class SchedulingDetailLoaded extends SchedulingDetailState {}

class SchedulingDetailLoading extends SchedulingDetailState {}

class SchedulingDetailSuccess extends SchedulingDetailState {}

class SchedulingDetailError extends SchedulingDetailState {
  final String message;

  SchedulingDetailError({required this.message});
}


class ServiceImagesLoaded extends SchedulingDetailState {}

class ServiceImagesLoading extends SchedulingDetailState {}

class ServiceImagesError extends SchedulingDetailError {
  ServiceImagesError({required super.message});
}


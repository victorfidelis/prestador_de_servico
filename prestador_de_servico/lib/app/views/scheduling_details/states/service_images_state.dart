abstract class ServiceImagesState {}

class ServiceImagesInitial extends ServiceImagesState {}

class ServiceImagesLoaded extends ServiceImagesState {}

class ServiceImagesLoading extends ServiceImagesState {}

class ServiceImagesError extends ServiceImagesState {
  final String message;

  ServiceImagesError(this.message);
}

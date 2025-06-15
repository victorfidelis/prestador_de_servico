import 'dart:io';

abstract class ServiceImagesState {}

class ServiceImagesInitial extends ServiceImagesState {}

class ServiceImagesLoaded extends ServiceImagesState {}

class ServiceImagesLoading extends ServiceImagesState {}

class ServiceImagesError extends ServiceImagesState {
  final String message;

  ServiceImagesError({required this.message});
}


class PickImageError extends ServiceImagesState{
  final String message;
  PickImageError(this.message);
}

class PickImageSuccess extends ServiceImagesState{
  final File imageFile;
  PickImageSuccess(this.imageFile);
}
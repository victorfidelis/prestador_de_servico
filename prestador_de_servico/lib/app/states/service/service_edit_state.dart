import 'dart:io';

import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

abstract class ServiceEditState {}

class ServiceEditInitial extends ServiceEditState {}

class ServiceEditAdd extends ServiceEditState {
  final ServiceCategory serviceCategory;
  ServiceEditAdd({required this.serviceCategory});
}

class ServiceEditUpdate extends ServiceEditState {
  final ServiceCategory serviceCategory;
  final Service service;
  ServiceEditUpdate({required this.serviceCategory, required this.service});
}

class ServiceEditLoading extends ServiceEditState {}

class ServiceEditError extends ServiceEditState {
  final String? nameMessage;
  final String? priceMessage;
  final String? hoursAndMinutesMessage;
  final String? genericMessage;

  ServiceEditError({
    this.nameMessage,
    this.priceMessage,
    this.hoursAndMinutesMessage,
    this.genericMessage,
  });
}

class ServiceEditValidated extends ServiceEditState {}

class ServiceEditSuccess extends ServiceEditState {
  final Service service;

  ServiceEditSuccess({required this.service});
}

class PickImageError extends ServiceEditState{
  final String message;
  PickImageError(this.message);
}

class PickImageSuccess extends ServiceEditState{
  final File imageFile;
  PickImageSuccess(this.imageFile);
}
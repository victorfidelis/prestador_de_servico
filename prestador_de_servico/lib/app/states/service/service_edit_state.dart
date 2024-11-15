import 'package:prestador_de_servico/app/models/service/service.dart';

abstract class ServiceEditState {}

class ServiceEditInitial extends ServiceEditState {}

class ServiceEditAdd extends ServiceEditState {}

class ServiceEditUpdate extends ServiceEditState {
  final Service service;
  ServiceEditUpdate({required this.service});
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

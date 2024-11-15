import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/service/service_edit_state.dart';

class ServiceEditController extends ChangeNotifier {
  final ServiceService serviceService;

  ServiceEditController({required this.serviceService});

  ServiceEditState _state = ServiceEditInitial();
  ServiceEditState get state => _state;
  void _changeState(ServiceEditState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void initInsert() {
    _changeState(ServiceEditAdd());
  }

  void initUpdate({required Service service}) {
    _changeState(ServiceEditUpdate(service: service));
  }

  Future<void> validateAndInsert({required Service service}) async {
    if (state is ServiceEditLoading) {
      return;
    }

    _changeState(ServiceEditLoading());

    final validation = _validade(service: service);
    if (validation is ServiceEditError) {
      _changeState(validation);
      return;
    }
    
    final insertEither = await serviceService.insert(service: service);
    if (insertEither.isLeft) {
      _changeState(ServiceEditError(genericMessage: insertEither.left!.message));
      return;
    }

    _changeState(ServiceEditSuccess(service: insertEither.right!));
  }

  Future<void> validateAndUpdate({required Service service}) async {
    if (state is ServiceEditLoading) {
      return;
    }

    _changeState(ServiceEditLoading());

    final validation = _validade(service: service);
    if (validation is ServiceEditError) {
      _changeState(validation);
      return;
    }
    
    final insertEither = await serviceService.update(service: service);
    if (insertEither.isLeft) {
      _changeState(ServiceEditError(genericMessage: insertEither.left!.message));
      return;
    }

    _changeState(ServiceEditSuccess(service: service));
  }

  ServiceEditState _validade({required Service service}) {
    if (service.name.trim().isEmpty) {
      return ServiceEditError(nameMessage: 'Necessário informar o nome');
    }
    if (service.price == 0) {
      return ServiceEditError(priceMessage: 'Necessário informar o preço');
    }
    if (service.hours == 0 && service.minutes == 0) {
      return ServiceEditError(hoursAndMinutesMessage: 'Necessário informar o tempo');
    }
    return ServiceEditValidated();
  }
}

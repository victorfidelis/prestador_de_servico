import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/service/service_edit_state.dart';

class ServiceEditController extends ChangeNotifier {
  final ServiceService serviceService;
  final OfflineImageService offlineImageService;

  ServiceEditController({
    required this.serviceService,
    required this.offlineImageService,
  });

  ServiceEditState _state = ServiceEditInitial();
  ServiceEditState get state => _state;
  void _changeState(ServiceEditState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void initInsert({required ServiceCategory serviceCategory}) {
    _changeState(ServiceEditAdd(serviceCategory: serviceCategory));
  }

  void initUpdate({required ServiceCategory serviceCategory, required Service service}) {
    _changeState(ServiceEditUpdate(serviceCategory: serviceCategory, service: service));
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

  Future<void> pickImageFromGallery() async {
    final eitherPickImage = await offlineImageService.pickImageFromGallery();
    if (eitherPickImage.isLeft) {
      _changeState(PickImageError(eitherPickImage.left!.message));
    } else {
      _changeState(PickImageSuccess(eitherPickImage.right!));
    }
  }
}

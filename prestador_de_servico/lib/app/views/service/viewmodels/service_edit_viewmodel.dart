import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/service/states/service_edit_state.dart';

class ServiceEditViewModel extends ChangeNotifier {
  final ServiceService serviceService;
  final OfflineImageService offlineImageService;
  bool _dispose = false;

  ServiceEditViewModel({
    required this.serviceService,
    required this.offlineImageService,
  });

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  ServiceEditState _state = ServiceEditInitial();
  ServiceEditState get state => _state;
  void _emitState(ServiceEditState currentState) {
    _state = currentState;
    if (!_dispose) notifyListeners();
  }

  void initInsert({required ServiceCategory serviceCategory}) {
    _emitState(ServiceEditAdd(serviceCategory: serviceCategory));
  }

  void initUpdate({required ServiceCategory serviceCategory, required Service service}) {
    _emitState(ServiceEditUpdate(serviceCategory: serviceCategory, service: service));
  }

  Future<void> validateAndInsert({required Service service}) async {
    if (state is ServiceEditLoading) {
      return;
    }

    _emitState(ServiceEditLoading());

    final validation = _validate(service: service);
    if (validation is ServiceEditError) {
      _emitState(validation);
      return;
    }

    final insertEither = await serviceService.insert(service: service);
    if (insertEither.isLeft) {
      _emitState(ServiceEditError(genericMessage: insertEither.left!.message));
      return;
    }

    _emitState(ServiceEditSuccess(service: insertEither.right!));
  }

  Future<void> validateAndUpdate({required Service service}) async {
    if (state is ServiceEditLoading) {
      return;
    }

    _emitState(ServiceEditLoading());

    final validation = _validate(service: service);
    if (validation is ServiceEditError) {
      _emitState(validation);
      return;
    }

    final updateEither = await serviceService.update(service: service);
    if (updateEither.isLeft) {
      _emitState(ServiceEditError(genericMessage: updateEither.left!.message));
      return;
    }

    _emitState(ServiceEditSuccess(service: updateEither.right!));
  }

  ServiceEditState _validate({required Service service}) {
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
      _emitState(PickImageError(eitherPickImage.left!.message));
    } else {
      _emitState(PickImageSuccess(eitherPickImage.right!));
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class ServiceEditViewModel extends ChangeNotifier {
  final ServiceService serviceService;
  final OfflineImageService offlineImageService;
  final ServiceCategory serviceCategory;
  Service? service;

  bool serviceEditLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  String? imageUrl;
  File? imageFile;
  late bool isUpdate;

  String? genericErrorMessage;
  String? nameErrorMessage;
  String? priceErrorMessage;
  String? hoursAndMinutesErrorMessage;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);
  ValueNotifier<bool> editSuccessful = ValueNotifier(false);
  
  ServiceEditViewModel({
    required this.serviceService,
    required this.offlineImageService,
    required this.serviceCategory,
    required this.service,
  }) {
    isUpdate = (service != null);
    _loadFields();
  }

  void _setServiceLoading(bool value) {
    serviceEditLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // É necessário para garantir o ValueNotifier vai notificar os ouvintes
    notificationMessage.value = value;
  }

  void _loadFields() {
    if (!isUpdate) {
      return;
    }

    nameController.text = service!.name;
    priceController.text = service!.price.toString().replaceAll('.', ',');
    if (service!.hours == 0) {
      hoursController.text = '';
    } else {
      hoursController.text = service!.hours.toString();
    }
    if (service!.minutes == 0) {
      minutesController.text = '';
    } else {
      minutesController.text = service!.minutes.toString();
    }
    if (service!.imageUrl.isNotEmpty) {
      imageUrl = service!.imageUrl;
    }
  }

  Future<void> saveService() async {
    if (serviceEditLoading) {
      return;
    }

    _clearErrors();
    if (!_validateService()) {
      notifyListeners();
      return;
    }

    _setServiceLoading(true);

    final serviceToSave = Service(
      id: service?.id ?? '',
      serviceCategoryId: serviceCategory.id,
      name: nameController.text,
      price: DataConverter.textToPrice(priceController.text),
      hours: DataConverter.textToHour(hoursController.text),
      minutes: DataConverter.textToMinute(minutesController.text),
      imageUrl: imageUrl ?? '',
      imageFile: imageFile,
    );

    Either<Failure, Service> saveEither;
    if (isUpdate) {
      saveEither = await serviceService.update(service: serviceToSave);
    } else {
      saveEither = await serviceService.insert(service: serviceToSave);
    }

    if (saveEither.isLeft) {
      genericErrorMessage = saveEither.left!.message;
    } else {
      service = saveEither.right!;
      editSuccessful.value = true;
      _setNotificationMessage('Serviço salvo com sucesso!');
    }

    _setServiceLoading(false);
  }

  bool _validateService() {
    bool isValid = true;

    nameController.text = nameController.text.trim();
    if (nameController.text.isEmpty) {
      nameErrorMessage = 'Necessário informar o nome';
      isValid = false;
    }

    final price = DataConverter.textToPrice(priceController.text);
    if (price == 0) {
      priceErrorMessage = 'Necessário informar o preço';
      isValid = false;
    }

    final hours = DataConverter.textToHour(hoursController.text);
    final minutes = DataConverter.textToMinute(minutesController.text);
    if (hours == 0 && minutes == 0) {
      hoursAndMinutesErrorMessage = 'Necessário informar o tempo';
      isValid = false;
    }

    return isValid;
  }

  Future<void> pickImageFromGallery() async {
    final eitherPickImage = await offlineImageService.pickImageFromGallery();
    if (eitherPickImage.isLeft) {
      _setNotificationMessage(eitherPickImage.left!.message);
    } else {
      imageFile = eitherPickImage.right!;
      notifyListeners();
    }
  }

  void _clearErrors() {
    nameErrorMessage = null;
    genericErrorMessage = null;
    nameErrorMessage = null;
    priceErrorMessage = null;
    hoursAndMinutesErrorMessage = null;
  }
}

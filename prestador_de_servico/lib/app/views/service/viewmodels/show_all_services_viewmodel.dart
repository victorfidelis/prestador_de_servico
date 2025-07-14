import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ShowAllServicesViewModel extends ChangeNotifier {
  final ServiceService serviceService;

  bool serviceLoading = false;
  bool serviceFiltered = false;

  ServiceCategory serviceCategory;
  List<Service> servicesFiltered = [];

  String? serviceErrorMessage;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);

  ShowAllServicesViewModel({
    required this.serviceService,
    required this.serviceCategory,
  });

  bool get hasServiceError => serviceErrorMessage != null;

  void _setServiceFiltered(bool value) {
    serviceFiltered = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // É necessário para garantir o ValueNotifier vai notificar os ouvintes
    notificationMessage.value = value;
  }

  void addService({required Service service}) {
    serviceCategory.services.add(service);
    if (serviceFiltered) {
      servicesFiltered.add(service);
    }
  }

  void editService({required Service service}) {
    final index = serviceCategory.services.indexWhere((s) => s.id == service.id);
    serviceCategory.services[index] = service;
    if (serviceFiltered) {
      final indexFiltered = servicesFiltered.indexWhere((s) => s.id == service.id);
      servicesFiltered[indexFiltered] = service;
    }
  }

  Future<void> delete({required Service service}) async {
    serviceCategory.services.removeWhere((s) => s.id == service.id);
    if (serviceFiltered) {
      servicesFiltered.removeWhere((s) => s.id == service.id);
    }

    final deleteEither = await serviceService.delete(service: service);
    if (deleteEither.isRight) {
      return;
    }
    _setNotificationMessage(deleteEither.left!.message);

    addService(service: service);

    notifyListeners();
  }

  void filter({required String textFilter}) {
    if (textFilter.trim().isEmpty) {
      servicesFiltered = [];
      _setServiceFiltered(false);
      return;
    }

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);
    servicesFiltered = serviceCategory.services
        .where(
          (service) => service.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    _setServiceFiltered(true);
  }
}

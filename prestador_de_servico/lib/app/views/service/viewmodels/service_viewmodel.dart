import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;
  final ServiceService serviceService;

  bool serviceLoading = false;
  bool serviceFiltered = false;

  List<ServiceCategory> serviceCategories = [];
  List<ServiceCategory> serviceCategoriesFiltered = [];

  String? serviceErrorMessage;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null); 

  ServiceViewModel({
    required this.serviceCategoryService,
    required this.serviceService,
  });

  bool get hasServiceError => serviceErrorMessage != null;

  void _setServiceLoading(bool value) {
    serviceLoading = value;
    notifyListeners();
  }

  void _setServiceFiltered(bool value) {
    serviceFiltered = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // É necessário para garantir o ValueNotifier vai notificar os ouvintes
    notificationMessage.value = value;
  }

  Future<void> load() async {
    _setServiceLoading(true);

    final getAllEither = await serviceCategoryService.getAllWithServices();
    if (getAllEither.isLeft) {
      serviceErrorMessage = getAllEither.left!.message;
    } else {
      serviceCategories = getAllEither.right!;
    }

    _setServiceLoading(false);
  }

  void filter({required String textFilter}) {
    if (textFilter.trim().isEmpty) {
      serviceCategoriesFiltered = [];
      _setServiceFiltered(false);
      return;
    }

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);

    serviceCategoriesFiltered = serviceCategories
        .where(
          (s) => s.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    _setServiceFiltered(true);
  }

  void addServiceCategory({required ServiceCategory serviceCategory}) async {
    serviceCategories.add(serviceCategory);
    if (serviceFiltered) {
      serviceCategoriesFiltered.add(serviceCategory);
    }
  }

  void editServiceCategory({required ServiceCategory serviceCategory}) {
    final index = serviceCategories.indexWhere((s) => s.id == serviceCategory.id);
    serviceCategories[index] = serviceCategory;

    if (serviceFiltered) {
      final indexOfFiltered =
          serviceCategoriesFiltered.indexWhere((s) => s.id == serviceCategory.id);
      serviceCategoriesFiltered[indexOfFiltered] = serviceCategory;
    }
  }

  Future<void> deleteCategory({required ServiceCategory serviceCategory}) async {
    serviceCategories.removeWhere((s) => s.id == serviceCategory.id);
    if (serviceFiltered) {
      serviceCategoriesFiltered.removeWhere((s) => s.id == serviceCategory.id);
    }

    final deleteEither = await serviceCategoryService.delete(serviceCategory: serviceCategory);
    if (deleteEither.isRight) {
      return;
    }
    _setNotificationMessage(deleteEither.left!.message);

    _setServiceLoading(true);

    final getAllEither = await serviceCategoryService.getAllWithServices();
    if (getAllEither.isLeft) {
      serviceErrorMessage = getAllEither.left!.message;
    } else {
      serviceCategories = getAllEither.right!;
    }

    _setServiceLoading(false);
  }

  Future<void> deleteService({required Service service}) async {
    final deleteEither = await serviceService.delete(service: service);
    if (deleteEither.isRight) {
      return;
    }
    _setNotificationMessage(deleteEither.left!.message);

    _setServiceLoading(true);

    final getAllEither = await serviceCategoryService.getAllWithServices();
    if (getAllEither.isLeft) {
      serviceErrorMessage = getAllEither.left!.message;
    } else {
      serviceCategories = getAllEither.right!;
    }

    _setServiceLoading(false);
  }
}

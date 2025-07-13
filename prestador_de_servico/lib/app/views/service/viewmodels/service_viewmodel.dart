import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;
  final ServiceService serviceService;
  final ServicesByCategoryService servicesByCategoryService;

  bool serviceLoading = false;
  bool serviceFiltered = false;

  List<ServicesByCategory> servicesByCategories = [];
  List<ServicesByCategory> servicesByCategoriesFiltered = [];
  final scrollController = ScrollController();

  String? serviceErrorMessage;

  ServiceViewModel({
    required this.serviceCategoryService,
    required this.serviceService,
    required this.servicesByCategoryService,
  });

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool get hasServiceError => serviceErrorMessage != null;

  void _setServiceLoading(bool value) {
    serviceLoading = value;
    notifyListeners();
  }

  void _setServiceFiltered(bool value) {
    serviceFiltered = value;
    notifyListeners();
  }

  Future<void> load() async {
    _setServiceLoading(true);

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      serviceErrorMessage = getAllEither.left!.message;
    } else {
      servicesByCategories = getAllEither.right!;
    }

    _setServiceLoading(false);
  }

  void filter({required String textFilter}) {
    if (textFilter.trim().isEmpty) {
      servicesByCategoriesFiltered = [];
      _setServiceFiltered(false);
      return;
    }

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);

    servicesByCategoriesFiltered = servicesByCategories
        .where(
          (s) => s.serviceCategory.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    _setServiceFiltered(true);
  }

  void addServiceByCategory({required ServicesByCategory serviceByCategory}) async {
    servicesByCategories.add(serviceByCategory);
    if (serviceFiltered) {
      servicesByCategoriesFiltered.add(serviceByCategory);
    }
  }

  void editServiceCategory({required ServiceCategory serviceCategory}) {
    final index = servicesByCategories.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    servicesByCategories[index].serviceCategory = serviceCategory;

    if (serviceFiltered) {
      final indexOfFiltered =
          servicesByCategoriesFiltered.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
      servicesByCategoriesFiltered[indexOfFiltered].serviceCategory = serviceCategory;
    }
  }

  Future<void> deleteCategory({required ServiceCategory serviceCategory}) async {
    servicesByCategories.removeWhere((s) => s.serviceCategory.id == serviceCategory.id);
    if (serviceFiltered) {
      servicesByCategoriesFiltered.removeWhere((s) => s.serviceCategory.id == serviceCategory.id);
    }

    final deleteEither = await serviceCategoryService.delete(serviceCategory: serviceCategory);
    if (deleteEither.isRight) {
      return;
    }

    final message = deleteEither.left!.message;

    _setServiceLoading(true);

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      serviceErrorMessage = getAllEither.left!.message;
    } else {
      servicesByCategories = getAllEither.right!;
    }

    _setServiceLoading(false);
  }

  Future<void> deleteService({required Service service}) async {
    final deleteEither = await serviceService.delete(service: service);
    if (deleteEither.isRight) {
      return;
    }

    final message = deleteEither.left!.message;

    _setServiceLoading(true);

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      serviceErrorMessage = getAllEither.left!.message;
    } else {
      servicesByCategories = getAllEither.right!;
    }

    _setServiceLoading(false);
  }

  void refreshValuesOfState({
    required List<ServicesByCategory> servicesByCategories,
    required List<ServicesByCategory> servicesByCategoriesFiltered,
  }) {
    this.servicesByCategories = servicesByCategories;
    this.servicesByCategoriesFiltered = servicesByCategoriesFiltered;
    notifyListeners();
  }
}

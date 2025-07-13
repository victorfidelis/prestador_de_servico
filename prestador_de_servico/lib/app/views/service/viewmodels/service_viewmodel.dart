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

  List<ServicesByCategory> servicesByCategories = [];
  List<ServicesByCategory> servicesByCategoriesFiltered = [];

  String? serviceErrorMessage;

  ServiceViewModel({
    required this.serviceCategoryService,
    required this.serviceService,
    required this.servicesByCategoryService,
  });

  bool get serviceFiltered => servicesByCategoriesFiltered.isNotEmpty;
  bool get hasServiceError => serviceErrorMessage != null;

  void _setServiceLoading(bool value) {
    serviceLoading = value;
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
      notifyListeners();
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

    notifyListeners();
  }

  Future<void> deleteCategory({required ServiceCategory serviceCategory}) async {
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

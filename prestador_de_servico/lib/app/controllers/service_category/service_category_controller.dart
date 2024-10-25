

import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/service_category/service_category_state.dart';

class ServiceCategoryController extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;
  final ServiceService serviceService;

  ServiceCategoryState _state = ServiceCategoryInitial();
  ServiceCategoryState get state => _state;
  void _changeState(ServiceCategoryState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ServiceCategoryController({
    required this.serviceCategoryService,
    required this.serviceService,
  });

  Future<void> load() async {
    _changeState(ServiceCategoryLoading());

    final getAllEither = await serviceCategoryService.getAll();

    if (getAllEither.isLeft) {
      _changeState(ServiceCategoryError(getAllEither.left!.message));
      return;
    }

    final servicesByCategories =
        getAllEither.right!.map((e) => ServicesByCategory(serviceCategory: e, services: [])).toList();

    for (int i = 0; i < servicesByCategories.length; i++) {
      final serviceCategoryId = servicesByCategories[i].serviceCategory.id;
      final getServicesEither = await serviceService.getByServiceCategoryId(serviceCategoryId: serviceCategoryId);
      if (getServicesEither.isLeft) {
        _changeState(ServiceCategoryError(getServicesEither.left!.message));
        return;
      }
      servicesByCategories[i].services = getServicesEither.right!;
    }

    _changeState(ServiceCategoryLoaded(servicesByCategories));
  }

  Future<void> filter({required String name}) async {
    _changeState(ServiceCategoryLoading());
  }

  Future<void> delete({required ServiceCategory serviceCategory}) async {
    _changeState(ServiceCategoryLoading());

    final deleteEither = await serviceCategoryService.delete(serviceCategory: serviceCategory);
    if (deleteEither.isLeft) {
      _changeState(ServiceCategoryError(deleteEither.left!.message));
      return;
    }

    // final getAllEither = await serviceCategoryService.getAll();
    // getAllEither.fold(
    //   (error) => _changeState(ServiceCategoryError(error.message)),
    //   (value) => _changeState(ServiceCategoryLoaded(cards: value)),
    // );
  }

  void addOnList({required ServiceCategory serviceCategory}) {
    if (state is! ServiceCategoryLoaded) {
      return;
    }

    // ServiceCategoryLoaded currentState = state as ServiceCategoryLoaded;
    // currentState.cards.insert(0, serviceCategory);

    // _changeState(currentState);
  }

  void updateOnList({required ServiceCategory serviceCategory}) {
    if (state is! ServiceCategoryLoaded) {
      return;
    }

    // ServiceCategoryLoaded currentState = state as ServiceCategoryLoaded;
    // int index = currentState.cards.indexWhere((element) => element.id == serviceCategory.id);
    // currentState.cards[index] = serviceCategory;

    // _changeState(currentState: currentState);
  }
}

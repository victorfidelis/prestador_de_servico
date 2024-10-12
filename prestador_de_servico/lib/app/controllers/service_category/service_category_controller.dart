import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_state.dart';

class ServiceCategoryController extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;

  ServiceCategoryState _state = ServiceCategoryInitial();
  ServiceCategoryState get state => _state;
  void _changeState({required ServiceCategoryState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  ServiceCategoryController({required this.serviceCategoryService});

  Future<void> load() async {
    _changeState(currentState: ServiceCategoryLoading());
    List<ServiceCategory> serviceCategories;
    serviceCategories = await serviceCategoryService.getAll();
    _changeState(
        currentState:
            ServiceCategoryLoaded(serviceCategories: serviceCategories));
  }

  Future<void> filter({required String value}) async {
    _changeState(currentState: ServiceCategoryLoading());
    List<ServiceCategory> serviceCategories;
    serviceCategories =
        await serviceCategoryService.getNameContained(value: value);
    _changeState(
        currentState:
            ServiceCategoryLoaded(serviceCategories: serviceCategories));
  }

  void deleteServiceCategory({required ServiceCategory serviceCategory}) async {
    _changeState(currentState: ServiceCategoryLoading());
    await serviceCategoryService.delete(serviceCategory: serviceCategory);
    await load();
  }

  void addOnList({required ServiceCategory serviceCategory}) {
    if (state is! ServiceCategoryLoaded) {
      return;
    }

    ServiceCategoryLoaded currentState = state as ServiceCategoryLoaded;
    currentState.serviceCategories.insert(0, serviceCategory);

    _changeState(currentState: currentState);
  }

  void updateOnList({required ServiceCategory serviceCategory}) {
    if (state is! ServiceCategoryLoaded) {
      return;
    }

    ServiceCategoryLoaded currentState = state as ServiceCategoryLoaded;
    int index = currentState.serviceCategories
        .indexWhere((element) => element.id == serviceCategory.id);
    currentState.serviceCategories[index] = serviceCategory;

    _changeState(currentState: currentState);
  }
}

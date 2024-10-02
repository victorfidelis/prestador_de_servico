import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
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
    ServiceCategoryState serviceCategoryState =
        await serviceCategoryService.getAll();
    _changeState(currentState: serviceCategoryState);
  }

  Future<void> filter({required String value}) async {
    _changeState(currentState: ServiceCategoryLoading());
    ServiceCategoryState serviceCategoryState =
        await serviceCategoryService.getNameContained(
      value: value,
    );
    _changeState(currentState: serviceCategoryState);
  }

  void deleteServiceCategory({required ServiceCategoryModel serviceCategory}) async {
    _changeState(currentState: ServiceCategoryLoading());
    ServiceCategoryState serviceCategoryState = await serviceCategoryService.delete(serviceCategory: serviceCategory);
    _changeState(currentState: serviceCategoryState);
  }

  void addOnList({required ServiceCategoryModel serviceCategory}) {
    _changeState(
      currentState: serviceCategoryService.addOnList(
        serviceCategoryState: state,
        serviceCategory: serviceCategory,
      ),
    );
  }

  void updateOnList({required ServiceCategoryModel serviceCategory}) {
    _changeState(
      currentState: serviceCategoryService.updateOnList(
        serviceCategoryState: state,
        serviceCategory: serviceCategory,
      ),
    );
  }
}

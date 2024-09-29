import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/states/service_category/service_category_state.dart';

class ServiceCategoryController extends ChangeNotifier {
  
  final ServiceCategoryService serviceCategoryService;

  ServiceCategoryState _state = ServiceCategoryInitial();
  ServiceCategoryState get state => _state;
  void _changeState({required ServiceCategoryState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  ServiceCategoryController({required this.serviceCategoryService}); 

  Future<void> loadServiceCategories() async {
    _changeState(currentState: ServiceCategoryLoading());
    ServiceCategoryState serviceCategoryState = await serviceCategoryService.getAll();
    _changeState(currentState: serviceCategoryState);
  }

  Future<void> filterServiceCategories({required String value}) async {
    _changeState(currentState: ServiceCategoryLoading());
    ServiceCategoryState serviceCategoryState = await serviceCategoryService.getNameContained(
      value: value,
    );
    _changeState(currentState: serviceCategoryState);
  }
}
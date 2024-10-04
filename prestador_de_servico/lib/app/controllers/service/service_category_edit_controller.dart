import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';

class ServiceCategoryEditController extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;

  ServiceCategoryEditState _state = ServiceCategoryEditInitial();
  ServiceCategoryEditState get state => _state;
  void _changeState({required ServiceCategoryEditState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  ServiceCategoryEditController({required this.serviceCategoryService});

  void initAdd() {
    _changeState(currentState: ServiceCategoryEditAdd());
  }

  void initUpdate({required ServiceCategory serviceCategory}) {
    _changeState(
        currentState:
            ServiceCategoryEditUpdate(serviceCategory: serviceCategory));
  }

  Future<void> add({required ServiceCategory serviceCategory}) async {
    _changeState(currentState: ServiceCategoryEditLoading());
    await serviceCategoryService.addOnDatabase(
        serviceCategory: serviceCategory);
    _changeState(currentState: ServiceCategoryEditSuccess(serviceCategory: serviceCategory));
  }

  Future<void> update({required ServiceCategory serviceCategory}) async {
    _changeState(currentState: ServiceCategoryEditLoading());
    await serviceCategoryService.updateOnDatabase(serviceCategory: serviceCategory);
    _changeState(currentState: ServiceCategoryEditSuccess(serviceCategory: serviceCategory));
  }
}

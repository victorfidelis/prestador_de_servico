import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
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

  void initUpdate({required ServiceCategoryModel serviceCategory}) {
    _changeState(currentState: ServiceCategoryEditUpdate(serviceCategory: serviceCategory));
  }

  Future<void> add({required String name}) async {
    _changeState(currentState: ServiceCategoryEditLoading());
    ServiceCategoryEditState serviceCategoryEditState =
        await serviceCategoryService.add(name: name);
    _changeState(currentState: serviceCategoryEditState);
  }
}

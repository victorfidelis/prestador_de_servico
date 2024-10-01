import 'package:flutter/material.dart';
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

  void init() {
    _changeState(currentState: ServiceCategoryEditInitial());
  }

  Future<void> add({required String name}) async {
    _changeState(currentState: ServiceCategoryEditLoading());
    ServiceCategoryEditState serviceCategoryEditState =
        await serviceCategoryService.add(name: name);
    _changeState(currentState: serviceCategoryEditState);
  }
}

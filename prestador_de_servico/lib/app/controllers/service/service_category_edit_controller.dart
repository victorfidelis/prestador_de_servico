import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';

class ServiceCategoryEditController extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;

  ServiceCategoryEditState _state = ServiceCategoryEditInitial();
  ServiceCategoryEditState get state => _state;
  void _changeState(ServiceCategoryEditState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ServiceCategoryEditController({required this.serviceCategoryService});

  void initInsert() {
    _changeState(ServiceCategoryEditAdd());
  }

  void initUpdate({required ServiceCategory serviceCategory}) {
    _changeState(ServiceCategoryEditUpdate(serviceCategory: serviceCategory));
  }

  Future<void> validateAndInsert({required ServiceCategory serviceCategory}) async {
    if (state is ServiceCategoryEditLoading) {
      return;
    }

    _changeState(ServiceCategoryEditLoading());

    final validEither = _validade(serviceCategory: serviceCategory);
    if (validEither is ServiceCategoryEditError) {
      _changeState(validEither);
      return;
    }

    final insertEither = await serviceCategoryService.insert(serviceCategory: serviceCategory);
    if (insertEither.isLeft) {
      _changeState(ServiceCategoryEditError(genericMessage: insertEither.left!.message));
      return;
    }

    _changeState(ServiceCategoryEditSuccess(serviceCategory: insertEither.right!));
  }

  Future<void> validateAndUpdate({required ServiceCategory serviceCategory}) async {
    if (state is ServiceCategoryEditLoading) {
      return;
    }
    
    _changeState(ServiceCategoryEditLoading());

    final validEither = _validade(serviceCategory: serviceCategory);
    if (validEither is ServiceCategoryEditError) {
      _changeState(validEither);
      return;
    }

    final updateEither = await serviceCategoryService.update(serviceCategory: serviceCategory);
    if (updateEither.isLeft) {
      _changeState(ServiceCategoryEditError(genericMessage: updateEither.left!.message));
      return;
    }

    _changeState(ServiceCategoryEditSuccess(serviceCategory: serviceCategory));
  }

  ServiceCategoryEditState _validade({required ServiceCategory serviceCategory}) {
    if (serviceCategory.name.trim().isEmpty) {
      return ServiceCategoryEditError(nameMessage: 'Necessário informar o nome');
    }
    return ServiceCategoryEditValidated();
  }
}

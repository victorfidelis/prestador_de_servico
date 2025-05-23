import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/service/states/service_category_edit_state.dart';

class ServiceCategoryEditViewModel extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;

  ServiceCategoryEditState _state = ServiceCategoryEditInitial();
  ServiceCategoryEditState get state => _state;
  void _emitState(ServiceCategoryEditState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ServiceCategoryEditViewModel({required this.serviceCategoryService});

  Future<void> validateAndInsert({required ServiceCategory serviceCategory}) async {
    if (state is ServiceCategoryEditLoading) {
      return;
    }

    _emitState(ServiceCategoryEditLoading());

    final validEither = _validade(serviceCategory: serviceCategory);
    if (validEither is ServiceCategoryEditError) {
      _emitState(validEither);
      return;
    }

    final insertEither = await serviceCategoryService.insert(serviceCategory: serviceCategory);
    if (insertEither.isLeft) {
      _emitState(ServiceCategoryEditError(genericMessage: insertEither.left!.message));
      return;
    }

    _emitState(ServiceCategoryEditSuccess(serviceCategory: insertEither.right!));
  }

  Future<void> validateAndUpdate({required ServiceCategory serviceCategory}) async {
    if (state is ServiceCategoryEditLoading) {
      return;
    }

    _emitState(ServiceCategoryEditLoading());

    final validEither = _validade(serviceCategory: serviceCategory);
    if (validEither is ServiceCategoryEditError) {
      _emitState(validEither);
      return;
    }

    final updateEither = await serviceCategoryService.update(serviceCategory: serviceCategory);
    if (updateEither.isLeft) {
      _emitState(ServiceCategoryEditError(genericMessage: updateEither.left!.message));
      return;
    }

    _emitState(ServiceCategoryEditSuccess(serviceCategory: serviceCategory));
  }

  ServiceCategoryEditState _validade({required ServiceCategory serviceCategory}) {
    if (serviceCategory.name.trim().isEmpty) {
      return ServiceCategoryEditError(nameMessage: 'Necessário informar o nome');
    }
    return ServiceCategoryEditValidated();
  }
}

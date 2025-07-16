import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class ServiceCategoryEditViewModel extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;
  ServiceCategory? serviceCategory;
  late bool isUpdate;

  bool categoryLoading = false;

  final TextEditingController nameController = TextEditingController();

  String? nameErrorMessage;
  String? genericErrorMessage;
  ValueNotifier<bool> editSuccessful = ValueNotifier(false);

  ServiceCategoryEditViewModel({required this.serviceCategoryService, required this.serviceCategory}) {
    isUpdate = (serviceCategory != null);
    _loadFields();
  }

  @override
  void dispose() {
    nameController.dispose();
    editSuccessful.dispose();
    super.dispose();
  }

  void _setCategoryEditLoading(bool value) {
    categoryLoading = value;
    notifyListeners();
  }

  void _loadFields() {
    if (!isUpdate) {
      return;
    }

    nameController.text = serviceCategory!.name;
  }

  Future<void> save() async {
    if (categoryLoading) {
      return;
    }

    _clearErrors();
    if (!_validade()) {
      notifyListeners();
      return;
    }

    _setCategoryEditLoading(true);

    final serviceCategoryToSave = ServiceCategory(
      id: serviceCategory?.id ?? '',
      name: nameController.text,
    );

    if (isUpdate) {
      final updateEither = await serviceCategoryService.update(serviceCategory: serviceCategoryToSave);
      if (updateEither.isLeft) {
        genericErrorMessage = updateEither.left!.message;
      } else {
        serviceCategory = serviceCategoryToSave;
        editSuccessful.value = true;
      }
    } else {
      final insertEither = await serviceCategoryService.insert(serviceCategory: serviceCategoryToSave);
      if (insertEither.isLeft) {
        genericErrorMessage = insertEither.left!.message;
      } else {
        serviceCategory = insertEither.right!;
        editSuccessful.value = true;
      }
    }

    _setCategoryEditLoading(false);
  }

  bool _validade() {
    bool isValid = true;

    nameController.text = nameController.text.trim();
    if (nameController.text.isEmpty) {
      nameErrorMessage = 'Necessário informar o nome';
      isValid = false;
    }

    return isValid;
  }

  void _clearErrors() {
    nameErrorMessage = null;
    genericErrorMessage = null;
  }
}

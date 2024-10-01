import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';
import 'package:prestador_de_servico/app/states/service/service_category_state.dart';

class HybridServiceCategoryService implements ServiceCategoryService {
  final ServiceCategoryRepository _onlineServiceCategoryRepository =
      ServiceCategoryRepository.create_online();
  final ServiceCategoryRepository _offlineServiceCategoryRepository =
      ServiceCategoryRepository.create_offline();

  @override
  Future<ServiceCategoryEditState> add({required String name}) async {
    name = name.trim();
    if (name.isEmpty) {
      return ServiceCategoryEditError(
          nameMessage: 'Necessário informar o nome');
    }

    ServiceCategoryModel serviceCategory =
        ServiceCategoryModel(id: '0', name: name);

    String? onlineServiceCategoryId = await _onlineServiceCategoryRepository
        .add(serviceCategory: serviceCategory);
    if (onlineServiceCategoryId == null) {
      return ServiceCategoryEditError(
          genericMessage: 'Falha ao salvar os dados');
    }
    serviceCategory = serviceCategory.copyWith(id: onlineServiceCategoryId);
    String? offlineServiceCategoryId = await _offlineServiceCategoryRepository
        .add(serviceCategory: serviceCategory);
    if (offlineServiceCategoryId == null) {
      return ServiceCategoryEditError(
          genericMessage: 'Um erro ocorreu ao salvar os dados locais');
    }
    return ServiceCategoryEditSuccess(serviceCategory: serviceCategory);
  }

  @override
  Future<ServiceCategoryState> delete(
      {required ServiceCategoryModel serviceCategory}) async {
    if (!await _onlineServiceCategoryRepository.deleteById(
        id: serviceCategory.id)) {
      return ServiceCategoryError(message: 'Falha ao deletar os dados');
    }

    if (!await _offlineServiceCategoryRepository.deleteById(
        id: serviceCategory.id)) {
      return ServiceCategoryError(
          message: 'Um erro ocorreu ao deletar os dados locais');
    }

    return await getAll();
  }

  @override
  Future<ServiceCategoryState> getAll() async {
    List<ServiceCategoryModel> serviceCategories =
        await _offlineServiceCategoryRepository.getAll();
    return ServiceCategoryLoaded(serviceCategories: serviceCategories);
  }

  @override
  Future<ServiceCategoryState> getNameContained({required String value}) async {
    List<ServiceCategoryModel> serviceCategories =
        await _offlineServiceCategoryRepository.getNameContained(name: value);
    return ServiceCategoryLoaded(serviceCategories: serviceCategories);
  }

  @override
  Future<ServiceCategoryEditState> update(
      {required ServiceCategoryModel serviceCategory}) async {
    if (!await _onlineServiceCategoryRepository.update(
        serviceCategory: serviceCategory)) {
      return ServiceCategoryEditError(
          genericMessage: 'Falha ao salvar os dados');
    }
    if (!await _offlineServiceCategoryRepository.update(
        serviceCategory: serviceCategory)) {
      return ServiceCategoryEditError(
          genericMessage: 'Um erro ocorreu ao salvar os dados locais');
    }
    return ServiceCategoryEditSuccess(serviceCategory: serviceCategory);
  }

  @override
  ServiceCategoryState insert({
    required ServiceCategoryState serviceCategoryState,
    required ServiceCategoryModel serviceCategory,
  }) {
    if (serviceCategoryState is! ServiceCategoryLoaded) {
      return serviceCategoryState;
    }
    serviceCategoryState.serviceCategories.insert(0, serviceCategory);
    return serviceCategoryState;
  }
}

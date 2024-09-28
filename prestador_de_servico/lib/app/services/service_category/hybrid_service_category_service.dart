import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/states/create_service_category/create_service_category_state.dart';
import 'package:prestador_de_servico/app/states/service_category/service_category_state.dart';

class HybridServiceCategoryService implements ServiceCategoryService {
  final ServiceCategoryRepository _onlineServiceCategoryRepository =
      ServiceCategoryRepository.create_online();
  final ServiceCategoryRepository _offlineServiceCategoryRepository =
      ServiceCategoryRepository.create_offline();

  @override
  Future<CreateServiceCategoryState> add(
      {required ServiceCategoryModel serviceCategory}) async {
    String? onlineServiceCategoryId = await _onlineServiceCategoryRepository
        .add(serviceCategory: serviceCategory);
    if (onlineServiceCategoryId == null) {
      return CreateServiceCategoryError(message: 'Falha ao salvar os dados');
    }
    serviceCategory = serviceCategory.copyWith(id: onlineServiceCategoryId);
    String? offlineServiceCategoryId = await _offlineServiceCategoryRepository
        .add(serviceCategory: serviceCategory);
    if (offlineServiceCategoryId == null) {
      return CreateServiceCategoryError(
          message: 'Um erro ocorreu ao salvar os dados locais');
    }
    return CreateServiceCategorySuccess();
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
  Future<CreateServiceCategoryState> update(
      {required ServiceCategoryModel serviceCategory}) async {
    if (!await _onlineServiceCategoryRepository.update(serviceCategory: serviceCategory)) {
      return CreateServiceCategoryError(message: 'Falha ao salvar os dados');
    }
    if (!await _offlineServiceCategoryRepository.update(serviceCategory: serviceCategory)) {
      return CreateServiceCategoryError(
          message: 'Um erro ocorreu ao salvar os dados locais');
    }
    return CreateServiceCategorySuccess();
  }
}

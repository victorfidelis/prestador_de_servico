import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';

class HybridServiceCategoryService implements ServiceCategoryService {
  final ServiceCategoryRepository _onlineServiceCategoryRepository =
      ServiceCategoryRepository.create_online();
  final ServiceCategoryRepository _offlineServiceCategoryRepository =
      ServiceCategoryRepository.create_offline();

  @override
  Future<List<ServiceCategory>> getAll() async {
    return await _offlineServiceCategoryRepository.getAll();
  }

  @override
  Future<List<ServiceCategory>> getNameContained(
      {required String value}) async {
    return await _offlineServiceCategoryRepository.getNameContained(
        name: value);
  }

  @override
  Future<void> addOnDatabase({required ServiceCategory serviceCategory}) async {
    String serviceCategoryId = await _onlineServiceCategoryRepository.add(
        serviceCategory: serviceCategory);

    serviceCategory = serviceCategory.copyWith(id: serviceCategoryId);
    
    await _offlineServiceCategoryRepository.add(
        serviceCategory: serviceCategory);
  }

  @override
  Future<void> updateOnDatabase({required ServiceCategory serviceCategory}) async {
    await _onlineServiceCategoryRepository.update(
        serviceCategory: serviceCategory);
    await _offlineServiceCategoryRepository.update(
        serviceCategory: serviceCategory);
  }

  @override
  Future<void> delete(
      {required ServiceCategory serviceCategory}) async {
    await _onlineServiceCategoryRepository.deleteById(id: serviceCategory.id);
    await _offlineServiceCategoryRepository.deleteById(id: serviceCategory.id);
  }
}

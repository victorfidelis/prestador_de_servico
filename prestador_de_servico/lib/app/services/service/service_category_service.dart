import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/services/service/hybrid_service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';
import 'package:prestador_de_servico/app/states/service/service_category_state.dart';

abstract class ServiceCategoryService {
  factory ServiceCategoryService.create() {
    return HybridServiceCategoryService();
  }

  Future<ServiceCategoryState> getAll();
  Future<ServiceCategoryState> getNameContained({required String value});
  Future<ServiceCategoryEditState> addOnDatabase({required String name});
  Future<ServiceCategoryEditState> updateOnDatabase({
    required String id,
    required String name,
  });
  Future<ServiceCategoryState> delete(
      {required ServiceCategoryModel serviceCategory});
  ServiceCategoryState addOnList({
    required ServiceCategoryState serviceCategoryState,
    required ServiceCategoryModel serviceCategory,
  });
  ServiceCategoryState updateOnList({
    required ServiceCategoryState serviceCategoryState,
    required ServiceCategoryModel serviceCategory,
  });
  ServiceCategoryState deleteOnList({
    required ServiceCategoryState serviceCategoryState,
    required ServiceCategoryModel serviceCategory,
  });
}

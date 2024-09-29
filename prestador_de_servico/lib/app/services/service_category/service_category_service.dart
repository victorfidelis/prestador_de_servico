import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/services/service_category/hybrid_service_category_service.dart';
import 'package:prestador_de_servico/app/states/create_service_category/create_service_category_state.dart';
import 'package:prestador_de_servico/app/states/service_category/service_category_state.dart';

abstract class ServiceCategoryService {

  factory ServiceCategoryService.create() {
    return HybridServiceCategoryService();
  }

  Future<ServiceCategoryState> getAll();
  Future<ServiceCategoryState> getNameContained({required String value});
  Future<CreateServiceCategoryState> add({required ServiceCategoryModel serviceCategory});
  Future<CreateServiceCategoryState> update({required ServiceCategoryModel serviceCategory});
  Future<ServiceCategoryState> delete({required ServiceCategoryModel serviceCategory});
}
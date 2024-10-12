import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service_category/hybrid_service_category_service.dart';

abstract class ServiceCategoryService {
  factory ServiceCategoryService.create() {
    return HybridServiceCategoryService();
  }

  Future<List<ServiceCategory>> getAll();
  Future<List<ServiceCategory>> getNameContained({required String value});
  Future<void> insert({required ServiceCategory serviceCategory});
  Future<void> update({required ServiceCategory serviceCategory});
  Future<void> delete({required ServiceCategory serviceCategory});
}

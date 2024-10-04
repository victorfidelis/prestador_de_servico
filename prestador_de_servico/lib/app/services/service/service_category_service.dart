import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/hybrid_service_category_service.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';
import 'package:prestador_de_servico/app/states/service/service_category_state.dart';

abstract class ServiceCategoryService {
  factory ServiceCategoryService.create() {
    return HybridServiceCategoryService();
  }

  Future<List<ServiceCategory>> getAll();
  Future<List<ServiceCategory>> getNameContained({required String value});
  Future<void> addOnDatabase({required ServiceCategory serviceCategory});
  Future<void> updateOnDatabase({required ServiceCategory serviceCategory});
  Future<void> delete({required ServiceCategory serviceCategory});
}

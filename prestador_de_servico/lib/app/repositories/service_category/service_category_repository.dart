import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';

abstract class ServiceCategoryRepository {
  Future<ServiceCartegoryModel?> getById({required int id});
  Future<List<ServiceCartegoryModel>> getNameContained({required String name});
  Future<ServiceCartegoryModel?> add({required ServiceCartegoryModel serviceCategory});
  Future<bool> update({required ServiceCartegoryModel serviceCategory});
  Future<bool> deleteById({required ServiceCartegoryModel serviceCategory});
}

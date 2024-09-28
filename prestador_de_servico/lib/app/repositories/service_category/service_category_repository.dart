import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/firebase_service_category_repository.dart';

abstract class ServiceCategoryRepository {

  factory ServiceCategoryRepository.create_online() {
    return FirebaseServiceCategoryRepository();
  }
  factory ServiceCategoryRepository.create_offline() {
    return FirebaseServiceCategoryRepository();
  }

  Future<List<ServiceCategoryModel>> getAll();
  Future<ServiceCategoryModel> getById({required String id});
  Future<List<ServiceCategoryModel>> getNameContained({required String name});
  Future<String?> add({required ServiceCategoryModel serviceCategory});
  Future<bool> update({required ServiceCategoryModel serviceCategory});
  Future<bool> deleteById({required String id});
}

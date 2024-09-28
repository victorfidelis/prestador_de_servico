import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/firebase_service_category_repository.dart';

abstract class ServiceCategoryRepository {

  factory ServiceCategoryRepository.create() {
    return FirebaseServiceCategoryRepository();
  }

  Future<List<ServiceCartegoryModel>> getAll();
  Future<ServiceCartegoryModel> getById({required String id});
  Future<List<ServiceCartegoryModel>> getNameContained({required String name});
  Future<String?> add({required ServiceCartegoryModel serviceCategory});
  Future<bool> update({required ServiceCartegoryModel serviceCategory});
  Future<bool> deleteById({required String id});
}

import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/firebase_service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service_category/sqflite_service_category_repository.dart';

abstract class ServiceCategoryRepository {

  factory ServiceCategoryRepository.create_online() {
    return FirebaseServiceCategoryRepository();
  }
  factory ServiceCategoryRepository.create_offline() {
    return SqfliteServiceCategoryRepository();
  }

  Future<List<ServiceCategory>> getAll();
  Future<ServiceCategory> getById({required String id});
  Future<List<ServiceCategory>> getNameContained({required String name});
  Future<String> add({required ServiceCategory serviceCategory});
  Future<void> update({required ServiceCategory serviceCategory});
  Future<void> deleteById({required String id});
}

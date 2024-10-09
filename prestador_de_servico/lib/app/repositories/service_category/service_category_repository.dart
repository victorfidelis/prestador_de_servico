import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/firebase_service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service_category/sqflite_service_category_repository.dart';

abstract class ServiceCategoryRepository {

  factory ServiceCategoryRepository.createOnline() {
    return FirebaseServiceCategoryRepository();
  }
  factory ServiceCategoryRepository.createOffline() {
    return SqfliteServiceCategoryRepository();
  }

  Future<List<ServiceCategory>> getAll();
  Future<ServiceCategory> getById({required String id});
  Future<List<ServiceCategory>> getNameContained({required String name});
  Future<List<ServiceCategory>> getUnsync({required DateTime dateLastSync});
  Future<String> insert({required ServiceCategory serviceCategory});
  Future<void> update({required ServiceCategory serviceCategory});
  Future<void> deleteById({required String id});
  Future<bool> existsById({required String id});
}
